function createElementInDiv(plyName, costs, id){
    const plyDiv = document.createElement("div");
    plyDiv.className = "plyDiv"
    document.getElementById("revivestat").appendChild(plyDiv);
    const playerName = document.createElement("h2");
    playerName.setAttribute("id", "name")
    playerName.innerHTML = plyName + "(" + id + ")";
    playerName.style.paddingLeft = "4%"
    plyDiv.appendChild(playerName);
    const reviveButton = document.createElement("button");
    reviveButton.innerHTML = "Wiederbeleben \n" + costs + "$";
    reviveButton.onclick = function() {
        $.post(window.location.origin.replace("cfx-nui-", "") + '/reviveply', JSON.stringify({
            ply: id
        }));
    }
    reviveButton.setAttribute("id", "revBut")
    reviveButton.style.marginRight = "-30%";
    reviveButton.style.width = "50%";
    reviveButton.style.paddingBottom = "3.5%";
    reviveButton.style.border = "2px solid #005faa";
    reviveButton.style.borderRadius = "5px";
    reviveButton.style.color = "white";
    reviveButton.style.backgroundColor = "#005faa"
    plyDiv.appendChild(reviveButton);
    plyDiv.style.border = "3px solid #005faa";
    plyDiv.style.borderRadius = "9px";
    plyDiv.style.paddingTop = "3.5%";
    plyDiv.style.paddingBottom = "3.5%";
    plyDiv.style.marginBottom = "2%";
    plyDiv.style.marginLeft = "4.8vw";
    plyDiv.style.width = "30vw";
    plyDiv.style.boxShadow = "0px 0px 45px 15px rgba(255,255,255,0.25)"
}


function showStation(bool, players, ids,price){
    if(bool){
        document.getElementById("revivestat").style.visibility = "visible";
        for(var i = 0; i < players.length; i++){
            createElementInDiv(players[i],price,ids[i]);
            //createElementInDiv(players[i], price);
        }
    } else {
        removeAll()
        document.getElementById("revivestat").style.visibility = "hidden";
    }
}

showStation(false, -1,-1,-1);

window.addEventListener("message", function(event){
    var data = event.data;
    if(data.type == "ui"){
        if(data.status == true){
            showStation(true, data.players, data.ids,data.price)
        
        }else{
            showStation(false, -1, -1, -1)
        }
    }
})

function removeAll(){
    var divs = document.getElementsByClassName('plyDiv');

    while(divs[0]) {
        divs[0].parentNode.removeChild(divs[0]);
    }
}


document.onkeyup = function (data) {
    if (data.which === 27) {
        removeAll()
        $.post(window.location.origin.replace("cfx-nui-", "") + '/exit', JSON.stringify({}));
    }
};