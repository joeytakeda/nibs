
/* Javascript file for HRN project */

if (window.addEventListener) window.addEventListener('load', init, false)
else if (window.attachEvent) window.attachEvent('onload', init);




function init(){
    scrollToChapter();
    
}


function scrollToChapter(){
    var currChapter = document.querySelectorAll('aside li>a.current')[0].parentNode;
    currChapter.scrollIntoView();
    
}