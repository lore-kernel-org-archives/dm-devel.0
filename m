From: Andy Grover <agrover@redhat.com>
Subject: [PATCH] dm integrity: Document size and format of
	superblock fields
Date: Fri,  9 Nov 2018 12:21:57 -0800
Message-ID: <20181109202157.5565-1-agrover@redhat.com>
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
To: dm-devel@redhat.com, snitzer@redhat.com
Cc: mpatocka@redhat.com
List-Id: dm-devel.ids

As mentioned elsewhere in dm-integrity.txt, creating a new integrity
device requires creating a small integrity device on top of the base
device that formats the base device, reading the provided data sectors
out of the superblock, and then recreating the integrity device with the
correct size. For this, userspace must know the offset, length, and
endianness of the provided_data_sectors field in the superblock.

Document all fields mentioned in the txt to include this, based on struct
superblock in dm-integrity.c. Extra fields in struct superblock not
already mentioned in the txt remain undocumented.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 Documentation/device-mapper/dm-integrity.txt | 26 ++++++++++++--------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/Documentation/device-mapper/dm-integrity.txt b/Documentation/device-mapper/dm-integrity.txt
index 297251b0d2d5..3d28328f16c1 100644
--- a/Documentation/device-mapper/dm-integrity.txt
+++ b/Documentation/device-mapper/dm-integrity.txt
@@ -158,16 +158,22 @@ The layout of the formatted block device:
   storing LUKS metadata or for other purpose), the size of the reserved
   area is specified in the target arguments
 * superblock (4kiB)
-	* magic string - identifies that the device was formatted
-	* version
-	* log2(interleave sectors)
-	* integrity tag size
-	* the number of journal sections
-	* provided data sectors - the number of sectors that this target
-	  provides (i.e. the size of the device minus the size of all
-	  metadata and padding). The user of this target should not send
-	  bios that access data beyond the "provided data sectors" limit.
-	* flags - a flag is set if journal_mac is used
+
+offset and length in bytes. All values little-endian.
+
+offset	length	description
+0	8	magic string - identifies that the device was formatted
+8	1	version
+9	1	log2(interleave sectors)
+10	2	integrity tag size
+12	4	the number of journal sections
+16	8	provided data sectors - the number of sectors that this
+		target provides (i.e. the size of the device minus the size of
+		all metadata and padding). The user of this target should not
+		send bios that access data beyond the "provided data sectors"
+		limit.
+24	4	flags - a flag is set if journal_mac is used
+
 * journal
 	The journal is divided into sections, each section contains:
 	* metadata area (4kiB), it contains journal entries
-- 
2.17.2
