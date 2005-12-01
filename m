From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: kpartx bug fixes for dos extended partition [3/4]
Date: Thu, 01 Dec 2005 15:22:33 -0500
Message-ID: <438F5B89.5000903@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070407050000010309060700"
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
--------------070407050000010309060700
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hi Christophe,

in the for loop in read_extended_partition,
'here' is updated if the next extended partition is found.

However, the 'here' value should be updated in the next while loop.
Otherwise it's possible that following partition table
entry refers updated value and generate wrong mapping.

I'm not sure if there is any partitioning tool which can generate
such table. But it's safer to fix this.

Thanks,
Nick

--------------070407050000010309060700
Content-Type: text/x-patch;
 name="03-kpartx-fix-cursor-update.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03-kpartx-fix-cursor-update.patch"

If the 1st slot of extended partition contains a pointer to
the next extended partition and the 2nd is normal logical partition,
incorrect mapping will be generated for the 2nd partition.

Usually, 2 slots of extended partition table is used
and the 2nd slot points to the next extended partition.
So this bug will not be hit in most cases.

--- multipath-tools.orig/kpartx/dos.c	2005-12-02 04:06:25.000000000 +0900
+++ multipath-tools/kpartx/dos.c	2005-12-02 01:33:41.000000000 +0900
@@ -20,15 +20,16 @@ read_extended_partition(int fd, struct p
 			struct slice *sp, int ns)
 {
 	struct partition p;
-	unsigned long start, here;
+	unsigned long start, here, next;
 	unsigned char *bp;
 	int loopct = 0;
 	int moretodo = 1;
 	int i, n=0;
 
-	here = start = le32_to_cpu(ep->start_sect);
+	next = start = le32_to_cpu(ep->start_sect);
 
 	while (moretodo) {
+		here = next;
 		moretodo = 0;
 		if (++loopct > 100)
 			return n;
@@ -43,8 +44,8 @@ read_extended_partition(int fd, struct p
 		for (i=0; i<2; i++) {
 			memcpy(&p, bp + 0x1be + i * sizeof (p), sizeof (p));
 			if (is_extended(p.sys_type)) {
-				if (p.nr_sects) {
-					here = start + le32_to_cpu(p.start_sect);
+				if (p.nr_sects && !moretodo) {
+					next = start + le32_to_cpu(p.start_sect);
 					moretodo = 1;
 				}
 				continue;

--------------070407050000010309060700
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------070407050000010309060700--
