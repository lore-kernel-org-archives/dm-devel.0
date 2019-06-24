From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 03/30] libmultipath: remove 'space' argument
	to merge_words()
Date: Mon, 24 Jun 2019 11:27:28 +0200
Message-ID: <20190624092756.7769-4-mwilck@suse.com>
References: <20190624092756.7769-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190624092756.7769-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

merge_words() is always called with space = 1. Remove the argument.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/dmparser.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index ac13ec06..04f675c1 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -18,12 +18,12 @@
 #define WORD_SIZE 64
 
 static int
-merge_words (char ** dst, char * word, int space)
+merge_words(char **dst, char *word)
 {
 	char * p = *dst;
 	int len;
 
-	len = strlen(*dst) + strlen(word) + space;
+	len = strlen(*dst) + strlen(word) + 1;
 	*dst = REALLOC(*dst, len + 1);
 
 	if (!*dst) {
@@ -36,11 +36,8 @@ merge_words (char ** dst, char * word, int space)
 	while (*p != '\0')
 		p++;
 
-	while (space) {
-		*p = ' ';
-		p++;
-		space--;
-	}
+	*p = ' ';
+	++p;
 	strncpy(p, word, strlen(word) + 1);
 
 	return 0;
@@ -163,7 +160,7 @@ int disassemble_map(vector pathvec, char *params, struct multipath *mpp,
 		if (!word)
 			return 1;
 
-		if (merge_words(&mpp->features, word, 1)) {
+		if (merge_words(&mpp->features, word)) {
 			FREE(word);
 			return 1;
 		}
@@ -187,7 +184,7 @@ int disassemble_map(vector pathvec, char *params, struct multipath *mpp,
 		if (!word)
 			return 1;
 
-		if (merge_words(&mpp->hwhandler, word, 1)) {
+		if (merge_words(&mpp->hwhandler, word)) {
 			FREE(word);
 			return 1;
 		}
@@ -248,9 +245,8 @@ int disassemble_map(vector pathvec, char *params, struct multipath *mpp,
 
 			num_pg_args = atoi(word);
 
-			if (merge_words(&mpp->selector, word, 1)) {
+			if (merge_words(&mpp->selector, word))
 				goto out1;
-			}
 			FREE(word);
 		} else {
 			p += get_word(p, NULL);
-- 
2.21.0
