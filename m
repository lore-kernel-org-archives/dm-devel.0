From: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>
Subject: [Patch] multipath-tools: rdac path checked leads to I/O
 hang when volumes are unmapped from storage.
Date: Tue, 20 Oct 2009 18:39:15 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C1C93A0247B@inbmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, "christophe.varoqui@free.fr" <christophe.varoqui@free.fr>
Cc: "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>, "sekharan@linux.vnet.ibm.com" <sekharan@linux.vnet.ibm.com>, "Moger, Babu" <Babu.Moger@lsi.com>
List-Id: dm-devel.ids

Hi,

We are seeing I/O hang when volumes (configured with rdac path checker) a=
re unmapped from the storage. Expected is I/O should fail. Please see the=
 syslog snippet below:

Oct  15 14:40:43 linux kernel: sd 6:0:0:0: queueing MODE_SELECT command.
Oct  15 14:40:43 linux kernel: sd 6:0:0:0: MODE_SELECT failed with sense =
0x59100.
Oct  15 14:40:43 linux kernel: end_request: I/O error, dev sdh, sector 18=
509824
Oct  15 14:40:43 linux kernel: device-mapper: multipath: Failing path 8:1=
12.
Oct  15 14:40:43 linux kernel: end_request: I/O error, dev sdh, sector 0
Oct  15 14:40:43 linux kernel: end_request: I/O error, dev sdh, sector 18=
512896
Oct  15 14:40:43 linux kernel: end_request: I/O error, dev sdh, sector 18=
511872
Oct  15 14:40:43 linux kernel: end_request: I/O error, dev sdh, sector 18=
510848
Oct  15 14:40:43 linux multipathd: 8:112: mark as failed
Oct  15 14:40:43 linux multipathd: 3600a0b800029ea52000097bc4acde51e: Ent=
ering recovery mode: max_retries=3D30
Oct  15 14:40:44 linux multipathd: 3600a0b800029eb0a0000f2af4acde4d1: que=
ue_if_no_path enabled
Oct  15 14:40:44 linux multipathd: 3600a0b800029eb0a0000f2af4acde4d1: Rec=
overed to normal mode
Oct  15 14:40:44 linux kernel: sd 5:0:0:1: queueing MODE_SELECT command.
Oct  15 14:40:44 linux kernel: sd 5:0:0:1: MODE_SELECT failed with sense =
0x59100.
Oct  15 14:40:44 linux kernel: end_request: I/O error, dev sdc, sector 0
Oct  15 14:40:44 linux kernel: device-mapper: multipath: Failing path 8:3=
2.
Oct  15 14:40:44 linux kernel: end_request: I/O error, dev sdc, sector 16=
089088
Oct  15 14:40:44 linux kernel: end_request: I/O error, dev sdc, sector 16=
090112
Oct  15 14:40:44 linux kernel: end_request: I/O error, dev sdc, sector 16=
091136
Oct  15 14:40:44 linux kernel: end_request: I/O error, dev sdc, sector 16=
092160
Oct  15 14:40:44 linux multipathd: 8:32: mark as failed

Below is the patch that fix this issue. When devices are unmapped from st=
orage, rdac patch checker sets the path state for those devices as ghost.=
 As a reason dm issues mode select to failover path group and fails with =
0x59100, which eventually ends up with ping pong between path groups resu=
lting in I/O hang. In rdac path checker, we need to check if devices are =
not connected, mark it as failed. This patch adds check for Peripheral Qu=
alifier (PQ) & Peripheral Device type(PDT) of Inquiry data and fails the =
path if either 1) PQ is set to 0x1 or 2) PQ set to 0x11 and PDT set to 0x=
1F.


Signed-off-by: Vijay Chauhan <vijay.chauhan@lsi.com>
Reviewed-by: Babu Moger <babu.moger@lsi.com>

---

--- multipath-tools/libmultipath/checkers/rdac.c.orig	2009-10-20 23:01:50=
.000000000 +0530
+++ multipath-tools/libmultipath/checkers/rdac.c	2009-10-20 23:49:31.0000=
00000 +0530
@@ -91,7 +91,8 @@ do_inq(int sg_fd, unsigned int pg_op, vo
=20
 struct volume_access_inq
 {
-	char dontcare0[8];
+	char PQ_PDT;
+	char dontcare0[7];
 	char avtcvp;
 	char dontcare1[39];
 };
@@ -105,6 +106,11 @@ libcheck_check (struct checker * c)
 	if (0 !=3D do_inq(c->fd, 0xC9, &inq, sizeof(struct volume_access_inq)))=
 {
 		MSG(c, MSG_RDAC_DOWN);
 		return PATH_DOWN;
+	} else {
+		if ((inq.PQ_PDT & 0x20) || (inq.PQ_PDT & 0x7f)) {
+			/* LUN not connected*/
+			return PATH_DOWN;
+		}
 	}
=20
 	if (inq.avtcvp & 0x1) {

--
