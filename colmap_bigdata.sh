while read line
do
#change path
cd $line
model_path="/home/konbe/HDD6TB/localization/bigdata/reference/querymodel/"$line

images_path=$model_path'/images'
database_path=$model_path'/reference.db'
dblist_path=$images_path'/dblist.txt'
querylist_path=$images_path'/querylist.txt'
matchlist_path=$model_path'/matchlist.txt'
vocabtree_path='/home/konbe/HDD6TB/localization/reference/engine_vocabtree.bin'

input=$model_path
output="${model_path}/output"
if ! [ -e $output ]; then
    mkdir -p $output
fi

colmap feature_extractor \
    --database_path $database_path \
    --image_path $images_path \
    --image_list_path $querylist_path \
    --ImageReader.single_camera 1 \
    --ImageReader.camera_model OPENCV_FISHEYE \
    --ImageReader.camera_params "721.645076, 721.299752, 522.600000, 395.830000, -0.123349, -0.012539, 0.009413, -0.004879"

colmap vocab_tree_retriever \
--database_path $database_path \
--vocab_tree_path $vocabtree_path \
--database_image_list_path $dblist_path \
--query_image_list_path $querylist_path \
--num_images 10 \

colmap matches_importer \
--database_path $database_path \
--match_list_path $matchlist_path \
--SiftMatching.max_num_matches 8192

colmap image_registrator \
    --database_path $database_path \
    --input_path $input \
    --output_path $output

colmap model_converter \
--input_path $output \
--output_path $output \
--output_type TXT

cd ..
done < rewrite.txt


