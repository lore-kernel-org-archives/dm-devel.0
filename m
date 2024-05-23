Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46178B645
	for <dm-devel@lists.linux.dev>; Thu, 23 May 2024 14:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716476317; cv=none; b=AYJKxpnxXKgqrm2bQpzK5yW9eNaChebSgVxdnJwpCZO+ExfPCoiBxsJO1orcTAYhLdPYT0zKRbYXNG0oiSh0k5GBNwyEedXTP8QnkYZkQdz99zIA1PAyFX6v93OfjwCeb5HB6vflnONgEMWsRYbFbh2rT0o4gbJWx7L5mG6mgoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716476317; c=relaxed/simple;
	bh=oSneREWGG2ETnM/vj8hywylDGM2f94bRDcsr8f8ARQA=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=a8L31AzYmPHgNWIyMNritxloPQGFkFFNUkDwezcB1/l88/GN+YC2Lzg07GU8Sf1xw45x4GIjbppBfo6zxc8qlsxm0vu/ZMaNqSA8lZiyJ8rfCe0YKfaD5AiU2CXj+hwvKQ6wcTCnqLqdTCvh1rLty2UYdH4xweZ7z5BRnX8jKW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a1Vfq1C0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a1Vfq1C0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716476315;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jmUiY9ZEjEZGC2aGfwSm6xcWZAuN4JLkyu/tzL/ne3A=;
	b=a1Vfq1C0MlEHKfeJpr5/oQpGB4YA5Xib9wnRNu7Yn3bKRbTVUerDwqF/DJ6s75pbbnJeSc
	ll8cFh65F6PzF9xRdZvDS2hrzLbBgtEFV5bhCs1X7wSEm5aChyPHTSZ7fWf5ux4Whiotl4
	vX3fF9WQ4EZcE9QNdVSw7Yu9K19jIv4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-613-tewdWmgVOpuCWGIP_MSJ5g-1; Thu,
 23 May 2024 10:58:31 -0400
X-MC-Unique: tewdWmgVOpuCWGIP_MSJ5g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 37ED429AA386;
	Thu, 23 May 2024 14:58:31 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1029440004D;
	Thu, 23 May 2024 14:58:31 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id EFD8930C1C33; Thu, 23 May 2024 14:58:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id EBDAF3FB4F;
	Thu, 23 May 2024 16:58:30 +0200 (CEST)
Date: Thu, 23 May 2024 16:58:30 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
cc: Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Sagi Grimberg <sagi@grimberg.me>, Mike Snitzer <snitzer@kernel.org>, 
    Milan Broz <gmazyland@gmail.com>, linux-block@vger.kernel.org, 
    dm-devel@lists.linux.dev, linux-nvme@lists.infradead.org
Subject: [PATCH v2] block: change rq_integrity_vec to respect the iterator
In-Reply-To: <8522af2f-fb97-4d0b-9e38-868c572da18a@kernel.dk>
Message-ID: <7060a917-6537-4334-4961-601a182bca54@redhat.com>
References: <f85e3824-5545-f541-c96d-4352585288a@redhat.com> <c366231-e146-5a2b-1d8a-5936fb2047ca@redhat.com> <8522af2f-fb97-4d0b-9e38-868c572da18a@kernel.dk>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10



On Wed, 15 May 2024, Jens Axboe wrote:

> On 5/15/24 7:28 AM, Mikulas Patocka wrote:
> > @@ -177,9 +177,9 @@ static inline int blk_integrity_rq(struc
> >  	return 0;
> >  }
> >  
> > -static inline struct bio_vec *rq_integrity_vec(struct request *rq)
> > +static inline struct bio_vec rq_integrity_vec(struct request *rq)
> >  {
> > -	return NULL;
> > +	BUG();
> >  }
> >  #endif /* CONFIG_BLK_DEV_INTEGRITY */
> >  #endif /* _LINUX_BLK_INTEGRITY_H */
> 
> Let's please not do that. If it's not used outside of
> CONFIG_BLK_DEV_INTEGRITY, it should just go away.
> 
> -- 
> Jens Axboe

Here I'm resending the patch with the function rq_integrity_vec removed if 
CONFIG_BLK_DEV_INTEGRITY is not defined.

Mikulas


From: Mikulas Patocka <mpatocka@redhat.com>

If we allocate a bio that is larger than NVMe maximum request size, attach
integrity metadata to it and send it to the NVMe subsystem, the integrity
metadata will be corrupted.

Splitting the bio works correctly. The function bio_split will clone the
bio, trim the iterator of the first bio and advance the iterator of the
second bio.

However, the function rq_integrity_vec has a bug - it returns the first
vector of the bio's metadata and completely disregards the metadata
iterator that was advanced when the bio was split. Thus, the second bio
uses the same metadata as the first bio and this leads to metadata
corruption.

This commit changes rq_integrity_vec, so that it calls mp_bvec_iter_bvec
instead of returning the first vector. mp_bvec_iter_bvec reads the
iterator and advances the vector by the iterator.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/nvme/host/pci.c       |   14 +++++++++++---
 include/linux/blk-integrity.h |   12 ++++--------
 2 files changed, 15 insertions(+), 11 deletions(-)

Index: linux-2.6/drivers/nvme/host/pci.c
===================================================================
--- linux-2.6.orig/drivers/nvme/host/pci.c
+++ linux-2.6/drivers/nvme/host/pci.c
@@ -821,18 +821,20 @@ out_free_sg:
 	return ret;
 }
 
+#ifdef CONFIG_BLK_DEV_INTEGRITY
 static blk_status_t nvme_map_metadata(struct nvme_dev *dev, struct request *req,
 		struct nvme_command *cmnd)
 {
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
+	struct bio_vec bv = rq_integrity_vec(req);
 
-	iod->meta_dma = dma_map_bvec(dev->dev, rq_integrity_vec(req),
-			rq_dma_dir(req), 0);
+	iod->meta_dma = dma_map_bvec(dev->dev, &bv, rq_dma_dir(req), 0);
 	if (dma_mapping_error(dev->dev, iod->meta_dma))
 		return BLK_STS_IOERR;
 	cmnd->rw.metadata = cpu_to_le64(iod->meta_dma);
 	return BLK_STS_OK;
 }
+#endif
 
 static blk_status_t nvme_prep_rq(struct nvme_dev *dev, struct request *req)
 {
@@ -853,16 +855,20 @@ static blk_status_t nvme_prep_rq(struct
 			goto out_free_cmd;
 	}
 
+#ifdef CONFIG_BLK_DEV_INTEGRITY
 	if (blk_integrity_rq(req)) {
 		ret = nvme_map_metadata(dev, req, &iod->cmd);
 		if (ret)
 			goto out_unmap_data;
 	}
+#endif
 
 	nvme_start_request(req);
 	return BLK_STS_OK;
+#ifdef CONFIG_BLK_DEV_INTEGRITY
 out_unmap_data:
 	nvme_unmap_data(dev, req);
+#endif
 out_free_cmd:
 	nvme_cleanup_cmd(req);
 	return ret;
@@ -962,12 +968,14 @@ static __always_inline void nvme_pci_unm
 	struct nvme_queue *nvmeq = req->mq_hctx->driver_data;
 	struct nvme_dev *dev = nvmeq->dev;
 
+#ifdef CONFIG_BLK_DEV_INTEGRITY
 	if (blk_integrity_rq(req)) {
 	        struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
 
 		dma_unmap_page(dev->dev, iod->meta_dma,
-			       rq_integrity_vec(req)->bv_len, rq_dma_dir(req));
+			       rq_integrity_vec(req).bv_len, rq_dma_dir(req));
 	}
+#endif
 
 	if (blk_rq_nr_phys_segments(req))
 		nvme_unmap_data(dev, req);
Index: linux-2.6/include/linux/blk-integrity.h
===================================================================
--- linux-2.6.orig/include/linux/blk-integrity.h
+++ linux-2.6/include/linux/blk-integrity.h
@@ -109,11 +109,11 @@ static inline bool blk_integrity_rq(stru
  * Return the first bvec that contains integrity data.  Only drivers that are
  * limited to a single integrity segment should use this helper.
  */
-static inline struct bio_vec *rq_integrity_vec(struct request *rq)
+static inline struct bio_vec rq_integrity_vec(struct request *rq)
 {
-	if (WARN_ON_ONCE(queue_max_integrity_segments(rq->q) > 1))
-		return NULL;
-	return rq->bio->bi_integrity->bip_vec;
+	WARN_ON_ONCE(queue_max_integrity_segments(rq->q) > 1);
+	return mp_bvec_iter_bvec(rq->bio->bi_integrity->bip_vec,
+				 rq->bio->bi_integrity->bip_iter);
 }
 #else /* CONFIG_BLK_DEV_INTEGRITY */
 static inline int blk_rq_count_integrity_sg(struct request_queue *q,
@@ -177,9 +177,5 @@ static inline int blk_integrity_rq(struc
 	return 0;
 }
 
-static inline struct bio_vec *rq_integrity_vec(struct request *rq)
-{
-	return NULL;
-}
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
 #endif /* _LINUX_BLK_INTEGRITY_H */

