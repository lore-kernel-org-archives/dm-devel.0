From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH] dmsetup: fix 'dmsetup status' for crypt filling
 '0' in wrong area
Date: Fri, 20 Apr 2007 12:07:04 -0400
Message-ID: <4628E528.1070900@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000406090203030507050309"
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
To: device-mapper development <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------000406090203030507050309
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hi,

dmsetup tries to suppress encryption key of crypt target in the table
by filling '0' in params buffer.
However, the code assumes the case for showing table only and will
fill '0' beyond the params buffer when it's showing status, where
the params is "".

The patch fixes it.
The suppression is not necessary for showing status as
no encryption key is included in status line.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation of America

--------------000406090203030507050309
Content-Type: text/x-patch; name="dmsetup-status-crypt-suppression-bug.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="dmsetup-status-crypt-suppression-bug.patch"

dmsetup tries to suppress encryption key of crypt target.
However, the code overruns the params buffer if the command
is showing 'status', in that case params is "".

---
 dmsetup/dmsetup.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: device-mapper.work/dmsetup/dmsetup.c
===================================================================
--- device-mapper.work.orig/dmsetup/dmsetup.c
+++ device-mapper.work/dmsetup/dmsetup.c
@@ -964,12 +964,14 @@ static int _status(int argc, char **argv
 			if (target_type) {
 
 			/* Suppress encryption key */
-			if (!_switches[SHOWKEYS_ARG] &&
+			if (cmd == DM_DEVICE_TABLE &&
+			    !_switches[SHOWKEYS_ARG] &&
 			    !strcmp(target_type, "crypt")) {
 				c = params;
 				while (*c && *c != ' ')
 					c++;
-				c++;
+				if (*c)
+					c++;
 				while (*c && *c != ' ')
 					*c++ = '0';
 			}

--------------000406090203030507050309
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------000406090203030507050309--
