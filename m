From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] kpartx compilation fix
Date: Fri, 09 Dec 2005 13:07:10 +0100
Message-ID: <4399736E.1060705@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070702050900090003020006"
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
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------070702050900090003020006
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Christophe,

this is a small compile fix for dasd.c; a pointer to unsigned char
should be of type unsigned char ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------070702050900090003020006
Content-Type: text/x-patch;
 name="kpartx-dasd-compilation-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kpartx-dasd-compilation-fix.patch"

[kpartx] compilation fixes for dasd.c

If a pointer points to an unsigned char it should be of the correct
type.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/kpartx/dasd.c b/kpartx/dasd.c
--- a/kpartx/dasd.c
+++ b/kpartx/dasd.c
@@ -52,7 +52,7 @@ read_dasd_pt(int fd, struct slice all, s
 	struct hd_geometry geo;
 	char type[5] = {0,};
 	char name[7] = {0,};
-	char *label_raw;
+	unsigned char *label_raw;
 	volume_label_t vlabel;
 	unsigned char *data = NULL;
 	unsigned int blk;

--------------070702050900090003020006
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------070702050900090003020006--
