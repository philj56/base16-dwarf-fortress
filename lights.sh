#!/bin/bash

function alt_colour {
        value=$(echo -e "$1\n$2\n$3" | sort -n | tail -n1)

        if [ "$4" = "1" ]; then
                colour=$1
        elif [ "$4" = "2" ]; then
                colour=$2
        else
                colour=$3
        fi

        printf "%.0f\n" $(echo "$colour * 255 / $value" | bc -l)
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
        echo -n "$file... "
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
        echo "done."
done
