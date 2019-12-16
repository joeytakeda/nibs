
/* Javascript file for HRN project */

if (window.addEventListener) window.addEventListener('load', init, false)
else if (window.attachEvent) window.attachEvent('onload', init);


var docId = document.getElementsByTagName('html')[0].id;

function init(){
    enablePopups(document.getElementsByTagName('body')[0]);
    
}


function scrollToChapter(){
    var currChapter = document.querySelectorAll('aside li>a.current')[0].parentNode;
    currChapter.scrollIntoView();   
}


 function enablePopups(el){
    
    
    /* First enable the popup closer */
    document.getElementById('popup_closer').addEventListener('click',closePopup, false);
    
    /* Add the popup div event listener.. */
    document.getElementById('popup').addEventListener('transitionend',function(){
        if (!this.classList.contains('enabled')){
            clearPopup();
        }
    }, false);
    
     var localLinks = el.querySelectorAll("a[href^='#']");
     
     localLinks.forEach(function(l){
         var ref = l.getAttribute('href');
         if (ref.length > 1){
           if (document.getElementById('appendix').querySelectorAll(l.getAttribute('href')).length == 1){
             l.classList.add('js');   
             addPopupEvent(l); 
            } else {
                l.classList.add('error');
            }
         } else {
             l.classList.add('error');
         }
     });
 }
 
  function addPopupEvent(el){
     var appendixDiv = document.getElementById('appendix');
     var hits = appendixDiv.querySelectorAll(el.getAttribute('href'));
     var inAppendix = (hits.length == 1)
     if (inAppendix){
         el.addEventListener('click',function(e){
            e.preventDefault();
            popup(el, hits[0]);
         }, false);
     } else {
         console.log('Link not available...');
     }
 }
 
  function popup(el, content){
    if (el.classList.contains('active')){
        closePopup();
        el.classList.remove('active');
        return;
    }
    removeActive();
    el.classList.add('active');
    var popupDiv = document.getElementById('popup');
    clearPopup();
    var popup_content = document.getElementById('popup_content');
    var inner = content.childNodes;
    for (var i=0; i < inner.length; i++){
       var clone = inner[i].cloneNode(true);
       popup_content.appendChild(clone);
     }
     if (popup_content.querySelectorAll('.map').length > 0){
         var mapDiv = popup_content.querySelectorAll('.map')[0];
         var thisLat = content.getAttribute('data-lat');
         var thisLon = content.getAttribute('data-lon');
         var latLng = L.latLng(thisLat * 1, thisLon * 1);
         var map = L.map(mapDiv).setView(latLng, 12);
 
      // add the OpenStreetMap tiles
      L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        maxZoom: 19,
        attribution: '© <a href="https://openstreetmap.org/copyright">OpenStreetMap contributors</a>'
      }).addTo(map);
       

      // show the scale bar on the lower left corner
      L.control.scale().addTo(map);
      
      
      console.log(latLng);
      
     }
      popupDiv.setAttribute('data-src', content.id);
      popupDiv.classList.add('enabled');
      updateControls(el);
      enablePopups(popup_content);
 }
 
 
 function updateControls(el){
     var localLinks = document.getElementsByTagName('body')[0].querySelectorAll("a[href^='#'].js");
     var prevButton = document.getElementById('prevAnn');
     var nextButton = document.getElementById('nextAnn');
     var prevEl = null;
     var nextEl = null;
     
     var emulatePrevEvent = function(){
        if (prevEl !== null){
           prevEl.scrollIntoView();
           prevEl.click();
        }
     }
     
     var emulateNextEvent = function(){
        console.log(nextEl);
         if (nextEl !== null){
            nextEl.scrollIntoView();
            nextEl.click();
         }
     }
     
     for (var i = 0; i < localLinks.length; i++){
         if (localLinks[i] == el){
             if (i > 0){
                prevButton.classList.remove('disabled');
                prevEl = localLinks[i - 1];
              } else {
                  prevButton.classList.add('disabled');
              }
              
              if (i < localLinks.length - 1){
                nextButton.classList.remove('disabled');
                 nextEl = localLinks[i + 1];
              } else {
                  nextButton.classList.add('disabled');
              }
           break;
         }
     }

        prevButton.addEventListener("click", emulatePrevEvent, true);
        nextButton.addEventListener("click", emulateNextEvent, true);
 }
 
 
 function closePopup(){
     var popupDiv = document.getElementById('popup');
     
     popupDiv.classList.remove('enabled');
     removeActive();
 }
 
 function removeActive(){
     var active = document.getElementsByClassName('active');
     while (active.length > 0){
         active[0].classList.remove('active');
     }
 }
 
 function clearPopup(){
      var popup = document.getElementById('popup');
      popup.removeAttribute('data-src');
      var popup_content = document.getElementById('popup_content');
      while (popup_content.childNodes.length > 0){
         popup_content.removeChild(popup_content.childNodes[0]);
     }
      reset(document.getElementById('prevAnn'));
      reset(document.getElementById('nextAnn'));
      var maps = popup.querySelectorAll('.map');
      if (maps.length > 0){
          for (var i=0; i < maps.length; i++){
                if (maps[i].remove){
                    maps[i].off();
                    maps[i].remove();
                }
          }
      }

 }
 
 function reset(el){
        var newEl = el.cloneNode(true);
        el.parentNode.replaceChild(newEl, el);
 }
 
 

function startTyping(){
    const instance = new Typewriter('#byline', {
      strings: ['Winnifred Eaton', 'Onoto Watanna', 'Winifred Reeve', 'Winnifred Eaton Reeve'],
      autoStart: true,
      loop: true,
      cursor:""
    });
}