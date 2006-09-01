From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Fixup hwtable regexp
Date: Fri, 01 Sep 2006 09:18:18 +0200
Message-ID: <44F7DEBA.2030404@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030706010601030806080001"
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
--------------030706010601030806080001
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi Christophe,

appearently no-one noticed that we've switched to regular expressions=20
instead of shell-style fnmatch for the hwtable.
Quite surprisingly, really, that no-one complained; the change has been=20
done in October 2005.

Anyway, this patch cleans it up. And also splits off the IBM DS6000 and=20
IBM SVC, as they are separate machines.

Please apply.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------030706010601030806080001
Content-Type: text/plain;
 name="multipath-tools-fixup-hwtable-regexp"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="multipath-tools-fixup-hwtable-regexp"

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index deb99e5..c395bf1 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -75,14 +75,14 @@ static struct hwentry default_hw[] = {
 		.checker_name  = HP_SW,
 	},
 	{
-		.vendor        = "{COMPAQ,HP}",
-		.product       = "{MSA,HSV}1*",
+		.vendor        = "(COMPAQ|HP)",
+		.product       = "(MSA|HSV)1.*",
 		.getuid        = DEFAULT_GETUID,
 		.getprio       = NULL,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = "1 hp_sw",
 		.selector      = DEFAULT_SELECTOR,
-		.pgpolicy      = GROUP_BY_SERIAL,
+		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
@@ -91,7 +91,7 @@ static struct hwentry default_hw[] = {
 	},
 	{
 		.vendor        = "HP",
-		.product       = "{HSV2*,A6189A}",
+		.product       = "(HSV2.*|A6189A)",
 		.getuid        = DEFAULT_GETUID,
 		.getprio       = NULL,
 		.features      = DEFAULT_FEATURES,
@@ -148,7 +148,7 @@ static struct hwentry default_hw[] = {
 	},
 	{
 		.vendor        = "DGC",
-		.product       = "*",
+		.product       = ".*",
 		.bl_product    = "LUNZ",
 		.getuid        = DEFAULT_GETUID,
 		.getprio       = "mpath_prio_emc /dev/%n",
@@ -190,8 +190,8 @@ static struct hwentry default_hw[] = {
 	 * Mail : matthias.rudolph@hds.com
 	 */
 	{
-		.vendor        = "{HITACHI,HP}",
-		.product       = "OPEN-*",
+		.vendor        = "(HITACHI|HP)",
+		.product       = "OPEN-.*",
 		.getuid        = DEFAULT_GETUID,
 		.getprio       = NULL,
 		.features      = DEFAULT_FEATURES,
@@ -206,9 +206,9 @@ static struct hwentry default_hw[] = {
 	},
 	{
 		.vendor        = "HITACHI",
-		.product       = "DF*",
+		.product       = "DF.*",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = "/sbin/mpath_prio_hds_modular %d",
+		.getprio       = "mpath_prio_hds_modular %d",
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -275,7 +291,7 @@ static struct hwentry default_hw[] = {
 	{
 		/* IBM ESS F20 aka Shark */
 		.vendor        = "IBM",
-		.product       = "2105{800,F20}",
+		.product       = "2105(800|F20)",
 		.getuid        = DEFAULT_GETUID,
 		.getprio       = NULL,
 		.features      = "1 queue_if_no_path",
@@ -289,9 +305,9 @@ static struct hwentry default_hw[] = {
 		.checker_name  = TUR,
 	},
 	{
-		/* IBM DS6000 / SAN Volume Controller */
+		/* IBM DS6000 */
 		.vendor        = "IBM",
-		.product       = "{1750500,2145}",
+		.product       = "1750500",
 		.getuid        = DEFAULT_GETUID,
 		.getprio       = "mpath_prio_alua /dev/%n",
 		.features      = "1 queue_if_no_path",
@@ -321,9 +337,26 @@ static struct hwentry default_hw[] = {
 		.checker_name  = TUR,
 	},
 	{
+		/* IBM SAN Volume Controller */
+		.vendor        = "IBM",
+		.product       = "2145",
+		.getuid        = DEFAULT_GETUID,
+		.getprio       = "mpath_prio_alua /dev/%n",
+		.features      = "1 queue_if_no_path",
+		.hwhandler     = DEFAULT_HWHANDLER,
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = NO_PATH_RETRY_UNDEF,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = TUR,
+	},
+	{
 		/* IBM S/390 ECKD DASD */
 		.vendor        = "IBM",
 		.product       = "S/390 DASD ECKD",
+		.bl_product       = "S/390.*",
 		.getuid        = "/sbin/dasd_id /dev/%n",
 		.getprio       = NULL,
 		.features      = DEFAULT_FEATURES,
@@ -464,7 +497,7 @@ static struct hwentry default_hw[] = {
 	 */
 	{
 		.vendor        = "SUN",
-		.product       = "{StorEdge 3510,T4}",
+		.product       = "(StorEdge 3510|T4)",
 		.getuid        = DEFAULT_GETUID,
 		.getprio       = NULL,
 		.features      = DEFAULT_FEATURES,

--------------030706010601030806080001
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------030706010601030806080001--
