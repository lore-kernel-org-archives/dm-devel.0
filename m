From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: [RFC PATCH v3 0/1] dm: add clone target
Date: Wed, 11 Sep 2019 17:36:39 +0300
Message-ID: <20190911143640.24991-1-ntsironis@arrikto.com>
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
To: snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com
Cc: vkoukis@arrikto.com, ntsironis@arrikto.com, iliastsi@arrikto.com
List-Id: dm-devel.ids

This patch adds the dm-clone target, which allows cloning of arbitrary
block devices.

dm-clone produces a one-to-one copy of an existing, read-only source
device into a writable destination device: It presents a virtual block
device which makes all data appear immediately, and redirects reads and
writes accordingly.

The main use case of dm-clone is to clone a potentially remote,
high-latency, read-only, archival-type block device into a writable,
fast, primary-type device for fast, low-latency I/O. The cloned device
is visible/mountable immediately and the copy of the source device to
the destination device happens in the background, in parallel with user
I/O.

For example, one could restore an application backup from a read-only
copy, accessible through a network storage protocol (NBD, Fibre Channel,
iSCSI, AoE, etc.), into a local SSD or NVMe device, and start using the
device immediately, without waiting for the restore to complete.

When the cloning completes, the dm-clone table can be removed altogether
and be replaced, e.g., by a linear table, mapping directly to the
destination device.

dm-clone is optimized for small, random writes, with size equal to
dm-clone's region size, e.g., 4K.

For more information regarding dm-clone's operation, please read the
attached documentation.

A preliminary test suite for dm-clone can be found at
https://github.com/arrikto/device-mapper-test-suite/tree/feature-dm-clone

Changes in v3:
  - Move Documentation/device-mapper/dm-clone.rst to
    Documentation/admin-guide/device-mapper/dm-clone.rst

v2: https://www.redhat.com/archives/dm-devel/2019-September/msg00061.html
v1: https://www.redhat.com/archives/dm-devel/2019-July/msg00088.html

Nikos Tsironis (1):
  dm: add clone target

 .../admin-guide/device-mapper/dm-clone.rst         |  333 +++
 drivers/md/Kconfig                                 |   14 +
 drivers/md/Makefile                                |    2 +
 drivers/md/dm-clone-metadata.c                     |  963 +++++++++
 drivers/md/dm-clone-metadata.h                     |  158 ++
 drivers/md/dm-clone-target.c                       | 2190 ++++++++++++++++++++
 6 files changed, 3660 insertions(+)
 create mode 100644 Documentation/admin-guide/device-mapper/dm-clone.rst
 create mode 100644 drivers/md/dm-clone-metadata.c
 create mode 100644 drivers/md/dm-clone-metadata.h
 create mode 100644 drivers/md/dm-clone-target.c

-- 
2.11.0
