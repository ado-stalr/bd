use lw8;

db.test_collection.drop();
db.createCollection('barbershop');
db.createCollection('barber');
db.createCollection('order');
db.createCollection('servise');
db.createCollection('client');

db.barbershop.find();

db.client.insertMany([
    {
        name: 'Ivan Ivanov',
        gender: 'man',
        contacts: {
            telephone: '+79871111111',
            email: '',
        },
        birth_date: new Date('2000-08-24'),
    },
    {
        name: 'Boris Petrov',
        gender: 'man',
        contacts: {
            telephone: '+79372222222',
            email: 'bor@mail.ru'
        },
        birth_date: new Date('2002-03-01'),
    },
    {
        name: 'Sergey Leuhin',
        gender: 'man',
        contacts: {
            telephone: '+79373333333',
            email: ''
        },
        birth_date: new Date('1995-01-07'),
    },
    {
        name: 'Evgen Petuhov',
        gender: 'man',
        contacts: {
            telephone: '+79374444444',
            email: 'petuh@yandex.ru'
        },
        birth_date: new Date('1989-09-01'),
    },
    {
        name: 'Elena Neskazhu',
        gender: 'woman',
        contacts: {
            telephone: '+79375555555',
            email: ''
        },
        birth_date: new Date('1987-12-25'),
    },
    {
        name: 'Tatyana Petrova',
        gender: 'woman',
        contacts: {
            telephone: '+79376666666',
            email: 'tanya@mail.ru'
        },
        birth_date: new Date('1995-04-08'),
    },
    {
        name: 'Dina Kurochkina',
        gender: 'woman',
        contacts: {
            telephone: '+79377777777',
            email: ''
        },
        birth_date: new Date('1992-03-05'),
    },
    {
        name: 'Artur Cupcake',
        gender: 'man',
        contacts: {
            telephone: '+79378888888',
            email: ''
        },
        birth_date: new Date('1990-10-20'),
    },
])

db.servise.insertMany([
    {
        cost: 200.00,
        duration: 30,
        name: 'Detskay strizhka',
    },
    {
        cost: 500.00,
        duration: 50,
        name: 'Detskay modelnaya strizhka',
    },
    {
        cost: 300.00,
        duration: 25,
        name: 'Muzhskaya strizhka',
    },
    {
        cost: 700.00,
        duration: 50,
        name: 'Muzhskaya modelnya strizhka',
    },
    {
        cost: 500.00,
        duration: 20,
        name: 'Strizhka borody',
    },
    {
        cost: 1000.00,
        duration: 30,
        name: 'Britye borody',
    },
    {
        cost: 300.00,
        duration: 30,
        name: 'Myt\'ye golovy',
    },
    {
        cost: 600.00,
        duration: 50,
        name: 'Podrovnyat\' koncy',
    },
    {
        cost: 400.00,
        duration: 25,
        name: 'Vygovorit\'sa',
    },
    {
        cost: 800.00,
        duration: 50,
        name: 'Zenskaya modelnya strizhka',
    },
    {
        cost: 600.00,
        duration: 20,
        name: 'Tonirovanie volos',
    },
    {
        cost: 1200.00,
        duration: 30,
        name: 'Pokraska volos',
    },
])


db.order.insertMany([
    {
        barber_id: ObjectId('6282c47f1023f636e682f49b'),
        barbershop_id: ObjectId('6282c0951023f636e682f496'),
        client_id: ObjectId('6282c6da1023f636e682f4a9'),
        date: new Date('2022-03-10'),
        price: 700.00,
        servises: [
            ObjectId('6282c8181023f636e682f4b3'),
            ObjectId('6282c8181023f636e682f4b4'),
        ],
    },
    {
        barber_id: ObjectId('6282c47f1023f636e682f49b'),
        barbershop_id: ObjectId('6282c0951023f636e682f496'),
        client_id: ObjectId('6282c6da1023f636e682f4aa'),
        date: new Date('2022-03-10'),
        price: 1700.00,
        servises: [
            ObjectId('6282c8181023f636e682f4b6'),
            ObjectId('6282c8181023f636e682f4b8'),
        ],
    },
    {
        barber_id: ObjectId('6282c47f1023f636e682f49e'),
        barbershop_id: ObjectId('6282c1af1023f636e682f499'),
        client_id: ObjectId('6282c6da1023f636e682f4ae'),
        date: new Date('2022-03-13'),
        price: 1200.00,
        servises: [
            ObjectId('6282c8181023f636e682f4be'),
        ],
    },
    {
        barber_id: ObjectId('6282c47f1023f636e682f49e'),
        barbershop_id: ObjectId('6282c1af1023f636e682f499'),
        client_id: ObjectId('6282c6da1023f636e682f4af'),
        date: new Date('2022-03-15'),
        price: 800.00,
        servises: [
            ObjectId('6282c8181023f636e682f4bc'),
        ],
    },
    {
        barber_id: ObjectId('6282c47f1023f636e682f49b'),
        barbershop_id: ObjectId('6282c0951023f636e682f496'),
        client_id: ObjectId('6282c6da1023f636e682f4a9'),
        date: new Date('2022-03-21'),
        price: 700.00,
        servises: [
            ObjectId('6282c8181023f636e682f4b6'),
        ],
    },
])

db.barber.find();
db.client.find();
db.servise.find();




// 3.1 Отобразить коллекции базы данных
show collections;

// 3.2 Вставка записей
// • Вставка одной записи insertOne
db.barbershop.insertOne({
    telephone: '+79371055588',
    address: 'Russia, Yoshkar-Ola, Sovetskaya street, 10',
    name: 'Cool barber',
})

// • Вставка нескольких записей insertMany
db.barbershop.insertMany([
    {
        telephone: '88008888888',
        address: 'Russia, Yoshkar-Ola, Pushkin street, 2',
        name: 'test1',
    },
    {
        telephone: '88009999999',
        address: 'Russia, Yoshkar-Ola, Lenina street, 20',
        name: 'test2',
    },
])

// 3.3 Удаление записей
// • Удаление одной записи по условию deleteOne
db.barbershop.deleteOne({name: 'test1'});
db.barbershop.deleteOne({name: 'test2'});

// • Удаление нескольких записей по условию deleteMany
db.barbershop.deleteMany({
    $or: [
        {name: 'test1'},
        {name: 'test2'},
    ]
});

// 3.4 Поиск записей
// • Поиск по ID
db.client.find({_id: ObjectId('6282c6da1023f636e682f4a9')});

// • Поиск записи по атрибуту первого уровня
db.client.find({
    name: 'Ivan'
});

// • Поиск записи по вложенному атрибуту
db.client.find({
    "contacts.email": {$ne: ''}
});

// • Поиск записи по нескольким атрибутам (логический оператор AND)
db.client.find({
    name: 'Ivan',
    last_name: 'Ivanov'
});

// • Поиск записи по одному из условий (логический оператор OR)
db.client.find({
    $or: [
        {name: 'Ivan'},
        {name: 'Elena'},
    ]
});
// • Поиск с использованием оператора сравнения (https://docs.mongodb.com/manual/reference/operator/query/#std-label-queryselectors)
db.order.find({
    price: {$gte: 1000}
});

// • Поиск с использованием двух операторов сравнения
db.order.find({
    price: {
        $gte: 1000,
        $lte: 1500
    }
});
db.order.find({
    date: {
        $gte: new Date('2022-03-10'),
        $lte: new Date('2022-03-15')
    }
});

// • Поиск по значению в массиве
db.order.find({
    servises: new ObjectId('6282c8181023f636e682f4b6'),
});

// • Поиск по количеству элементов в массиве
db.order.find({
    servises: {
        $size: 1,
    },
});

db.order.find({
    $where: 'this.servises.length > 1',
});

// • Поиск записей без атрибута
db.order.find({hohoho: {$exists: false}})

// 3.5 Обновление записей
// • Изменить значение атрибута у записи
db.client.updateOne(
    {
        name: 'Ivan',
        last_name: 'Ivanov'
    },
    {
        $set: {
            "contacts.email": "capitan2000@mail.ru"
        }
    }
);

// • Удалить атрибут у записи
db.client.updateMany(
    {
         "contacts.email": ''
    },
    {
        $unset: {
            "contacts.email": 1
        }
    },
    false,
    true
);

db.client.find({
    "contacts.email": ''
});

// • Добавить атрибут записи
db.client.updateMany(
    {
        "contacts.email": {$exists: false}
    },
    {
        $set: {
            "contacts.email": ""
        }
    }
);