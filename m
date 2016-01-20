From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: [PATCH V2] kpartx: support device names with spaces
Date: Wed, 20 Jan 2016 11:52:45 -0200
Message-ID: <1453297965-32278-1-git-send-email-mauricfo@linux.vnet.ibm.com>
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
List-Id: dm-devel.ids

Device names with spaces fail to be added to device-mapper tables
because spaces are field separators.  In order to support it, use
device major:minor numbers, instead.  While still there, make the
verbose output of container- and contained-slices consistent.

This is useful on some scenarios with arbitrary loop device names,
and non-user_friendly_names multipath WWIDs with spaces (eg, QEMU
emulated hard drives, and some IBM devices) on some distros.

Changelog:
- V2: Use major()/minor() instead of MAJOR()/MINOR() (build errors).
      Update test-case verification output.
      Thanks: Christophe Varoqui

Test-case:

	# img="/tmp/my.img"
	# spacename="/dev/my space name"

	# truncate --size=1G "$img"
	# lodev=$(sudo losetup --find --show "$img")
	# ln -sf "$lodev" "$spacename"

	# ls -l $lodev "$spacename"
	brw-rw----. 1 root disk 7, 0 Jan 20 11:15 /dev/loop0
	lrwxrwxrwx. 1 root root   10 Jan 20 11:16 /dev/my space name -> /dev/loop0

	# fdisk $lodev
	<...>

	# fdisk -l $lodev
	<...>
	      Device Boot      Start         End      Blocks   Id  System
	/dev/loop0p1            2048      264191      131072   83  Linux
	/dev/loop0p2          264192      788479      262144   83  Linux
	/dev/loop0p3          788480     2097151      654336    5  Extended
	/dev/loop0p5          790528      856063       32768   83  Linux
	/dev/loop0p6          858112      989183       65536   83  Linux
	/dev/loop0p7          991232     1515519      262144   83  Linux

Without patch:

	# ./kpartx/kpartx -av "$spacename"
	device-mapper: reload ioctl on my\x20space\x20name1 failed: Invalid argument
	create/reload failed on my space name1
	add map my space name1 (0:0): 0 262144 linear /dev/my space name 2048

	device-mapper: reload ioctl on my\x20space\x20name2 failed: Invalid argument
	create/reload failed on my space name2
	add map my space name2 (0:0): 0 524288 linear /dev/my space name 264192

	device-mapper: reload ioctl on my\x20space\x20name3 failed: Invalid argument
	create/reload failed on my space name3
	add map my space name3 (0:0): 0 2 linear /dev/my space name 788480

	device-mapper: reload ioctl on my\x20space\x20name5 failed: Invalid argument
	add map my space name5 : 0 65536 linear /dev/my space name 790528

	device-mapper: reload ioctl on my\x20space\x20name6 failed: Invalid argument
	add map my space name6 : 0 131072 linear /dev/my space name 858112

	device-mapper: reload ioctl on my\x20space\x20name7 failed: Invalid argument
	add map my space name7 : 0 524288 linear /dev/my space name 991232

	(note: line breaks added for clarity)

With patch:

	# ./kpartx/kpartx -av "$spacename"
	add map my space name1 (253:3): 0 262144 linear 7:0 2048
	add map my space name2 (253:4): 0 524288 linear 7:0 264192
	add map my space name3 (253:5): 0 2 linear 7:0 788480
	add map my space name5 (253:6): 0 65536 linear 7:0 790528
	add map my space name6 (253:7): 0 131072 linear 7:0 858112
	add map my space name7 (253:8): 0 524288 linear 7:0 991232

	# dmsetup table | sort
	my space name1: 0 262144 linear 7:0 2048
	my space name2: 0 524288 linear 7:0 264192
	my space name3: 0 2 linear 7:0 788480
	my space name5: 0 65536 linear 7:0 790528
	my space name6: 0 131072 linear 7:0 858112
	my space name7: 0 524288 linear 7:0 991232

	# ls -l /dev/mapper/
	total 0
	crw-------. 1 root root 10, 236 Jan 11 16:29 control
	lrwxrwxrwx. 1 root root       7 Jan 20 11:19 my\x20space\x20name1 -> ../dm-3
	lrwxrwxrwx. 1 root root       7 Jan 20 11:19 my\x20space\x20name2 -> ../dm-4
	lrwxrwxrwx. 1 root root       7 Jan 20 11:19 my\x20space\x20name3 -> ../dm-5
	lrwxrwxrwx. 1 root root       7 Jan 20 11:19 my\x20space\x20name5 -> ../dm-6
	lrwxrwxrwx. 1 root root       7 Jan 20 11:19 my\x20space\x20name6 -> ../dm-7
	lrwxrwxrwx. 1 root root       7 Jan 20 11:19 my\x20space\x20name7 -> ../dm-8

Thanks: Scott Moser (pointers to the error and test-case).

Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
---
 kpartx/kpartx.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index a9d4c98..ee7c38a 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -477,8 +477,8 @@ main(int argc, char **argv){
 				}
 				strip_slash(partname);
 
-				if (safe_sprintf(params, "%s %" PRIu64 ,
-						 device, slices[j].start)) {
+				if (safe_sprintf(params, "%d:%d %" PRIu64 ,
+						 major(buf.st_rdev), minor(buf.st_rdev), slices[j].start)) {
 					fprintf(stderr, "params too small\n");
 					exit(1);
 				}
@@ -540,8 +540,8 @@ main(int argc, char **argv){
 					}
 					strip_slash(partname);
 
-					if (safe_sprintf(params, "%s %" PRIu64,
-							 device,
+					if (safe_sprintf(params, "%d:%d %" PRIu64,
+							 major(buf.st_rdev), minor(buf.st_rdev),
 							 slices[j].start)) {
 						fprintf(stderr, "params too small\n");
 						exit(1);
@@ -563,8 +563,8 @@ main(int argc, char **argv){
 						&slices[j].minor);
 
 					if (verbose)
-						printf("add map %s : 0 %" PRIu64 " %s %s\n",
-						       partname, slices[j].size,
+						printf("add map %s (%d:%d): 0 %" PRIu64 " %s %s\n",
+						       partname, slices[j].major, slices[j].minor, slices[j].size,
 						       DM_TARGET, params);
 					c--;
 				}
-- 
1.8.3.1
