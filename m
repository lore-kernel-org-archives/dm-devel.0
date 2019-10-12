From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 35/72] libmultipath:
 snprint_multipath_map_json(): remove unused argument
Date: Sat, 12 Oct 2019 21:28:20 +0000
Message-ID: <20191012212703.12989-36-martin.wilck@suse.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-1-martin.wilck@suse.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/print.c      | 4 ++--
 libmultipath/print.h      | 2 +-
 multipathd/cli_handlers.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 74c0d62d..8fa86267 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -1339,8 +1339,8 @@ snprint_multipath_fields_json (char * buff, int len,
 }
 
 int
-snprint_multipath_map_json (char * buff, int len,
-		const struct multipath * mpp, int last){
+snprint_multipath_map_json (char * buff, int len, const struct multipath * mpp)
+{
 	int fwd = 0;
 
 	fwd +=  snprint_json_header(buff, len);
diff --git a/libmultipath/print.h b/libmultipath/print.h
index 7e36ec63..0c909e75 100644
--- a/libmultipath/print.h
+++ b/libmultipath/print.h
@@ -125,7 +125,7 @@ char *snprint_config(const struct config *conf, int *len,
 		     const struct _vector *hwtable,
 		     const struct _vector *mpvec);
 int snprint_multipath_map_json (char * buff, int len,
-				const struct multipath * mpp, int last);
+				const struct multipath * mpp);
 int snprint_blacklist_report (struct config *, char *, int);
 int snprint_wildcards (char *, int);
 int snprint_status (char *, int, const struct vectors *);
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 8a899049..371b0a79 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -237,7 +237,7 @@ show_map_json (char ** r, int * len, struct multipath * mpp,
 
 		c = reply;
 
-		c += snprint_multipath_map_json(c, maxlen, mpp, 1);
+		c += snprint_multipath_map_json(c, maxlen, mpp);
 		again = ((c - reply) == maxlen);
 
 		REALLOC_REPLY(reply, again, maxlen);
-- 
2.23.0
