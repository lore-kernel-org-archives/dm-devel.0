From: Vasily Tarasov <tarasov@vasily.name>
Subject: [PATCH RFC 10/10] dm-dedup: documentation
Date: Mon, 28 Apr 2014 11:26:52 -0400
Message-ID: <535ed0e1.69688c0a.2c5f.ffffc6ba@mx.google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, Philip Shilane <philip.shilane@emc.com>, Sonam Mandal <sonam.dp42@gmail.com>, Erez Zadok <ezk@fsl.cs.sunysb.edu>
List-Id: dm-devel.ids

Description of the Dmdedup target in Documentation.

Signed-off-by: Vasily Tarasov <tarasov@vasily.name>
---
 Documentation/device-mapper/dm-dedup.txt |   51 ++++++++++++++++++++++++++++++
 1 files changed, 51 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/device-mapper/dm-dedup.txt

diff --git a/Documentation/device-mapper/dm-dedup.txt b/Documentation/device-mapper/dm-dedup.txt
new file mode 100644
index 0000000..11bb7c2
--- /dev/null
+++ b/Documentation/device-mapper/dm-dedup.txt
@@ -0,0 +1,51 @@
+* DMDEDUP
+
+Dmdedup is a device-mapper deduplication target.  Every write coming to the
+Dmdedup instance is deduplicated against previously written data.  For
+datasets that contain many duplicates scattered across the disk (e.g.,
+virtual machine disk images collection and backups) deduplication provides a
+significant amount of space savings.
+
+To quickly identify duplicates, Dmdedup maintains an index of hashes for all
+written blocks.  The block is a user-configurable unit of deduplication with
+a default block size equal to 4KB.  Dmdedup index, along with other
+deduplication metadata, resides on a separate block device, which we refer
+to as metadata device.  Although the metadata device can be on any block
+device, e.g., an HDD or its partition, for higher performance we recommend
+to use SSD devices to store metadata.
+
+To create a new Dmdedup instance, a user can use the standard dmsetup tool:
+
+echo "0 $DMDEDUP_DEV_SIZE dedup data_dev=$DATA_DEV metadata_dev=$META_DEV \
+	mdbackend=cowbtree reconstruct=no" | dmsetup create mydedup
+
+where
+	- $DMDEDUP_DEV_SIZE	is the logical block device size in sectors;
+	- $DATA_DEV		is the block device where the data will reside
+				(e.g., /dev/hdb);
+	- $META_DEV 		is the block device where the metadata
+				will reside (e.g., /dev/hdc).
+
+The mdbackend parameter specifies the metadata backend that should be used
+for storing metadata.  Supported backends are "cowbtree" and "inram."
+Cowbtree uses the device-mapper's persistent API to store metadata. The
+inram backend stores all meta-data in RAM as a hash table.
+
+The "reconstruct= parameter specifies if one wants to reconstruct a
+previously created Dmdedup target (e.g., after a reboot).  Specifying
+"reconstruct=no" reinitializes a metadata device with an empty device.
+
+* AUTHORS
+
+Dmdedup was developed in the File system and Storage Lab (FSL) at Stony
+Brook University Computer Science Department, in collaboration with Harvey
+Mudd College and EMC.
+
+Key people involved in the project were Vasily Tarasov, Geoff Kuenning,
+Sonam Mandal, Karthikeyani Palanisami, Philip Shilane, Sagar Trehan, and
+Erez Zadok.
+
+We also acknowledge the help of several students involved in the
+deduplication project: Teo Asinari, Deepak Jain, Mandar Joshi, Atul
+Karmarkar, Meg O'Keefe, Gary Lent, Amar Mudrankit, Ujwala Tulshigiri, and
+Nabil Zaman.
-- 
1.7.1
