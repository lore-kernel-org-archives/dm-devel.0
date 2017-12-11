From: Scott Bauer <scott.bauer@intel.com>
Subject: [PATCH v2 2/2] dm unstripe: Add documentation for unstripe target
Date: Mon, 11 Dec 2017 09:00:19 -0700
Message-ID: <20171211160019.20518-3-scott.bauer@intel.com>
References: <20171211160019.20518-1-scott.bauer@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171211160019.20518-1-scott.bauer@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: snitzer@redhat.com, agk@redhat.com, linux-kernel@vger.kernel.org, keith.busch@intel.com, jonathan.derrick@intel.com, Scott Bauer <scott.bauer@intel.com>
List-Id: dm-devel.ids

Signed-off-by: Scott Bauer <scott.bauer@intel.com>
---
 Documentation/device-mapper/dm-unstripe.txt | 82 +++++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)
 create mode 100644 Documentation/device-mapper/dm-unstripe.txt

diff --git a/Documentation/device-mapper/dm-unstripe.txt b/Documentation/device-mapper/dm-unstripe.txt
new file mode 100644
index 000000000000..4e1a0a39a689
--- /dev/null
+++ b/Documentation/device-mapper/dm-unstripe.txt
@@ -0,0 +1,82 @@
+Device-Mapper Unstripe
+=====================
+
+The device-mapper Unstripe (dm-unstripe) target provides a transparent
+mechanism to unstripe a RAID 0 striping to access segregated disks.
+
+This module should be used by users who understand what the underlying
+disks look like behind the software/hardware RAID.
+
+Parameters:
+<drive (ex: /dev/nvme0n1)> <drive #> <# of drives> <stripe sectors>
+
+
+<drive>
+	The block device you wish to unstripe.
+
+<drive #>
+        The physical drive you wish to expose via this "virtual" device
+	mapper target. This must be 0 indexed.
+
+<# of drives>
+        The number of drives in the RAID 0.
+
+<stripe sectors>
+	The amount of 512B sectors in the raid striping, or zero, if you
+	wish you use max_hw_sector_size.
+
+
+Why use this module?
+=====================
+
+As a use case:
+
+
+    As an example:
+
+    Intel NVMe drives contain two cores on the physical device.
+    Each core of the drive has segregated access to its LBA range.
+    The current LBA model has a RAID 0 128k stripe across the two cores:
+
+       Core 0:                Core 1:
+      __________            __________
+      | LBA 511|            | LBA 768|
+      | LBA 0  |            | LBA 256|
+      ⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻            ⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻
+
+    The purpose of this unstriping is to provide better QoS in noisy
+    neighbor environments. When two partitions are created on the
+    aggregate drive without this unstriping, reads on one partition
+    can affect writes on another partition. With the striping concurrent
+    reads and writes and I/O on opposite cores have lower completion times,
+    and better tail latencies.
+
+    With the module we were able to segregate a fio script that has read and
+    write jobs that are independent of each other. Compared to when we run
+    the test on a combined drive with partitions, we were able to get a 92%
+    reduction in five-9ths read latency using this device mapper target.
+
+
+    One could use the module to Logical de-pop a HDD if you have sufficient
+    geometry information regarding the drive.
+
+
+Example scripts:
+====================
+
+dmsetup create nvmset1 --table '0 1 dm-unstripe /dev/nvme0n1 1 2 0'
+dmsetup create nvmset0 --table '0 1 dm-unstripe /dev/nvme0n1 0 2 0'
+
+There will now be two mappers:
+/dev/mapper/nvmset1
+/dev/mapper/nvmset0
+
+that will expose core 0 and core 1.
+
+
+In a Raid 0 with 4 drives of stripe size 128K:
+dmsetup create raid_disk0 --table '0 1 dm-unstripe /dev/nvme0n1 0 4 256'
+dmsetup create raid_disk1 --table '0 1 dm-unstripe /dev/nvme0n1 1 4 256'
+dmsetup create raid_disk2 --table '0 1 dm-unstripe /dev/nvme0n1 2 4 256'
+dmsetup create raid_disk3 --table '0 1 dm-unstripe /dev/nvme0n1 3 4 256'
+
-- 
2.11.0
