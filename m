Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A806314F6C;
	Thu,  2 Nov 2023 12:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="d/bJkBWz";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="7+I9n1AP"
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7C5A121A04;
	Thu,  2 Nov 2023 12:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1698927715; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5mAwtuufov9lTyy9sGroezcbI4J+0d92k5eAe06+d7k=;
	b=d/bJkBWzLkto/7fGyqVLPb1234f6tUyvUNiGGAK7Qoa8qcSX2xy+GlFZUIjtizxRoIhTQw
	a+VGgqPncn2LHxZGvcVnzn5XRAp9g4+PoYAslRKjrVPjc0vY9sdDyCr+iTruuzwCIYi1Kw
	3VbDzjjOhoWdWqh6HVj4Noo1SIELCOw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1698927715;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5mAwtuufov9lTyy9sGroezcbI4J+0d92k5eAe06+d7k=;
	b=7+I9n1APdWA4llCvO7g/6lEagQD4M+yeaMcPW4WCfXzozzeg8KR3dU9aGgwa4GrCFmWM6c
	u3lBNfzxJp1TuKDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6DCAF138EC;
	Thu,  2 Nov 2023 12:21:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id vJjEGmOUQ2VQRQAAMHmgww
	(envelope-from <jack@suse.cz>); Thu, 02 Nov 2023 12:21:55 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E5402A06E3; Thu,  2 Nov 2023 13:21:54 +0100 (CET)
Date: Thu, 2 Nov 2023 13:21:54 +0100
From: Jan Kara <jack@suse.cz>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>,
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Jan Kara <jack@suse.cz>, Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org,
	regressions@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5
Message-ID: <20231102122154.jtwcl6l4f4pebqqx@quack3>
References: <20231030155603.k3kejytq2e4vnp7z@quack3>
 <ZT/e/EaBIkJEgevQ@mail-itl>
 <98aefaa9-1ac-a0e4-fb9a-89ded456750@redhat.com>
 <ZUB5HFeK3eHeI8UH@mail-itl>
 <20231031140136.25bio5wajc5pmdtl@quack3>
 <ZUEgWA5P8MFbyeBN@mail-itl>
 <8a35cdea-3a1a-e859-1f7c-55d1c864a48@redhat.com>
 <ebbc7ca7-5169-dbdc-9ea8-c6d8c3ae31e2@redhat.com>
 <ZULvkPhcpgAVyI8w@mail-itl>
 <ac5b5ac0-9e8-c1b0-a26-62f832f845f0@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ac5b5ac0-9e8-c1b0-a26-62f832f845f0@redhat.com>

On Thu 02-11-23 10:28:57, Mikulas Patocka wrote:
> On Thu, 2 Nov 2023, Marek Marczykowski-Górecki wrote:
> > On Tue, Oct 31, 2023 at 06:24:19PM +0100, Mikulas Patocka wrote:
> > 
> > > > Hi
> > > > 
> > > > I would like to ask you to try this patch. Revert the changes to "order" 
> > > > and "PAGE_ALLOC_COSTLY_ORDER" back to normal and apply this patch on a 
> > > > clean upstream kernel.
> > > > 
> > > > Does it deadlock?
> > > > 
> > > > There is a bug in dm-crypt that it doesn't account large pages in 
> > > > cc->n_allocated_pages, this patch fixes the bug.
> > 
> > This patch did not help.
> > 
> > > If the previous patch didn't fix it, try this patch (on a clean upstream 
> > > kernel).
> > >
> > > This patch allocates large pages, but it breaks them up into single-page 
> > > entries when adding them to the bio.
> > 
> > But this does help.
> 
> Thanks. So we can stop blaming the memory allocator and start blaming the 
> NVMe subsystem.

;-)

> I added NVMe maintainers to this thread - the summary of the problem is: 
> In dm-crypt, we allocate a large compound page and add this compound page 
> to the bio as a single big vector entry. Marek reports that on his system 
> it causes deadlocks, the deadlocks look like a lost bio that was never 
> completed. When I chop the large compound page to individual pages in 
> dm-crypt and add bio vector for each of them, Marek reports that there are 
> no longer any deadlocks. So, we have a problem (either hardware or 
> software) that the NVMe subsystem doesn't like bio vectors with large 
> bv_len. This is the original bug report: 
> https://lore.kernel.org/stable/ZTNH0qtmint%2FzLJZ@mail-itl/

Actually, Ming Lei has already identified [1] that we are apparently
looping in an endless retry loop in nvme_queue_rq(), always ending up the
attempt with BLK_STS_RESOURCE.
								Honza

[1] https://lore.kernel.org/all/ZUHE52SznRaZQxnG@fedora

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
