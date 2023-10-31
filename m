Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816D85255;
	Tue, 31 Oct 2023 14:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Ftzu5Fhv";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="5AehXmbL"
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0F9DF1F38C;
	Tue, 31 Oct 2023 14:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1698760897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1LF7kbHX9N77tVn1FdmTn2yQglSxGX4kd1aiT/nhq30=;
	b=Ftzu5FhvcqTcaOYiHY91lRJ/oN1s8Qz2uzrsxDg8ACQGCpWpL93PeQDVfINnK7CpjomSpE
	NXAbrLkoe3mb8TfnGpUS70JM+8YxPaJzg7w3rNjI0SBpXmF5BIRurx7ZD6OV3D7ZVGiajY
	oWTbXPPTJKemeoCQE8dwtnBjOOYXmvs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1698760897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1LF7kbHX9N77tVn1FdmTn2yQglSxGX4kd1aiT/nhq30=;
	b=5AehXmbL1cgO0YhZ0g3JQJBoKhxnlVe5OHvpvwxfI0mcRDdnIpEDe+uHpt80iAs8NMxPIQ
	HqrlJuHl1wvzhNDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 002D3138EF;
	Tue, 31 Oct 2023 14:01:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id 4EQNAMEIQWV8BAAAMHmgww
	(envelope-from <jack@suse.cz>); Tue, 31 Oct 2023 14:01:36 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7B01AA06E5; Tue, 31 Oct 2023 15:01:36 +0100 (CET)
Date: Tue, 31 Oct 2023 15:01:36 +0100
From: Jan Kara <jack@suse.cz>
To: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Jan Kara <jack@suse.cz>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org,
	regressions@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5
Message-ID: <20231031140136.25bio5wajc5pmdtl@quack3>
References: <18a38935-3031-1f35-bc36-40406e2e6fd2@suse.cz>
 <3514c87f-c87f-f91f-ca90-1616428f6317@redhat.com>
 <1a47fa28-3968-51df-5b0b-a19c675cc289@suse.cz>
 <20231030122513.6gds75hxd65gu747@quack3>
 <ZT+wDLwCBRB1O+vB@mail-itl>
 <a2a8dbf6-d22e-65d0-6fab-b9cdf9ec3320@redhat.com>
 <20231030155603.k3kejytq2e4vnp7z@quack3>
 <ZT/e/EaBIkJEgevQ@mail-itl>
 <98aefaa9-1ac-a0e4-fb9a-89ded456750@redhat.com>
 <ZUB5HFeK3eHeI8UH@mail-itl>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZUB5HFeK3eHeI8UH@mail-itl>

On Tue 31-10-23 04:48:44, Marek Marczykowski-Górecki wrote:
> On Mon, Oct 30, 2023 at 06:50:35PM +0100, Mikulas Patocka wrote:
> > On Mon, 30 Oct 2023, Marek Marczykowski-Górecki wrote:
> > > Then retried with order=PAGE_ALLOC_COSTLY_ORDER and
> > > PAGE_ALLOC_COSTLY_ORDER back at 3, and also got similar crash.
> > 
> > So, does it mean that even allocating with order=PAGE_ALLOC_COSTLY_ORDER 
> > isn't safe?
> 
> That seems to be another bug, see below.
> 
> > Try enabling CONFIG_DEBUG_VM (it also needs CONFIG_DEBUG_KERNEL) and try 
> > to provoke a similar crash. Let's see if it crashes on one of the 
> > VM_BUG_ON statements.
> 
> This was very interesting idea. With this, immediately after login I get
> the crash like below. Which makes sense, as this is when pulseaudio
> starts and opens /dev/snd/*. I then tried with the dm-crypt commit
> reverted and still got the crash! But, after blacklisting snd_pcm,
> there is no BUG splat, but the storage freeze still happens on vanilla
> 6.5.6.

OK, great. Thanks for testing.

<snip snd_pcm bug>

> Plain 6.5.6 (so order = MAX_ORDER - 1, and PAGE_ALLOC_COSTLY_ORDER=3), in frozen state:
> [  143.196106] task:blkdiscard      state:D stack:13672 pid:4884  ppid:2025   flags:0x00000002
> [  143.196130] Call Trace:
> [  143.196139]  <TASK>
> [  143.196147]  __schedule+0x30e/0x8b0
> [  143.196162]  schedule+0x59/0xb0
> [  143.196175]  schedule_timeout+0x14c/0x160
> [  143.196193]  io_schedule_timeout+0x4b/0x70
> [  143.196207]  wait_for_completion_io+0x81/0x130
> [  143.196226]  submit_bio_wait+0x5c/0x90
> [  143.196241]  blkdev_issue_discard+0x94/0xe0
> [  143.196260]  blkdev_common_ioctl+0x79e/0x9c0
> [  143.196279]  blkdev_ioctl+0xc7/0x270
> [  143.196293]  __x64_sys_ioctl+0x8f/0xd0
> [  143.196310]  do_syscall_64+0x3c/0x90

So this shows there was bio submitted and it never ran to completion.
 
> for f in $(grep -l crypt /proc/*/comm); do head $f ${f/comm/stack}; done
<snip some backtraces>

So this shows dm-crypt layer isn't stuck anywhere. So the allocation path
itself doesn't seem to be locking up, looping or anything.

> Then tried:
>  - PAGE_ALLOC_COSTLY_ORDER=4, order=4 - cannot reproduce,
>  - PAGE_ALLOC_COSTLY_ORDER=4, order=5 - cannot reproduce,
>  - PAGE_ALLOC_COSTLY_ORDER=4, order=6 - freeze rather quickly
> 
> I've retried the PAGE_ALLOC_COSTLY_ORDER=4,order=5 case several times
> and I can't reproduce the issue there. I'm confused...

And this kind of confirms that allocations > PAGE_ALLOC_COSTLY_ORDER
causing hangs is most likely just a coincidence. Rather something either in
the block layer or in the storage driver has problems with handling bios
with sufficiently high order pages attached. This is going to be a bit
painful to debug I'm afraid. How long does it take for you trigger the
hang? I'm asking to get rough estimate how heavy tracing we can afford so
that we don't overwhelm the system...

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
