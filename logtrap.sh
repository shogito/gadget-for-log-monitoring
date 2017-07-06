#!/bin/bash
MONITORED="./grateful.log"
DEST="./target.log"
PREVIOUS="./grateful.log.prev"


trap() {
    while read i
    do
        # ここになんか書け

        # とりあえず標準出力に出しながらファイルに書き込む
        echo ${i} | tee -a ${DEST}
    done
}

# ログ比較
check_diff() {
    
    # snapとmonitredを比較
    # 前回のスナップから追加されたものだけをフィルタリング
    # ログの先頭から"+"を除去
    diff -u ${PREVIOUS} ${MONITORED} | grep -E "^\+" | tail -n +2 | sed -e 's/^\+//'
}

copy_prev() {
    cp -p ${MONITORED} ${PREVIOUS}
}

# main
main() {
    # 監視対象ファイルが存在しなければrc 127で抜ける
    if [ ! -f ${MONITORED} ]; then
        echo "${MONITORED} not exists" >&2
        exit 127
    fi

    # 前回のsnapが存在しなければsnapを作成してrc 126で抜ける
    if [ ! -f ${PREVIOUS} ]; then
        echo "${PREVIOUS} not exists" >&2
        echo "create ${PREVIOUS} and exit" >&2
        copy_prev
        exit 126
    fi

    # prevとmonitoredを比較して差分をtrapに渡す
    check_diff | trap

    # monitoredのsnapを作成して終了
    copy_prev
}

main
