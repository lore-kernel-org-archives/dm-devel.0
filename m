Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFEE18C08;
	Mon, 30 Oct 2023 15:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="kR38w7x3";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="YmGYY48H"
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B1A051F7AB;
	Mon, 30 Oct 2023 15:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1698681363; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E3XSA6WYBW8wrapbDS0LhBDnP8RGWsuPkduvqjedEqs=;
	b=kR38w7x3BQ7gPL3vFPD9UWK/Ssfj/pyDTaDMbLv2qaWIQteL3Hwcf4Vbkrc9on90TpC1F4
	lr8Cbs1p4oNm14I8vNHRq7HSAU0ulEbAVm42YXxdQLgCb8cqyxqwxdry+JgM5ymFXtVjeq
	xgoLjsKgHtKY/Y9oK+NdacDzYqsOeOA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1698681363;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E3XSA6WYBW8wrapbDS0LhBDnP8RGWsuPkduvqjedEqs=;
	b=YmGYY48HATodz9rPRuIhG053z/Hc+GzKDncp3XcDsaOpjoqlYV+AVRowhJZE1aLiHA9Zwa
	gMionwcRsqOM67AA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9F9E8138EF;
	Mon, 30 Oct 2023 15:56:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id lVjgJhPSP2XqegAAMHmgww
	(envelope-from <jack@suse.cz>); Mon, 30 Oct 2023 15:56:03 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 293D2A05BC; Mon, 30 Oct 2023 16:56:03 +0100 (CET)
Date: Mon, 30 Oct 2023 16:56:03 +0100
From: Jan Kara <jack@suse.cz>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>,
	Jan Kara <jack@suse.cz>, Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org,
	regressions@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5
Message-ID: <20231030155603.k3kejytq2e4vnp7z@quack3>
References: <ZTiJ3CO8w0jauOzW@mail-itl>
 <a413efbf-7194-95ff-562b-f2eb766ca5c1@redhat.com>
 <89320668-67a2-2a41-e577-a2f561e3dfdd@suse.cz>
 <818a23f2-c242-1c51-232d-d479c3bcbb6@redhat.com>
 <18a38935-3031-1f35-bc36-40406e2e6fd2@suse.cz>
 <3514c87f-c87f-f91f-ca90-1616428f6317@redhat.com>
 <1a47fa28-3968-51df-5b0b-a19c675cc289@suse.cz>
 <20231030122513.6gds75hxd65gu747@quack3>
 <ZT+wDLwCBRB1O+vB@mail-itl>
 <a2a8dbf6-d22e-65d0-6fab-b9cdf9ec3320@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a2a8dbf6-d22e-65d0-6fab-b9cdf9ec3320@redhat.com>

On Mon 30-10-23 15:08:56, Mikulas Patocka wrote:
> On Mon, 30 Oct 2023, Marek Marczykowski-Górecki wrote:
> 
> > > Well, it would be possible that larger pages in a bio would trip e.g. bio
> > > splitting due to maximum segment size the disk supports (which can be e.g.
> > > 0xffff) and that upsets something somewhere. But this is pure
> > > speculation. We definitely need more debug data to be able to tell more.
> > 
> > I can collect more info, but I need some guidance how :) Some patch
> > adding extra debug messages?
> > Note I collect those via serial console (writing to disk doesn't work
> > when it freezes), and that has some limits in the amount of data I can
> > extract especially when printed quickly. For example sysrq-t is too much.
> > Or maybe there is some trick to it, like increasing log_bug_len?
> 
> If you can do more tests, I would suggest this:
> 
> We already know that it works with order 3 and doesn't work with order 4.
> 
> So, in the file include/linux/mmzone.h, change PAGE_ALLOC_COSTLY_ORDER 
> from 3 to 4 and in the file drivers/md/dm-crypt.c leave "unsigned int 
> order = PAGE_ALLOC_COSTLY_ORDER" there.
> 
> Does it deadlock or not?
> 
> So, that we can see whether the deadlock depends on 
> PAGE_ALLOC_COSTLY_ORDER or whether it is just a coincidence.

Good idea. Also if the kernel hangs, please find kcryptd processes. In what
state are they? If they are sleeping, please send what's in
/proc/<kcryptd-pid>/stack. Thanks!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
