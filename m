From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Fixup return code for 'multipath -l'
Date: Fri, 01 Sep 2006 09:36:28 +0200
Message-ID: <44F7E2FC.1090806@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050703010808090706020804"
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
--------------050703010808090706020804
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi Christophe,

'multipath -l' should really set the return code to '0' if no error=20
occurred.

Please apply.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------050703010808090706020804
Content-Type: text/plain;
 name="multipath-tools-fixup-return-code"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="multipath-tools-fixup-return-code"

 multipath/main.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index c1257a2..b6f8814 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -280,8 +280,10 @@ configure (void)
 
 	filter_pathvec(pathvec, refwwid);
 
-	if (conf->list)
+	if (conf->list) {
+		r = 0;
 		goto out;
+	}
 
 	/*
 	 * core logic entry point

--------------050703010808090706020804
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------050703010808090706020804--
