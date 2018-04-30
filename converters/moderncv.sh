#!/bin/bash
[ $# -lt 1 ] && echo "$0 yml_file" && exit 1

TMP_BUILD_DIR="tmp_build_"`date +%s`
rm -fr $TMP_BUILD_DIR
mkdir $TMP_BUILD_DIR

function common() {
    echo
}

function entry() {
    moderncv="$TMP_BUILD_DIR/moderncv.md"
    moderncvbank="$TMP_BUILD_DIR/moderncvbank.md"
    echo $blocktitle >> $moderncv
    echo $blocktitle >> $moderncvbank
    
    for id in `seq 0 $entry_len`;do
        entry=`cat $1 |shyaml get-value entrys.$id.entry`
        date=`cat $1 |shyaml get-value entrys.$id.date`
        major=`cat $1 |shyaml get-value entrys.$id.major`
        section=`cat $1 |shyaml get-value entrys.$id.section`
        title=`cat $1 |shyaml get-value entrys.$id.title`
        echo "\cventry{$date}{$entry}{$section}{$title}{$major}{}" >> $TMP_BUILD_DIR/moderncv.md
        echo "\cventry{$date}{$title}{$entry}{$section}{$major}{}" >> $TMP_BUILD_DIR/moderncvbank.md
    done
}

function project() {
    echo
}

function item() {
    echo
}

function bank() {
    block_len=`cat $1 |shyaml get-length spec`
    ((block_len--))
    
    for id in `seq 0 $block_len`;do
        TMPFILE=$TMP_BUILD_DIR/$id.yml
        cat $1 |shyaml get-value spec.$id > $TMPFILE
        
        blocktitle=`cat $TMPFILE |shyaml get-value title`
        entry_len=`cat $TMPFILE |shyaml get-length entrys`
        ((entry_len--))
        
        blocktype=`cat $TMPFILE |shyaml get-value type`
        eval $blocktype $TMPFILE
    done
}

bank $1
#rm -fr $TMP_BUILD_DIR