From: Gris Ge <fge@redhat.com>
Subject: [PATCH] Multipath: Remove duplicated memset() for
	multipathd show command.
Date: Wed, 15 Jun 2016 22:50:38 +0800
Message-ID: <20160615145038.10249-1-fge@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Gris Ge <fge@redhat.com>
List-Id: dm-devel.ids

Problem:

 * The duplicated memset() wasted too much time. For example:
   with 5k paths, "sudo multipathd -k'show paths'" command will have
   at least 5k times of memset().

Reasons:

 * The memory passing to snprint_xxx(e.g. snprint_multipath) is already
   zeroed by MALLOC().

 * No need to zero memory before snprintf which will always terminate
   the string with '\0'.

Signed-off-by: Gris Ge <fge@redhat.com>
---
 libmultipath/print.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 2d159ed..e3c14b6 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -782,8 +782,6 @@ snprint_multipath_header (char * line, int len, char * format)
 	int fwd;
 	struct multipath_data * data;
 
-	memset(line, 0, len);
-
 	do {
 		if (!TAIL)
 			break;
@@ -817,8 +815,6 @@ snprint_multipath (char * line, int len, char * format,
 	struct multipath_data * data;
 	char buff[MAX_FIELD_LEN] = {};
 
-	memset(line, 0, len);
-
 	do {
 		if (!TAIL)
 			break;
@@ -853,8 +849,6 @@ snprint_path_header (char * line, int len, char * format)
 	int fwd;
 	struct path_data * data;
 
-	memset(line, 0, len);
-
 	do {
 		if (!TAIL)
 			break;
@@ -888,8 +882,6 @@ snprint_path (char * line, int len, char * format,
 	struct path_data * data;
 	char buff[MAX_FIELD_LEN];
 
-	memset(line, 0, len);
-
 	do {
 		if (!TAIL)
 			break;
@@ -925,8 +917,6 @@ snprint_pathgroup (char * line, int len, char * format,
 	struct pathgroup_data * data;
 	char buff[MAX_FIELD_LEN];
 
-	memset(line, 0, len);
-
 	do {
 		if (!TAIL)
 			break;
-- 
2.8.3
