From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH] dm-verity: fix documentation
Date: Mon, 11 Jun 2012 13:56:53 +0200
Message-ID: <1339415813-21375-1-git-send-email-mbroz@redhat.com>
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
Cc: Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Fix target line specification.
Mention units for block size paramaters.
Remove on-disk header description (which is not parsed in kernel)
and point users to cryptsetup where it the format is documented.
Fix dmsetup parameters.
Veritysetup is now part of cryptsetup package.

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 Documentation/device-mapper/verity.txt |  121 +++++++++++---------------------
 1 file changed, 41 insertions(+), 80 deletions(-)

diff --git a/Documentation/device-mapper/verity.txt b/Documentation/device-mapper/verity.txt
index 32e4879..cdc9bbf 100644
--- a/Documentation/device-mapper/verity.txt
+++ b/Documentation/device-mapper/verity.txt
@@ -7,39 +7,39 @@ This target is read-only.
 
 Construction Parameters
 =======================
-    <version> <dev> <hash_dev> <hash_start>
+    <version> <dev> <hash_dev>
     <data_block_size> <hash_block_size>
     <num_data_blocks> <hash_start_block>
     <algorithm> <digest> <salt>
 
 <version>
-    This is the version number of the on-disk format.
+    This is the type of the on-disk hash format.
 
     0 is the original format used in the Chromium OS.
-	The salt is appended when hashing, digests are stored continuously and
-	the rest of the block is padded with zeros.
+      The salt is appended when hashing, digests are stored continuously and
+      the rest of the block is padded with zeros.
 
     1 is the current format that should be used for new devices.
-	The salt is prepended when hashing and each digest is
-	padded with zeros to the power of two.
+      The salt is prepended when hashing and each digest is
+      padded with zeros to the power of two.
 
 <dev>
-    This is the device containing the data the integrity of which needs to be
+    This is the device containing data of which integrity needs to be
     checked.  It may be specified as a path, like /dev/sdaX, or a device number,
     <major>:<minor>.
 
 <hash_dev>
-    This is the device that that supplies the hash tree data.  It may be
+    This is the device that supplies the hash tree data.  It may be
     specified similarly to the device path and may be the same device.  If the
     same device is used, the hash_start should be outside of the dm-verity
     configured device size.
 
 <data_block_size>
-    The block size on a data device.  Each block corresponds to one digest on
-    the hash device.
+    The block size on a data device in bytes.
+    Each block corresponds to one digest on the hash device.
 
 <hash_block_size>
-    The size of a hash block.
+    The size of a hash block in bytes.
 
 <num_data_blocks>
     The number of data blocks on the data device.  Additional blocks are
@@ -77,16 +77,16 @@ tree, the root hash, then the I/O will fail.  This should identify
 tampering with any data on the device and the hash data.
 
 Cryptographic hashes are used to assert the integrity of the device on a
-per-block basis.  This allows for a lightweight hash computation on first read
-into the page cache.  Block hashes are stored linearly-aligned to the nearest
-block the size of a page.
+per-block basis. This allows for a lightweight hash computation on first read
+into the page cache. Block hashes are stored linearly, aligned to the nearest
+block size.
 
 Hash Tree
 ---------
 
 Each node in the tree is a cryptographic hash.  If it is a leaf node, the hash
-is of some block data on disk.  If it is an intermediary node, then the hash is
-of a number of child nodes.
+is calculated of some data block on disk. If it is an intermediary node,
+the hash is calculated of a number of child nodes.
 
 Each entry in the tree is a collection of neighboring nodes that fit in one
 block.  The number is determined based on block_size and the size of the
@@ -110,63 +110,23 @@ alg = sha256, num_blocks = 32768, block_size = 4096
 On-disk format
 ==============
 
-Below is the recommended on-disk format. The verity kernel code does not
-read the on-disk header. It only reads the hash blocks which directly
-follow the header. It is expected that a user-space tool will verify the
-integrity of the verity_header and then call dmsetup with the correct
-parameters. Alternatively, the header can be omitted and the dmsetup
-parameters can be passed via the kernel command-line in a rooted chain
-of trust where the command-line is verified.
+The verity kernel code does not read the verity metadata on-disk header.
+It only reads the hash blocks which directly follow the header.
+It is expected that a user-space tool will verify the integrity of the
+verity header.
 
-The on-disk format is especially useful in cases where the hash blocks
-are on a separate partition. The magic number allows easy identification
-of the partition contents. Alternatively, the hash blocks can be stored
-in the same partition as the data to be verified. In such a configuration
-the filesystem on the partition would be sized a little smaller than
-the full-partition, leaving room for the hash blocks.
-
-struct superblock {
-	uint8_t signature[8]
-		"verity\0\0";
-
-	uint8_t version;
-		1 - current format
-
-	uint8_t data_block_bits;
-		log2(data block size)
-
-	uint8_t hash_block_bits;
-		log2(hash block size)
-
-	uint8_t pad1[1];
-		zero padding
-
-	uint16_t salt_size;
-		big-endian salt size
-
-	uint8_t pad2[2];
-		zero padding
-
-	uint32_t data_blocks_hi;
-		big-endian high 32 bits of the 64-bit number of data blocks
-
-	uint32_t data_blocks_lo;
-		big-endian low 32 bits of the 64-bit number of data blocks
-
-	uint8_t algorithm[16];
-		cryptographic algorithm
-
-	uint8_t salt[384];
-		salt (the salt size is specified above)
-
-	uint8_t pad3[88];
-		zero padding to 512-byte boundary
-}
+Alternatively, the header can be omitted and the dmsetup parameters can
+be passed via the kernel command-line in a rooted chain of trust where
+the command-line is verified.
 
 Directly following the header (and with sector number padded to the next hash
 block boundary) are the hash blocks which are stored a depth at a time
 (starting from the root), sorted in order of increasing index.
 
+The full specification of kernel parameters and on-disk metadata format
+is available at cryptsetup project wiki page
+  http://code.google.com/p/cryptsetup/wiki/DMVerity
+
 Status
 ======
 V (for Valid) is returned if every check performed so far was valid.
@@ -174,21 +134,22 @@ If any check failed, C (for Corruption) is returned.
 
 Example
 =======
-
 Setup a device:
-  dmsetup create vroot --table \
-    "0 2097152 "\
-    "verity 1 /dev/sda1 /dev/sda2 4096 4096 2097152 1 "\
+  # dmsetup create vroot --readonly --table \
+    "0 2097152 verity 1 /dev/sda1 /dev/sda2 4096 4096 262144 1 sha256 "\
     "4392712ba01368efdf14b05c76f9e4df0d53664630b5d48632ed17a137f39076 "\
     "1234000000000000000000000000000000000000000000000000000000000000"
 
 A command line tool veritysetup is available to compute or verify
-the hash tree or activate the kernel driver.  This is available from
-the LVM2 upstream repository and may be supplied as a package called
-device-mapper-verity-tools:
-    git://sources.redhat.com/git/lvm2
-    http://sourceware.org/git/?p=lvm2.git
-    http://sourceware.org/cgi-bin/cvsweb.cgi/LVM2/verity?cvsroot=lvm2
-
-veritysetup -a vroot /dev/sda1 /dev/sda2 \
-	4392712ba01368efdf14b05c76f9e4df0d53664630b5d48632ed17a137f39076
+the hash tree or activate the kernel device. This is available from
+the cryptsetup upstream repository http://code.google.com/p/cryptsetup/
+(as libcryptsetup extension).
+
+Create hash on the device:
+  # veritysetup format /dev/sda1 /dev/sda2
+  ...
+  Root hash: 4392712ba01368efdf14b05c76f9e4df0d53664630b5d48632ed17a137f39076
+
+Activate the device:
+  # veritysetup create vroot /dev/sda1 /dev/sda2 \
+    4392712ba01368efdf14b05c76f9e4df0d53664630b5d48632ed17a137f39076
-- 
1.7.10
