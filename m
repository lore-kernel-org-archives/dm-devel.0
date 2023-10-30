Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371452591;
	Mon, 30 Oct 2023 12:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="bbgPuYCQ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4MQfVbtv"
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8236821CDF;
	Mon, 30 Oct 2023 12:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1698667919; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vBfz81xIWn4r9V4YAbxU176YDt6pDqO8Q0c1xsiNSTs=;
	b=bbgPuYCQGGZlBaxvY7K6c7r0QzzAtjpsbwE6JJduB2M0DDiVDo7O5nqrh23dtypzj8jy4S
	ri8dMVQ0fJ2WW64D3/iaLJu3C0V/C8QXwrYQCukK90CJuGQzGlrvTn9A5INIkC+aO8IGBu
	cN74Z0cg764V3OM2GgMJjejQ5tq4jzo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1698667919;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vBfz81xIWn4r9V4YAbxU176YDt6pDqO8Q0c1xsiNSTs=;
	b=4MQfVbtv7w5IREapUP0Q3pFfdXNWL0Q4KAMVdpbmDTULNkynXCNedp28A/iZTgIm7QsAY2
	QMKbCk6OXqoQk9DQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 69F6F138F8;
	Mon, 30 Oct 2023 12:11:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id OH1YGY+dP2UIaAAAMHmgww
	(envelope-from <jack@suse.cz>); Mon, 30 Oct 2023 12:11:59 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id DE261A05BC; Mon, 30 Oct 2023 13:11:58 +0100 (CET)
Date: Mon, 30 Oct 2023 13:11:58 +0100
From: Jan Kara <jack@suse.cz>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Vlastimil Babka <vbabka@suse.cz>,
	Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org,
	regressions@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5
Message-ID: <20231030121158.c2lamlhskgoj7kgk@quack3>
References: <ZTNH0qtmint/zLJZ@mail-itl>
 <e427823c-e869-86a2-3549-61b3fdf29537@redhat.com>
 <ZTiHQDY54E7WAld+@mail-itl>
 <ZTiJ3CO8w0jauOzW@mail-itl>
 <a413efbf-7194-95ff-562b-f2eb766ca5c1@redhat.com>
 <89320668-67a2-2a41-e577-a2f561e3dfdd@suse.cz>
 <818a23f2-c242-1c51-232d-d479c3bcbb6@redhat.com>
 <18a38935-3031-1f35-bc36-40406e2e6fd2@suse.cz>
 <20231030112844.g7b76cm2xxpovt6e@quack3>
 <7355fe90-5176-ea11-d6ed-a187c0146fdc@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7355fe90-5176-ea11-d6ed-a187c0146fdc@redhat.com>

On Mon 30-10-23 12:49:01, Mikulas Patocka wrote:
> On Mon, 30 Oct 2023, Jan Kara wrote:
> > > >> What if we end up in "goto retry" more than once? I don't see a matching
> > > > 
> > > > It is impossible. Before we jump to the retry label, we set 
> > > > __GFP_DIRECT_RECLAIM. mempool_alloc can't ever fail if 
> > > > __GFP_DIRECT_RECLAIM is present (it will just wait until some other task 
> > > > frees some objects into the mempool).
> > > 
> > > Ah, missed that. And the traces don't show that we would be waiting for
> > > that. I'm starting to think the allocation itself is really not the issue
> > > here. Also I don't think it deprives something else of large order pages, as
> > > per the sysrq listing they still existed.
> > > 
> > > What I rather suspect is what happens next to the allocated bio such that it
> > > works well with order-0 or up to costly_order pages, but there's some
> > > problem causing a deadlock if the bio contains larger pages than that?
> > 
> > Hum, so in all the backtraces presented we see that we are waiting for page
> > writeback to complete but I don't see anything that would be preventing the
> > bios from completing. Page writeback can submit quite large bios so it kind
> > of makes sense that it trips up some odd behavior. Looking at the code
> > I can see one possible problem in crypt_alloc_buffer() but it doesn't
> > explain why reducing initial page order would help. Anyway: Are we
> > guaranteed mempool has enough pages for arbitrarily large bio that can
> > enter crypt_alloc_buffer()? I can see crypt_page_alloc() does limit the
> > number of pages in the mempool to dm_crypt_pages_per_client plus I assume
> > the percpu counter bias in cc->n_allocated_pages can limit the really
> > available number of pages even further. So if a single bio is large enough
> > to trip percpu_counter_read_positive(&cc->n_allocated_pages) >=
> > dm_crypt_pages_per_client condition in crypt_page_alloc(), we can loop
> > forever? But maybe this cannot happen for some reason...
> > 
> > If this is not it, I think we need to find out why the writeback bios are
> > not completeting. Probably I'd start with checking what is kcryptd,
> > presumably responsible for processing these bios, doing.
> > 
> > 								Honza
> 
> cc->page_pool is initialized to hold BIO_MAX_VECS pages. crypt_map will 
> restrict the bio size to BIO_MAX_VECS (see dm_accept_partial_bio being 
> called from crypt_map).
> 
> When we allocate a buffer in crypt_alloc_buffer, we try first allocation 
> without waiting, then we grab the mutex and we try allocation with 
> waiting.
> 
> The mutex should prevent a deadlock when two processes allocate 128 pages 
> concurrently and wait for each other to free some pages.
> 
> The limit to dm_crypt_pages_per_client only applies to pages allocated 
> from the kernel - when this limit is reached, we can still allocate from 
> the mempool, so it shoudn't cause deadlocks.

Ah, ok, I missed the limitation of the bio size in crypt_map(). Thanks for
explanation! So really the only advice I have now it to check what kcryptd
is doing when the system is stuck. Because we didn't see it in any of the
stacktrace dumps.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
