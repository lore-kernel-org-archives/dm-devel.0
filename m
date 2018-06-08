From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 05/28] libmultipath: some const usage in hwentry
	handling
Date: Fri,  8 Jun 2018 12:20:18 +0200
Message-ID: <20180608102041.22904-6-mwilck@suse.com>
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

Add some const qualifiers in in the code dealing with hwentries.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/blacklist.c | 6 ++++--
 libmultipath/config.c    | 8 ++++----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
index ee396e26..34a7e717 100644
--- a/libmultipath/blacklist.c
+++ b/libmultipath/blacklist.c
@@ -126,7 +126,8 @@ _blacklist (vector blist, const char * str)
 }
 
 int
-_blacklist_exceptions_device(vector elist, char * vendor, char * product)
+_blacklist_exceptions_device(const struct _vector *elist, const char * vendor,
+			     const char * product)
 {
 	int i;
 	struct blentry_device * ble;
@@ -144,7 +145,8 @@ _blacklist_exceptions_device(vector elist, char * vendor, char * product)
 }
 
 int
-_blacklist_device (vector blist, char * vendor, char * product)
+_blacklist_device (const struct _vector *blist, const char * vendor,
+		   const char * product)
 {
 	int i;
 	struct blentry_device * ble;
diff --git a/libmultipath/config.c b/libmultipath/config.c
index ce7bedac..44f141ba 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -28,7 +28,7 @@
 #include "propsel.h"
 
 static int
-hwe_strmatch (struct hwentry *hwe1, struct hwentry *hwe2)
+hwe_strmatch (const struct hwentry *hwe1, const struct hwentry *hwe2)
 {
 	if ((hwe2->vendor && !hwe1->vendor) ||
 	    (hwe1->vendor && (!hwe2->vendor ||
@@ -49,7 +49,7 @@ hwe_strmatch (struct hwentry *hwe1, struct hwentry *hwe2)
 }
 
 static struct hwentry *
-find_hwe_strmatch (vector hwtable, struct hwentry *hwe)
+find_hwe_strmatch (const struct _vector *hwtable, const struct hwentry *hwe)
 {
 	int i;
 	struct hwentry *tmp, *ret = NULL;
@@ -64,7 +64,7 @@ find_hwe_strmatch (vector hwtable, struct hwentry *hwe)
 }
 
 static int
-hwe_regmatch (struct hwentry *hwe1, struct hwentry *hwe2)
+hwe_regmatch (const struct hwentry *hwe1, const struct hwentry *hwe2)
 {
 	regex_t vre, pre, rre;
 	int retval = 1;
@@ -283,7 +283,7 @@ alloc_hwe (void)
 }
 
 static char *
-set_param_str(char * str)
+set_param_str(const char * str)
 {
 	char * dst;
 	int len;
-- 
2.17.0
