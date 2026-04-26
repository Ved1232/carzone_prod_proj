import os
import django
from django.apps import apps

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "carzone.settings")
django.setup()

Car = apps.get_model("cars", "Car")

cars = [
    {
        "car_title": "Toyota Fortuner",
        "state": "Dublin",
        "city": "Dublin",
        "color": "White",
        "model": "Fortuner",
        "year": 2021,
        "condition": "Used",
        "price": 850000,
        "body_style": "SUV",
        "engine": "2.8L Diesel",
        "transmission": "Automatic",
        "interior": "Black",
        "miles": 35000,
        "doors": 5,
        "passengers": 7,
        "vin_no": "TOYFORT2021",
        "milage": 15,
        "fuel_type": "Diesel",
        "no_of_owners": 1,
        "is_featured": True,
        "description": "Well maintained Toyota Fortuner with strong engine and premium comfort.",
    },
    {
        "car_title": "Honda Civic",
        "state": "Dublin",
        "city": "Dublin",
        "color": "Black",
        "model": "Civic",
        "year": 2020,
        "condition": "Used",
        "price": 650000,
        "body_style": "Sedan",
        "engine": "1.8L Petrol",
        "transmission": "Automatic",
        "interior": "Beige",
        "miles": 28000,
        "doors": 4,
        "passengers": 5,
        "vin_no": "HONCIV2020",
        "milage": 17,
        "fuel_type": "Petrol",
        "no_of_owners": 1,
        "is_featured": True,
        "description": "Honda Civic sedan with smooth drive, clean interior and good mileage.",
    },
    {
        "car_title": "BMW X5",
        "state": "Cork",
        "city": "Cork",
        "color": "Blue",
        "model": "X5",
        "year": 2022,
        "condition": "Used",
        "price": 1200000,
        "body_style": "SUV",
        "engine": "3.0L Diesel",
        "transmission": "Automatic",
        "interior": "Black Leather",
        "miles": 18000,
        "doors": 5,
        "passengers": 5,
        "vin_no": "BMWX52022",
        "milage": 12,
        "fuel_type": "Diesel",
        "no_of_owners": 1,
        "is_featured": True,
        "description": "Luxury BMW X5 SUV with powerful performance and premium features.",
    },
    {
        "car_title": "Audi A6",
        "state": "Galway",
        "city": "Galway",
        "color": "Grey",
        "model": "A6",
        "year": 2021,
        "condition": "Used",
        "price": 980000,
        "body_style": "Sedan",
        "engine": "2.0L Diesel",
        "transmission": "Automatic",
        "interior": "Brown Leather",
        "miles": 24000,
        "doors": 4,
        "passengers": 5,
        "vin_no": "AUDIA62021",
        "milage": 16,
        "fuel_type": "Diesel",
        "no_of_owners": 1,
        "is_featured": False,
        "description": "Audi A6 executive sedan with excellent comfort and road presence.",
    },
    {
        "car_title": "Mercedes Benz C-Class",
        "state": "Limerick",
        "city": "Limerick",
        "color": "Silver",
        "model": "C-Class",
        "year": 2020,
        "condition": "Used",
        "price": 1050000,
        "body_style": "Sedan",
        "engine": "2.0L Petrol",
        "transmission": "Automatic",
        "interior": "Black Leather",
        "miles": 30000,
        "doors": 4,
        "passengers": 5,
        "vin_no": "MERC2020C",
        "milage": 14,
        "fuel_type": "Petrol",
        "no_of_owners": 2,
        "is_featured": True,
        "description": "Premium Mercedes C-Class with luxury interior and excellent drive quality.",
    },
    {
        "car_title": "Renault Triber",
        "state": "Waterford",
        "city": "Waterford",
        "color": "Red",
        "model": "Triber",
        "year": 2021,
        "condition": "Used",
        "price": 499999,
        "body_style": "MPV",
        "engine": "1.0L Petrol",
        "transmission": "Manual",
        "interior": "Black",
        "miles": 22000,
        "doors": 5,
        "passengers": 7,
        "vin_no": "RENTRI2021",
        "milage": 19,
        "fuel_type": "Petrol",
        "no_of_owners": 1,
        "is_featured": False,
        "description": "Budget friendly family car with 7 seats and good fuel efficiency.",
    },
]

existing_fields = {field.name for field in Car._meta.fields}

for item in cars:
    data = {key: value for key, value in item.items() if key in existing_fields}

    if "features" in existing_fields:
        data["features"] = "Air Conditioning,Power Steering,ABS,Airbags"

    if "car_photo" in existing_fields:
        data["car_photo"] = "photos/cars/default_car.jpg"

    obj, created = Car.objects.update_or_create(
        car_title=item["car_title"],
        defaults=data
    )

    print(("Created: " if created else "Updated: ") + obj.car_title)

print("Sample CarZone database data inserted successfully.")