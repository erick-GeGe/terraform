resource "google_compute_autoscaler" "my_autoscaler" {
    name = "my-autoscaler"
    project = "axial-life-371817"
    zone = "us-central1-c"
    target = google_compute_instance_group_manager.group_manager.self_link

    autoscaling_policy {
        max_replicas = 5
        min_replicas = 2
        cooldown_period = 60

        cpu_utilization {
            target = 0.5
        }
    }
}

resource "google_compute_target_pool" "my_target_pool" {
    name = "my-target-pool"
    project = "axial-life-371817"
    region = "us-central1"
}

resource "google_compute_instance_group_manager" "group_manager" {
    name = "my-igm"
    zone = "us-central1-c"
    project = "axial-life-371817"
    version {
        instance_template = google_compute_instance_template.my_instance.self_link 
        name = "primary"
    }

    target_pools = [google_compute_target_pool.my_target_pool.self_link]
    base_instance_name = "terraform"
}

module "lb" {
    source = "GoogleCloudPlatform/lb/google"
    version = "2.2.0"
    region = "us-central1"
    name = "load-balancer"
    service_port = 80
    target_tags = ["my-target-pool"]
    network = google_compute_network.vpc_network.name
}