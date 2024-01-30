Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CC365BD6
	for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 09:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706605995; cv=none; b=Bn9M9scHCZ1hpkriHH7KEXYmWMnrMT9E6i0ZpcS3cYBZCvvelrxl1PigdE85yuhHWZU+rOnGwE+EvjIillsRgvp48CbGj4Decr/SYjMh1uBbdM1hJ8DU5blO/ppWMh2D6zKSK9XXlyHsxJS8KV8FX9j7raw+G9yn0unSYNXLV6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706605995; c=relaxed/simple;
	bh=iJp3fdu0fy1eOcOxILeo5Du4UmNzi0oWDAcs0eGthNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IdYvenNs4w+3kZnwM/TTDyAhJcblUpzc2bA5YlGaRkad/sFCmXHds1qb8GFgHo/o9gkuNjV+GlsCwRJtiGnnonSoejof3SSeNjKMhIbZFZmK7k8oAd1sNXW1XDunVjmkbkXpaINWh2fglm5MnXDPT5kpNIaSMRy4REXq7Sq6AgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GbGh7etk; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GbGh7etk"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6ddc2a78829so1488059b3a.3
        for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 01:13:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706605993; x=1707210793; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/gc+JDMFysloX3bLK8Ab7sB4XneQUnO5q2M+huTrtLI=;
        b=GbGh7etkth29pnebXmAqx6kzqzn8TwXqdJDYCSLTfqLsqfhul8C2ZOWyp/Kg6ZivLt
         NygP1HAhO7/sHghwnIElxSP4oF1C/uIoiWHm4EmuKA9CJCYOcYdyb/uwK8jDMGMwHVjb
         P1TXnJtrciLQo5IUwGdK1BKD6+x2REQwJlDNHInslAZVGl6PKX0ZyLuBuHJdZ1WsLURN
         qTIUvevj2WrcWFAp0hrwieoBeTltEhUgkoRCVeSXKHxDM61IWy5B0DIcCzEbG3c/64Yo
         7ZVxKjZFETt3SRGfDI043e7rokQTjEKe5lY2q6BEWfIsDhUUILjphOBuGJsZS0cUN2mm
         bTXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706605993; x=1707210793;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/gc+JDMFysloX3bLK8Ab7sB4XneQUnO5q2M+huTrtLI=;
        b=I3uwuKgHlGI5Ogp0PKG42X0roOtDSyqwffRBCJHepnsKpFdW0uTJzwaI3s9rJRYjVj
         LSgw+NyJmvcs2OzqDvpTNURdSOEMzDcXsAneQp92+aWRj5d6D4IB0OF+iocJV2jccXlK
         K5fJdMiIJavk2fYkALyqLC7jPOpVlj9V8Vr6rlR8wkHTUgTqlGEoNf3aOLzGXyid+Fue
         YDaotdzJE8E9lXnLUsunP2zf3dXudJP6dnQiNPdnbn0nFGt49WFhB/pq0FTNRlhXP1tn
         fAxdQX8DcNhU72e/WNFXCwG2jHjtoNlHUWdq2FcPrTHNXf976BE6Yk+1KbqL6JOgXvMu
         YGZw==
X-Gm-Message-State: AOJu0YyjKxFdRI5qQuCblcy/UGW4o+UUoJ+cxKlzcNL9D9Mj0v10rhWb
	nMTAa5vP0wwtatbZHaryOVaD3/1ycCqJZP+qqD6ff7UQrIdBEdLp
X-Google-Smtp-Source: AGHT+IEMPeN+mDQxL1EgLPRL8abGu/7KopEZVJSkRj9KwItNcvpwt/WNottFX3ZGHhox/BltgpoPPA==
X-Received: by 2002:a05:6a00:cce:b0:6de:2f36:8284 with SMTP id b14-20020a056a000cce00b006de2f368284mr3510669pfv.3.1706605992637;
        Tue, 30 Jan 2024 01:13:12 -0800 (PST)
Received: from localhost (dhcp-141-239-144-21.hawaiiantel.net. [141.239.144.21])
        by smtp.gmail.com with ESMTPSA id lo18-20020a056a003d1200b006dde0b7d633sm7301241pfb.77.2024.01.30.01.13.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jan 2024 01:13:12 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org,
	mpatocka@redhat.com
Cc: linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	msnitzer@redhat.com,
	ignat@cloudflare.com,
	damien.lemoal@wdc.com,
	bob.liu@oracle.com,
	houtao1@huawei.com,
	peterz@infradead.org,
	mingo@kernel.org,
	netdev@vger.kernel.org,
	allen.lkml@gmail.com,
	kernel-team@meta.com,
	Tejun Heo <tj@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-usb@vger.kernel.org
Subject: [PATCH 5/8] usb: core: hcd: Convert from tasklet to BH workqueue
Date: Mon, 29 Jan 2024 23:11:52 -1000
Message-ID: <20240130091300.2968534-6-tj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240130091300.2968534-1-tj@kernel.org>
References: <20240130091300.2968534-1-tj@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The only generic interface to execute asynchronously in the BH context is
tasklet; however, it's marked deprecated and has some design flaws. To
replace tasklets, BH workqueue support was recently added. A BH workqueue
behaves similarly to regular workqueues except that the queued work items
are executed in the BH context.

This patch converts usb hcd from tasklet to BH workqueue.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org
---
 drivers/usb/core/hcd.c  | 23 ++++++++++++-----------
 include/linux/usb/hcd.h |  2 +-
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 12b6dfeaf658..edf74458474a 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1664,9 +1664,10 @@ static void __usb_hcd_giveback_urb(struct urb *urb)
 	usb_put_urb(urb);
 }
 
-static void usb_giveback_urb_bh(struct tasklet_struct *t)
+static void usb_giveback_urb_bh(struct work_struct *work)
 {
-	struct giveback_urb_bh *bh = from_tasklet(bh, t, bh);
+	struct giveback_urb_bh *bh =
+		container_of(work, struct giveback_urb_bh, bh);
 	struct list_head local_list;
 
 	spin_lock_irq(&bh->lock);
@@ -1691,9 +1692,9 @@ static void usb_giveback_urb_bh(struct tasklet_struct *t)
 	spin_lock_irq(&bh->lock);
 	if (!list_empty(&bh->head)) {
 		if (bh->high_prio)
-			tasklet_hi_schedule(&bh->bh);
+			queue_work(system_bh_highpri_wq, &bh->bh);
 		else
-			tasklet_schedule(&bh->bh);
+			queue_work(system_bh_wq, &bh->bh);
 	}
 	bh->running = false;
 	spin_unlock_irq(&bh->lock);
@@ -1706,7 +1707,7 @@ static void usb_giveback_urb_bh(struct tasklet_struct *t)
  * @status: completion status code for the URB.
  *
  * Context: atomic. The completion callback is invoked in caller's context.
- * For HCDs with HCD_BH flag set, the completion callback is invoked in tasklet
+ * For HCDs with HCD_BH flag set, the completion callback is invoked in BH
  * context (except for URBs submitted to the root hub which always complete in
  * caller's context).
  *
@@ -1725,7 +1726,7 @@ void usb_hcd_giveback_urb(struct usb_hcd *hcd, struct urb *urb, int status)
 	struct giveback_urb_bh *bh;
 	bool running;
 
-	/* pass status to tasklet via unlinked */
+	/* pass status to BH via unlinked */
 	if (likely(!urb->unlinked))
 		urb->unlinked = status;
 
@@ -1747,9 +1748,9 @@ void usb_hcd_giveback_urb(struct usb_hcd *hcd, struct urb *urb, int status)
 	if (running)
 		;
 	else if (bh->high_prio)
-		tasklet_hi_schedule(&bh->bh);
+		queue_work(system_bh_highpri_wq, &bh->bh);
 	else
-		tasklet_schedule(&bh->bh);
+		queue_work(system_bh_wq, &bh->bh);
 }
 EXPORT_SYMBOL_GPL(usb_hcd_giveback_urb);
 
@@ -2540,7 +2541,7 @@ static void init_giveback_urb_bh(struct giveback_urb_bh *bh)
 
 	spin_lock_init(&bh->lock);
 	INIT_LIST_HEAD(&bh->head);
-	tasklet_setup(&bh->bh, usb_giveback_urb_bh);
+	INIT_WORK(&bh->bh, usb_giveback_urb_bh);
 }
 
 struct usb_hcd *__usb_create_hcd(const struct hc_driver *driver,
@@ -2926,7 +2927,7 @@ int usb_add_hcd(struct usb_hcd *hcd,
 			&& device_can_wakeup(&hcd->self.root_hub->dev))
 		dev_dbg(hcd->self.controller, "supports USB remote wakeup\n");
 
-	/* initialize tasklets */
+	/* initialize BHs */
 	init_giveback_urb_bh(&hcd->high_prio_bh);
 	hcd->high_prio_bh.high_prio = true;
 	init_giveback_urb_bh(&hcd->low_prio_bh);
@@ -3036,7 +3037,7 @@ void usb_remove_hcd(struct usb_hcd *hcd)
 	mutex_unlock(&usb_bus_idr_lock);
 
 	/*
-	 * tasklet_kill() isn't needed here because:
+	 * flush_work() isn't needed here because:
 	 * - driver's disconnect() called from usb_disconnect() should
 	 *   make sure its URBs are completed during the disconnect()
 	 *   callback
diff --git a/include/linux/usb/hcd.h b/include/linux/usb/hcd.h
index 00724b4f6e12..f698aac71de3 100644
--- a/include/linux/usb/hcd.h
+++ b/include/linux/usb/hcd.h
@@ -55,7 +55,7 @@ struct giveback_urb_bh {
 	bool high_prio;
 	spinlock_t lock;
 	struct list_head  head;
-	struct tasklet_struct bh;
+	struct work_struct bh;
 	struct usb_host_endpoint *completing_ep;
 };
 
-- 
2.43.0

