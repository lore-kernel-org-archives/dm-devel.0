From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 5/6] libmultipath: config parser: fix corner case
	for double quotes
Date: Tue,  6 Mar 2018 23:56:32 +0100
Message-ID: <20180306225633.12028-6-mwilck@suse.com>
References: <20180306225633.12028-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180306225633.12028-1-mwilck@suse.com>
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

A corner case of the previous patch are strings starting with a double quote,
such as '"prepended to itself is false" prepended to itself is false' or
'"" is the empty string', and in particular, the string '"' ("\"" in C
notation), which is indistinguishable from the "QUOTE" token in the parsed strvec.

This patch fixes that by introducing a special token that can't occur as part
of a normal string to indicate the beginning and end of a quoted string.

'"' is admittedly not a very likely keyword value for multipath.conf, but
a) this is a matter of correctness, b) we didn't think of '2.5"' before, either, and
c) the (*str != '"') expressions would need to be patched anyway to fix the
'string starting with "' case.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/parser.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/libmultipath/parser.c b/libmultipath/parser.c
index 592269a9b5b1..da8de305f680 100644
--- a/libmultipath/parser.c
+++ b/libmultipath/parser.c
@@ -186,6 +186,12 @@ snprint_keyword(char *buff, int len, char *fmt, struct keyword *kw,
 	return fwd;
 }
 
+static const char quote_marker[] = { '\0', '"', '\0' };
+static bool is_quote(const char* token)
+{
+	return !memcmp(token, quote_marker, sizeof(quote_marker));
+}
+
 vector
 alloc_strvec(char *string)
 {
@@ -225,17 +231,13 @@ alloc_strvec(char *string)
 		start = cp;
 		if (!in_string && *cp == '"') {
 			cp++;
-			token = MALLOC(2);
+			token = MALLOC(sizeof(quote_marker));
 
 			if (!token)
 				goto out;
 
-			*(token) = '"';
-			*(token + 1) = '\0';
-			if (in_string)
-				in_string = 0;
-			else
-				in_string = 1;
+			memcpy(token, quote_marker, sizeof(quote_marker));
+			in_string = 1;
 		} else if (!in_string && (*cp == '{' || *cp == '}')) {
 			token = MALLOC(2);
 
@@ -324,13 +326,13 @@ set_value(vector strvec)
 			(char *)VECTOR_SLOT(strvec, 0));
 		return NULL;
 	}
-	size = strlen(str);
-	if (size == 0) {
-		condlog(0, "option '%s' has empty value",
-			(char *)VECTOR_SLOT(strvec, 0));
-		return NULL;
-	}
-	if (*str != '"') {
+	if (!is_quote(str)) {
+		size = strlen(str);
+		if (size == 0) {
+			condlog(0, "option '%s' has empty value",
+				(char *)VECTOR_SLOT(strvec, 0));
+			return NULL;
+		}
 		alloc = MALLOC(sizeof (char) * (size + 1));
 		if (alloc)
 			memcpy(alloc, str, size);
@@ -354,7 +356,7 @@ set_value(vector strvec)
 				(char *)VECTOR_SLOT(strvec, 0));
 			return NULL;
 		}
-		if (*str == '"')
+		if (is_quote(str))
 			break;
 		tmp = alloc;
 		/* The first +1 is for the NULL byte. The rest are for the
@@ -460,7 +462,7 @@ validate_config_strvec(vector strvec, char *file)
 			(char *)VECTOR_SLOT(strvec, 0), line_nr, file);
 		return -1;
 	}
-	if (*str != '"') {
+	if (!is_quote(str)) {
 		if (VECTOR_SIZE(strvec) > 2)
 			condlog(0, "ignoring extra data starting with '%s' on line %d of %s", (char *)VECTOR_SLOT(strvec, 2), line_nr, file);
 		return 0;
@@ -472,7 +474,7 @@ validate_config_strvec(vector strvec, char *file)
 				line_nr, file);
 			return -1;
 		}
-		if (*str == '"') {
+		if (is_quote(str)) {
 			if (VECTOR_SIZE(strvec) > i + 1)
 				condlog(0, "ignoring extra data starting with '%s' on line %d of %s", (char *)VECTOR_SLOT(strvec, (i + 1)), line_nr, file);
 			return 0;
-- 
2.16.1
