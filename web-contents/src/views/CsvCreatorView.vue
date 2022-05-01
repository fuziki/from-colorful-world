<template>
  <div class="body">
    <h1 class="header">CSV Creator</h1>
    <div class="config-panel" :style="{width: reactiveWidth}">
      <div class="view-name">
        <label class="view-name-input-title">提出物名</label>
        <input id="view-name-input" type="text" v-model="text" :placeholder="placeholderName" @input="onChangeInput">
        <div class="text_underline"></div>
      </div>
    </div>
    <button disabled class="copy-button" id="copy-button" v-on:click="download">CSVをダウンロード</button>
  </div>
</template>

<script lang="ts">

export default {
  data() {
    return {
      text: "",
      placeholderName: "ここに提出物名を入力",
      reactiveWidth: "25ch",
    };
  },
  methods: {
  	download: function() {
      let str = "";
      for (let i = 1; i <= 40; i++) {
        str = str + this.text + ( '00' + i ).slice( -2 ) + "\r\n";
      }
      let blob = new Blob([str], {type : "text/csv;charset=utf-8"});
      let blobURL = window.URL.createObjectURL(blob);
      let obj = document.createElement('a');
      obj.href = blobURL;
      obj.download = this.text + ".csv"
      document.body.appendChild(obj);
      obj.click();
      obj.parentNode.removeChild(obj);
    },
    onChangeInput: function(event) {
      if((event.target.value.length) * 2 > 15) {
        this.reactiveWidth = ((event.target.value.length) * 2 + 10) + "ch"
      } else {
        this.reactiveWidth = "25ch"
      }
      document.getElementById("copy-button").disabled = event.target.value.length == 0;
    },
  }
};
</script>

<style>
.body {
  align-items: center;
}
.header {
  text-align : center;
}
.config-panel {
  right: 0;
  left: 0;
  margin-right: auto;
  margin-left: auto;
  margin-top: 16px;
}
.view-name {
  margin-top: 16px;
  padding: 0px 4px 0px 4px;
  background-color: #FFF3E0;
  color: #455A64;
}
.view-name-input-title {
  margin-left: 4px;
  text-align: left;
  display: inline-block;
  width: 100%;
  font-size: 12px;
}
#view-name-input {
  font-size: 16px;
  font-weight: bold;
  width: 100%;
  border: none;
  outline: none;
  padding-bottom: 4px;
  background-color: #FFF3E0;
}
.text_underline {
  position: relative;
  border-top: 2px solid #546E7A;
  margin-left: -4px;
  margin-right: -4px;
}
.text_underline::before,
.text_underline::after{
  position: absolute; 
  bottom: 0px;
  width: 0px;
  height: 2px;
  content: '';
  background-color: #FB8C00;
  left: 0px;
}
#view-name-input:focus + .text_underline::after {
  width: 100%;
}
.copy-button {
  border-radius: 1000px;
  border: 2px solid #FB8C00;
  font-size: 16px;
  font-weight: bold;
  padding: 8px 32px;
  color: #FB8C00;
  background-color: #FFFFFF;
  margin: 32px;
}
.copy-button:disabled {
  border-radius: 1000px;
  border: 2px solid #546E7A;
  font-size: 16px;
  font-weight: bold;
  padding: 8px 32px;
  color: #546E7A;
  background-color: #FFFFFF;
  margin: 32px;
}
</style>