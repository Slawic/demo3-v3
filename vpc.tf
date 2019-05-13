
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
  name   = "ip-external-address"
  region = "${var.region}"
}

resource "google_dns_record_set" "app" {
  name = "eschool.${google_dns_managed_zone.app.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.app.name}"

  rrdatas = ["${google_compute_address.address.address}"]
}

resource "google_dns_managed_zone" "app" {
  name     = "app-zone"
  dns_name = "app.demo3.com."
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