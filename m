Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB2329BDBB;
	Mon, 15 Jun 2026 20:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781554165; cv=none; b=OEUNWmDb/0FdvUqNLDEsVM7WKnWMVj6Q3aWDn7VKXyqaSm/wUxYC4wPYkTgmBObLZr3YQKM0t3vT8g1Lb+nZx3gQk3FUfR+n6G07+03jEpmMqcd9FTk0rPMQcK0aQugNTVhlLHyzuvSxHFk6Deo6Fa+/+lrYQVNdV8nGLD1ah64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781554165; c=relaxed/simple;
	bh=tSs2qRaNnzRJ5YYbjRMZFlsY6LW0L1FgXhiTZaYrr08=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OpxR1lS131aNFMaxcuehL6isSWL0HM/DLmuAraEuPtbvLLZIkb/x92LdtnRWy5SCGWZXRkscCCtu2/2OeK8M8HXcvG4xKNO4kzq1xI0pZCusMj5rIiMATH+AccGSvffaZgeGWACcKtiIOnswSb+72spRwfGr8qmtxDn1I0LbJn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iX/IoOhh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iX/IoOhh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E1E1F000E9;
	Mon, 15 Jun 2026 20:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781554163;
	bh=wRM/WXOkYOKh+4JQuuVRGyzwmONOzjZ44ML9KD6gb8c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iX/IoOhhGGEH6jOnE2wT1iChsVfdz02XSJ1YuPTm9po53Pa8vv+elrfwJ9eV8Hf9T
	 QqIrwZXrhza+OyOskZO5m7kWgJwqZV6ZaTz5hA5JwtMaTGtrj2y3Qw1ybqOLxbY0gG
	 Xhie2QLaCCqoFzM8Oha06UCFRkhqI2uoMH1Ugy3oqArYZrlB7S+FFBGaCW4g2zwBEW
	 d2FRkgNt114lnXtK7RgWwPBWwAjRN9eMO7zEgtvpiH87bUMm3LIZBaY7cvPxuPEJZH
	 4g4XoTFcToyWtU9b95Mu3m80n+qpnobltkZFNmkBxQ9407u/etJ+2GZtgSWMz8laAB
	 OxOy0MICeK6hA==
Date: Mon, 15 Jun 2026 14:09:22 -0600
From: Keith Busch <kbusch@kernel.org>
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: linux-block@vger.kernel.org, dm-devel@lists.linux.dev
Subject: Re: Repeatable, raid1+O_DIRECT, hang/warn
Message-ID: <ajBb8tK-0aJBpIgF@kbusch-mbp>
References: <ai7rnH20IYeSmY8s@gallifrey>
 <ajAYN_mmjzYBAimV@kbusch-mbp>
 <ajAb0m9cNraQn2Pw@kbusch-mbp>
 <ajAqUwo3eTm1c2_J@gallifrey>
 <ajA0L-u-r4nhbpfl@kbusch-mbp>
 <ajA5kpUraXqh9ag9@gallifrey>
 <ajBRnUqXd7DqxLiG@kbusch-mbp>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajBRnUqXd7DqxLiG@kbusch-mbp>

On Mon, Jun 15, 2026 at 01:25:17PM -0600, Keith Busch wrote:
> In the meantime, since I so far can't reproduce this after including my
> previous proposal, I may have to request trying out a debug patch to get
> some more visibility on what's happening if that's okay.

Going in a different direction here, there's no reason to recreate the
lower level bio's from scratch when they originate from an incoming bio.
We can just clone it along with an iterator pointing to the original.

Can you try this one out? This was successful when I ran your reproducer
and cuts out a lot of code too with a performance bonus for large IO.

---
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 1db565b376200..28adfeb58f240 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -170,12 +170,11 @@ struct dpages {
 			 struct page **p, unsigned long *len, unsigned int *offset);
 	void (*next_page)(struct dpages *dp);
 
-	union {
-		unsigned int context_u;
-		struct bvec_iter context_bi;
-	};
+	unsigned int context_u;
 	void *context_ptr;
 
+	struct bio *orig_bio;
+
 	void *vma_invalidate_address;
 	unsigned long vma_invalidate_size;
 };
@@ -210,44 +209,6 @@ static void list_dp_init(struct dpages *dp, struct page_list *pl, unsigned int o
 	dp->context_ptr = pl;
 }
 
-/*
- * Functions for getting the pages from a bvec.
- */
-static void bio_get_page(struct dpages *dp, struct page **p,
-			 unsigned long *len, unsigned int *offset)
-{
-	struct bio_vec bvec = bvec_iter_bvec((struct bio_vec *)dp->context_ptr,
-					     dp->context_bi);
-
-	*p = bvec.bv_page;
-	*len = bvec.bv_len;
-	*offset = bvec.bv_offset;
-
-	/* avoid figuring it out again in bio_next_page() */
-	dp->context_bi.bi_sector = (sector_t)bvec.bv_len;
-}
-
-static void bio_next_page(struct dpages *dp)
-{
-	unsigned int len = (unsigned int)dp->context_bi.bi_sector;
-
-	bvec_iter_advance((struct bio_vec *)dp->context_ptr,
-			  &dp->context_bi, len);
-}
-
-static void bio_dp_init(struct dpages *dp, struct bio *bio)
-{
-	dp->get_page = bio_get_page;
-	dp->next_page = bio_next_page;
-
-	/*
-	 * We just use bvec iterator to retrieve pages, so it is ok to
-	 * access the bvec table directly here
-	 */
-	dp->context_ptr = bio->bi_io_vec;
-	dp->context_bi = bio->bi_iter;
-}
-
 /*
  * Functions for getting the pages from a VMA.
  */
@@ -332,6 +293,21 @@ static void do_region(const blk_opf_t opf, unsigned int region,
 		return;
 	}
 
+	if (dp->orig_bio) {
+		bio = bio_alloc_clone(where->bdev, dp->orig_bio, GFP_NOIO,
+				      &io->client->bios);
+		bio->bi_iter.bi_sector = where->sector;
+		bio->bi_iter.bi_size = where->count << SECTOR_SHIFT;
+		bio->bi_opf = opf;
+		bio->bi_end_io = endio;
+		bio->bi_ioprio = ioprio;
+		store_io_and_region_in_bio(bio, io, region);
+
+		atomic_inc(&io->count);
+		submit_bio(bio);
+		return;
+	}
+
 	/*
 	 * where->count may be zero if op holds a flush and we need to
 	 * send a zero-sized flush.
@@ -468,6 +444,7 @@ static int dp_init(struct dm_io_request *io_req, struct dpages *dp,
 
 	dp->vma_invalidate_address = NULL;
 	dp->vma_invalidate_size = 0;
+	dp->orig_bio = NULL;
 
 	switch (io_req->mem.type) {
 	case DM_IO_PAGE_LIST:
@@ -475,7 +452,11 @@ static int dp_init(struct dm_io_request *io_req, struct dpages *dp,
 		break;
 
 	case DM_IO_BIO:
-		bio_dp_init(dp, io_req->mem.ptr.bio);
+		/*
+		 * The destination bios clone this bio's biovec directly, so
+		 * there are no per-page accessors to set up here.
+		 */
+		dp->orig_bio = io_req->mem.ptr.bio;
 		break;
 
 	case DM_IO_VMA:
-- 
