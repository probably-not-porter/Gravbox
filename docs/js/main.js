var gridParent = document.getElementById("grid");
for (let y = 1; y < 21; y++) {
  for (let x = 1; x < 21; x++) {
    console.log(x, y);
    gridParent.innerHTML += `<div data-id="none" data-x="${x}" data-y="${y}" data-content="none" onclick='fillBlock(this)' class='box'></div>`;
  }
}

function replaceID(e) {
  let newID = prompt("Enter an integer ID", "0");
  e.parentElement.setAttribute("data-id", newID);
  e.innerHTML = `<p1 onclick='replaceID(this)' >ID: ${newID}</p1>`;
}

function fillBlock(e) {
  let checkedValue = document.querySelector('input[name="tool"]:checked').value;
  if (checkedValue == "clear") {
    e.style.backgroundImage = "none";
    e.innerHTML = "";
    e.setAttribute("data-content", "none");
  }

  if (e.getAttribute("data-content") == "none") {
    if (checkedValue == "player") {
      e.style.backgroundImage = "url('img/player.png')";
      e.innerHTML = "";
      e.setAttribute("data-content", "player");
    }
    if (checkedValue == "block") {
      e.style.backgroundImage = "url('img/block.png')";
      e.innerHTML = "";
      e.setAttribute("data-content", "block");
    }
    if (checkedValue == "key") {
      e.style.backgroundImage = "url('img/key.png')";
      e.innerHTML = "<p1 onclick='replaceID(this)' >ID: 0</p1>";
      e.setAttribute("data-id", "0");
      e.setAttribute("data-content", "key_block");
    }
    if (checkedValue == "lock") {
      e.style.backgroundImage = "url('img/lock.png')";
      e.innerHTML = "<p1 onclick='replaceID(this)' >ID: 0</p1>";
      e.setAttribute("data-id", "0");
      e.setAttribute("data-content", "lock_block");
    }
    if (checkedValue == "finish") {
      e.style.backgroundImage = "url('img/finish.png')";
      e.innerHTML = "<p1 onclick='replaceID(this)' >ID: 0</p1>";
      e.setAttribute("data-id", "0");
      e.setAttribute("data-content", "finish_block");
    }
  }
}
function exportJson() {
  var boxes = document.getElementsByClassName("box");
  var outputJSON = {
    name: document.getElementById("name").value,
    contents: [],
    openingText: document.getElementById("starttext").value,
  };
  for (var i = boxes.length - 1; i >= 0; i--) {
    if (boxes[i].getAttribute("data-content") != "none") {
      outputJSON.contents.push({
        type: boxes[i].getAttribute("data-content"),
        x: boxes[i].getAttribute("data-x"),
        y: boxes[i].getAttribute("data-y"),
        id: boxes[i].getAttribute("data-id"),
      });
    }
  }
  return outputJSON;
}
function downloadJson() {
  var content = exportJson();
  var dataStr =
    "data:text/json;charset=utf-8," +
    encodeURIComponent(JSON.stringify(content));

  var dlAnchorElem = document.getElementById("downloadAnchorElem");

  dlAnchorElem.setAttribute("href", dataStr);
  dlAnchorElem.setAttribute(
    "download",
    `${document.getElementById("name").value}.json`,
  );
  dlAnchorElem.click();
}
