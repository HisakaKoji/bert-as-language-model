export BERT_BASE_DIR=model
export INPUT_FILE=data/lm/test.ja.tsv
python3 run_lm_predict.py   --input_file=$INPUT_FILE   --vocab_file=$BERT_BASE_DIR/wiki-ja.vocab   --bert_config_file=$BERT_BASE_DIR/bert_config.json   --init_checkpoint=$BERT_BASE_DIR/model_model.ckpt-1400000   --max_seq_length=128   --output_dir=/tmp/lm_output/   --jp_tokenizer=True

cp /tmp/lm_output/test_results.json  .
