From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 3/5] libmultipath: config parser: Allow '"' in
	strings
Date: Thu,  8 Mar 2018 00:26:18 +0100
Message-ID: <20180307232620.15746-4-mwilck@suse.com>
References: <20180307232620.15746-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180307232620.15746-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

We have seen model strings lile '2.5" SSD' which can't be parsed
by the current config parser. This patch fixes this by allowing
'""' to represent a double quote character inside a a string.
The above model string could now be entered in the config file like this:

blacklist {
	  vendor SomeCorp
	  product "2.5"" SSD"
}

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/parser.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/libmultipath/parser.c b/libmultipath/parser.c
index 3d9656f47945..21151a16ad74 100644
--- a/libmultipath/parser.c
+++ b/libmultipath/parser.c
@@ -219,11 +219,13 @@ alloc_strvec(char *string)
 
 	in_string = 0;
 	while (1) {
+		int two_quotes = 0;
+
 		if (!vector_alloc_slot(strvec))
 			goto out;
 
 		start = cp;
-		if (*cp == '"') {
+		if (*cp == '"' && !(in_string && *(cp + 1) == '"')) {
 			cp++;
 			token = MALLOC(2);
 
@@ -246,11 +248,23 @@ alloc_strvec(char *string)
 			*(token + 1) = '\0';
 			cp++;
 		} else {
+
+		move_on:
 			while ((in_string ||
 				(!isspace((int) *cp) && isascii((int) *cp) &&
 				 *cp != '!' && *cp != '#' && *cp != '{' &&
 				 *cp != '}')) && *cp != '\0' && *cp != '"')
 				cp++;
+
+			/* Two consecutive double quotes - don't end string */
+			if (in_string && *cp == '"') {
+				if (*(cp + 1) == '"') {
+					two_quotes = 1;
+					cp += 2;
+					goto move_on;
+				}
+			}
+
 			strlen = cp - start;
 			token = MALLOC(strlen + 1);
 
@@ -259,6 +273,16 @@ alloc_strvec(char *string)
 
 			memcpy(token, start, strlen);
 			*(token + strlen) = '\0';
+
+			/* Replace "" by " */
+			if (two_quotes) {
+				char *qq = strstr(token, "\"\"");
+				while (qq != NULL) {
+					memmove(qq + 1, qq + 2,
+						strlen + 1 - (qq + 2 - token));
+					qq = strstr(qq + 1, "\"\"");
+				}
+			}
 		}
 		vector_set_slot(strvec, token);
 
-- 
2.16.1
