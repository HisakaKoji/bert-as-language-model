### environment

bert-as-language-model]# ls model
bert_config.json                              model_model.ckpt-1400000.index  wiki-ja.model
model_model.ckpt-1400000.data-00000-of-00001  model_model.ckpt-1400000.meta   wiki-ja.vocab

実行
sh run_check.sh


## BERT as Language Model



For a sentence <!-- S = w_1, w_2,..., w_k --> ![](https://user-images.githubusercontent.com/13825126/51437437-6d600100-1cd9-11e9-993a-c119186c5f6e.gif), we have


![](https://user-images.githubusercontent.com/13825126/51437439-7355e200-1cd9-11e9-88fe-3d4c9fc2229b.gif)
<!-- p(S) = \prod_{i=1}^{k} p(w_i | context) -->


In traditional language model, such as RNN,  <!-- context = w_1, ..., w_{i-1} --> ![equ3](https://user-images.githubusercontent.com/13825126/51437440-73ee7880-1cd9-11e9-9a78-7cf21bd04bf6.gif), 

![equ4](https://user-images.githubusercontent.com/13825126/51437441-781a9600-1cd9-11e9-8d6d-4a720d04347c.gif)
<!-- p(S) = \prod_{i=1}^{k} p(w_i | w_1, ..., w_{i-1}) -->

In bidirectional language model, it has larger context, <!-- context = w_1, ..., w_{i-1},w_{i+1},...,w_k -->
![equ5](https://user-images.githubusercontent.com/13825126/51437442-781a9600-1cd9-11e9-8207-87718b8f6a28.gif).

In this implementation, we simply adopt the following approximation,

![equ6](https://user-images.githubusercontent.com/13825126/51437443-78b32c80-1cd9-11e9-917e-88824d3e456f.gif)
<!-- p(S) \approx \prod_{i=1}^{k} p(w_i | w_1, ..., w_{i-1},w_{i+1}, ...,w_k) -->

<!--
1. 近似相等
2. 句子越长，单个word预测的概率越大，ppl越大？传统的RNN也有这个问题
-->

<!-- n-gram
n-gram models construct tables of conditional probabilities for the next word,

Under Markov assumption, the context is the all the 
-->


### test-case

> [more cases: 中文](cases/test.zh.md)


```bash
export BERT_BASE_DIR=model/uncased_L-12_H-768_A-12
export INPUT_FILE=data/lm/test.en.tsv
python run_lm_predict.py \
  --input_file=$INPUT_FILE \
  --vocab_file=$BERT_BASE_DIR/vocab.txt \
  --bert_config_file=$BERT_BASE_DIR/bert_config.json \
  --init_checkpoint=$BERT_BASE_DIR/bert_model.ckpt \
  --max_seq_length=128 \
  --output_dir=/tmp/lm_output/
```

for the following test case

```bash
$ cat data/lm/test.en.tsv 
there is a book on the desk
there is a plane on the desk
there is a book in the desk

$ cat /tmp/lm/output/test_result.json
```
output:

```yml
[
  {
    "tokens": [
      {
        "token": "there",
        "prob": 0.9988962411880493
      },
      {
        "token": "is",
        "prob": 0.013578361831605434
      },
      {
        "token": "a",
        "prob": 0.9420605897903442
      },
      {
        "token": "book",
        "prob": 0.07452250272035599
      },
      {
        "token": "on",
        "prob": 0.9607976675033569
      },
      {
        "token": "the",
        "prob": 0.4983428418636322
      },
      {
        "token": "desk",
        "prob": 4.040586190967588e-06
      }
    ],
    "ppl": 17.69329728285426
  },
  {
    "tokens": [
      {
        "token": "there",
        "prob": 0.996775209903717
      },
      {
        "token": "is",
        "prob": 0.03194097802042961
      },
      {
        "token": "a",
        "prob": 0.8877727389335632
      },
      {
        "token": "plane",
        "prob": 3.4907534427475184e-05   # low probability
      },
      {
        "token": "on",
        "prob": 0.1902322769165039
      },
      {
        "token": "the",
        "prob": 0.5981084704399109
      },
      {
        "token": "desk",
        "prob": 3.3164762953674654e-06
      }
    ],
    "ppl": 59.646456254851806
  },
  {
    "tokens": [
      {
        "token": "there",
        "prob": 0.9969795942306519
      },
      {
        "token": "is",
        "prob": 0.03379646688699722
      },
      {
        "token": "a",
        "prob": 0.9095568060874939
      },
      {
        "token": "book",
        "prob": 0.013939591124653816
      },
      {
        "token": "in",
        "prob": 0.000823647016659379  # low probability
      },
      {
        "token": "the",
        "prob": 0.5844194293022156
      },
      {
        "token": "desk",
        "prob": 3.3361218356731115e-06
      }
    ],
    "ppl": 54.65941516205144
  }
]
```



