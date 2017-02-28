From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 08/33] libmultipath: Do not crash on empty
	features
Date: Tue, 28 Feb 2017 17:23:04 +0100
Message-ID: <20170228162329.14517-9-mwilck@suse.com>
References: <20170228162329.14517-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170228162329.14517-1-mwilck@suse.com>
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
List-Id: dm-devel.ids

From: Hannes Reinecke <hare@suse.de>

When adding to an otherwise empty feature list multipath would
crash as it doesn't check for an empty feature list.


Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/structs.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index f36a0552..4419510d 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -506,7 +506,7 @@ void setup_feature(struct multipath *mpp, char *feature)
 
 int add_feature(char **f, char *n)
 {
-	int c = 0, d, l;
+	int c = 0, d, l = 0;
 	char *e, *p, *t;
 
 	if (!f)
@@ -528,18 +528,19 @@ int add_feature(char **f, char *n)
 	}
 
 	/* Check if feature is already present */
-	if (strstr(*f, n))
-		return 0;
-
-	/* Get feature count */
-	c = strtoul(*f, &e, 10);
-	if (*f == e)
-		/* parse error */
-		return 1;
-
-	/* Check if we need to increase feature count space */
-	l = strlen(*f) + strlen(n) + 1;
+	if (*f) {
+		if (strstr(*f, n))
+			return 0;
+
+		/* Get feature count */
+		c = strtoul(*f, &e, 10);
+		if (*f == e)
+			/* parse error */
+			return 1;
 
+		/* Check if we need to increase feature count space */
+		l = strlen(*f) + strlen(n) + 1;
+	}
 	/* Count new features */
 	if ((c % 10) == 9)
 		l++;
@@ -571,7 +572,10 @@ int add_feature(char **f, char *n)
 	snprintf(p, l + 2, "%0d ", c);
 
 	/* Copy the feature string */
-	p = strchr(*f, ' ');
+	p = NULL;
+	if (*f)
+		p = strchr(*f, ' ');
+
 	if (p) {
 		while (*p == ' ')
 			p++;
-- 
2.11.0
