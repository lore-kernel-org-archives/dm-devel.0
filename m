From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Announcement: new device-mapper thin provisioning target
 with infrastructure online for review
Date: Tue, 25 Jan 2011 17:19:25 +0100
Message-ID: <1295972365.2936.77.camel@o>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids


A new device-mapper thin provisioning target together with supporting
block-manager, btree, space-map and transaction-manager infrastructure
is online at

https://github.com/jthornber/linux-2.6

for review.

We are interested in correctness and performance test results and
senseful coding related change requests.

Please find more details below and provide any feedback
through dm-devel@redhat.com.

Heinz and Joe.


---
The thin provisioning target is on branch "thin-provisioning" including
its respective infrastructure:

drivers/md/dm-thin-prov.c       (target)
drivers/md/thinp-metadata.[ch]  (infrastructure wrappers)
drivers/md/persistent-data/*    (infrastructure; see below)

This target allows for creation of thin provisioned mapped devices with
housekeeping persistent metadata on a backing store device separate from
the data device holding provisioned blocks. The block size is selectable
on thin provisioned device creation and the data device is extensible.
Each thin provisioned device has its own pair of metadata and data
devices.
Instructions how to use the target follow further down.

---
The supporting infrastructure itself, which we intend to utilize with
other functionality (eg. snapshots), is on branch "persistent-data"
in directory drivers/md/persistent-data/:

block-manager.c       Kconfig                space-map-dummy.c
block-manager.h       Makefile               space-map.h
block-manager-test.c  pd-module.c            space-map-staged.c
btree.c               space-map-staged.h     btree.h
space-map-core.c      space-map-test.c       btree-internal.h
space-map-core.h      transaction-manager.c  btree-spine.c
space-map-disk.c      transaction-manager.h  btree-test.c
space-map-disk.h

block-manager*; a low level block pool creation and (locked)
                block io API.

btree*: hierarchical b+-tree with arbitrary values API

space-map*: API to keep record of how many times a block-manager
            block is being referenced

transaction-manager*: 2 phase commit API to allow for
                      consistent multi-block updates

pd-module.c: tiny kernel module helper


---
Using the thin provisioning target

Table line syntax (also see thinp_ctr() in dm-thin-prov.c):

<start> <len> thin-prov \
<data_dev> <meta_dev> <data_block_size> <low_water_mark>

* data_dev: device holding thin provisioned data blocks
* meta_dev: device keeping track of provisioned blocks
* data_block_size: provisioning unit size in sectors
* low_water_mark: block low water mark to throw a dm event
  for userpace to resize


E.g.:

0 16777216 thin-prov \
/dev/tst/thin-prov-data /dev/tst/thin-prov-meta 32786 16

defines an 8GB thin provisioned mapped device using logical volumes
tst/thin-prov-meta and tst/thin-prov-data for metadata and data backing
stores respectively with a block size of 16MB and a low water mark of 16
blocks. Support to resize the data device is implemented but the
metadata device should be large enough.

Use the following formula to do the calculation:
sz[4KB blocks] = \
1 + ceiling(device size / block size / 255) * 3

metadata_dev_size[KB] = (sz > 100 ? sz : 100) * 4KB

So, for the above example, assuming a data device size of 1GB,
this results in::
1 + ceiling(2097152 / 32768 / 255) * 3 = 4
4 is smaller than 100 so we'll go by 400KB.

The metadata logical volume has 1 extent allocated, thus there's
typically at least 4MB space available, which would allow for more than
87000 blocks.
I.e. a thin provisioned device capacity larger than 1.32TB.


Create the mapped device:

dmsetup create --table \
"0 16777216 thin-prov \
/dev/tst/thin-prov-data /dev/tst/thin-prov-meta 32786 16" thin-dev


Access /dev/mapper/thin-dev for arbitrary use (mkfs, mount, ...).


Resize the data device:

#!/bin/sh
# Assuming data device size was smaller than 4GB
dmsetup wait thin-dev
lvextend -L4G tst/thin-prov-data
echo "0 16777216 thin-prov \
/dev/tst/thin-prov-data /dev/tst/thin-prov-meta 32786 16"| \
dmsetup load
dmsetup suspend --noflush thin-dev
dmsetup resume thin-dev


Resize the thin provisioned device to 16GB:

echo "0 33554432 thin-prov \
/dev/tst/thin-prov-data /dev/tst/thin-prov-meta 32786 16"| \
dmsetup load
dmsetup suspend --noflush thin-dev
dmsetup resume thin-dev


Remove the idle (e.g. unmounted) mapped device:

dmsetup remove thin-dev
