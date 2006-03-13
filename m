From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] multipath-tools: IBM hwtable update
Date: Mon, 13 Mar 2006 12:31:04 +0100
Message-ID: <441557F8.10008@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000200030203060301000608"
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
--------------000200030203060301000608
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Christophe,

attached is an update for the IBM hwtable.
There is a new hardware ID for the IBM F20; and I've also switched to
'dasd_id' from udev instead of dasdview from s390-tools.

Please apply.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------000200030203060301000608
Content-Type: text/plain;
 name="multipath-tools-shark-update"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="multipath-tools-shark-update"

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 5c7d625..008e518 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -201,7 +201,7 @@ static struct hwentry default_hw[] = {
 	/*
 	 * IBM controler family
 	 *
-	 * Maintainer : Hannes Reinecke, Suse
+	 * Maintainer : Hannes Reinecke, SuSE
 	 * Mail : hare@suse.de
 	 */
 	{
@@ -254,7 +254,7 @@ static struct hwentry default_hw[] = {
 	{
 		/* IBM ESS F20 aka Shark */
 		.vendor        = "IBM",
-		.product       = "2105F20",
+		.product       = "2105{800,F20}",
 		.getuid        = DEFAULT_GETUID,
 		.getprio       = NULL,
 		.features      = "1 queue_if_no_path",
@@ -303,7 +303,7 @@ static struct hwentry default_hw[] = {
 		/* IBM S/390 ECKD DASD */
 		.vendor        = "IBM",
 		.product       = "S/390 DASD ECKD",
-		.getuid        = "/sbin/dasdview -j /dev/%n",
+		.getuid        = "/sbin/dasd_id /dev/%n",
 		.getprio       = NULL,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,

--------------000200030203060301000608
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------000200030203060301000608--
