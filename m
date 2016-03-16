From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 1/5] dm: Do not export dm_send_uevents
Date: Wed, 16 Mar 2016 16:27:43 -0700
Message-ID: <1458170867-429-2-git-send-email-agrover@redhat.com>
References: <1458170867-429-1-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1458170867-429-1-git-send-email-agrover@redhat.com>
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
List-Id: dm-devel.ids

Since dm-uevent.c (if CONFIG_DM_UEVENT) is part of the same module as where
dm_sent_uevents is called, it does not need to be exported.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/md/dm-uevent.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/dm-uevent.c b/drivers/md/dm-uevent.c
index 8efe033..2d5f858 100644
--- a/drivers/md/dm-uevent.c
+++ b/drivers/md/dm-uevent.c
@@ -169,7 +169,6 @@ uevent_free:
 		dm_uevent_free(event);
 	}
 }
-EXPORT_SYMBOL_GPL(dm_send_uevents);
 
 /**
  * dm_path_uevent - called to create a new path event and queue it
-- 
2.5.0
