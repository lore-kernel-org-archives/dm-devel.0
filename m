Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DBF81FBA;
	Mon, 30 Oct 2023 11:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="XW8axk8U";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="jq7LbyhL"
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2F4B31FEF0;
	Mon, 30 Oct 2023 11:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1698665325; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7+MAdxAuVinBXZcCJL4/EKLK4pRjoLXrIPh+TEUOPZE=;
	b=XW8axk8UmIhsqHSxUQBcewcGOXoBAH7r5DaLZDdsYsO40AQIXr1e2csYN7ueAdM98cJqjY
	QvwuJOH0ShR5RlQMLqeczeRT08BQ+fmpU8anq/BVCGjnnuSOIM8c8gLwEdN02J6kPc+G/C
	YD9Y7DTL1iT18fOkDWUVq74tTvjcFYI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1698665325;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7+MAdxAuVinBXZcCJL4/EKLK4pRjoLXrIPh+TEUOPZE=;
	b=jq7LbyhL8aFf8kmwRFv8/QL9PD6AwV0DeKhn++1TmLbMFdAU+e4G2mxN4gqZ80nQCsvgbD
	F/URD+2Qq9zbtWCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1C55E138F8;
	Mon, 30 Oct 2023 11:28:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id 4ZvkBm2TP2VeTgAAMHmgww
	(envelope-from <jack@suse.cz>); Mon, 30 Oct 2023 11:28:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 90A8BA05BC; Mon, 30 Oct 2023 12:28:44 +0100 (CET)
Date: Mon, 30 Oct 2023 12:28:44 +0100
From: Jan Kara <jack@suse.cz>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org,
	regressions@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev,
	linux-mm@kvack.org, Jan Kara <jack@suse.cz>
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5
Message-ID: <20231030112844.g7b76cm2xxpovt6e@quack3>
References: <ZTNH0qtmint/zLJZ@mail-itl>
 <e427823c-e869-86a2-3549-61b3fdf29537@redhat.com>
 <ZTiHQDY54E7WAld+@mail-itl>
 <ZTiJ3CO8w0jauOzW@mail-itl>
 <a413efbf-7194-95ff-562b-f2eb766ca5c1@redhat.com>
 <89320668-67a2-2a41-e577-a2f561e3dfdd@suse.cz>
 <818a23f2-c242-1c51-232d-d479c3bcbb6@redhat.com>
 <18a38935-3031-1f35-bc36-40406e2e6fd2@suse.cz>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18a38935-3031-1f35-bc36-40406e2e6fd2@suse.cz>
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -10.60
X-Spamd-Result: default: False [-10.60 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 BAYES_HAM(-3.00)[100.00%];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 NEURAL_HAM_LONG(-3.00)[-1.000];
	 MIME_GOOD(-0.10)[text/plain];
	 REPLY(-4.00)[];
	 DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-1.00)[-1.000];
	 RCPT_COUNT_TWELVE(0.00)[13];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 MID_RHS_NOT_FQDN(0.50)[];
	 RCVD_COUNT_TWO(0.00)[2];
	 RCVD_TLS_ALL(0.00)[];
	 SUBJECT_HAS_QUESTION(0.00)[]
X-Spam-Flag: NO

On Mon 30-10-23 09:37:10, Vlastimil Babka wrote:
> On 10/30/23 08:37, Mikulas Patocka wrote:
> > On Sun, 29 Oct 2023, Vlastimil Babka wrote:
> > 
> >> Haven't found any. However I'd like to point out some things I noticed in
> >> crypt_alloc_buffer(), although they are probably not related.
> >> 
> >> > static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned int size)
> >> > {
> >> > 	struct crypt_config *cc = io->cc;
> >> > 	struct bio *clone;
> >> > 	unsigned int nr_iovecs = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
> >> > 	gfp_t gfp_mask = GFP_NOWAIT | __GFP_HIGHMEM;
> >> > 	unsigned int remaining_size;
> >> > 	unsigned int order = MAX_ORDER - 1;
> >> > 
> >> > retry:
> >> > 	if (unlikely(gfp_mask & __GFP_DIRECT_RECLAIM))
> >> > 		mutex_lock(&cc->bio_alloc_lock);
> >> 
> >> What if we end up in "goto retry" more than once? I don't see a matching
> > 
> > It is impossible. Before we jump to the retry label, we set 
> > __GFP_DIRECT_RECLAIM. mempool_alloc can't ever fail if 
> > __GFP_DIRECT_RECLAIM is present (it will just wait until some other task 
> > frees some objects into the mempool).
> 
> Ah, missed that. And the traces don't show that we would be waiting for
> that. I'm starting to think the allocation itself is really not the issue
> here. Also I don't think it deprives something else of large order pages, as
> per the sysrq listing they still existed.
> 
> What I rather suspect is what happens next to the allocated bio such that it
> works well with order-0 or up to costly_order pages, but there's some
> problem causing a deadlock if the bio contains larger pages than that?

Hum, so in all the backtraces presented we see that we are waiting for page
writeback to complete but I don't see anything that would be preventing the
bios from completing. Page writeback can submit quite large bios so it kind
of makes sense that it trips up some odd behavior. Looking at the code
I can see one possible problem in crypt_alloc_buffer() but it doesn't
explain why reducing initial page order would help. Anyway: Are we
guaranteed mempool has enough pages for arbitrarily large bio that can
enter crypt_alloc_buffer()? I can see crypt_page_alloc() does limit the
number of pages in the mempool to dm_crypt_pages_per_client plus I assume
the percpu counter bias in cc->n_allocated_pages can limit the really
available number of pages even further. So if a single bio is large enough
to trip percpu_counter_read_positive(&cc->n_allocated_pages) >=
dm_crypt_pages_per_client condition in crypt_page_alloc(), we can loop
forever? But maybe this cannot happen for some reason...

If this is not it, I think we need to find out why the writeback bios are
not completeting. Probably I'd start with checking what is kcryptd,
presumably responsible for processing these bios, doing.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
