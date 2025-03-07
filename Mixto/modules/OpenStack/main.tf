# *** YOUR CODE HERE ***
# Crear instancia denominada mysql conectada a la red del proyecto e inicializada
# con el archivo install_mysql.sh
# Asignarle una dirección IP flotante
# **********************
resource "openstack_compute_instance_v2" "mysql" {
  name              = "mysql"
  image_id     = "5b7ee726-db11-4987-b5a9-6284a83be58e"
  availability_zone = "nova"
  flavor_name       = "medium"
  key_pair          = var.openstack_keypair
  security_groups   = ["default"]
  network {
    name = "jt800-net"
  }

  user_data = file("install_mysql.sh")
}





# Configura el archivo de plantilla para la API
data "template_file" "setup-api-docker" {
  template = file("setup-api-docker.tpl")
  vars = {
    mysql_ip = openstack_compute_instance_v2.mysql.network.0.fixed_ip_v4
  }
  depends_on = [openstack_compute_instance_v2.mysql]
}

# Espera 5 minutos a que se configure la instancia MySQL
# para que no falle el contenedor de la API al conectar a la BD
resource "time_sleep" "wait_5_minutes" {
  depends_on = [openstack_compute_instance_v2.mysql]

  create_duration = "5m"
}
resource "openstack_networking_floatingip_v2" "mysql_ip" {
  pool = "ext-net"
}

resource "openstack_compute_floatingip_associate_v2" "mysql_ip" {
  floating_ip = openstack_networking_floatingip_v2.mysql_ip.address
  instance_id = openstack_compute_instance_v2.mysql.id
}

output mysql_Floating_IP {
  value      = openstack_networking_floatingip_v2.mysql_ip.address
  depends_on = [openstack_networking_floatingip_v2.mysql_ip]
}
# *** YOUR CODE HERE ***
# Configuración de la instancia denominada book_api 
# conectada a la red del proyecto e inicializada 
# con el archivo de la plantilla ya inicializado setup-api-docker
# **********************
resource "openstack_compute_instance_v2" "book_api" {
  name              = "book_api"
  image_id       = "5b7ee726-db11-4987-b5a9-6284a83be58e"
  availability_zone = "nova"
  flavor_name       = "medium"
  key_pair          = var.openstack_keypair
  security_groups   = ["default"]
  
  network {
    name = "jt800-net"
  }
  user_data = data.template_file.setup-api-docker.rendered

  depends_on = [time_sleep.wait_5_minutes ]
  }
 
# *** YOUR CODE HERE ***
# Asignarle una dirección IP flotante
# **********************
resource "openstack_networking_floatingip_v2" "book_api" {
  pool = "ext-net"
}

resource "openstack_compute_floatingip_associate_v2" "book_api" {
  floating_ip = openstack_networking_floatingip_v2.book_api.address
  instance_id = openstack_compute_instance_v2.book_api.id
}

output book_api_Floating_IP {
  value      = openstack_networking_floatingip_v2.book_api.address
  depends_on = [openstack_networking_floatingip_v2.book_api]
}

# Configura el archivo de plantilla para la aplicación
data "template_file" "setup-app-docker" {
  template = file("setup-app-docker.tpl")
  vars = {
    book_api_ip = openstack_compute_instance_v2.book_api.network.0.fixed_ip_v4
  }
  depends_on = [openstack_compute_instance_v2.book_api]
}

#Crear nodo APP
# *** YOUR CODE HERE ***
# Configuración de la instancia denominada book_app 
# conectada a la red del proyecto e inicializada 
# con el archivo de la aplicación ya inicializado setup-app-docker
# **********************
  resource "openstack_compute_instance_v2" "book_app" {
  name              = "book_app"
  image_id      = "5b7ee726-db11-4987-b5a9-6284a83be58e"
  availability_zone = "nova"
  flavor_name       = "medium"
  key_pair          = var.openstack_keypair
  security_groups   = ["default"]
  network {
    name = "jt800-net"
  }
 
  user_data = data.template_file.setup-app-docker.rendered
    
}
# *** YOUR CODE HERE ***
# Asignarle una dirección IP flotante
# **********************
resource "openstack_networking_floatingip_v2" "book_app" {
  pool = "ext-net"
}

resource "openstack_compute_floatingip_associate_v2" "book_app" {
  floating_ip = openstack_networking_floatingip_v2.book_api.address
  instance_id = openstack_compute_instance_v2.book_api.id
}

output book_app_Floating_IP {
  value      = openstack_networking_floatingip_v2.book_app.address
  depends_on = [openstack_networking_floatingip_v2.book_app]
}

# *** YOUR CODE HERE ***
# Mostrar las direcciones IP generadas
# **********************

