Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43DC1DDE4
	for <dm-devel@lists.linux.dev>; Thu,  2 Nov 2023 17:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GxoeYRDF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698944797;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0UeuJsv4XGxr7QngFqmHvnq1CZ9BvM92/cz1tGmQL4A=;
	b=GxoeYRDFfbVLSCj9q0z/OtWF5/jRmlmcT2EUIcltsoTCWM1r205oRU5oF8buz+s1sL3qGk
	JrJBE7S6kSJiIdRDR0ik785T61pdf9SxJsGb9lO+oLCPXGm0AKSJ/L+mYHRnRiabKuKVSW
	JLUyse21fTJZs0lSxvWNUKzWY4kITAI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-573-8By9kwQ-OE-0s75BmH0nag-1; Thu, 02 Nov 2023 13:06:34 -0400
X-MC-Unique: 8By9kwQ-OE-0s75BmH0nag-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 51E9A85A58C;
	Thu,  2 Nov 2023 17:06:33 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B13B1C060BA;
	Thu,  2 Nov 2023 17:06:33 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 1369D30C72A4; Thu,  2 Nov 2023 17:06:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 0ED763FD17;
	Thu,  2 Nov 2023 18:06:33 +0100 (CET)
Date: Thu, 2 Nov 2023 18:06:33 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: =?ISO-8859-15?Q?Marek_Marczykowski-G=F3recki?= <marmarek@invisiblethingslab.com>
cc: Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>, 
    Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
    Jan Kara <jack@suse.cz>, Vlastimil Babka <vbabka@suse.cz>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, 
    stable@vger.kernel.org, regressions@lists.linux.dev, 
    Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev, linux-mm@kvack.org
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5
In-Reply-To: <ZUOL8kXVTF1OngeN@mail-itl>
Message-ID: <3cb4133c-b6db-9187-a678-11ed8c9456e@redhat.com>
References: <20231030155603.k3kejytq2e4vnp7z@quack3> <ZT/e/EaBIkJEgevQ@mail-itl> <98aefaa9-1ac-a0e4-fb9a-89ded456750@redhat.com> <ZUB5HFeK3eHeI8UH@mail-itl> <20231031140136.25bio5wajc5pmdtl@quack3> <ZUEgWA5P8MFbyeBN@mail-itl> <8a35cdea-3a1a-e859-1f7c-55d1c864a48@redhat.com>
 <ebbc7ca7-5169-dbdc-9ea8-c6d8c3ae31e2@redhat.com> <ZULvkPhcpgAVyI8w@mail-itl> <ac5b5ac0-9e8-c1b0-a26-62f832f845f0@redhat.com> <ZUOL8kXVTF1OngeN@mail-itl>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="185210117-1922301100-1698942373=:543920"
Content-ID: <752ad75f-d113-13e4-4fc9-bfe050665852@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--185210117-1922301100-1698942373=:543920
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <84311bc9-9f3-6568-af7e-549ca0e53215@redhat.com>



On Thu, 2 Nov 2023, Marek Marczykowski-Górecki wrote:

> On Thu, Nov 02, 2023 at 10:28:57AM +0100, Mikulas Patocka wrote:
> 
> > Try lowring /sys/block/nvme0n1/queue/max_sectors_kb to some small value 
> > (for example 64) and test if it helps.
> 
> Yes, this helps too.

On a plain upstream kernel with no other modifications (and with default 
max_sectors_kb), set the value /sys/module/nvme/parameters/sgl_threshold 
to "0" and test it if it deadlocks. Then, set this value to "1" and test 
it again.

Revert sgl_threshold back to the default (32768). Boot the kernel with the 
option "iommu=panic". Reproduce the deadlock and if you get a kernel 
panic, send us the panic log.

Then, try this patch (without "iommu=panic"), reproduce the deadlock and 
tell us which one of the "printk" statements is triggered during the 
deadlock.

Mikulas

---
 drivers/nvme/host/core.c |    8 ++++++--
 drivers/nvme/host/pci.c  |   27 ++++++++++++++++++++++-----
 2 files changed, 28 insertions(+), 7 deletions(-)

Index: linux-stable/drivers/nvme/host/pci.c
===================================================================
--- linux-stable.orig/drivers/nvme/host/pci.c	2023-10-31 15:35:38.000000000 +0100
+++ linux-stable/drivers/nvme/host/pci.c	2023-11-02 17:38:20.000000000 +0100
@@ -622,6 +622,10 @@ static blk_status_t nvme_pci_setup_prps(
 	prp_list = dma_pool_alloc(pool, GFP_ATOMIC, &prp_dma);
 	if (!prp_list) {
 		iod->nr_allocations = -1;
+		if (nprps <= (256 / 8))
+			printk("allocation failure at %d\n", __LINE__);
+		else
+			printk("allocation failure at %d\n", __LINE__);
 		return BLK_STS_RESOURCE;
 	}
 	iod->list[0].prp_list = prp_list;
@@ -631,8 +635,10 @@ static blk_status_t nvme_pci_setup_prps(
 		if (i == NVME_CTRL_PAGE_SIZE >> 3) {
 			__le64 *old_prp_list = prp_list;
 			prp_list = dma_pool_alloc(pool, GFP_ATOMIC, &prp_dma);
-			if (!prp_list)
+			if (!prp_list) {
+				printk("allocation failure at %d\n", __LINE__);
 				goto free_prps;
+			}
 			iod->list[iod->nr_allocations++].prp_list = prp_list;
 			prp_list[0] = old_prp_list[i - 1];
 			old_prp_list[i - 1] = cpu_to_le64(prp_dma);
@@ -712,6 +718,7 @@ static blk_status_t nvme_pci_setup_sgls(
 	sg_list = dma_pool_alloc(pool, GFP_ATOMIC, &sgl_dma);
 	if (!sg_list) {
 		iod->nr_allocations = -1;
+		printk("allocation failure at %d\n", __LINE__);
 		return BLK_STS_RESOURCE;
 	}
 
@@ -736,8 +743,10 @@ static blk_status_t nvme_setup_prp_simpl
 	unsigned int first_prp_len = NVME_CTRL_PAGE_SIZE - offset;
 
 	iod->first_dma = dma_map_bvec(dev->dev, bv, rq_dma_dir(req), 0);
-	if (dma_mapping_error(dev->dev, iod->first_dma))
+	if (dma_mapping_error(dev->dev, iod->first_dma)) {
+		printk("allocation failure at %d\n", __LINE__);
 		return BLK_STS_RESOURCE;
+	}
 	iod->dma_len = bv->bv_len;
 
 	cmnd->dptr.prp1 = cpu_to_le64(iod->first_dma);
@@ -755,8 +764,10 @@ static blk_status_t nvme_setup_sgl_simpl
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
 
 	iod->first_dma = dma_map_bvec(dev->dev, bv, rq_dma_dir(req), 0);
-	if (dma_mapping_error(dev->dev, iod->first_dma))
+	if (dma_mapping_error(dev->dev, iod->first_dma)) {
+		printk("allocation failure at %d\n", __LINE__);
 		return BLK_STS_RESOURCE;
+	}
 	iod->dma_len = bv->bv_len;
 
 	cmnd->flags = NVME_CMD_SGL_METABUF;
@@ -791,8 +802,10 @@ static blk_status_t nvme_map_data(struct
 
 	iod->dma_len = 0;
 	iod->sgt.sgl = mempool_alloc(dev->iod_mempool, GFP_ATOMIC);
-	if (!iod->sgt.sgl)
+	if (!iod->sgt.sgl) {
+		printk("allocation failure at %d\n", __LINE__);
 		return BLK_STS_RESOURCE;
+	}
 	sg_init_table(iod->sgt.sgl, blk_rq_nr_phys_segments(req));
 	iod->sgt.orig_nents = blk_rq_map_sg(req->q, req, iod->sgt.sgl);
 	if (!iod->sgt.orig_nents)
@@ -801,8 +814,12 @@ static blk_status_t nvme_map_data(struct
 	rc = dma_map_sgtable(dev->dev, &iod->sgt, rq_dma_dir(req),
 			     DMA_ATTR_NO_WARN);
 	if (rc) {
-		if (rc == -EREMOTEIO)
+		if (rc == -EREMOTEIO) {
+			printk("allocation failure at %d\n", __LINE__);
 			ret = BLK_STS_TARGET;
+		} else {
+			printk("allocation failure at %d\n", __LINE__);
+		}
 		goto out_free_sg;
 	}
 
Index: linux-stable/drivers/nvme/host/core.c
===================================================================
--- linux-stable.orig/drivers/nvme/host/core.c	2023-10-31 15:35:38.000000000 +0100
+++ linux-stable/drivers/nvme/host/core.c	2023-11-02 17:12:39.000000000 +0100
@@ -708,8 +708,10 @@ blk_status_t nvme_fail_nonready_command(
 	    ctrl->state != NVME_CTRL_DELETING &&
 	    ctrl->state != NVME_CTRL_DEAD &&
 	    !test_bit(NVME_CTRL_FAILFAST_EXPIRED, &ctrl->flags) &&
-	    !blk_noretry_request(rq) && !(rq->cmd_flags & REQ_NVME_MPATH))
+	    !blk_noretry_request(rq) && !(rq->cmd_flags & REQ_NVME_MPATH)) {
+		printk("allocation failure at %d\n", __LINE__);
 		return BLK_STS_RESOURCE;
+	}
 	return nvme_host_path_error(rq);
 }
 EXPORT_SYMBOL_GPL(nvme_fail_nonready_command);
@@ -784,8 +786,10 @@ static blk_status_t nvme_setup_discard(s
 		 * discard page. If that's also busy, it's safe to return
 		 * busy, as we know we can make progress once that's freed.
 		 */
-		if (test_and_set_bit_lock(0, &ns->ctrl->discard_page_busy))
+		if (test_and_set_bit_lock(0, &ns->ctrl->discard_page_busy)) {
+			printk("allocation failure at %d\n", __LINE__);
 			return BLK_STS_RESOURCE;
+		}
 
 		range = page_address(ns->ctrl->discard_page);
 	}
--185210117-1922301100-1698942373=:543920--

