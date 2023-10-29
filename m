Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE43D512;
	Sun, 29 Oct 2023 20:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fiST6Ivg";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Mdow0UmQ"
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A950F1FE7B;
	Sun, 29 Oct 2023 20:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1698609746; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a+mlAZHkXveu53BHYO2pmLq8ql1sbVoGFayTg1Oh0KA=;
	b=fiST6IvgoZIdmx9DkTg4Jsr5QsELiCPNnOHQwoj5n+r0mYE6rkA3zQwykgQxT3KI9TfOKJ
	YX8KHxfq9DFs29ig4JhtNq2cG4FSDIkwBczXVJYMAf9jNfggxRCBH4dFrw1n5N8nhU+wak
	5KE86uWVZOJHC8mKpo2X+2jr/tJFyo8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1698609746;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a+mlAZHkXveu53BHYO2pmLq8ql1sbVoGFayTg1Oh0KA=;
	b=Mdow0UmQrZQW1NV8ErMqBdWwHXRLFrMxjKTF3f+IP3xmy7uyM4hixHbdhNYQUqawSmgGki
	lfPAHDmI9GJQ3rAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8052E1391D;
	Sun, 29 Oct 2023 20:02:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id II2SHlK6PmX8XQAAMHmgww
	(envelope-from <vbabka@suse.cz>); Sun, 29 Oct 2023 20:02:26 +0000
Message-ID: <89320668-67a2-2a41-e577-a2f561e3dfdd@suse.cz>
Date: Sun, 29 Oct 2023 21:02:26 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5
To: Mikulas Patocka <mpatocka@redhat.com>,
 =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?=
 <marmarek@invisiblethingslab.com>, Andrew Morton
 <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>,
 Michal Hocko <mhocko@suse.com>
Cc: stable@vger.kernel.org, regressions@lists.linux.dev,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@lists.linux.dev, linux-mm@kvack.org
References: <ZTNH0qtmint/zLJZ@mail-itl>
 <e427823c-e869-86a2-3549-61b3fdf29537@redhat.com> <ZTiHQDY54E7WAld+@mail-itl>
 <ZTiJ3CO8w0jauOzW@mail-itl> <a413efbf-7194-95ff-562b-f2eb766ca5c1@redhat.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <a413efbf-7194-95ff-562b-f2eb766ca5c1@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/25/23 12:13, Mikulas Patocka wrote:
> So, I forward this to memory management maintainers.

Hi,

> What do you think? - We have a problem that if dm-crypt allocates pages 
> with order > 3 (PAGE_ALLOC_COSTLY_ORDER), the system occasionally freezes 
> waiting in writeback.

Hmm, so I've checked the backtraces provided and none seems to show the
actual allocating task doing the crypt_alloc_buffer(), do we know what it's
doing? Is it blocked or perhaps spinning in some infinite loop?

> dm-crypt allocates the pages with GFP_NOWAIT | __GFP_HIGHMEM | 
> __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN | __GFP_COMP, so it 
> shouldn't put any pressure on the system. If the allocations fails, it 
> falls back to smaller order allocation or to mempool as a last resort.

Right. I noticed it may also fallback to __GFP_DIRECT_RECLAIM but then it's
only order-0.

> When the freeze happens, there is "349264kB" free memory - so the system 
> is not short on memory.

Yeah, it may still be fragmented, although in [1] the sysqr show memory
report suggests it's not, pages do exist up to MAX_ORDER. Weird.

[1] https://lore.kernel.org/all/ZTiJ3CO8w0jauOzW@mail-itl/

> Should we restrict the dm-crypt allocation size to 
> PAGE_ALLOC_COSTLY_ORDER? Or is it a bug somewhere in memory management 
> system that needs to be fixes there?

Haven't found any. However I'd like to point out some things I noticed in
crypt_alloc_buffer(), although they are probably not related.

> static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned int size)
> {
> 	struct crypt_config *cc = io->cc;
> 	struct bio *clone;
> 	unsigned int nr_iovecs = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
> 	gfp_t gfp_mask = GFP_NOWAIT | __GFP_HIGHMEM;
> 	unsigned int remaining_size;
> 	unsigned int order = MAX_ORDER - 1;
> 
> retry:
> 	if (unlikely(gfp_mask & __GFP_DIRECT_RECLAIM))
> 		mutex_lock(&cc->bio_alloc_lock);

What if we end up in "goto retry" more than once? I don't see a matching
unlock. Yeah, very unlikely to happen that order-0 in page allocator which
includes __GFP_DIRECT_RECLAIM would fail, but not impossible, and also I see
crypt_page_alloc() for the mempool can fail for another reason, due to a
counter being too high. Looks dangerous.

> 
> 	clone = bio_alloc_bioset(cc->dev->bdev, nr_iovecs, io->base_bio->bi_opf,
> 				 GFP_NOIO, &cc->bs);
> 	clone->bi_private = io;
> 	clone->bi_end_io = crypt_endio;
> 
> 	remaining_size = size;
> 
> 	while (remaining_size) {
> 		struct page *pages;
> 		unsigned size_to_add;
> 		unsigned remaining_order = __fls((remaining_size + PAGE_SIZE - 1) >> PAGE_SHIFT);

Tip: you can use get_order(remaining_size) here.

> 		order = min(order, remaining_order);
> 
> 		while (order > 0) {

Is this intentionally > 0 and not >= 0? We could still succeed avoiding
mempool with order-0...

> 			pages = alloc_pages(gfp_mask
> 				| __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN | __GFP_COMP,
> 				order);
> 			if (likely(pages != NULL))
> 				goto have_pages;
> 			order--;
> 		}
> 
> 		pages = mempool_alloc(&cc->page_pool, gfp_mask);
> 		if (!pages) {
> 			crypt_free_buffer_pages(cc, clone);
> 			bio_put(clone);
> 			gfp_mask |= __GFP_DIRECT_RECLAIM;
> 			order = 0;
> 			goto retry;
> 		}
> 
> have_pages:
> 		size_to_add = min((unsigned)PAGE_SIZE << order, remaining_size);
> 		__bio_add_page(clone, pages, size_to_add, 0);
> 		remaining_size -= size_to_add;
> 	}
> 
> 	/* Allocate space for integrity tags */
> 	if (dm_crypt_integrity_io_alloc(io, clone)) {
> 		crypt_free_buffer_pages(cc, clone);
> 		bio_put(clone);
> 		clone = NULL;
> 	}
> 
> 	if (unlikely(gfp_mask & __GFP_DIRECT_RECLAIM))
> 		mutex_unlock(&cc->bio_alloc_lock);
> 
> 	return clone;
> }

