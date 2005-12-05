From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: kpartx bug fixes for dos extended partition [4/4]
Date: Mon, 05 Dec 2005 11:29:14 -0500
Message-ID: <43946ADA.7060600@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070605000101090400020701"
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------070605000101090400020701
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

This mail was not reached to dm-devel.
I'm resending this.

There is meaninglessly duplicated code in read_dos_pt().
It should be safe to remove it.

Thanks,
Nick

--------------070605000101090400020701
Content-Type: text/x-patch;
 name="04-kpartx-remove-duplicated-code.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="04-kpartx-remove-duplicated-code.patch"

Duplicated for loop is non-sense.

--- multipath-tools.orig/kpartx/dos.c	2005-12-02 01:33:29.000000000 +0900
+++ multipath-tools/kpartx/dos.c	2005-12-02 04:11:13.000000000 +0900
@@ -86,9 +86,6 @@ read_dos_pt(int fd, struct slice all, st
 
 	for (i=0; i<4; i++) {
 		memcpy(&p, bp + 0x1be + i * sizeof (p), sizeof (p));
-	}
-	for (i=0; i<4; i++) {
-		memcpy(&p, bp + 0x1be + i * sizeof (p), sizeof (p));
 		if (is_gpt(p.sys_type))
 			return 0;
 		if (i < ns) {

--------------070605000101090400020701
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------070605000101090400020701--
