From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 48/72] libmultipath: print: use unsigned int for
	"width" field
Date: Sat, 12 Oct 2019 21:28:36 +0000
Message-ID: <20191012212703.12989-49-martin.wilck@suse.com>
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
 libmultipath/print.c | 4 ++--
 libmultipath/print.h | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 8fa86267..b98e9bda 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -36,7 +36,7 @@
 #define NOPAD    s = c
 #define PAD(x) \
 do { \
-	while ((int)(c - s) < (x) && (c < (line + len - 1))) \
+	while (c < (s + x) && (c < (line + len - 1))) \
 		*c++ = ' '; \
 	s = c; \
 } while (0)
@@ -783,7 +783,7 @@ get_path_layout(vector pathvec, int header)
 }
 
 static void
-reset_width(int *width, enum layout_reset reset, const char *header)
+reset_width(unsigned int *width, enum layout_reset reset, const char *header)
 {
 	switch (reset) {
 	case LAYOUT_RESET_HEADER:
diff --git a/libmultipath/print.h b/libmultipath/print.h
index 0c909e75..e8260d03 100644
--- a/libmultipath/print.h
+++ b/libmultipath/print.h
@@ -78,21 +78,21 @@
 struct path_data {
 	char wildcard;
 	char * header;
-	int width;
+	unsigned int width;
 	int (*snprint)(char * buff, size_t len, const struct path * pp);
 };
 
 struct multipath_data {
 	char wildcard;
 	char * header;
-	int width;
+	unsigned int width;
 	int (*snprint)(char * buff, size_t len, const struct multipath * mpp);
 };
 
 struct pathgroup_data {
 	char wildcard;
 	char * header;
-	int width;
+	unsigned int width;
 	int (*snprint)(char * buff, size_t len, const struct pathgroup * pgp);
 };
 
-- 
2.23.0
