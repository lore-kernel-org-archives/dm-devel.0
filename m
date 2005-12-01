From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: kpartx bug fixes for dos extended partition [1/4]
Date: Thu, 01 Dec 2005 15:05:50 -0500
Message-ID: <438F579E.302@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010604000803030303060502"
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@free.fr>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------010604000803030303060502
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hi Christophe,

the latest kpartx generates wrong mapping for
MS-DOS extended partitions.
Attached patch fixes the problem.
Please consider to apply.

Consider you created the following partition table.
  # parted /dev/sdc p
  Disk geometry for /dev/sdc: 0.000-34686.000 megabytes
  Disk label type: msdos
  Minor    Start       End     Type      Filesystem  Flags
  1          0.031      7.844  primary
  2          7.844     31.376  extended
  5          7.875     23.532  logical
  6         23.563     31.376  logical

kpartx should generate the following mappings:
  # dmsetup table|grep sdc|sort
  sdc1: 0 16002 linear 8:32 63
  sdc5: 0 32067 linear 8:32 16128
  sdc6: 0 16002 linear 8:32 48258

However, actually it generates:
  # dmsetup table|grep sdc|sort
  sdc1: 0 16002 linear 8:32 63
  sdc5: 0 32067 linear 8:32 16128
  sdc6: 0 16065 linear 8:32 80325
  sdc7: 0 16002 linear 8:32 48258

Thanks,
Nick

--------------010604000803030303060502
Content-Type: text/x-patch; name="01-kpartx-dont-count-hidden-extended.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="01-kpartx-dont-count-hidden-extended.patch"

Don't count (hidden) extended partition table entry as partition.

Otherwise, kpartx cause inconsistent numbering of partitions and
also generate useless/misleading mappings for such entries.


DOS extended partition is implemented by chain of 2-slot tables.
Both Linux kernel and fdisk/parted doesn't count the link to the next
extended partition table as single partition.

--- multipath-tools.orig/kpartx/dos.c	2005-12-01 08:36:57.000000000 +0900
+++ multipath-tools/kpartx/dos.c	2005-12-02 04:06:25.000000000 +0900
@@ -47,8 +47,7 @@ read_extended_partition(int fd, struct p
 					here = start + le32_to_cpu(p.start_sect);
 					moretodo = 1;
 				}
-				else
-					continue;
+				continue;
 			}
 			if (n < ns) {
 				sp[n].start = here + le32_to_cpu(p.start_sect);

--------------010604000803030303060502
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------010604000803030303060502--
