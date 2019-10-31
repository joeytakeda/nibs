
/* Javascript file for HRN project */

if (window.addEventListener) window.addEventListener('load', init, false)
else if (window.attachEvent) window.attachEvent('onload', init);


var docId = document.getElementsByTagName('html')[0].id;

function init(){
    if (docId.match('^chapter')){
      scrollToChapter();
    }
   
}


function scrollToChapter(){
    var currChapter = document.querySelectorAll('aside li>a.current')[0].parentNode;
    currChapter.scrollIntoView();
    
}

function startTyping(){
    const instance = new Typewriter('#byline', {
      strings: ['Winnifred Eaton', 'Onoto Watanna', 'Winifred Reeve', 'Winnifred Eaton Reeve'],
      autoStart: true,
      loop: true,
      cursor:""
    });
}