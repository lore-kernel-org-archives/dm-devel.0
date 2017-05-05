From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 03/10] kpartx: remove is_loop_device
Date: Sat,  6 May 2017 00:05:52 +0200
Message-ID: <20170505220559.7248-4-mwilck@suse.com>
References: <20170505220559.7248-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170505220559.7248-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

This function is not used any more.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/lopart.c | 31 -------------------------------
 kpartx/lopart.h |  1 -
 2 files changed, 32 deletions(-)

diff --git a/kpartx/lopart.c b/kpartx/lopart.c
index 2eb3f631..44f0c277 100644
--- a/kpartx/lopart.c
+++ b/kpartx/lopart.c
@@ -62,37 +62,6 @@ xstrdup (const char *s)
 	return t;
 }
 
-int is_loop_device(const char *device)
-{
-	struct stat statbuf;
-	int loopmajor;
-#if 1
-	loopmajor = 7;
-#else
-	FILE *procdev;
-	char line[100], *cp;
-
-	loopmajor = 0;
-
-	if ((procdev = fopen(PROC_DEVICES, "r")) != NULL) {
-
-		while (fgets (line, sizeof(line), procdev)) {
-
-			if ((cp = strstr (line, " loop\n")) != NULL) {
-				*cp='\0';
-				loopmajor=atoi(line);
-				break;
-			}
-		}
-
-		fclose(procdev);
-	}
-#endif
-	return (loopmajor && stat(device, &statbuf) == 0 &&
-		S_ISBLK(statbuf.st_mode) &&
-		major(statbuf.st_rdev) == loopmajor);
-}
-
 #define SIZE(a) (sizeof(a)/sizeof(a[0]))
 
 char *find_loop_by_file(const char *filename)
diff --git a/kpartx/lopart.h b/kpartx/lopart.h
index a512353b..d3bad10a 100644
--- a/kpartx/lopart.h
+++ b/kpartx/lopart.h
@@ -1,6 +1,5 @@
 extern int verbose;
 extern int set_loop (const char *, const char *, int, int *);
 extern int del_loop (const char *);
-extern int is_loop_device (const char *);
 extern char * find_unused_loop_device (void);
 extern char * find_loop_by_file (const char *);
-- 
2.12.2
