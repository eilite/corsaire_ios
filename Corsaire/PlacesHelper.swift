//
//  PlacesHelper.swift
//  Corsaire
//
//  Created by Elie on 21/05/2016.
//  Copyright © 2016 Elie. All rights reserved.
//

import Foundation
import MapKit

class PlacesHelper{
    private static let ENDPOINT: String = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyCBSBccUNuVsDo59ISe2AHEd9wfc9SDHCc";

    static func getCategories(key: String, userLocation: CLLocation, categories: [String: (String, [String])], actionOnComplete: (([Place])->Void)?){
        print("Catégorie sélectionnée")
        let keyWords: [String] = categories[key.localized]!.1
        var url: String = "\(PlacesHelper.ENDPOINT)&location=\(userLocation.coordinate.latitude),\(userLocation.coordinate.longitude)&language=\(NSLocale.preferredLanguages()[0])&rankby=distance&types=\(keyWords.first!)"
        
        for keyWord in keyWords.dropFirst(){
            url += "%7C\(keyWord)"
        }
        print("URL \(url)")
        
        let httpRequest: HttpRequest = HttpRequest(url: NSURL(string: url)!)
        do{
            try httpRequest.get({(data, response, error) in
                if error != nil {
                    print("ERROR \(error)")
                    return
                }
                
                do{
                    let jsonItinerary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? [String: AnyObject]
                    if let results = jsonItinerary!["results"] as? [[String: AnyObject]]{
                        var places: [Place] = []
                        if (results.count == 0){
                            print("ERROR while parsing")
                            return;
                        }
                        for result in results{
                            print("IN LOOP")
                            if let geometry = result["geometry"] as? [String: AnyObject], location = geometry["location"] as? [String: AnyObject], name = result["name"] as? String, lat = location["lat"] as? Double, lng = location["lng"] as? Double{
                                print("PLACE : \(name) \(lat) \(lng)")
                                places.append(Place(title: name, subtitle: nil, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lng)))
                                
                            }
                         }
                        
                        if let action = actionOnComplete{
                            action(places)
                        }
                    }
                    
                }catch{
                    print("ERROR WHILE PARSING \(error)")
                }
            })
        }catch{
            print("error \(error)")
        }
        
        
    }
    
//    try {
//    JSONArray results = new JSONObject(extras.getString("json")).getJSONArray("results");
//    if (results.length() <= 0) {
//    Toast.makeText(this, getString(R.string.erreur_pas_de_place_proximite), Toast.LENGTH_LONG).show();
//    finish();
//    return;
//    }
//    for (int i = 0; i < results.length(); i++) {
//    JSONObject item = results.getJSONObject(i);
//    JSONObject location = item.getJSONObject("geometry").getJSONObject("location");
//    places.add(new Place(item.getString("name"), location.getDouble("lat"), location.getDouble("lng")));
//    }
//    Log.i(TAG, "Reponse : " + results.toString());
//    
//    List<Map<String,Object>> data = new ArrayList<>();
//    for (Place place : places) {
//    Map<String, Object> map = new HashMap<String, Object>();
//    map.put("contentDescription",place.name + " - " + Math.round(place.location.distanceTo(location)) + "m");
//    map.put("name",place.name);
//    map.put("distance",Math.round(place.location.distanceTo(location)) + "m");
//    data.add(map);
//    }
//    //            ArrayAdapter adapter = new ArrayAdapter(this,
//    //                    android.R.layout.simple_list_item_1, data.toArray());
//    SimpleAdapter adapter = new Adapter(this,data,R.layout.list_view_select_place, new String[]{"name","distance"}, new int[]{R.id.name,R.id.distance});
//    
//    
//    ListView listView = (ListView) findViewById(R.id.listView);
//    listView.setAdapter(adapter);
//    listView.setClickable(true);
//    
//    listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
//    @Override
//    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
//    Intent result = new Intent();
//    Place place = places.get(position);
//    result.putExtra("name", place.name);
//    result.putExtra("latitude", place.location.getLatitude());
//    result.putExtra("longitude", place.location.getLongitude());
//    setResult(RESULT_OK, result);
//    finish();
//    }
//    });
//    
//    SupportMapFragment mapFragment = (SupportMapFragment) getSupportFragmentManager()
//    .findFragmentById(R.id.map);
//    if(mapFragment != null)
//    mapFragment.getMapAsync(this);
//    findViewById(R.id.map).setVisibility(View.GONE);
//    
//    } catch (JSONException e) {
//    e.printStackTrace();
//    Toast.makeText(this, getString(R.string.erreur_505), Toast.LENGTH_LONG).show();
//    finish();
//    }
}