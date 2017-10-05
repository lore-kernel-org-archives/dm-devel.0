From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 1/1] limbultipath: prefer RDAC checker with
	detect_checker
Date: Thu,  5 Oct 2017 22:25:51 +0200
Message-ID: <20171005202551.10719-2-mwilck@suse.com>
References: <20170925164924.GX3145@octiron.msp.redhat.com>
	<20171005202551.10719-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20171005202551.10719-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Martin Wilck <mwilck@suse.de>, dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

With "detect_checker yes", ALUA is used for all storage devices
that support ALUA. But currently RDAC is still preferred for RDAC
devices
(https://www.redhat.com/archives/dm-devel/2017-September/msg00326.html)

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/propsel.c | 52 +++++++++++++++++++++++++++++---------------------
 1 file changed, 30 insertions(+), 22 deletions(-)

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 00adc0da4cb1..4a7e3811d21c 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -367,16 +367,42 @@ out:
 	return 0;
 }
 
+/*
+ * Current RDAC (NetApp E-Series) firmware relies
+ * on periodic REPORT TARGET PORT GROUPS for
+ * internal load balancing.
+ * Using the sysfs priority checker defeats this purpose.
+ *
+ * Moreover, NetApp would also prefer the RDAC checker over ALUA.
+ * (https://www.redhat.com/archives/dm-devel/2017-September/msg00326.html)
+ */
+static int
+check_rdac(struct path * pp)
+{
+	int len;
+	char buff[44];
+
+	len = get_vpd_sgio(pp->fd, 0xC9, buff, 44);
+	if (len <= 0)
+		return 0;
+	return !(memcmp(buff + 4, "vac1", 4));
+}
+
 int select_checker(struct config *conf, struct path *pp)
 {
 	char *origin, *checker_name;
 	struct checker * c = &pp->checker;
 
-	if (pp->detect_checker == DETECT_CHECKER_ON && pp->tpgs > 0) {
-		checker_name = TUR;
+	if (pp->detect_checker == DETECT_CHECKER_ON) {
 		origin = "(setting: storage device autodetected)";
-		goto out;
-	}
+		if (check_rdac(pp)) {
+			checker_name = RDAC;
+			goto out;
+		} else if (pp->tpgs > 0) {
+			checker_name = TUR;
+			goto out;
+		}
+ 	}
 	do_set(checker_name, conf->overrides, checker_name, "(setting: multipath.conf overrides section)");
 	do_set(checker_name, pp->hwe, checker_name, "(setting: storage device configuration)");
 	do_set(checker_name, conf, checker_name, "(setting: multipath.conf defaults/devices section)");
@@ -427,24 +453,6 @@ out:
 	return 0;
 }
 
-/*
- * Current RDAC (NetApp E-Series) firmware relies
- * on periodic REPORT TARGET PORT GROUPS for
- * internal load balancing.
- * Using the sysfs priority checker defeats this purpose.
- */
-static int
-check_rdac(struct path * pp)
-{
-	int len;
-	char buff[44];
-
-	len = get_vpd_sgio(pp->fd, 0xC9, buff, 44);
-	if (len <= 0)
-		return 0;
-	return !(memcmp(buff + 4, "vac1", 4));
-}
-
 void
 detect_prio(struct config *conf, struct path * pp)
 {
-- 
2.14.2
