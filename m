From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 1/9] dm: Do not export dm_send_uevents
Date: Mon,  3 Oct 2016 12:22:52 -0700
Message-ID: <1475522580-16723-2-git-send-email-agrover@redhat.com>
References: <1475522580-16723-1-git-send-email-agrover@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1475522580-16723-1-git-send-email-agrover@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, snitzer@redhat.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
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
2.7.4
