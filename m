From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: kpartx bug fixes for dos extended partition [2/4]
Date: Thu, 01 Dec 2005 15:14:41 -0500
Message-ID: <438F59B1.1010901@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060103000309000007080709"
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
--------------060103000309000007080709
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hi Christophe,

kpartx usually doesn't create a mapping for extended partition.
However, it does if it's empty.
It's harmless but not consistent.
Attached patch makes it consistent by not creating a mapping
even when the extended partition is empty.

Please consider to apply.

If you have logical partitions in extended partition:
  # parted /dev/sdc p
  Disk geometry for /dev/sdc: 0.000-34686.000 megabytes
  Disk label type: msdos
  Minor    Start       End     Type      Filesystem  Flags
  1          7.844     31.376  extended
  5          7.875     23.532  logical

No mapping is created for extended partition:
  # dmsetup table|grep sdc|sort
  sdc5: 0 32067 linear 8:32 16128

However, if the extended partition is empty:
  # parted /dev/sdc p
  Disk geometry for /dev/sdc: 0.000-34686.000 megabytes
  Disk label type: msdos
  Minor    Start       End     Type      Filesystem  Flags
  1          7.844     31.376  extended

The following mapping is created:
  # dmsetup table|grep sdc|sort
  sdc1: 0 48195 linear 8:32 16065

Thanks,
Nick



--------------060103000309000007080709
Content-Type: text/x-patch;
	name="02-kpartx-avoid-mapping-empty-extended-part.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="02-kpartx-avoid-mapping-empty-extended-part.patch"

Don't create mapping for extended partition.

--- multipath-tools.orig/kpartx/dos.c	2005-12-02 01:33:41.000000000 +0900
+++ multipath-tools/kpartx/dos.c	2005-12-02 01:33:29.000000000 +0900
@@ -99,8 +99,11 @@ read_dos_pt(int fd, struct slice all, st
 				"dos_partition: too many slices\n");
 			break;
 		}
-		if (is_extended(p.sys_type))
+		if (is_extended(p.sys_type)) {
 			n += read_extended_partition(fd, &p, sp+n, ns-n);
+			/* hide the extended partition itself */
+			sp[i].size = 0;
+		}
 	}
 	return n;
 }

--------------060103000309000007080709
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------060103000309000007080709--
