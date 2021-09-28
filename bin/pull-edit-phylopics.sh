#! /usr/bin/env bash 

gv_path="../phylopics/gekko-vittatus.svg"
gg_path="../phylopics/gekko-gecko.svg"
gp_path="../phylopics/gecko-pixabay-cc0.png"

echo "Getting phylopics..."
if [ ! -e "$gv_path" ]
then
    curl -o "$gv_path" http://phylopic.org/assets/images/submissions/21ebdb0e-35ac-4e66-a7ba-99c101a7c2d1.svg
fi
if [ ! -e "$gg_path" ]
then
    curl -o "$gg_path" http://phylopic.org/assets/images/submissions/9aca34d8-4dde-418d-9fdc-2d58b6a7b267.svg
fi
echo "done."

paths="${gv_path} ${gg_path} ${gp_path}"

# colors="red_#f00000 orange_#ff8000 yellow_#ffff00 green_#007940 blue_#4040ff violet_#a000c0"
colors="green_rgb(50,162,81) \
    orange_rgb(255,127,15) \
    blue_rgb(60,183,204) \
    yellow_rgb(255,217,74) \
    teal_rgb(57,115,124) \
    auburn_rgb(184,90,13) \
    viridis000_rgb(68,1,84) \
    viridis005_rgb(71,18,101) \
    viridis010_rgb(72,35,116) \
    viridis015_rgb(69,52,127) \
    viridis020_rgb(64,67,135) \
    viridis025_rgb(58,82,139) \
    viridis030_rgb(52,94,141) \
    viridis035_rgb(46,107,142) \
    viridis040_rgb(41,120,142) \
    viridis045_rgb(36,132,141) \
    viridis050_rgb(32,144,140) \
    viridis055_rgb(30,155,137) \
    viridis060_rgb(34,167,132) \
    viridis065_rgb(47,179,123) \
    viridis070_rgb(68,190,112) \
    viridis075_rgb(94,201,97) \
    viridis080_rgb(121,209,81) \
    viridis085_rgb(154,216,60) \
    viridis090_rgb(189,222,38) \
    viridis095_rgb(223,227,24)"

for g_path in $paths;
do
    n=1
    for c in $colors
    do
        color="${c%%_*}"
        color_code="${c##*_}"
        fuzz="90%"
        n_string="-${n}-"
        if [[ $color == viridis* ]]
        then
            n_string="-"
        fi
        out_path="${g_path/\.svg/$n_string$color\.png}"
        shadow_path="${g_path/\.svg/$n_string$color-shadow\.png}"
        if [ "$g_path" = "$gp_path" ]
        then
            # fuzz="80%"
            out_path="${g_path/\.png/$n_string$color\.png}"
            shadow_path="${g_path/\.png/$n_string$color-shadow\.png}"
        fi
        echo "Converting to $color ($color_code)..."
        convert "$g_path" -fuzz "$fuzz" -transparent white -fill "$color_code" -opaque black "$out_path"
        convert "$out_path" \( +clone -background black -shadow 95x9+20+20 \) +swap -background none -layers merge +repage "$shadow_path" 
        echo "done."
        n=$(expr $n + 1)
    done
done
