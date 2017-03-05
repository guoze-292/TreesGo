// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/
var trees = [
  {name:"Broncos", id:110, type:"Apple Tree", location:"Santa Clara City Library", latitude:37.3446167260408,longitude:-121.932690069077, age:10,status: "adpoted"},
  {name:"Apple", id:110, type:"Palm Tree", location:"Cupertino City Library", latitude:37.350266893316,longitude:-121.94374592494, age:20,status: "reviewing"},
  {name:"Tony", id:110, type:"Orange Tree", location:"Sanjose City Library", latitude:37.3392813,longitude:-121.9382831, age:30,status: "available"},
  {name:"SuperMike", id:110, type:"Junkrat Tree", location:"Milpitas City Library", latitude:37.345256,longitude:-121.935864, age:40,status: "available"},
  {name:"LULU", id:110, type:"LULU Tree", location:"SCU Library", latitude:37.348655,longitude:-121.946166, age:50,status: "available"}
];

var currentInfoWindow = null;
var currentAnimationMarker = null;

var initInfoWindows = function(trees) {
  var info = '<div id="content"><p><h3> {content} </h3></p> </div>';
  trees().forEach(function(e){
    var infowindow = new google.maps.InfoWindow({
      content: info.replace("{content}",e.name)
    });
    e.infowindow = infowindow;
    e.marker.addListener('click',function(){
      if(currentInfoWindow){

        currentInfoWindow.close();
      }
      if (currentAnimationMarker!==null)
      {
        currentAnimationMarker.setAnimation(null);
      }
      e.marker.setAnimation(google.maps.Animation.BOUNCE);
      //stop the Animation after a while
      setTimeout(function(){e.marker.setAnimation(null);}, 1400);

      currentAnimationMarker = e.marker;
      e.infowindow.open(map,e.marker);
      currentInfoWindow = infowindow;
    });
  });
};

 var map;
 function initMap() {
   map = new google.maps.Map(document.getElementById('map'),{
     center: {lat: 37.354107, lng: -121.955238},
     zoom: 13
   });

   function AppViewModel(){
     self = this;
     self.keyword = ko.observable();
     self.trees = ko.observableArray(trees);
     self.trees().forEach(function(e){
       e.marker = new google.maps.Marker({
       position: {lat:e.latitude,lng:e.longitude},
       map: map,
       title: e.title,
       animation: google.maps.Animation.DROP
     });
   });

   initInfoWindows(self.trees);

   self.selectMarker = function(e){
       if(currentInfoWindow){

         currentInfoWindow.close();

       }
       if (currentAnimationMarker!==null)
       {
         currentAnimationMarker.setAnimation(null);
       }
       e.infowindow.open(map,e.marker);
       currentInfoWindow = e.infowindow;
       e.marker.setAnimation(google.maps.Animation.BOUNCE);
       //stop the Animation after a while
       setTimeout(function(){e.marker.setAnimation(null);}, 1500);


   };

   self.mytrees = ko.computed(function(){
     if(!self.keyword()){
       self.trees().forEach(function(e){
         if(e.marker){
             e.marker.setVisible(true);
           }
       });
       return self.trees();
     }
     else if (self.trees()){
       if(currentInfoWindow){currentInfoWindow.close();}
       var temArray = ko.observableArray();
       self.trees().forEach(function(e){
       if(e.location.toLowerCase().indexOf(self.keyword().toLowerCase()) >= 0&&e.marker)
       {   e.marker.setVisible(true);
           temArray().push(e);
       }
       else if (e.marker)
       {
           e.marker.setVisible(false);
       }
         });
     return temArray();
     }

   }, this);
 }




    ko.applyBindings(new AppViewModel());


 }
