function handler(event) {
    console.log('Injecting ubuntu touch styling fixes');

    var style = document.createElement('style');
    style.type = 'text/css';
    style.appendChild(document.createTextNode(
        '#nav { display: none;} ' 
    ));

    document.head.appendChild(style);
}

window.addEventListener('load', handler, false);
