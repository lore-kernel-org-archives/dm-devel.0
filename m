From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 6/6] libmultipath: don't print undefined values
Date: Thu, 29 Mar 2018 22:37:03 -0500
Message-ID: <1522381023-15262-7-git-send-email-bmarzins@redhat.com>
References: <1522381023-15262-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1522381023-15262-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

commit 48e9fd9f ("libmultipath: parser: use call-by-value for "snprint"
methods") removed some of the code that checked for undefined values to
avoid printing them.  This lead to device configurations that printed
out values for parameters that they hadn't configured. This patch adds
that code back in.

Fixes: 48e9fd9f ("libmultipath: parser: use call-by-value for "snprint" methods")
Cc: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/dict.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index ac9216c..1a18337 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -101,12 +101,16 @@ print_int (char *buff, int len, long v)
 static int
 print_nonzero (char *buff, int len, long v)
 {
+	if (!v)
+		return 0;
 	return snprintf(buff, len, "%li", v);
 }
 
 static int
 print_str (char *buff, int len, const char *ptr)
 {
+	if (!ptr)
+		return 0;
 	return snprintf(buff, len, "\"%s\"", ptr);
 }
 
@@ -120,6 +124,8 @@ print_yes_no (char *buff, int len, long v)
 static int
 print_yes_no_undef (char *buff, int len, long v)
 {
+	if (!v)
+		return 0;
 	return snprintf(buff, len, "\"%s\"",
 			(v == YNU_NO)? "no" : "yes");
 }
@@ -665,6 +671,8 @@ set_dev_loss(vector strvec, void *ptr)
 int
 print_dev_loss(char * buff, int len, unsigned long v)
 {
+	if (!v)
+		return 0;
 	if (v >= MAX_DEV_LOSS_TMO)
 		return snprintf(buff, len, "\"infinity\"");
 	return snprintf(buff, len, "%lu", v);
-- 
2.7.4
