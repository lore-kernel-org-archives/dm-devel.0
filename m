From: Joe Thornber <ejt@redhat.com>
Subject: [PATCH 3/4] [block-manager] remove spurious decrement of
	write_lock_pending in the case of a recycled block.
Date: Tue,  2 Aug 2011 15:36:47 +0100
Message-ID: <1312295808-4323-3-git-send-email-ejt@redhat.com>
References: <Pine.LNX.4.64.1108011620590.9983@hs20-bc2-1.build.redhat.com>
	<1312295808-4323-1-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1312295808-4323-1-git-send-email-ejt@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: mpatocka@redhat.com
Cc: dm-devel@redhat.com, Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

---
 drivers/md/persistent-data/dm-block-manager.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/md/persistent-data/dm-block-manager.c b/drivers/md/persistent-data/dm-block-manager.c
index b68be88..d27ab6e 100644
--- a/drivers/md/persistent-data/dm-block-manager.c
+++ b/drivers/md/persistent-data/dm-block-manager.c
@@ -756,9 +756,15 @@ retry:
 
 				b->write_lock_pending++;
 				__wait_unlocked(b, &flags);
-				b->write_lock_pending--;
 				if (b->where != block)
+					/*
+					 * Recycled blocks have their
+					 * write_lock_pending count reset
+					 * to zero, so no need to undo the
+					 * above increment.
+					 */
 					goto retry;
+				b->write_lock_pending--;
 			}
 			break;
 		}
-- 
1.7.4.1
