From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 5/6] kpartx: fix device checks
Date: Tue,  9 May 2017 11:57:04 -0500
Message-ID: <1494349025-6561-6-git-send-email-bmarzins@redhat.com>
References: <1494349025-6561-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1494349025-6561-1-git-send-email-bmarzins@redhat.com>
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
List-Id: dm-devel.ids

There are a number of issues in the the kpartx device checking code.
First, it accepts files that are neither regular files or a block device
nodes (you can run kpartx on character devices or directories, and it
will treat them as block devices). When trying to figure out the
basename of a device, the code returns garbage if the path doesn't
include a '/'. Finally, the set_delimiter code can access memory outside
of the string if an empty string is passed in.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 kpartx/kpartx.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index cc7e2e7..a1af156 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -135,10 +135,13 @@ set_delimiter (char * device, char * delimiter)
 {
 	char * p = device;
 
-	while (*(p++) != 0x0)
+	if (*p == 0x0)
+		return;
+
+	while (*(++p) != 0x0)
 		continue;
 
-	if (isdigit(*(p - 2)))
+	if (isdigit(*(p - 1)))
 		*delimiter = 'p';
 }
 
@@ -157,15 +160,17 @@ strip_slash (char * device)
 static int
 find_devname_offset (char * device)
 {
-	char *p, *q = NULL;
+	char *p, *q;
 
-	p = device;
+	q = p = device;
 
-	while (*p++)
+	while (*p) {
 		if (*p == '/')
-			q = p;
+			q = p + 1;
+		p++;
+	}
 
-	return (int)(q - device) + 1;
+	return (int)(q - device);
 }
 
 static char *
@@ -381,6 +386,10 @@ main(int argc, char **argv){
 			exit (1);
 		}
 	}
+	else if (!S_ISBLK(buf.st_mode)) {
+		fprintf(stderr, "invalid device: %s\n", device);
+		exit(1);
+	}
 
 	off = find_devname_offset(device);
 
-- 
1.8.3.1
