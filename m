From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 11/28] libmultipath: add debug messages to
	hwentry lookup/merging code
Date: Fri,  8 Jun 2018 12:20:24 +0200
Message-ID: <20180608102041.22904-12-mwilck@suse.com>
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

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index d2812e4a..9e2f166f 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -103,6 +103,16 @@ out:
 	return retval;
 }
 
+static void _log_match(const char *fn, const struct hwentry *h,
+		       const char *vendor, const char *product,
+		       const char *revision)
+{
+	condlog(4, "%s: found match /%s:%s:%s/ for '%s:%s:%s'", fn,
+		h->vendor, h->product, h->revision,
+		vendor, product, revision);
+}
+#define log_match(h, v, p, r) _log_match(__func__, (h), (v), (p), (r))
+
 struct hwentry *
 find_hwe (const struct _vector *hwtable,
 	  const char * vendor, const char * product, const char * revision)
@@ -120,6 +130,7 @@ find_hwe (const struct _vector *hwtable,
 		if (hwe_regmatch(tmp, vendor, product, revision))
 			continue;
 		ret = tmp;
+		log_match(tmp, vendor, product, revision);
 		break;
 	}
 	return ret;
@@ -457,8 +468,13 @@ restart:
 					 hwe2->product, hwe2->revision))
 				continue;
 			/* dup */
+			log_match(hwe1, hwe2->vendor,
+				  hwe2->product, hwe2->revision);
 			merge_hwe(hwe2, hwe1);
 			if (hwe_strmatch(hwe2, hwe1) == 0) {
+				condlog(4, "%s: removing hwentry %s:%s:%s",
+					__func__, hwe1->vendor, hwe1->product,
+					hwe1->revision);
 				vector_del_slot(hw, i);
 				free_hwe(hwe1);
 				n -= 1;
-- 
2.17.0
