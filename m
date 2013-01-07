From: Phillip Susi <psusi@ubuntu.com>
Subject: [PATCH] Don't add 'p' delimiter when you shouldn't
Date: Mon,  7 Jan 2013 14:56:21 -0500
Message-ID: <1357588581-29831-1-git-send-email-psusi@ubuntu.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
Cc: Phillip Susi <psusi@ubuntu.com>
List-Id: dm-devel.ids

The 'p' delimiter is supposed to be added when the base disk name ends
in a digit.  This decision was based on the name given on the command
line, not the canonical device name, so giving /dev/dm-0 instead of
/dev/mapper/foo triggered the digit test and added the 'p'.  Changed
test to use the canonical name rather than the given name.

Signed-off-by: Phillip Susi <psusi@ubuntu.com>
---
 kpartx/kpartx.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index 0711450..08f3407 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -323,12 +323,6 @@ main(int argc, char **argv){
 		device = loopdev;
 	}
 
-	if (delim == NULL) {
-		delim = malloc(DELIM_SIZE);
-		memset(delim, 0, DELIM_SIZE);
-		set_delimiter(device, delim);
-	}
-
 	off = find_devname_offset(device);
 
 	if (!loopdev) {
@@ -350,6 +344,12 @@ main(int argc, char **argv){
 		return 0;
 	}
 
+	if (delim == NULL) {
+		delim = malloc(DELIM_SIZE);
+		memset(delim, 0, DELIM_SIZE);
+		set_delimiter(mapname, delim);
+	}
+
 	fd = open(device, O_RDONLY);
 
 	if (fd == -1) {
-- 
1.7.9.5
