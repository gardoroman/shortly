// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
// import "../css/app.scss"
import "../css/app.css";

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html";


const buttons = document.getElementsByClassName('copy-button');

const setClipboard = text =>  {
    const type = 'text/plain';
    const blob = new Blob([text], { type });
    const data = [new ClipboardItem({ [type]: blob })];
  
    navigator.clipboard.write(data).then(function() {
      /* success */
      console.log('clickboard copied')

    }, function() {
      /* failure */
      console.log('copy to clipboard failed')

    });
};
  

const handleClickEvent = event => {
    
    let shortenedUrl = event.currentTarget.parentNode.previousElementSibling.innerText;
    console.log(shortenedUrl)
    setClipboard(shortenedUrl)
}

Array.from(buttons).forEach( button => {
    button.addEventListener('click', handleClickEvent);
});

