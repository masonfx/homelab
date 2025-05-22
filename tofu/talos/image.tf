locals {
  version = var.image.version
  schematic = var.image.schematic
  image_id = "${talos_image_factory_schematic.this.id}_${local.version}"
  needs_update_image = anytrue([for node in var.nodes : lookup(node, "update", false)])
  update_image_id = local.needs_update_image ? "${talos_image_factory_schematic.updated[0].id}_${var.image.update_version}" : null

  pve_hosts = toset(distinct([ for n in var.nodes : n.host_node ]))
}

resource "talos_image_factory_schematic" "this" {
  schematic = local.schematic
}

resource "talos_image_factory_schematic" "updated" {
  count = local.needs_update_image ? 1 : 0
  schematic = coalesce(var.image.update_schematic, local.schematic)
}

resource "proxmox_virtual_environment_download_file" "per_host" {
  depends_on = [ talos_image_factory_schematic.this ]
  for_each = local.pve_hosts  # each.value is now a host name

  node_name               = each.value
  content_type            = "iso"
  datastore_id            = var.image.proxmox_datastore
  decompression_algorithm = "gz"
  overwrite               = false

  file_name = format(
    "talos-%s-%s-%s-%s.img",
    local.needs_update_image
      ? talos_image_factory_schematic.updated[0].id
      : talos_image_factory_schematic.this.id,
    local.needs_update_image
      ? var.image.update_version
      : var.image.version,
    var.image.platform,
    var.image.arch,
  )

  url = format(
    "%s/image/%s/%s/%s-%s.raw.gz",
    var.image.factory_url,
    local.needs_update_image
      ? talos_image_factory_schematic.updated[0].id
      : talos_image_factory_schematic.this.id,
    local.needs_update_image
      ? var.image.update_version
      : var.image.version,
    var.image.platform,
    var.image.arch,
  )
}
