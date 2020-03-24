From: Bob Liu <bob.liu@oracle.com>
Subject: [RFC PATCH v2 0/3] dm zoned: extend the way of exposing zoned block device
Date: Tue, 24 Mar 2020 19:02:52 +0800
Message-ID: <20200324110255.8385-1-bob.liu@oracle.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: Damien.LeMoal@wdc.com, linux-block@vger.kernel.org, Dmitry.Fomichev@wdc.com, hare@suse.de, Bob Liu <bob.liu@oracle.com>
List-Id: dm-devel.ids

Motivation:
dm-zoned exposes a zoned block device(ZBC) as a regular block device by storing
metadata and buffering random writes in its conventional zones.
This way is not flexible, there must be enough conventional zones and the
performance may be constrained.

This patchset split the metadata from zoned device to an extra regular device,
with aim to increase the flexibility and potential performance.
For example, now we can store metadata in a faster device like persistent memory.
Also random writes can go to the regular devices in this version.

Usage(will send user space patches later):
> dmzadm --format $zoned_dev --regular=$regu_dev --force
> echo "0 $size zoned $regu_dev $zoned_dev" | dmsetup create $dm-zoned-name

v2:
 * emulate regular device zone info
 * support write both metadata and random writes to regular dev

Bob Liu (3):
  dm zoned: rename dev name to zoned_dev
  dm zoned: introduce regular device to dm-zoned-target
  dm zoned: add regular device info to metadata

 drivers/md/dm-zoned-metadata.c | 205 +++++++++++++++++++++++++++--------------
 drivers/md/dm-zoned-target.c   | 205 +++++++++++++++++++++++------------------
 drivers/md/dm-zoned.h          |  53 ++++++++++-
 3 files changed, 299 insertions(+), 164 deletions(-)

-- 
2.9.5
