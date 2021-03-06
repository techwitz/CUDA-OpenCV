
# Making a custom fish object detector to track Atlantic Salmon _Salmo salar_ 

The journey starts here https://tensorflow-object-detection-api-tutorial.readthedocs.io/en/latest/training.html

I would like to thank the creators of the following pages:
- https://github.com/tzutalin/labelImg
- https://github.com/datitran/raccoon_dataset
- https://pythonprogramming.net/training-custom-objects-tensorflow-object-detection-api-tutorial/
- https://tensorflow-object-detection-api-tutorial.readthedocs.io/en/latest/training.html

I will try to create a script later but here are my steps towards a custom object detector.

```bash
# Install some packages
sudo apt-get install -y git ssh build-essential linuxbrew-wrapper

# Install PIP for Python 3
sudo apt install -y python3-pip
python3 -m pip install --upgrade --user pip
sudo apt install -y python3-testresources

```


2nd run of 
==> Select the Linuxbrew installation directory
- Enter your password to install to /home/linuxbrew/.linuxbrew (recommended)
- Press Control-D to install to /home/jarleven/.linuxbrew
- Press Control-C to cancel installation







How can we answer "yes" in homebrew?
```bash
brew install protobuf
```

### Set the paths

During this endeavour I have failed to get the "paths" right several times. This topic will be investigated more while completing the custom object detector setup script. 

"The right place to define environment variables such as PATH is ~/.profile (or ~/.bash_profile if you don't care about shells other than bash)" Please refer to  [this link](https://superuser.com/questions/183870/difference-between-bashrc-and-bash-profile/183980#183980) for more information.


"An important point is that, even if system scripts do not use this (I wonder why)*1, the bullet-proof way to add a path (e.g., $HOME/bin) to the PATH environment variable to
avoid the spurious leading/trailing colon when $PATH is initially empty, which can have undesired side effects and can become a nightmare" Please refer to  [this link](https://unix.stackexchange.com/questions/26047/how-to-correctly-add-a-path-to-path) for more information.

Some examples
```bash
# For appending a path 
PATH="${PATH:+${PATH}:}$HOME/bin"
echo 'export PATH="${PATH:+${PATH}:}$HOME/bin"' >> ~/.bash_profile
# For prepending to the path 
PATH="$HOME/bin${PATH:+:${PATH}}"
```

For this setup the following was done
```bash
echo 'export PYTHONPATH="${PYTHONPATH:+${PYTHONPATH}:}$HOME/TensorFlow/models/research/object_detection:$HOME/TensorFlow/models/research:$HOME/TensorFlow/models/research/slim"' >> ~/.bash_profile

# Yes this is done above
# "export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim"
# Print-working-directory pwd should be done from within the TensorFlow/models/research/ folder according the guides.

echo 'export PATH="${PATH:+${PATH}:}$HOME/.local/bin:/home/linuxbrew/.linuxbrew/bin"' >> ~/.bash_profile

echo 'export MANPATH="${MANPATH:+${MANPATH}:}/home/linuxbrew/.linuxbrew/share/man"' >> ~/.bash_profile

echo 'export INFOPATH="${INFOPATH:+${INFOPATH}:}/home/linuxbrew/.linuxbrew/share/info"' >> ~/.bash_profile

source ~/.bash_profile
```

Need to look into this in more details the next time I do the setup
```bash

#sudo apt install -y python3-dev python3-numpy
python3 -m pip install --upgrade --force-reinstall Cython --user
python3 -m pip install --upgrade --force-reinstall pycocotools --user
python3 -m pip install --upgrade --force-reinstall pandas --user
```



####  At the time of writing 1.15 is the lastest / final 1.x version.
```bash
#python3 -m pip install --upgrade --force-reinstall tensorflow==1.15 --user
```

Using this without GPU for training is probably in vain. For a dataset with 1k images will take several weeks and weeks to train. Initially I see aprox 150x on the GPU compared to the CPU.
 - 200ms / step on a GTX1060 3GB		11 hours for 200.000 steps
 - 30sec / step on my CPU			2 months 
 
 ```bash
python3 -m pip install --upgrade --force-reinstall tensorflow-gpu==1.15 --user
 ```
 
 #### The system
 - Ubuntu 18.04.4 
 - NVIDIA driver Version: 440.59
 - CUDA 10.0
 - cuDNN 7.6.4.38 for CUDA 10.0



Make the folder structure 
 ```bash
mkdir ~/TensorFlow

cd ~/TensorFlow

mkdir workspace
mkdir workspace/training_demo
mkdir workspace/training_demo/annotations
mkdir workspace/training_demo/images
mkdir workspace/training_demo/images/test
mkdir workspace/training_demo/images/train
mkdir workspace/training_demo/pre-trained-model
mkdir workspace/training_demo/training

mkdir scripts
mkdir scripts/preprocessing
 ```




Get the "Models and examples built with TensorFlow"
 ```bash
cd ~/TensorFlow
git clone https://github.com/tensorflow/models.git
 ```
If you would like to test if Tensorflow is working
 ```bash
cd ~/TensorFlow/models/tutorials/image/imagenet
python3 classify_image.py
```

To check out a tag do
```bash
git clone https://github.com/tensorflow/models.git --tag 2.0.0
```


From within TensorFlow/models/research/
 ```bash
cd ~/TensorFlow/models/research/ && protoc object_detection/protos/*.proto --python_out=.
 ```

From within TensorFlow/models/research/
 ```bash
python3 setup.py build
sudo python3 setup.py install
 ```



TODO ADD some text
 ```bash
cd ~
git clone https://github.com/cocodataset/cocoapi.git
cd cocoapi/PythonAPI
```

==TODO edit python to python3 two places in the Makefile==

```bash
git diff --ignore-space-at-eol -b -w --ignore-blank-lines > ~/TensorFlow/patches/cocoapi-python3.diff
 ```
 
 ```bash

make
cp -r pycocotools ~/TensorFlow/models/research/
```


Copy the backup of all the images annotaed with LabelImg
```bash
cp -r /media/$USER/CUDA/laks ~/
```
Split in approx 10% test and 90% train images (I had 800 annotated images)
```bash
cd ~/laks
cp {00001..00080}.jpg ~/TensorFlow/workspace/training_demo/images/test/
cp {00001..00080}.xml ~/TensorFlow/workspace/training_demo/images/test/
cp * ~/TensorFlow/workspace/training_demo/images/train
```


Create the label map file
```bash
vi ~/TensorFlow/workspace/training_demo/annotations/label_map.pbtxt
```
put the following in this file
```java
item {
    id: 1
    name: 'salmon'
}
```



Paste the xml_to_csv.py from https://tensorflow-object-detection-api-tutorial.readthedocs.io/en/latest/training.html into your own file
```bash
<<<< cd ~/TensorFlow/scripts/preprocessing/
<<<< vi xml_to_csv.py

cp ~/CUDA-OpenCV/CUDA102-OpenCV420/xml_to_csv.py ~/TensorFlow/scripts/preprocessing/



```
Paste the generate_tfrecord.py from https://tensorflow-object-detection-api-tutorial.readthedocs.io/en/latest/training.html into your own file
```bash
<<<< cd ~/TensorFlow/scripts/preprocessing 
<<<< vi generate_tfrecord.py

cp ~/CUDA-OpenCV/CUDA102-OpenCV420/generate_tfrecord.py ~/TensorFlow/scripts/preprocessing

```

```bash

cd ~/TensorFlow/scripts/preprocessing 
python3 xml_to_csv.py -i ~/TensorFlow/workspace/training_demo/images/train -o ~/TensorFlow/workspace/training_demo/annotations/train_labels.csv
python3 xml_to_csv.py -i ~/TensorFlow/workspace/training_demo/images/test -o ~/TensorFlow/workspace/training_demo/annotations/test_labels.csv

```


#### ABSOLUTE PATH IS NEEDED HERE !!!!!!!!

#### Remember that the label is the labels used in your annotations!
In this case the label is ==salmon==

```bash
python3 generate_tfrecord.py --label=salmon --csv_input=/home/$USER/TensorFlow/workspace/training_demo/annotations/train_labels.csv --output_path=/home/$USER/TensorFlow/workspace/training_demo/annotations/train.record --img_path=/home/$USER/TensorFlow/workspace/training_demo/images/train
python3 generate_tfrecord.py --label=salmon --csv_input=/home/$USER/TensorFlow/workspace/training_demo/annotations/test_labels.csv --output_path=/home/$USER/TensorFlow/workspace/training_demo/annotations/test.record --img_path=/home/$USER/TensorFlow/workspace/training_demo/images/test
```
```bash
cd ~
wget http://download.tensorflow.org/models/object_detection/ssd_inception_v2_coco_2018_01_28.tar.gz
tar xvzf ssd_inception_v2_coco_2018_01_28.tar.gz
cd ~/ssd_inception_v2_coco_2018_01_28



http://download.tensorflow.org/models/object_detection/ssd_mobilenet_v1_quantized_300x300_coco14_sync_2018_07_18.tar.gz"
http://download.tensorflow.org/models/object_detection/ssd_mobilenet_v2_quantized_300x300_coco_2019_01_03.tar.gz"





>>>>> cd ~
>>>>> wget http://download.tensorflow.org/models/object_detection/ssd_mobilenet_v2_quantized_300x300_coco_2019_01_03.tar.gz
>>>>> tar xvzf ssd_mobilenet_v2_quantized_300x300_coco_2019_01_03.tar.gz
>>>>> cd ~/ssd_mobilenet_v2_quantized_300x300_coco_2019_01_03

>>>>> cp ~/CUDA-OpenCV/CUDA102-OpenCV420/ssd_mobilenet_v2_quantized_pipeline.config ~/TensorFlow/workspace/training_demo/training/



rm -rf ~/TensorFlow/workspace/training_demo/pre-trained-model/*
cp -r * ~/TensorFlow/workspace/training_demo/pre-trained-model/

cp pipeline.config ~/TensorFlow/workspace/training_demo/training/
vi ~/TensorFlow/workspace/training_demo/training/pipeline.config

diff ~/TensorFlow/workspace/training_demo/training/pipeline.config ~/ssd_inception_v2_coco_2018_01_28/pipeline.config > ~/pipeline.patch


cp ~/TensorFlow/models/research/object_detection/legacy/train.py ~/TensorFlow/workspace/training_demo/
```


### ==The above DID NOT WORK, I had to download a new pipeline.config file==
```bash
cd ~/TensorFlow/workspace/training_demo/
python3 train.py --logtostderr --train_dir=training/ --pipeline_config_path=training/ssd_inception_v2_coco.config
>>>> python3 train.py --logtostderr --train_dir=training/ --pipeline_config_path=training/ssd_mobilenet_v2_quantized_pipeline.config
```



source ~/.bash_profile 
cp ~/CUDA-OpenCV/CUDA102-OpenCV420/ssd_mobilenet_v2_quantized_pipeline.config ~/TensorFlow/workspace/training_demo/training/pipeline.config 

cd ~/TensorFlow/models/research/
protoc object_detection/protos/*.proto --python_out=.


cd ~/TensorFlow/workspace/training_demo/
python3 train.py --logtostderr --train_dir=training/ --pipeline_config_path=training/pipeline.config


>>>> screen -d -r



>>>>>>>>  Worked kind of....

mkdir /home/jarleven/frozen
cd ~/TensorFlow/models/research/object_detection



python3 export_tflite_ssd_graph.py \
  --pipeline_config_path="/home/jarleven/TensorFlow/workspace/training_demo/training/ssd_mobilenet_v2_quantized_pipeline.config" \   <<<<<<<<<<<<<<  pipeline.config
  --trained_checkpoint_prefix="/home/jarleven/TensorFlow/workspace/training_demo/training/model.ckpt-51718" \
  --output_directory="/home/jarleven/frozen" \
  --add_postprocessing_op=true
  
INPUT_TENSORS='normalized_input_image_tensor'
OUTPUT_TENSORS='TFLite_Detection_PostProcess,TFLite_Detection_PostProcess:1,TFLite_Detection_PostProcess:2,TFLite_Detection_PostProcess:3'



tflite_convert \
  --output_file="/home/jarleven/frozen/output_tflite_graph.tflite" \
  --graph_def_file="/home/jarleven/frozen/tflite_graph.pb" \
  --inference_type=QUANTIZED_UINT8 \
  --input_arrays="${INPUT_TENSORS}" \
  --output_arrays="${OUTPUT_TENSORS}" \
  --mean_values=128 \
  --std_dev_values=128 \
  --input_shapes=1,300,300,3 \
  --change_concat_input_ranges=false \
  --allow_nudging_weights_to_use_fast_gemm_kernel=true \
  --allow_custom_ops
  

>>>>>>>>>>>

















TODO investigate diff ! compared to the config in the http://download.tensorflow.org/models/object_detection/ssd_inception_v2_coco_2018_01_28.tar.gz

In the .config the batch size was set to 2 for a working training
#OOM and other crashes did happen with 12 and the default 24, PS A VALUE OF 1 ALSO FAILED !!!!
#1.14 with and without tensorflow-gpu was tested without luck i ended on the follwoing TensorFlow installation
```bash

python3 -m pip install --upgrade --force-reinstall tensorflow-gpu==1.15 --user
```
```bash
train_config: {
  batch_size: 2
```
```bash

wget https://raw.githubusercontent.com/developmentseed/label-maker/94f1863945c47e1b69fe0d6d575caa0b42aa8d63/examples/utils/ssd_inception_v2_coco.config

cp ssd_inception_v2_coco.config  ~/TensorFlow/workspace/training_demo/training/
vi ~/TensorFlow/workspace/training_demo/training/ssd_inception_v2_coco.config
```



#### Fire up the tensorboard 
```bash

cd ~/TensorFlow/workspace/training_demo && tensorboard --logdir=training
firefox http://localhost:6006
```

Follow the training in your favorite webbrowser 
 - http://localhost:6006/


##### The salmon model is being created so I saved some of the paths for later in case I forgot to log some of the steps done to get here. More updates when I do a new fresh install.

```bash

echo $PATH
/home/linuxbrew/.linuxbrew/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/home/jarleven/.local/bin


echo $PYTHONPATH
:/home/jarleven/TensorFlow/models/research/object_detection:/home/jarleven/TensorFlow/models/research/object_detection:/home/jarleven/TensorFlow/models/research/object_detection:/home/jarleven/TensorFlow/models/research:/home/jarleven/TensorFlow/models/research/slim



cat ~/.bash_profile
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:~/.local/bin
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"
export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"

```


#### Exporting the model

mkdir ~/EXPORT
cd ~/TensorFlow/models/research/object_detection

python3 export_inference_graph.py \
    --input_type image_tensor \
    --pipeline_config_path /home/jarleven/TensorFlow/workspace/training_demo/training/pipeline.config \
    --trained_checkpoint_prefix /home/jarleven/TensorFlow/workspace/training_demo/training/model.ckpt-200000 \
    --output_directory /home/jarleven/EXPORT



*****************************************************


# From tensorflow/models/research/
INPUT_TYPE=image_tensor
PIPELINE_CONFIG_PATH={path to pipeline config file}
TRAINED_CKPT_PREFIX={path to model.ckpt}
EXPORT_DIR={path to folder that will be used for export}
python object_detection/export_inference_graph.py \
    --input_type=${INPUT_TYPE} \
    --pipeline_config_path=${PIPELINE_CONFIG_PATH} \
    --trained_checkpoint_prefix=${TRAINED_CKPT_PREFIX} \
    --output_directory=${EXPORT_DIR}


https://stackoverflow.com/questions/51220978/how-to-convert-a-retrained-model-to-tflite-format

toco \
  --input_file=frozen_inference_graph.pb \
  --output_file=optimized_graph.lite \
  --input_format=TENSORFLOW_GRAPHDEF \
  --output_format=TFLITE \
  --input_shape=1,224,224,3 \
  --input_array=input \
  --output_array=final_result \
  --inference_type=FLOAT \
  --input_data_type=FLOAT


WARNING:tensorflow:From /home/jarleven/.local/lib/python3.6/site-packages/tensorflow_core/lite/python/convert_saved_model.py:60: load (from tensorflow.python.saved_model.loader_impl) is deprecated and will be removed in a future version.
Instructions for updating:
This function will only be available through the v1 compatibility library as tf.compat.v1.saved_model.loader.load or tf.compat.v1.saved_model.load. There will be a new function for importing SavedModels in Tensorflow 2.0.
Traceback (most recent call last):
  File "convert.py", line 3, in <module>
    converter = tf.lite.TFLiteConverter.from_saved_model("frozen_inference_graph.pb")
  File "/home/jarleven/.local/lib/python3.6/site-packages/tensorflow_core/lite/python/lite.py", line 762, in from_saved_model
    output_arrays, tag_set, signature_key)
  File "/home/jarleven/.local/lib/python3.6/site-packages/tensorflow_core/lite/python/convert_saved_model.py", line 187, in freeze_saved_model
    meta_graph = get_meta_graph_def(saved_model_dir, tag_set)
  File "/home/jarleven/.local/lib/python3.6/site-packages/tensorflow_core/lite/python/convert_saved_model.py", line 60, in get_meta_graph_def
    return loader.load(sess, tag_set, saved_model_dir)
  File "/home/jarleven/.local/lib/python3.6/site-packages/tensorflow_core/python/util/deprecation.py", line 324, in new_func
    return func(*args, **kwargs)
  File "/home/jarleven/.local/lib/python3.6/site-packages/tensorflow_core/python/saved_model/loader_impl.py", line 268, in load
    loader = SavedModelLoader(export_dir)
  File "/home/jarleven/.local/lib/python3.6/site-packages/tensorflow_core/python/saved_model/loader_impl.py", line 284, in __init__
    self._saved_model = parse_saved_model(export_dir)
  File "/home/jarleven/.local/lib/python3.6/site-packages/tensorflow_core/python/saved_model/loader_impl.py", line 83, in parse_saved_model
    constants.SAVED_MODEL_FILENAME_PB))
OSError: SavedModel file does not exist at: frozen_inference_graph.pb/{saved_model.pbtxt|saved_model.pb}


tflite_convert \
  --output_file=foo.tflite \
  --saved_model_dir=./saved_model


tflite_convert \
  --output_file=/tmp/foo.tflite \
  --graph_def_file=frozen_inference_graph.pb \
  --input_arrays=input \
  --output_arrays=MobilenetV1/Predictions/Reshape_1
