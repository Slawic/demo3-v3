
resource "google_compute_network" "my_vpc_network" {
  name = "my-vpc-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "private_subnetwork" {
  name          = "private-subnetwork"
  ip_cidr_range = "${var.ip_cidr_range_private}"
  region        = "${var.region}"
  network       = "${google_compute_network.my_vpc_network.self_link}"
#  private_ip_google_access = true

}

resource "google_compute_router" "router" {
  count  = 0
  name    = "router"

  region  = "${google_compute_subnetwork.private_subnetwork.region}"
  network = "${google_compute_network.my_vpc_network.self_link}"

  bgp {
    asn = 64514
  }
}

resource "google_compute_address" "address" {
#  count  = 0
#  count  = "${var.countnat}"
#  name   = "nat-external-address-${count.index}"
  name   = "ip-external-address"
  region = "${var.region}"
}
# resource "google_compute_router_nat" "simple-nat" {
#   name                               = "nat-1"
#   router                             = "${google_compute_router.router.name}"
#   region                             = "${var.region}"
#   nat_ip_allocate_option             = "MANUAL_ONLY"
#   nat_ips                            = ["${google_compute_address.address.*.self_link}"]
#   source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
# }
# data "google_compute_address" "my_address" {
#   name   = "external-address"
#   region = "${var.region}"
# }
resource "google_dns_record_set" "app" {
  name = "eschool.${google_dns_managed_zone.app.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.app.name}"

  rrdatas = ["${google_compute_address.address.address}"]
}

resource "google_dns_managed_zone" "app" {
  name     = "app-zone"
  dns_name = "app.devops095.com."
}

resource "google_compute_firewall" "ssh_firewall" {
  name    = "allow-ssh"
  network = "${google_compute_network.my_vpc_network.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  source_tags = ["ssh"]
}
resource "google_compute_firewall" "sonar_firewall" {
  name    = "allow-sonar"
  network = "${google_compute_network.my_vpc_network.name}"

  allow {
    protocol = "tcp"
    ports    = ["9000"]
  }
  source_ranges = ["0.0.0.0/0"]
  source_tags = ["sonar"]
}
resource "google_compute_firewall" "web_firewall" {
  name    = "allow-web"
  network = "${google_compute_network.my_vpc_network.name}"

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
  source_ranges = ["0.0.0.0/0"]
  source_tags = ["web"]
}