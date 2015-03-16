From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 44/78] multipath: do not print state 'orphan' for
	option '-l'
Date: Mon, 16 Mar 2015 13:36:31 +0100
Message-ID: <1426509425-15978-45-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

When called with '-l' multipath would mistakenly print a state
of 'orphan' instead off 'running' of 'offline'.
This is a regression introduced by commit 7023d320.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/print.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 39b4f98..5d63ed3 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -322,8 +322,6 @@ snprint_offline (char * buff, size_t len, struct path * pp)
 		return snprintf(buff, len, "unknown");
 	else if (pp->offline)
 		return snprintf(buff, len, "offline");
-	else if (!pp->mpp)
-		return snprintf(buff, len, "orphan");
 	else
 		return snprintf(buff, len, "running");
 }
-- 
1.8.4.5
