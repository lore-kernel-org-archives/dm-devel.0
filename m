From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 2/8] libmultipath: add/remove_feature: use
	const char* for feature
Date: Tue, 20 Jun 2017 13:46:08 +0200
Message-ID: <20170620114614.26261-3-mwilck@suse.com>
References: <20170620114614.26261-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170620114614.26261-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Change the argument type for the feature to add or remove to
const char*, making it possible to pass const strings without
warnings.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs.c | 30 ++++++++++++++++--------------
 libmultipath/structs.h |  4 ++--
 2 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index e225f8b4..28704676 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -513,10 +513,11 @@ void setup_feature(struct multipath *mpp, char *feature)
 	}
 }
 
-int add_feature(char **f, char *n)
+int add_feature(char **f, const char *n)
 {
 	int c = 0, d, l = 0;
 	char *e, *p, *t;
+	const char *q;
 
 	if (!f)
 		return 1;
@@ -554,14 +555,14 @@ int add_feature(char **f, char *n)
 	if ((c % 10) == 9)
 		l++;
 	c++;
-	p = n;
-	while (*p != '\0') {
-		if (*p == ' ' && p[1] != '\0' && p[1] != ' ') {
+	q = n;
+	while (*q != '\0') {
+		if (*q == ' ' && q[1] != '\0' && q[1] != ' ') {
 			if ((c % 10) == 9)
 				l++;
 			c++;
 		}
-		p++;
+		q++;
 	}
 
 	t = MALLOC(l + 1);
@@ -601,10 +602,11 @@ int add_feature(char **f, char *n)
 	return 0;
 }
 
-int remove_feature(char **f, char *o)
+int remove_feature(char **f, const char *o)
 {
 	int c = 0, d, l;
 	char *e, *p, *n;
+	const char *q;
 
 	if (!f || !*f)
 		return 1;
@@ -630,18 +632,18 @@ int remove_feature(char **f, char *o)
 	/* Just spaces, return */
 	if (*o == '\0')
 		return 0;
-	e = o + strlen(o);
-	while (*e == ' ')
-		e--;
-	d = (int)(e - o);
+	q = o + strlen(o);
+	while (*q == ' ')
+		q--;
+	d = (int)(q - o);
 
 	/* Update feature count */
 	c--;
-	p = o;
-	while (p[0] != '\0') {
-		if (p[0] == ' ' && p[1] != ' ' && p[1] != '\0')
+	q = o;
+	while (q[0] != '\0') {
+		if (q[0] == ' ' && q[1] != ' ' && q[1] != '\0')
 			c--;
-		p++;
+		q++;
 	}
 
 	/* Quick exit if all features have been removed */
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 01e031ad..8ea984d9 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -369,8 +369,8 @@ int pathcountgr (struct pathgroup *, int);
 int pathcount (struct multipath *, int);
 int pathcmp (struct pathgroup *, struct pathgroup *);
 void setup_feature(struct multipath *, char *);
-int add_feature (char **, char *);
-int remove_feature (char **, char *);
+int add_feature (char **, const char *);
+int remove_feature (char **, const char *);
 
 extern char sysfs_path[PATH_SIZE];
 
-- 
2.13.1
