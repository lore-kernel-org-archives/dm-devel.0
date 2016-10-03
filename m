From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 6/9] dm: Rename dm_event_add to dm_event_queue
Date: Mon,  3 Oct 2016 12:22:57 -0700
Message-ID: <1475522580-16723-7-git-send-email-agrover@redhat.com>
References: <1475522580-16723-1-git-send-email-agrover@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1475522580-16723-1-git-send-email-agrover@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, snitzer@redhat.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

For clarity. This function queues an event to be sent, which is not
totally clear from the previous name. And, we want to reuse the name
for something else.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 Documentation/device-mapper/dm-uevent.txt | 2 +-
 drivers/md/dm-mpath.c                     | 2 +-
 drivers/md/dm.c                           | 4 ++--
 include/linux/device-mapper.h             | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/device-mapper/dm-uevent.txt b/Documentation/device-mapper/dm-uevent.txt
index 5780e76..4fcb71d 100644
--- a/Documentation/device-mapper/dm-uevent.txt
+++ b/Documentation/device-mapper/dm-uevent.txt
@@ -22,7 +22,7 @@ Optionally add event-specific data to the generated uevent. e.g. dm-mpath's
 PATH_FAILED and PATH_REINSTATED uevents add path and number-of-remaining-paths
 vars.
 
-void dm_uevent_add(struct mapped_device *md, struct list_head *elist)
+void dm_uevent_queue(struct mapped_device *md, struct list_head *elist)
 
 Hand off the uevent to the device's list of pending events.
 
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 26f99d0..467724c 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1282,7 +1282,7 @@ static void dm_path_uevent(enum dm_uevent_type event_type, struct dm_target *ti,
 		goto err;
 	}
 
-	dm_uevent_add(md, &event->elist);
+	dm_uevent_queue(md, &event->elist);
 	return;
 err:
 	dm_uevent_free(event);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 701c75f..37b3a82 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2419,7 +2419,7 @@ int dm_wait_event(struct mapped_device *md, int event_nr)
 			(event_nr != atomic_read(&md->event_nr)));
 }
 
-void dm_uevent_add(struct mapped_device *md, struct list_head *elist)
+void dm_uevent_queue(struct mapped_device *md, struct list_head *elist)
 {
 	unsigned long flags;
 
@@ -2427,7 +2427,7 @@ void dm_uevent_add(struct mapped_device *md, struct list_head *elist)
 	list_add(elist, &md->uevent_list);
 	spin_unlock_irqrestore(&md->uevent_lock, flags);
 }
-EXPORT_SYMBOL_GPL(dm_uevent_add);
+EXPORT_SYMBOL_GPL(dm_uevent_queue);
 
 /*
  * The gendisk is only valid as long as you have a reference
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 91acfce..024207c 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -419,7 +419,7 @@ int dm_resume(struct mapped_device *md);
 uint32_t dm_get_event_nr(struct mapped_device *md);
 int dm_wait_event(struct mapped_device *md, int event_nr);
 uint32_t dm_next_uevent_seq(struct mapped_device *md);
-void dm_uevent_add(struct mapped_device *md, struct list_head *elist);
+void dm_uevent_queue(struct mapped_device *md, struct list_head *elist);
 
 /*
  * Info functions.
-- 
2.7.4
