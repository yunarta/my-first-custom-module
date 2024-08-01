# This file is part of cloud-init. See LICENSE file for license information.
"""Example Module: Shows how to create a module"""

import logging
from cloudinit.cloud import Cloud
from cloudinit.config import Config
from cloudinit.config.schema import MetaSchema
from cloudinit.distros import ALL_DISTROS
from cloudinit.settings import PER_INSTANCE

LOG = logging.getLogger(__name__)

meta: MetaSchema = {
    "id": "cc_my_custom_module",
    "distros": [ALL_DISTROS],
    "frequency": PER_INSTANCE,
    "activate_by_schema_keys": ["my_custom_module"],
} # type: ignore

def handle(
    name: str, cfg: Config, cloud: Cloud, args: list
) -> None:
    LOG.debug(f"Hi from module {name}")