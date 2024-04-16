Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC0D130A65
	for <dm-devel@lists.linux.dev>; Tue, 16 Apr 2024 15:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713281347; cv=none; b=pdH9iNEd+uInW7lh5M0OFJgexPeR/UYjTNlSzYMoDiY1OkRa5GTNcfhYTHwXxnKdHY4OcwQAYjKGb7RXtvL2ybI8V/lqD7jtN7QVTJoITpSPCGriQDJZ2TfanBICMadQS6Mrg5PMxGnjm4PFBRc0l7Y3Y0Ep1yUclbSyAeEjcNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713281347; c=relaxed/simple;
	bh=04LmKJy9tv3jnf8es510u+F1veLrMcBHefejr9yQqoU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=P4GyMplNZIJQCp5gRFE+fpXTiRXwSA4oq0HXNLaHKn1p9FxhT4KQgh3XiM5WWns02NR/ax4xFp46HV5Ya2zHFn0O11PaOkat70t4cFceIaM+H+CL/ZwtolcJCutAh+IZsIe57PnU8ZdeVUZWW4FzjeOBq0I0T1uKA3Po9Q3KUE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-434832aa162so16864141cf.1
        for <dm-devel@lists.linux.dev>; Tue, 16 Apr 2024 08:29:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713281345; x=1713886145;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TNYj7H9P7fHg2UmrKFO+txY1tWvttbrM2kjJrAop9rQ=;
        b=hmjYWe543xrI6uHwbOnSvxh1KHh1H/FbZtC6VdS78eT0XqNg4IH0XoOrUdEy+TQgPa
         ZEM2b6flv03e/c29gGhYoe6EjZLPm4+mfCdIBEVYxjlwYFxKy1yN9Z/lAu4LMMtq9MXd
         jpRHecOvI1RSKCq5ClSkWzTTEXILtQI0quPgB333oCcEHQ0xuRd+GQLp2YtzttaHVMVL
         DKmZgc/uHlOJmX4sqnMCK17wsRJI334IXITZQn+yxyBjGaFvcIYids33hCGVl/suWIGW
         B62GMdcvZuikQaknNzmjwY+9Xz48256PYIprxorciYjW9efwfkjgv3GX6QNxeMXpPBrT
         Jdsw==
X-Forwarded-Encrypted: i=1; AJvYcCUQtIbEAy/c0FbJO1p0TpXHpfUTRPotSxRYsbHuf4OWz8eRPIMlXAz3NPN5bjqprZfeDAwELSIgegKjuhsf5R8AlsBTVVxD9AY=
X-Gm-Message-State: AOJu0YzVSWdTFuVIC1msxZrAq7W+VhMQ7+gk25iaFqeMO3ix93cYfP0N
	uQmdpS8nL39E39ovR2rowoIzFQRQ0hObBLW5hCEWvvoXt0q9tXl3rNHJ5JVsOQ==
X-Google-Smtp-Source: AGHT+IF6tklWOylUTS1UEDno/7QyHEfpcQ9UJz6XptzNyZPKu+upsSY/4Wln6nxMJzW7adK8zA6cVA==
X-Received: by 2002:ac8:5747:0:b0:432:ec1e:efc3 with SMTP id 7-20020ac85747000000b00432ec1eefc3mr15876571qtx.7.1713281345362;
        Tue, 16 Apr 2024 08:29:05 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id x26-20020ac84d5a000000b00436c05b12a6sm4509361qtv.60.2024.04.16.08.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Apr 2024 08:29:04 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: ming.lei@redhat.com
Cc: brauner@kernel.org,
	czhong@redhat.com,
	dm-devel@lists.linux.dev,
	jack@suse.cz,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH v2] dm: restore synchronous close of device mapper block device
Date: Tue, 16 Apr 2024 11:28:42 -0400
Message-Id: <20240416152842.13933-1-snitzer@kernel.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20240416005633.877153-1-ming.lei@redhat.com>
References: <20240416005633.877153-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ming Lei <ming.lei@redhat.com>

'dmsetup remove' and 'dmsetup remove_all' require synchronous bdev
release. Otherwise dm_lock_for_deletion() may return -EBUSY if the open
count is > 0, because the open count is dropped in dm_blk_close()
which occurs after fput() completes.

So if dm_blk_close() is delayed because of asynchronous fput(), this
device mapper device is skipped during remove, which is a regression.

Fix the issue by using __fput_sync().

Also: DM device removal has long supported being made asynchronous by
setting the DMF_DEFERRED_REMOVE flag on the DM device. So leverage
using async fput() in close_table_device() if DMF_DEFERRED_REMOVE flag
is set.

Reported-by: Zhong Changhui <czhong@redhat.com>
Fixes: a28d893eb327 ("md: port block device access to file")
Suggested-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
[snitzer: editted commit header, use fput() if DMF_DEFERRED_REMOVE set]
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 56aa2a8b9d71..7d0746b37c8e 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -765,7 +765,7 @@ static struct table_device *open_table_device(struct mapped_device *md,
 	return td;
 
 out_blkdev_put:
-	fput(bdev_file);
+	__fput_sync(bdev_file);
 out_free_td:
 	kfree(td);
 	return ERR_PTR(r);
@@ -778,7 +778,13 @@ static void close_table_device(struct table_device *td, struct mapped_device *md
 {
 	if (md->disk->slave_dir)
 		bd_unlink_disk_holder(td->dm_dev.bdev, md->disk);
-	fput(td->dm_dev.bdev_file);
+
+	/* Leverage async fput() if DMF_DEFERRED_REMOVE set */
+	if (unlikely(test_bit(DMF_DEFERRED_REMOVE, &md->flags)))
+		fput(td->dm_dev.bdev_file);
+	else
+		__fput_sync(td->dm_dev.bdev_file);
+
 	put_dax(td->dm_dev.dax_dev);
 	list_del(&td->list);
 	kfree(td);
-- 
2.40.0

