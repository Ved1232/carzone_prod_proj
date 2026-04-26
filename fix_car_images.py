from cars.models import Car

for car in Car.objects.all():
    if not car.car_photo_1:
        car.car_photo_1 = "photos/cars/car-2.jpg"
        car.save()
        print(f"Image added: {car.car_title}")

print("Done. Default image assigned to all cars without image.")