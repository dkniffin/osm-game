latlng = RGeo::Geographic.spherical_factory(srid: 4326).point(-78.903991, 35.992591)
john = Character.create(name: "John Smith", latlng: latlng)
john.move(35.0, -78.0)
