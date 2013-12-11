From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 10/16] kpartx: Make kpartx able to create
	read-only loop devices
Date: Wed, 11 Dec 2013 00:43:04 -0600
Message-ID: <1386744190-1295-11-git-send-email-bmarzins@redhat.com>
References: <1386744190-1295-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1386744190-1295-1-git-send-email-bmarzins@redhat.com>
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
Cc: Till Maas <opensource@till.name>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

This just passes the read-only value into set_loop, and falls back
to read-only mapping on EACCESS to handle immutable files.

Signed-off-by: Till Maas <opensource@till.name>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 kpartx/kpartx.c | 3 +--
 kpartx/lopart.c | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index 1369542..9a9a5eb 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -205,7 +205,6 @@ main(int argc, char **argv){
 	char * delim = NULL;
 	char *uuid = NULL;
 	char *mapname = NULL;
-	int loopro = 0;
 	int hotplug = 0;
 	int loopcreated = 0;
 	struct stat buf;
@@ -316,7 +315,7 @@ main(int argc, char **argv){
 		if (!loopdev) {
 			loopdev = find_unused_loop_device();
 
-			if (set_loop(loopdev, device, 0, &loopro)) {
+			if (set_loop(loopdev, device, 0, &ro)) {
 				fprintf(stderr, "can't set up loop\n");
 				exit (1);
 			}
diff --git a/kpartx/lopart.c b/kpartx/lopart.c
index 79a7593..9082ca8 100644
--- a/kpartx/lopart.c
+++ b/kpartx/lopart.c
@@ -230,7 +230,7 @@ set_loop (const char *device, const char *file, int offset, int *loopro)
 
 	if ((ffd = open (file, mode)) < 0) {
 
-		if (!*loopro && errno == EROFS)
+		if (!*loopro && (errno == EROFS || errno == EACCES))
 			ffd = open (file, mode = O_RDONLY);
 
 		if (ffd < 0) {
-- 
1.8.4.2
