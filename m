Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FACF42E007
	for <dm-devel@lists.linux.dev>; Thu, 10 Sep 2026 08:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789027895; cv=none; b=Hep190BsHLi0yXmf9ZnJXd4gw5LtXEWVrn1ROHKs7SPY+rBksoX6Iu7hP2V3kEWBL9i5fsKwZ020NCZ5/nr9DVxcpmg4pyZFbMWtOeHhVGObqKXY+wuUtjjW4KtYx+5upgCAqbyhM6c/ZNtlMsHVeCDrfjYfcaP3W4OfKyX1dYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789027895; c=relaxed/simple;
	bh=VWJq79Pbtf4IbOZyn7AR5EcaHFmtf9h2nH5b25XhR2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VeaMUixw1lHJNSUtKmFeLTAxQrzBGHUIVyoGN6+nRlJeh5ZLETfgAsnv03bOXvnPvTqTsr/wHGZsofDlbU7bAUqpGI0ADRn0JpiLTnuHoaFmAzdi4k66dfzK3mnH4kWcWBtnsVYnfkibgo9Yvf0Guki2vOs6VBHQwzJbniO1MrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=d2RW2cgt; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="d2RW2cgt"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49d0726cdbcso3153455e9.0
        for <dm-devel@lists.linux.dev>; Thu, 10 Sep 2026 01:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1789027888; x=1789632688; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7WxxmD3yg0pg+i13gK8J2zlyLTSoxJMhIHGtHp0KYMk=;
        b=d2RW2cgtCZ0feKkBnaebpBjRAHuULcjuKqsYvfr8ho1OJ2Rw/VLRR/DHmI9rRGSnyr
         jRPYYcfJ15XpK09cwqsLh0Uz++7TDqjNvqnFzHnz8lmo4zXvn7IBni14lqAeFAdSYTe0
         nllLLp+fkQGcro1sheR6VMvsIdEwB4g9uKAT2dLMQfMJe4kDedSkIhc5Gc6JxQ3pTRD4
         ic+DNWA4iUhsal38Hm5OJaB8r52XeE3shSpXfJSlXi24vQOVcN393a4kTvsG1yMbyMin
         1mxvroZ0dfm//ZF7hQFDoyoT1pY51aKyeQs9Efw1KiDpauRbUdzKvSbOYq2oeStpIEPD
         sYXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789027888; x=1789632688;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7WxxmD3yg0pg+i13gK8J2zlyLTSoxJMhIHGtHp0KYMk=;
        b=q/J83Amnm7whdQe2CNiIr5QacmJCrEvtDuIS/ah4J+INVaFns1RHvDl9/rLjMYktaq
         4rkPqMem3Qv+m6XiNH7y25zZ1ylZR3aQfaGT5bMomsqKGwBQhZLIBc9+O5iYcGcVG9T7
         ZRbdhoCkBrdMzLR5QsqAGiLoN8FoGWHQCXaSUaJQ3svn17tOGcf/xNstp/evcrx0EMuk
         ni0WChdDybbcYfagK+uSr3+tQzsdohumQygKh1TS4PU2JvDzas6v38sk+sxk1FLmfLa1
         TFrZIiq6Oq05PVHzw/oNIUePfVm8+cHPoKIVMCjhxFMR/tEttY9LeHgz5kbVRDxwt4lJ
         BQng==
X-Forwarded-Encrypted: i=1; AKwUvBzgvqzmxbk6LN6BvaV9co+40X4e2wXFtkFmVqPQ1tNIeqH5NtqCB66hFU/vb32dKqikrXWu6bwL+A==@lists.linux.dev
X-Gm-Message-State: AFuF++mPyUMe5XSQKEIbwIAQVLHrt3x87pUvLA/vHktD/qnT3eV1E4k1
	/fCgitGvT5dMg1KqQaK+lbZFatd1h/20XOOzDk+bKBw15qFsuOd4X3H8jN55YvZ/RAs=
X-Gm-Gg: AYBFou1l1wGw5T7fj2VFP0gDXAQLfcZEcl6zfMhqO+YRz9InwDA+OCpSeACUrWtto5e
	qjFzWm0Z96wvrexfnI8c6CNkLsmihJq4IIzjKVsfVKDIu8ZlNtI0nQqmTxyAUuzLOwzbu5xBbzs
	Z2X0r7qrE4IsxxXrn1ZE/SUD5quY9dh5z+21eazvzt8kfpnF9ejiCSMuV02dkPxpH21pOwQIB9x
	qZ8gK1yndi4Xut9YS5TK/e97YYxrTqpYEtH/GhmA4K7CT67QsQ4y2ElnDXHJntpQxcaCTT9Y+LZ
	GHEmb23nsqNZEeHKgfCxCzy8XB1k1RM4R62f7I3wQKpJXpq6rbsT2enyJ9a5BbiPx2ywynumv20
	/qoyDsEtOWfMGNB2CFE4Lwivu3IFccV/6uvdcVth4RdP9hxt9n+MMCJRsWR6skmgvZvmZ/4j2Pk
	2iJtQKezm7XBytNr0xQE+97kdNcyW7n8mWv0r6d00svZ/yeLmKZIZysppa34zleijRQbMFcQsFB
	0DhBtLx/T8BDvb13uRHfcuQgPzCa/IzVF0zPnlK0xQJ
X-Received: by 2002:a05:600c:3b25:b0:49b:910c:76fb with SMTP id 5b1f17b1804b1-49d01dd415bmr272852515e9.2.1789027887561;
        Thu, 10 Sep 2026 01:11:27 -0700 (PDT)
Received: from jwang-ThinkPad-T14-Gen-6.fkb.profitbricks.net ([212.227.34.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d20fc1be3sm55261135e9.4.2026.09.10.01.11.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 01:11:26 -0700 (PDT)
From: Jack Wang <jinpu.wang@ionos.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org,
	Nilay Shroff <nilay@linux.ibm.com>,
	abd.masalkhi@gmail.com
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Ming Lei <tom.leiming@gmail.com>,
	Xiao Ni <xiao@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH v2 8/8] md: link a new leg's holder before locking the array
Date: Thu, 10 Sep 2026 10:11:13 +0200
Message-ID: <20260910081114.1605746-9-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260910081114.1605746-1-jinpu.wang@ionos.com>
References: <20260910081114.1605746-1-jinpu.wang@ionos.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jack Wang <jinpu.wang@cloud.ionos.com>

bd_link_disk_holder() takes the leg's disk->open_mutex, and
bind_rdev_to_array() calls it with reconfig_mutex held, so the
dependency the previous patch removed from md_import_device() is still
there by another route:

  -> #2 (&q->limits_lock):        sd_revalidate_disk / sd_open
  -> #1 (&disk->open_mutex):      bd_link_disk_holder
                                  bind_rdev_to_array
                                  md_add_new_disk
                                  md_ioctl        <- ADD_NEW_DISK
  -> #0 (&mddev->reconfig_mutex): md_ioctl        <- RUN_ARRAY

bd_unlink_disk_holder() only takes blk_holder_mutex, which is why the
release side needs no change and made the link side easy to miss.

Link the holder where the leg is opened, before the array is locked, and
record it in a new HolderLinked flag so the release side knows whether
there is a link to drop.  A failed link is not fatal, as before.  A leg
that is linked but not yet bound is released through md_export_rdev(),
which drops the link first.

A leg is now linked before it is known to be acceptable, so a leg the
array goes on to reject shows up in its slaves directory until the
error path releases it.

md then no longer takes disk->open_mutex under reconfig_mutex: of the
functions that take it, md reaches bdev_open() and bd_link_disk_holder()
from the paths above, bdev_release() and bdev_fput() only through fput(),
which defers to task work, del_gendisk() only from mddev teardown, and
never sync_bdevs().

Assisted-by: LLM
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/md/md-autodetect.c |  2 +-
 drivers/md/md.c            | 70 ++++++++++++++++++++++++++++----------
 drivers/md/md.h            |  7 +++-
 3 files changed, 59 insertions(+), 20 deletions(-)

diff --git a/drivers/md/md-autodetect.c b/drivers/md/md-autodetect.c
index e592577356ad..b6f9fb36f1bb 100644
--- a/drivers/md/md-autodetect.c
+++ b/drivers/md/md-autodetect.c
@@ -231,7 +231,7 @@ static void __init md_setup_drive(struct md_setup_args *args)
 		mddev_lock_nointr(mddev);
 
 		md_add_new_disk(mddev, &dinfo, &nd, NULL);
-		md_put_new_disk(&nd);
+		md_put_new_disk(mddev, &nd);
 	}
 
 	/*
diff --git a/drivers/md/md.c b/drivers/md/md.c
index fa033d7d3831..235f0d645cea 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2632,7 +2632,7 @@ static int bind_rdev_to_array(struct md_rdev *rdev, struct mddev *mddev)
 		sysfs_get_dirent_safe(rdev->kobj.sd, "bad_blocks");
 
 	list_add_rcu(&rdev->same_set, &mddev->disks);
-	bd_link_disk_holder(rdev->bdev, mddev->gendisk);
+	/* the holder is linked with the open, see md_link_rdev_holder() */
 
 	return 0;
 
@@ -2648,6 +2648,23 @@ void md_autodetect_dev(dev_t dev);
 /* just for claiming the bdev */
 static struct md_rdev claim_rdev;
 
+/*
+ * bd_link_disk_holder() takes the leg's disk->open_mutex, so the link is
+ * made with the open, before the array is locked.  bd_unlink_disk_holder()
+ * only takes blk_holder_mutex, so dropping it is safe under any lock.
+ */
+static void md_link_rdev_holder(struct md_rdev *rdev, struct mddev *mddev)
+{
+	if (!bd_link_disk_holder(rdev->bdev, mddev->gendisk))
+		set_bit(HolderLinked, &rdev->flags);
+}
+
+static void md_unlink_rdev_holder(struct md_rdev *rdev, struct mddev *mddev)
+{
+	if (test_and_clear_bit(HolderLinked, &rdev->flags))
+		bd_unlink_disk_holder(rdev->bdev, mddev->gendisk);
+}
+
 static void export_rdev(struct md_rdev *rdev)
 {
 	pr_debug("md: export_rdev(%pg)\n", rdev->bdev);
@@ -2661,11 +2678,18 @@ static void export_rdev(struct md_rdev *rdev)
 	kobject_put(&rdev->kobj);
 }
 
+/* release a leg that was linked before the array was locked */
+static void md_export_rdev(struct mddev *mddev, struct md_rdev *rdev)
+{
+	md_unlink_rdev_holder(rdev, mddev);
+	export_rdev(rdev);
+}
+
 static void md_kick_rdev_from_array(struct md_rdev *rdev)
 {
 	struct mddev *mddev = rdev->mddev;
 
-	bd_unlink_disk_holder(rdev->bdev, rdev->mddev->gendisk);
+	md_unlink_rdev_holder(rdev, rdev->mddev);
 	list_del_rcu(&rdev->same_set);
 	pr_debug("md: unbind<%pg>\n", rdev->bdev);
 	mddev_destroy_serial_pool(rdev->mddev, rdev);
@@ -4974,9 +4998,11 @@ new_dev_store(struct mddev *mddev, const char *buf, size_t len)
 	if (IS_ERR(rdev))
 		return PTR_ERR(rdev);
 
+	md_link_rdev_holder(rdev, mddev);
+
 	err = mddev_suspend_and_lock(mddev);
 	if (err) {
-		export_rdev(rdev);
+		md_export_rdev(mddev, rdev);
 		return err;
 	}
 	noio_flags = memalloc_noio_save();
@@ -5003,7 +5029,7 @@ new_dev_store(struct mddev *mddev, const char *buf, size_t len)
 	err = bind_rdev_to_array(rdev, mddev);
  out:
 	if (err)
-		export_rdev(rdev);
+		md_export_rdev(mddev, rdev);
 	memalloc_noio_restore(noio_flags);
 	mddev_unlock_and_resume(mddev);
 	if (!err)
@@ -7519,6 +7545,10 @@ static void autorun_devices(int part)
 			limp = &lim;
 		}
 
+		/* link before locking, see md_link_rdev_holder() */
+		rdev_for_each_list(rdev, tmp, &candidates)
+			md_link_rdev_holder(rdev, mddev);
+
 		if (mddev_suspend_and_lock(mddev)) {
 			pr_warn("md: %s locked, cannot run\n", mdname(mddev));
 			if (limp) {
@@ -7538,7 +7568,7 @@ static void autorun_devices(int part)
 			rdev_for_each_list(rdev, tmp, &candidates) {
 				list_del_init(&rdev->same_set);
 				if (bind_rdev_to_array(rdev, mddev))
-					export_rdev(rdev);
+					md_export_rdev(mddev, rdev);
 			}
 			autorun_array(mddev, limp);
 			if (limp && queue_limits_commit_update(q, limp))
@@ -7552,7 +7582,7 @@ static void autorun_devices(int part)
 		 */
 		rdev_for_each_list(rdev, tmp, &candidates) {
 			list_del_init(&rdev->same_set);
-			export_rdev(rdev);
+			md_export_rdev(mddev, rdev);
 		}
 		mddev_put(mddev);
 	}
@@ -7730,7 +7760,7 @@ int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info,
 	     nd->minor_version != mddev->minor_version)) {
 		pr_warn("%s: array reconfigured while opening %pg\n",
 			mdname(mddev), nd->rdev->bdev);
-		export_rdev(nd->rdev);
+		md_export_rdev(mddev, nd->rdev);
 		nd->rdev = NULL;
 		return -EBUSY;
 	}
@@ -7763,13 +7793,13 @@ int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info,
 				pr_warn("md: %pg has different UUID to %pg\n",
 					rdev->bdev,
 					rdev0->bdev);
-				export_rdev(rdev);
+				md_export_rdev(mddev, rdev);
 				return -EINVAL;
 			}
 		}
 		err = bind_rdev_to_array(rdev, mddev);
 		if (err)
-			export_rdev(rdev);
+			md_export_rdev(mddev, rdev);
 		return err;
 	}
 
@@ -7806,7 +7836,7 @@ int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info,
 			/* This was a hot-add request, but events doesn't
 			 * match, so reject it.
 			 */
-			export_rdev(rdev);
+			md_export_rdev(mddev, rdev);
 			return -EINVAL;
 		}
 
@@ -7832,7 +7862,7 @@ int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info,
 				}
 			}
 			if (has_journal || mddev->bitmap) {
-				export_rdev(rdev);
+				md_export_rdev(mddev, rdev);
 				return -EBUSY;
 			}
 			set_bit(Journal, &rdev->flags);
@@ -7847,7 +7877,7 @@ int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info,
 				/* --add initiated by this node */
 				err = mddev->cluster_ops->add_new_disk(mddev, rdev);
 				if (err) {
-					export_rdev(rdev);
+					md_export_rdev(mddev, rdev);
 					return err;
 				}
 			}
@@ -7857,7 +7887,7 @@ int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info,
 		err = bind_rdev_to_array(rdev, mddev);
 
 		if (err)
-			export_rdev(rdev);
+			md_export_rdev(mddev, rdev);
 
 		if (mddev_is_clustered(mddev)) {
 			if (info->state & (1 << MD_DISK_CANDIDATE)) {
@@ -7919,7 +7949,7 @@ int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info,
 
 		err = bind_rdev_to_array(rdev, mddev);
 		if (err) {
-			export_rdev(rdev);
+			md_export_rdev(mddev, rdev);
 			return err;
 		}
 	}
@@ -8031,7 +8061,7 @@ static int hot_add_disk(struct mddev *mddev, struct md_new_disk *nd)
 	return 0;
 
 abort_export:
-	export_rdev(rdev);
+	md_export_rdev(mddev, rdev);
 	return err;
 }
 
@@ -8577,15 +8607,18 @@ int md_import_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info,
 		return err;
 	}
 
+	/* link the holder here too, for the same reason */
+	md_link_rdev_holder(rdev, mddev);
+
 	nd->rdev = rdev;
 	return 0;
 }
 
 /* release a leg md_add_new_disk() did not take ownership of */
-void md_put_new_disk(struct md_new_disk *nd)
+void md_put_new_disk(struct mddev *mddev, struct md_new_disk *nd)
 {
 	if (nd->rdev) {
-		export_rdev(nd->rdev);
+		md_export_rdev(mddev, nd->rdev);
 		nd->rdev = NULL;
 	}
 }
@@ -8717,6 +8750,7 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 			err = -EINVAL;
 			goto out;
 		}
+		md_link_rdev_holder(nd.rdev, mddev);
 	}
 
 	/* q->limits_lock nests outside both, see md_start_sync() */
@@ -8864,7 +8898,7 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 
 out:
 	/* a leg we opened but nothing took ownership of */
-	md_put_new_disk(&nd);
+	md_put_new_disk(mddev, &nd);
 
 	if (cmd == STOP_ARRAY_RO || (err && cmd == STOP_ARRAY))
 		clear_bit(MD_CLOSING, &mddev->flags);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 73a27d83d65a..1a0d57d58ad1 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -294,6 +294,11 @@ enum flag_bits {
 				 * serial bios.
 				 */
 	Nonrot,			/* non-rotational device (SSD) */
+	HolderLinked,		/* bd_link_disk_holder() succeeded for this
+				 * leg.  The link is made before the array is
+				 * locked, as it takes disk->open_mutex,
+				 * see md_import_new_disk().
+				 */
 };
 
 static inline int is_badblock(struct md_rdev *rdev, sector_t s, sector_t sectors,
@@ -1069,7 +1074,7 @@ struct md_new_disk {
 
 int md_import_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info,
 		       struct md_new_disk *nd);
-void md_put_new_disk(struct md_new_disk *nd);
+void md_put_new_disk(struct mddev *mddev, struct md_new_disk *nd);
 int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info,
 		    struct md_new_disk *nd, struct queue_limits *lim);
 int do_md_run(struct mddev *mddev, struct queue_limits *lim);
-- 
2.43.0

