From: Hannes Reinecke <hare@suse.de>
Subject: [multipathd] correct oom_adj value
Date: Wed, 07 Dec 2005 15:57:57 +0100
Message-ID: <4396F875.1050907@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030004020106080106060402"
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
--------------030004020106080106060402
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Christophe,

any recent kernel will only accept values > -17 for oom_adj.
So writing '-17' into oom_adj will only lead to an error, not to the
desired behaviour.

Patch is attached.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------030004020106080106060402
Content-Type: text/x-patch;
 name="multipath-tools-oom-adj.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="multipath-tools-oom-adj.patch"

[multipathd] set oom_adj to a valid value

As of 2.6.14, the kernel will only accept oom_adj values of > -17.
Writing '-17' into oom_adj will be ignored. This patch fixes the
value to -16.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/multipathd/main.c b/multipathd/main.c
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1554,7 +1554,7 @@ child (void * param)
 	}
 	signal_init();
 	setscheduler();
-	set_oom_adj(-17);
+	set_oom_adj(-16);
 	vecs = gvecs = init_vecs();
 
 	if (!vecs)

--------------030004020106080106060402
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------030004020106080106060402--
