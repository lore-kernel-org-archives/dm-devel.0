From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 06/28] libmultipath: change prototypes of
	hwe_regmatch() and find_hwe()
Date: Fri,  8 Jun 2018 12:20:19 +0200
Message-ID: <20180608102041.22904-7-mwilck@suse.com>
References: <20180608102041.22904-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180608102041.22904-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

hwentry structures are supposed to be initialized and destroyed
with alloc_hwe() and free_hwe(), respectively. The second
argument is of hwe_regmatch() isn't a real hwentry, just a
vendor/product/revision tuple. Clarify that by adapting the
prototype. This allows to use const arguments in find_hwe(), too.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.c | 30 +++++++++++++++---------------
 libmultipath/config.h |  4 +++-
 2 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 44f141ba..d2812e4a 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -64,7 +64,8 @@ find_hwe_strmatch (const struct _vector *hwtable, const struct hwentry *hwe)
 }
 
 static int
-hwe_regmatch (const struct hwentry *hwe1, const struct hwentry *hwe2)
+hwe_regmatch (const struct hwentry *hwe1, const char *vendor,
+	      const char *product, const char *revision)
 {
 	regex_t vre, pre, rre;
 	int retval = 1;
@@ -81,13 +82,13 @@ hwe_regmatch (const struct hwentry *hwe1, const struct hwentry *hwe2)
 	    regcomp(&rre, hwe1->revision, REG_EXTENDED|REG_NOSUB))
 		goto out_pre;
 
-	if ((hwe2->vendor || hwe2->product || hwe2->revision) &&
-	    (!hwe1->vendor || !hwe2->vendor ||
-	     !regexec(&vre, hwe2->vendor, 0, NULL, 0)) &&
-	    (!hwe1->product || !hwe2->product ||
-	     !regexec(&pre, hwe2->product, 0, NULL, 0)) &&
-	    (!hwe1->revision || !hwe2->revision ||
-	     !regexec(&rre, hwe2->revision, 0, NULL, 0)))
+	if ((vendor || product || revision) &&
+	    (!hwe1->vendor || !vendor ||
+	     !regexec(&vre, vendor, 0, NULL, 0)) &&
+	    (!hwe1->product || !product ||
+	     !regexec(&pre, product, 0, NULL, 0)) &&
+	    (!hwe1->revision || !revision ||
+	     !regexec(&rre, revision, 0, NULL, 0)))
 		retval = 0;
 
 	if (hwe1->revision)
@@ -103,14 +104,12 @@ out:
 }
 
 struct hwentry *
-find_hwe (vector hwtable, char * vendor, char * product, char * revision)
+find_hwe (const struct _vector *hwtable,
+	  const char * vendor, const char * product, const char * revision)
 {
 	int i;
-	struct hwentry hwe, *tmp, *ret = NULL;
+	struct hwentry *tmp, *ret = NULL;
 
-	hwe.vendor = vendor;
-	hwe.product = product;
-	hwe.revision = revision;
 	/*
 	 * Search backwards here.
 	 * User modified entries are attached at the end of
@@ -118,7 +117,7 @@ find_hwe (vector hwtable, char * vendor, char * product, char * revision)
 	 * continuing to the generic entries
 	 */
 	vector_foreach_slot_backwards (hwtable, tmp, i) {
-		if (hwe_regmatch(tmp, &hwe))
+		if (hwe_regmatch(tmp, vendor, product, revision))
 			continue;
 		ret = tmp;
 		break;
@@ -454,7 +453,8 @@ restart:
 				free_hwe(hwe2);
 				continue;
 			}
-			if (hwe_regmatch(hwe1, hwe2))
+			if (hwe_regmatch(hwe1, hwe2->vendor,
+					 hwe2->product, hwe2->revision))
 				continue;
 			/* dup */
 			merge_hwe(hwe2, hwe1);
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 6e69a37e..83eaf62f 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -213,7 +213,9 @@ struct config {
 
 extern struct udev * udev;
 
-struct hwentry * find_hwe (vector hwtable, char * vendor, char * product, char *revision);
+struct hwentry * find_hwe (const struct _vector *hwtable,
+			   const char * vendor, const char * product,
+			   const char *revision);
 struct mpentry * find_mpe (vector mptable, char * wwid);
 char * get_mpe_wwid (vector mptable, char * alias);
 
-- 
2.17.0
