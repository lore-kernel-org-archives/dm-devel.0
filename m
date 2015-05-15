From: Ritesh Raj Sarraf <rrs@debian.org>
Subject: [PATCH 2/2] Display error when we fail to delete device
Date: Fri, 15 May 2015 15:17:47 +0530
Message-ID: <1431683267-16155-2-git-send-email-rrs@debian.org>
References: <1431683267-16155-1-git-send-email-rrs@debian.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1431683267-16155-1-git-send-email-rrs@debian.org>
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

We are exiting when the device fails, so also print an error message

Signed-off-by: Ritesh Raj Sarraf <rrs@debian.org>
---
 kpartx/kpartx.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index d69f9af..8a13c16 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -448,9 +448,8 @@ main(int argc, char **argv){
 
 			if (S_ISREG (buf.st_mode)) {
 				if (del_loop(device)) {
-					if (verbose)
-						printf("can't del loop : %s\n",
-							device);
+					printf("can't del loop : %s\n",
+						device);
 					exit(1);
 				}
 				printf("loop deleted : %s\n", device);
-- 
2.1.4
