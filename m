From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Fixup 3526 prio callout
Date: Mon, 04 Sep 2006 08:35:20 +0200
Message-ID: <44FBC928.5020908@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060200090405070906010404"
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
--------------060200090405070906010404
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi Christophe,

the patch for adding 3526 has a small glitch; it should also call the=20
prio-callout without any path. This patch fixes this up.

Please apply.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------060200090405070906010404
Content-Type: text/plain;
 name="multipath-tools-fixup-3526-callout"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="multipath-tools-fixup-3526-callout"

Fixup prio callout for IBM 3526

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 09cf0a4..c395bf1 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -261,7 +261,7 @@ static struct hwentry default_hw[] = {
 		.vendor        = "IBM",
 		.product       = "3526",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = "/sbin/mpath_prio_tpc /dev/%n",
+		.getprio       = "mpath_prio_tpc /dev/%n",
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,

--------------060200090405070906010404
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------060200090405070906010404--
