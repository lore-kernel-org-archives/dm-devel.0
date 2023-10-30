Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5445BD2E9;
	Mon, 30 Oct 2023 08:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="24qfnBZ/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="rLkfd/tX"
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4F81621992;
	Mon, 30 Oct 2023 08:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1698655031; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OT3gH6W3eVii6TzxQ2SSrakkNp82aIS3RiPQ/z/s9nk=;
	b=24qfnBZ/ngwGoEVrHhkIOaZDKFpbYpOmf8t/yCcsFyZa+/v9gE/ClAV4rZvDOhxPaN8ros
	gsam/yFyrhJAs5tSDCdBBvTo5TRBwXf+BkZhTDQfUx4fduhNYRvwuWYjX9ymkSHcx4xrmi
	KRnScYNc+iWKHQPUKx7WktfpOAN6/XE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1698655031;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OT3gH6W3eVii6TzxQ2SSrakkNp82aIS3RiPQ/z/s9nk=;
	b=rLkfd/tXI4lLSxLJFuDtXWYfqb3NogmTxO2wxKiFYibHKn/nPUhId+nKEdOauiRL09Cm9C
	hdz9hnWo4o93nqDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2C2F6138EF;
	Mon, 30 Oct 2023 08:37:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id g8kTCjdrP2XlbAAAMHmgww
	(envelope-from <vbabka@suse.cz>); Mon, 30 Oct 2023 08:37:11 +0000
Message-ID: <18a38935-3031-1f35-bc36-40406e2e6fd2@suse.cz>
Date: Mon, 30 Oct 2023 09:37:10 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?=
 <marmarek@invisiblethingslab.com>, Andrew Morton
 <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>,
 Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org,
 regressions@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev,
 linux-mm@kvack.org, Jan Kara <jack@suse.cz>
References: <ZTNH0qtmint/zLJZ@mail-itl>
 <e427823c-e869-86a2-3549-61b3fdf29537@redhat.com> <ZTiHQDY54E7WAld+@mail-itl>
 <ZTiJ3CO8w0jauOzW@mail-itl> <a413efbf-7194-95ff-562b-f2eb766ca5c1@redhat.com>
 <89320668-67a2-2a41-e577-a2f561e3dfdd@suse.cz>
 <818a23f2-c242-1c51-232d-d479c3bcbb6@redhat.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <818a23f2-c242-1c51-232d-d479c3bcbb6@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Authentication-Results: smtp-out1.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -5.02
X-Spamd-Result: default: False [-5.02 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 BAYES_HAM(-0.92)[86.27%];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 NEURAL_HAM_LONG(-3.00)[-1.000];
	 MIME_GOOD(-0.10)[text/plain];
	 DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-1.00)[-1.000];
	 RCPT_COUNT_TWELVE(0.00)[12];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_COUNT_TWO(0.00)[2];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[];
	 SUBJECT_HAS_QUESTION(0.00)[]
X-Spam-Flag: NO

On 10/30/23 08:37, Mikulas Patocka wrote:
> 
> 
> On Sun, 29 Oct 2023, Vlastimil Babka wrote:
> 
>> Haven't found any. However I'd like to point out some things I noticed in
>> crypt_alloc_buffer(), although they are probably not related.
>> 
>> > static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned int size)
>> > {
>> > 	struct crypt_config *cc = io->cc;
>> > 	struct bio *clone;
>> > 	unsigned int nr_iovecs = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
>> > 	gfp_t gfp_mask = GFP_NOWAIT | __GFP_HIGHMEM;
>> > 	unsigned int remaining_size;
>> > 	unsigned int order = MAX_ORDER - 1;
>> > 
>> > retry:
>> > 	if (unlikely(gfp_mask & __GFP_DIRECT_RECLAIM))
>> > 		mutex_lock(&cc->bio_alloc_lock);
>> 
>> What if we end up in "goto retry" more than once? I don't see a matching
> 
> It is impossible. Before we jump to the retry label, we set 
> __GFP_DIRECT_RECLAIM. mempool_alloc can't ever fail if 
> __GFP_DIRECT_RECLAIM is present (it will just wait until some other task 
> frees some objects into the mempool).

Ah, missed that. And the traces don't show that we would be waiting for
that. I'm starting to think the allocation itself is really not the issue
here. Also I don't think it deprives something else of large order pages, as
per the sysrq listing they still existed.

What I rather suspect is what happens next to the allocated bio such that it
works well with order-0 or up to costly_order pages, but there's some
problem causing a deadlock if the bio contains larger pages than that?

Cc Honza. The thread starts here:
https://lore.kernel.org/all/ZTNH0qtmint%2FzLJZ@mail-itl/

The linked qubes reports has a number of blocked task listings that can be
expanded:
https://github.com/QubesOS/qubes-issues/issues/8575
