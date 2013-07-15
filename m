From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 03/29] alua: Do not add preferred path priority
	for active/optimized
Date: Mon, 15 Jul 2013 15:00:04 +0200
Message-ID: <1373893230-26077-4-git-send-email-hare@suse.de>
References: <1373893230-26077-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1373893230-26077-1-git-send-email-hare@suse.de>
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

When a path is in active/optimized we should disregard the
'preferred path' bit when calculating the priority.
Otherwise we'll end up with having two different priorities
(one for 'active/optimized (preferred)' and one for
'active/optimized (non-preferred)').
Which will result in two different path groups and a
sub-optimal path usage.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/prioritizers/alua.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/prioritizers/alua.c b/libmultipath/prioritizers/alua.c
index b9493a4..4165ec6 100644
--- a/libmultipath/prioritizers/alua.c
+++ b/libmultipath/prioritizers/alua.c
@@ -108,7 +108,7 @@ int getprio (struct path * pp, char * args)
 			default:
 				rc = 0;
 		}
-		if (priopath)
+		if (priopath && aas != AAS_OPTIMIZED)
 			rc += 80;
 	} else {
 		switch(-rc) {
-- 
1.7.10.4
