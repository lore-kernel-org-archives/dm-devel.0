From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/3] Implement 'revision' matching
Date: Thu, 09 Nov 2006 11:31:09 +0100
Message-ID: <4553036D.8030409@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070802050607040509060703"
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
--------------070802050607040509060703
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

This patch implements a 'revision' field for the hardware table.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------070802050607040509060703
Content-Type: text/plain;
	name*0="0002-libmultipath-Add-support-for-matching-against-revision-fiel";
	name*1="d.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename*0="0002-libmultipath-Add-support-for-matching-against-revision-";
	filename*1="field.txt"

[libmultipath] Add support for matching against revision field

The standard SCSI inquiry data provides for a field 'revision' whic
specifies the software revision of the device. Some vendors changed
the behaviour during software releases so it's desireable that we
can match on that field in the hardware table, too.

Signed-off-by: Hannes Reinecke <hare@suse.de>

---

 libmultipath/config.c    |   40 ++++++++++++++++++++++++++++++----------
 libmultipath/config.h    |    3 ++-
 libmultipath/discovery.c |    4 ++--
 3 files changed, 34 insertions(+), 13 deletions(-)

c40e7e72592eca6ed54e6aee5861fcfbee059f2f
diff --git a/libmultipath/config.c b/libmultipath/config.c
index 2f07792..1da525a 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -21,7 +21,7 @@ #include "blacklist.h"
 #include "defaults.h"
 
 static struct hwentry *
-find_hwe_strmatch (vector hwtable, char * vendor, char * product)
+find_hwe_strmatch (vector hwtable, char * vendor, char * product, char * revision)
 {
 	int i;
 	struct hwentry *hwe, *ret = NULL;
@@ -33,6 +33,9 @@ find_hwe_strmatch (vector hwtable, char 
 		if (hwe->product && product && strcmp(hwe->product, product))
 			continue;
 
+		if (hwe->revision && revision && strcmp(hwe->revision, revision))
+			continue;
+
 		ret = hwe;
 		break;
 	}
@@ -40,11 +43,11 @@ find_hwe_strmatch (vector hwtable, char 
 }
 
 struct hwentry *
-find_hwe (vector hwtable, char * vendor, char * product)
+find_hwe (vector hwtable, char * vendor, char * product, char * revision)
 {
 	int i;
 	struct hwentry *hwe, *ret = NULL;
-	regex_t vre, pre;
+	regex_t vre, pre, rre;
 
 	vector_foreach_slot (hwtable, hwe, i) {
 		if (hwe->vendor &&
@@ -55,12 +58,23 @@ find_hwe (vector hwtable, char * vendor,
 			regfree(&vre);
 			break;
 		}
+		if (hwe->revision &&
+		    regcomp(&rre, hwe->revision, REG_EXTENDED|REG_NOSUB)) {
+			regfree(&vre);
+			regfree(&pre);
+			break;
+		}
 		if ((!hwe->vendor || !regexec(&vre, vendor, 0, NULL, 0)) &&
-		    (!hwe->product || !regexec(&pre, product, 0, NULL, 0)))
+		    (!hwe->product || !regexec(&pre, product, 0, NULL, 0)) &&
+		    (!hwe->revision || !regexec(&rre, revision, 0, NULL, 0)))
 			ret = hwe;
-		
-		regfree(&pre);
-		regfree(&vre);
+
+		if (hwe->revision)
+			regfree(&rre);
+		if (hwe->product)
+			regfree(&pre);
+		if (hwe->vendor)
+			regfree(&vre);
 
 		if (ret)
 			break;
@@ -112,6 +126,9 @@ free_hwe (struct hwentry * hwe)
 	if (hwe->product)
 		FREE(hwe->product);
 
+	if (hwe->revision)
+		FREE(hwe->revision);
+
 	if (hwe->selector)
 		FREE(hwe->selector);
 
@@ -226,9 +243,9 @@ set_param_str(char * str)
 }
 
 static int
-dup_hwe (vector hwtable, char * vendor, char * product)
+dup_hwe (vector hwtable, char * vendor, char * product, char * revision)
 {
-	struct hwentry * hwe = find_hwe(hwtable, vendor, product);
+	struct hwentry * hwe = find_hwe(hwtable, vendor, product, revision);
 
 	if (hwe)
 		return 1;
@@ -241,7 +258,7 @@ store_hwe (vector hwtable, struct hwentr
 {
 	struct hwentry * hwe;
 
-	if (find_hwe_strmatch(hwtable, dhwe->vendor, dhwe->product))
+	if (find_hwe_strmatch(hwtable, dhwe->vendor, dhwe->product, dhwe->revision))
 		return 0;
 	
 	if (!(hwe = alloc_hwe()))
@@ -253,6 +270,9 @@ store_hwe (vector hwtable, struct hwentr
 	if (!dhwe->product || !(hwe->product = set_param_str(dhwe->product)))
 		goto out;
 	
+	if (dhwe->revision && !(hwe->revision = set_param_str(dhwe->revision)))
+		goto out;
+	
 	if (dhwe->getuid && !(hwe->getuid = set_param_str(dhwe->getuid)))
 		goto out;
 
diff --git a/libmultipath/config.h b/libmultipath/config.h
index ca022c5..0c3b640 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -11,6 +11,7 @@ enum devtypes {
 struct hwentry {
 	char * vendor;
 	char * product;
+	char * revision;
 	char * getuid;
 	char * getprio;
 	char * features;
@@ -78,7 +79,7 @@ struct config {
 
 struct config * conf;
 
-struct hwentry * find_hwe (vector hwtable, char * vendor, char * product);
+struct hwentry * find_hwe (vector hwtable, char * vendor, char * product, char *revision);
 struct mpentry * find_mpe (char * wwid);
 char * get_mpe_wwid (char * alias);
 
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index efc2016..65a093f 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -442,7 +442,7 @@ scsi_sysfs_pathinfo (struct path * pp)
 	/*
 	 * set the hwe configlet pointer
 	 */
-	pp->hwe = find_hwe(conf->hwtable, pp->vendor_id, pp->product_id);
+	pp->hwe = find_hwe(conf->hwtable, pp->vendor_id, pp->product_id, pp->rev);
 
 	/*
 	 * host / bus / target / lun
@@ -526,7 +526,7 @@ ccw_sysfs_pathinfo (struct path * pp)
 	/*
 	 * set the hwe configlet pointer
 	 */
-	pp->hwe = find_hwe(conf->hwtable, pp->vendor_id, pp->product_id);
+	pp->hwe = find_hwe(conf->hwtable, pp->vendor_id, pp->product_id, NULL);
 
 	/*
 	 * host / bus / target / lun
-- 
1.3.1


--------------070802050607040509060703
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------070802050607040509060703--
