#!/bin/bash

function alt_colour {
        difference_r=$(echo "255-$1" | bc)
        difference_g=$(echo "255-$2" | bc)
        difference_b=$(echo "255-$3" | bc)
        value=$(echo -e "$difference_r\n$difference_g\n$difference_b" | sort -n | tail -n1)
        new_r=$(echo "$difference_r*(255-$value)/$value" | bc)
        new_g=$(echo "$difference_g*(255-$value)/$value" | bc)
        new_b=$(echo "$difference_b*(255-$value)/$value" | bc)

        if [ "$4" = "1" ]; then
                echo "$1 - $new_r" | bc
        elif [ "$4" = "2" ]; then
                echo "$2 - $new_g" | bc
        else
                echo "$3 - $new_b" | bc
        fi
}

function get_colour {
        echo "$1" | sed "s/.*:\(.*\)]/\1/g"
}

function replace_colour {
        echo "$1" | sed "s/\(.*:\).*]/\1$2]/g"
}

function add_escapes {
        echo "$1" | sed "s/\[/\\\[/g" | sed "s/\]/\\\]/g"
}

l_lines[0]=30
l_lines[1]=31
l_lines[2]=32
l_lines[3]=33
l_lines[4]=34
l_lines[5]=35
l_lines[6]=36
l_lines[7]=37
l_lines[8]=38
l_lines[9]=39
l_lines[10]=40
l_lines[11]=41
l_lines[12]=42
l_lines[13]=43
l_lines[14]=44 

for file in colors/*.txt; do
        dos2unix -q $file
        mapfile -t lines < $file
        for i in 0 1 2 3 4; do
                i_r=$(echo "$i * 3" | bc)
                i_g=$(echo "$i * 3 + 1" | bc)
                i_b=$(echo "$i * 3 + 2" | bc)
                old_r_line=${lines[${l_lines[$i_r]}]}
                old_g_line=${lines[${l_lines[$i_g]}]}
                old_b_line=${lines[${l_lines[$i_b]}]}
                old_r=$(get_colour $old_r_line)
                old_g=$(get_colour $old_g_line)
                old_b=$(get_colour $old_b_line)
                new_r=$(alt_colour $old_r $old_g $old_b 1)
                new_g=$(alt_colour $old_r $old_g $old_b 2)
                new_b=$(alt_colour $old_r $old_g $old_b 3)
                old_r_line=$(add_escapes $old_r_line)
                old_g_line=$(add_escapes $old_g_line)
                old_b_line=$(add_escapes $old_b_line)
                new_r_line=$(replace_colour $old_r_line $new_r)
                new_g_line=$(replace_colour $old_g_line $new_g)
                new_b_line=$(replace_colour $old_b_line $new_b)
                sed -i "s/$old_r_line/$new_r_line/g" $file
                sed -i "s/$old_g_line/$new_g_line/g" $file
                sed -i "s/$old_b_line/$new_b_line/g" $file
        done
        echo "Done $file"
done
