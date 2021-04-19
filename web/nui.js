var audioPlayer = null;

window.addEventListener("message", function (event) {
  if (event.data.transactionType !== undefined && event.data.transactionType === "playSound") {
    audioPlayer = new Howl({
      src: ["./sounds/" + event.data.transactionFile + ".ogg"],
    });
    audioPlayer.volume(event.data.transactionVolume);
    audioPlayer.play();
  }

  if (event.data.playSound3d !== undefined) {
    audioPlayer = new Howl({
      src: ["./sounds/" + event.data.transactionFile + ".ogg"],
    });
    audioPlayer.volume(event.data.transactionVolume);
    audioPlayer.pos(event.data.audioCoords.x, event.data.audioCoords.y, event.data.audioCoords.z);
    audioPlayer.orientation(event.data.audioRot.x, event.data.audioRot.y, event.data.audioRot.z)
    audioPlayer.play();
    audioPlayer.pannerAttr({
			panningModel: 'equalpower',
			refDistance: 0.01,
			rolloffFactor: 0.9,
			distanceModel: 'linear'
	})
  }
});