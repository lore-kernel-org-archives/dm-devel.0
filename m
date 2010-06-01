From: NeilBrown <neilb@suse.de>
Subject: [PATCH 01/24] md: reduce dependence on sysfs.
Date: Tue, 01 Jun 2010 19:56:18 +1000
Message-ID: <20100601095618.565.30040.stgit@notabene.brown>
References: <20100601094414.565.3638.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100601094414.565.3638.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Heinz Mauelshagen <heinzm@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

We will want md devices to live as dm targets where sysfs is not
visible.  So allow md to not connect to sysfs.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c    |  101 ++++++++++++++++++++++++----------------------------
 drivers/md/md.h    |   12 ++++++
 drivers/md/raid5.c |    8 ++--
 3 files changed, 62 insertions(+), 59 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 46b3a04..6fbd1c7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -541,14 +541,16 @@ static void mddev_unlock(mddev_t * mddev)
 		mutex_lock(&mddev->open_mutex);
 		mutex_unlock(&mddev->reconfig_mutex);
 
-		if (to_remove != &md_redundancy_group)
-			sysfs_remove_group(&mddev->kobj, to_remove);
-		if (mddev->pers == NULL ||
-		    mddev->pers->sync_request == NULL) {
-			sysfs_remove_group(&mddev->kobj, &md_redundancy_group);
-			if (mddev->sysfs_action)
-				sysfs_put(mddev->sysfs_action);
-			mddev->sysfs_action = NULL;
+		if (mddev->kobj.sd) {
+			if (to_remove != &md_redundancy_group)
+				sysfs_remove_group(&mddev->kobj, to_remove);
+			if (mddev->pers == NULL ||
+			    mddev->pers->sync_request == NULL) {
+				sysfs_remove_group(&mddev->kobj, &md_redundancy_group);
+				if (mddev->sysfs_action)
+					sysfs_put(mddev->sysfs_action);
+				mddev->sysfs_action = NULL;
+			}
 		}
 		mutex_unlock(&mddev->open_mutex);
 	} else
@@ -1811,11 +1813,9 @@ static int bind_rdev_to_array(mdk_rdev_t * rdev, mddev_t * mddev)
 		goto fail;
 
 	ko = &part_to_dev(rdev->bdev->bd_part)->kobj;
-	if ((err = sysfs_create_link(&rdev->kobj, ko, "block"))) {
-		kobject_del(&rdev->kobj);
-		goto fail;
-	}
-	rdev->sysfs_state = sysfs_get_dirent(rdev->kobj.sd, NULL, "state");
+	if (sysfs_create_link(&rdev->kobj, ko, "block"))
+		/* failure here is OK */;
+	rdev->sysfs_state = sysfs_get_dirent_safe(rdev->kobj.sd, "state");
 
 	list_add_rcu(&rdev->same_set, &mddev->disks);
 	bd_claim_by_disk(rdev->bdev, rdev->bdev->bd_holder, mddev->gendisk);
@@ -2333,8 +2333,8 @@ state_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 		set_bit(In_sync, &rdev->flags);
 		err = 0;
 	}
-	if (!err && rdev->sysfs_state)
-		sysfs_notify_dirent(rdev->sysfs_state);
+	if (!err)
+		sysfs_notify_dirent_safe(rdev->sysfs_state);
 	return err ? err : len;
 }
 static struct rdev_sysfs_entry rdev_state =
@@ -2429,14 +2429,10 @@ slot_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 			rdev->raid_disk = -1;
 			return err;
 		} else
-			sysfs_notify_dirent(rdev->sysfs_state);
+			sysfs_notify_dirent_safe(rdev->sysfs_state);
 		sprintf(nm, "rd%d", rdev->raid_disk);
 		if (sysfs_create_link(&rdev->mddev->kobj, &rdev->kobj, nm))
-			printk(KERN_WARNING
-			       "md: cannot register "
-			       "%s for %s\n",
-			       nm, mdname(rdev->mddev));
-
+			/* failure here is OK */;
 		/* don't wakeup anyone, leave that to userspace. */
 	} else {
 		if (slot >= rdev->mddev->raid_disks)
@@ -2446,7 +2442,7 @@ slot_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 		clear_bit(Faulty, &rdev->flags);
 		clear_bit(WriteMostly, &rdev->flags);
 		set_bit(In_sync, &rdev->flags);
-		sysfs_notify_dirent(rdev->sysfs_state);
+		sysfs_notify_dirent_safe(rdev->sysfs_state);
 	}
 	return len;
 }
@@ -3411,7 +3407,7 @@ array_state_store(mddev_t *mddev, const char *buf, size_t len)
 	if (err)
 		return err;
 	else {
-		sysfs_notify_dirent(mddev->sysfs_state);
+		sysfs_notify_dirent_safe(mddev->sysfs_state);
 		return len;
 	}
 }
@@ -3709,7 +3705,7 @@ action_store(mddev_t *mddev, const char *page, size_t len)
 	}
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
-	sysfs_notify_dirent(mddev->sysfs_action);
+	sysfs_notify_dirent_safe(mddev->sysfs_action);
 	return len;
 }
 
@@ -4255,13 +4251,14 @@ static int md_alloc(dev_t dev, char *name)
 		       disk->disk_name);
 		error = 0;
 	}
-	if (sysfs_create_group(&mddev->kobj, &md_bitmap_group))
+	if (mddev->kobj.sd &&
+	    sysfs_create_group(&mddev->kobj, &md_bitmap_group))
 		printk(KERN_DEBUG "pointless warning\n");
  abort:
 	mutex_unlock(&disks_mutex);
-	if (!error) {
+	if (!error && mddev->kobj.sd) {
 		kobject_uevent(&mddev->kobj, KOBJ_ADD);
-		mddev->sysfs_state = sysfs_get_dirent(mddev->kobj.sd, NULL, "array_state");
+		mddev->sysfs_state = sysfs_get_dirent_safe(mddev->kobj.sd, "array_state");
 	}
 	mddev_put(mddev);
 	return error;
@@ -4299,7 +4296,7 @@ static void md_safemode_timeout(unsigned long data)
 	if (!atomic_read(&mddev->writes_pending)) {
 		mddev->safemode = 1;
 		if (mddev->external)
-			sysfs_notify_dirent(mddev->sysfs_state);
+			sysfs_notify_dirent_safe(mddev->sysfs_state);
 	}
 	md_wakeup_thread(mddev->thread);
 }
@@ -4371,7 +4368,7 @@ static int md_run(mddev_t *mddev)
 				return -EINVAL;
 			}
 		}
-		sysfs_notify_dirent(rdev->sysfs_state);
+		sysfs_notify_dirent_safe(rdev->sysfs_state);
 	}
 
 	spin_lock(&pers_lock);
@@ -4470,11 +4467,12 @@ static int md_run(mddev_t *mddev)
 		return err;
 	}
 	if (mddev->pers->sync_request) {
-		if (sysfs_create_group(&mddev->kobj, &md_redundancy_group))
+		if (mddev->kobj.sd &&
+		    sysfs_create_group(&mddev->kobj, &md_redundancy_group))
 			printk(KERN_WARNING
 			       "md: cannot register extra attributes for %s\n",
 			       mdname(mddev));
-		mddev->sysfs_action = sysfs_get_dirent(mddev->kobj.sd, NULL, "sync_action");
+		mddev->sysfs_action = sysfs_get_dirent_safe(mddev->kobj.sd, "sync_action");
 	} else if (mddev->ro == 2) /* auto-readonly not meaningful */
 		mddev->ro = 0;
 
@@ -4492,8 +4490,7 @@ static int md_run(mddev_t *mddev)
 			char nm[20];
 			sprintf(nm, "rd%d", rdev->raid_disk);
 			if (sysfs_create_link(&mddev->kobj, &rdev->kobj, nm))
-				printk("md: cannot register %s for %s\n",
-				       nm, mdname(mddev));
+				/* failure here is OK */;
 		}
 	
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
@@ -4505,9 +4502,8 @@ static int md_run(mddev_t *mddev)
 	md_wakeup_thread(mddev->sync_thread); /* possibly kick off a reshape */
 
 	md_new_event(mddev);
-	sysfs_notify_dirent(mddev->sysfs_state);
-	if (mddev->sysfs_action)
-		sysfs_notify_dirent(mddev->sysfs_action);
+	sysfs_notify_dirent_safe(mddev->sysfs_state);
+	sysfs_notify_dirent_safe(mddev->sysfs_action);
 	sysfs_notify(&mddev->kobj, NULL, "degraded");
 	return 0;
 }
@@ -4547,7 +4543,7 @@ static int restart_array(mddev_t *mddev)
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
 	md_wakeup_thread(mddev->sync_thread);
-	sysfs_notify_dirent(mddev->sysfs_state);
+	sysfs_notify_dirent_safe(mddev->sysfs_state);
 	return 0;
 }
 
@@ -4671,7 +4667,7 @@ static int md_set_readonly(mddev_t *mddev, int is_open)
 		mddev->ro = 1;
 		set_disk_ro(mddev->gendisk, 1);
 		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-		sysfs_notify_dirent(mddev->sysfs_state);
+		sysfs_notify_dirent_safe(mddev->sysfs_state);
 		err = 0;	
 	}
 out:
@@ -4704,7 +4700,7 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 		mddev->queue->backing_dev_info.congested_fn = NULL;
 
 		/* tell userspace to handle 'inactive' */
-		sysfs_notify_dirent(mddev->sysfs_state);
+		sysfs_notify_dirent_safe(mddev->sysfs_state);
 
 		list_for_each_entry(rdev, &mddev->disks, same_set)
 			if (rdev->raid_disk >= 0) {
@@ -4750,7 +4746,7 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 	err = 0;
 	blk_integrity_unregister(disk);
 	md_new_event(mddev);
-	sysfs_notify_dirent(mddev->sysfs_state);
+	sysfs_notify_dirent_safe(mddev->sysfs_state);
 	return err;
 }
 
@@ -5112,7 +5108,7 @@ static int add_new_disk(mddev_t * mddev, mdu_disk_info_t *info)
 		if (err)
 			export_rdev(rdev);
 		else
-			sysfs_notify_dirent(rdev->sysfs_state);
+			sysfs_notify_dirent_safe(rdev->sysfs_state);
 
 		md_update_sb(mddev, 1);
 		if (mddev->degraded)
@@ -5787,7 +5783,7 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 	if (_IOC_TYPE(cmd) == MD_MAJOR && mddev->ro && mddev->pers) {
 		if (mddev->ro == 2) {
 			mddev->ro = 0;
-			sysfs_notify_dirent(mddev->sysfs_state);
+			sysfs_notify_dirent_safe(mddev->sysfs_state);
 			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 			md_wakeup_thread(mddev->thread);
 		} else {
@@ -6032,7 +6028,7 @@ void md_error(mddev_t *mddev, mdk_rdev_t *rdev)
 	mddev->pers->error_handler(mddev,rdev);
 	if (mddev->degraded)
 		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
-	sysfs_notify_dirent(rdev->sysfs_state);
+	sysfs_notify_dirent_safe(rdev->sysfs_state);
 	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
@@ -6493,7 +6489,7 @@ void md_write_start(mddev_t *mddev, struct bio *bi)
 		spin_unlock_irq(&mddev->write_lock);
 	}
 	if (did_change)
-		sysfs_notify_dirent(mddev->sysfs_state);
+		sysfs_notify_dirent_safe(mddev->sysfs_state);
 	wait_event(mddev->sb_wait,
 		   !test_bit(MD_CHANGE_CLEAN, &mddev->flags) &&
 		   !test_bit(MD_CHANGE_PENDING, &mddev->flags));
@@ -6536,7 +6532,7 @@ int md_allow_write(mddev_t *mddev)
 			mddev->safemode = 1;
 		spin_unlock_irq(&mddev->write_lock);
 		md_update_sb(mddev, 0);
-		sysfs_notify_dirent(mddev->sysfs_state);
+		sysfs_notify_dirent_safe(mddev->sysfs_state);
 	} else
 		spin_unlock_irq(&mddev->write_lock);
 
@@ -6922,10 +6918,7 @@ static int remove_and_add_spares(mddev_t *mddev)
 					sprintf(nm, "rd%d", rdev->raid_disk);
 					if (sysfs_create_link(&mddev->kobj,
 							      &rdev->kobj, nm))
-						printk(KERN_WARNING
-						       "md: cannot register "
-						       "%s for %s\n",
-						       nm, mdname(mddev));
+						/* failure here is OK */;
 					spares++;
 					md_new_event(mddev);
 					set_bit(MD_CHANGE_DEVS, &mddev->flags);
@@ -7018,7 +7011,7 @@ void md_check_recovery(mddev_t *mddev)
 				mddev->safemode = 0;
 			spin_unlock_irq(&mddev->write_lock);
 			if (did_change)
-				sysfs_notify_dirent(mddev->sysfs_state);
+				sysfs_notify_dirent_safe(mddev->sysfs_state);
 		}
 
 		if (mddev->flags)
@@ -7057,7 +7050,7 @@ void md_check_recovery(mddev_t *mddev)
 			mddev->recovery = 0;
 			/* flag recovery needed just to double check */
 			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-			sysfs_notify_dirent(mddev->sysfs_action);
+			sysfs_notify_dirent_safe(mddev->sysfs_action);
 			md_new_event(mddev);
 			goto unlock;
 		}
@@ -7119,7 +7112,7 @@ void md_check_recovery(mddev_t *mddev)
 				mddev->recovery = 0;
 			} else
 				md_wakeup_thread(mddev->sync_thread);
-			sysfs_notify_dirent(mddev->sysfs_action);
+			sysfs_notify_dirent_safe(mddev->sysfs_action);
 			md_new_event(mddev);
 		}
 	unlock:
@@ -7128,7 +7121,7 @@ void md_check_recovery(mddev_t *mddev)
 			if (test_and_clear_bit(MD_RECOVERY_RECOVER,
 					       &mddev->recovery))
 				if (mddev->sysfs_action)
-					sysfs_notify_dirent(mddev->sysfs_action);
+					sysfs_notify_dirent_safe(mddev->sysfs_action);
 		}
 		mddev_unlock(mddev);
 	}
@@ -7136,7 +7129,7 @@ void md_check_recovery(mddev_t *mddev)
 
 void md_wait_for_blocked_rdev(mdk_rdev_t *rdev, mddev_t *mddev)
 {
-	sysfs_notify_dirent(rdev->sysfs_state);
+	sysfs_notify_dirent_safe(rdev->sysfs_state);
 	wait_event_timeout(rdev->blocked_wait,
 			   !test_bit(Blocked, &rdev->flags),
 			   msecs_to_jiffies(5000));
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 7ab5ea1..1f680e4 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -379,6 +379,18 @@ struct md_sysfs_entry {
 };
 extern struct attribute_group md_bitmap_group;
 
+static inline struct sysfs_dirent *sysfs_get_dirent_safe(struct sysfs_dirent *sd, char *name)
+{
+	if (sd)
+		return sysfs_get_dirent(sd, NULL, name);
+	return sd;
+}
+static inline void sysfs_notify_dirent_safe(struct sysfs_dirent *sd)
+{
+	if (sd)
+		sysfs_notify_dirent(sd);
+}
+
 static inline char * mdname (mddev_t * mddev)
 {
 	return mddev->gendisk ? mddev->gendisk->disk_name : "mdX";
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index d2c0f94..8882da3 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5070,7 +5070,8 @@ static int run(mddev_t *mddev)
 	/* Ok, everything is just fine now */
 	if (mddev->to_remove == &raid5_attrs_group)
 		mddev->to_remove = NULL;
-	else if (sysfs_create_group(&mddev->kobj, &raid5_attrs_group))
+	else if (mddev->kobj.sd &&
+	    sysfs_create_group(&mddev->kobj, &raid5_attrs_group))
 		printk(KERN_WARNING
 		       "md/raid:%s: failed to create sysfs attributes.\n",
 		       mdname(mddev));
@@ -5451,10 +5452,7 @@ static int raid5_start_reshape(mddev_t *mddev)
 				sprintf(nm, "rd%d", rdev->raid_disk);
 				if (sysfs_create_link(&mddev->kobj,
 						      &rdev->kobj, nm))
-					printk(KERN_WARNING
-					       "md/raid:%s: failed to create "
-					       " link %s\n",
-					       mdname(mddev), nm);
+					/* Failure here is OK */;
 			} else
 				break;
 		}


