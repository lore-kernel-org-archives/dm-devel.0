From: Ritesh Raj Sarraf <rrs@debian.org>
Subject: [PATCH 1/2] Increase number of retries
Date: Fri, 15 May 2015 15:17:46 +0530
Message-ID: <1431683267-16155-1-git-send-email-rrs@debian.org>
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
Cc: Ritesh Raj Sarraf <rrs@debian.org>
List-Id: dm-devel.ids

There have been 3 bug reports so far, that claim increasing the number
of retries allows clean up of loop device

https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=785251
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=734794
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=608737

I can't be sure if this is the ideal number of retries, but for many
users it seems to have solved the error

Signed-off-by: Ritesh Raj Sarraf <rrs@debian.org>
---
 kpartx/lopart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kpartx/lopart.c b/kpartx/lopart.c
index 6f83048..fc1ff85 100644
--- a/kpartx/lopart.c
+++ b/kpartx/lopart.c
@@ -288,7 +288,7 @@ set_loop (const char *device, const char *file, int offset, int *loopro)
 extern int 
 del_loop (const char *device)
 {
-	int retries = 3;
+	int retries = 5;
 	int fd;
 
 	if ((fd = open (device, O_RDONLY)) < 0) {
-- 
2.1.4
