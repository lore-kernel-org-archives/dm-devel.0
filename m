Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CB123E347
	for <dm-devel@lists.linux.dev>; Tue, 13 May 2025 10:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747130767; cv=none; b=AyPfyQv25n9iNyUBNvw36kYPqgelEvBx3vzYctVBaYzEu+Ws2SNUrCKbcbYGZ9Hr8WLzNi3gMZAeBPaai4IAIihxkdrIDX9xVeNw6Q+D3cCD/+5GK0vuiLRVnZjybzjD1mOsgnk6IlhUKtKR55w4voKXjJxiQLjBcwAxgyaDHnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747130767; c=relaxed/simple;
	bh=f95ADMG9YyDctRuUQsoo88V9Ke6EkWb5qpSkRQwsS2E=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=c+9/k6x8QjEonE2iNGG3mn2a+ydthPQXM0IEnAcFTR18mICr/qPLW50fMABiiYzp8KKUcWN4jrHwRF4070fbOyjxBmS1/WrR1edTDoei7WHkrD+kDaripuOvqYE0hiG9iTpXO1v39OZftKFUjTmggXBUT+0dfz4aV46tXdnEQ30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=gIf+b7/a; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=gIf+b7/a; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="gIf+b7/a";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="gIf+b7/a"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5B8471F787;
	Tue, 13 May 2025 10:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1747130763; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f95ADMG9YyDctRuUQsoo88V9Ke6EkWb5qpSkRQwsS2E=;
	b=gIf+b7/axiROoDAEqjCYAc0BsmJxNWrUGQP4l9/ZpPyyqwH3CUZKbAn9vRAaT5CH2GwQDY
	/8DtXHGeiEOaUY/bZerU7bttHjk4nZMoApIxCBWzHfpvqOsLNSqstb2Q7jLFQq/Uj+2Dza
	ccWst2jj2yon+AhzhWtrLJbfsknQRLQ=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1747130763; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f95ADMG9YyDctRuUQsoo88V9Ke6EkWb5qpSkRQwsS2E=;
	b=gIf+b7/axiROoDAEqjCYAc0BsmJxNWrUGQP4l9/ZpPyyqwH3CUZKbAn9vRAaT5CH2GwQDY
	/8DtXHGeiEOaUY/bZerU7bttHjk4nZMoApIxCBWzHfpvqOsLNSqstb2Q7jLFQq/Uj+2Dza
	ccWst2jj2yon+AhzhWtrLJbfsknQRLQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1A2561365D;
	Tue, 13 May 2025 10:06:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yoHbBIsZI2jdFQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Tue, 13 May 2025 10:06:03 +0000
Message-ID: <c16e79a6db9f22f87d43388fe52169fb584f9562.camel@suse.com>
Subject: Re: [PATCH 0/2] dm mpath: Interface for explicit probing of active
 paths
From: Martin Wilck <mwilck@suse.com>
To: Kevin Wolf <kwolf@redhat.com>, Christoph Hellwig <hch@infradead.org>
Cc: dm-devel@lists.linux.dev, hreitz@redhat.com, mpatocka@redhat.com, 
	snitzer@kernel.org, bmarzins@redhat.com, linux-kernel@vger.kernel.org
Date: Tue, 13 May 2025 12:06:01 +0200
In-Reply-To: <d51d6f85b5728648fe9c584f9cb3acee12c4873f.camel@suse.com>
References: <20250429165018.112999-1-kwolf@redhat.com>
			 <47dd225b433b0df585a25084a2e793344eeda239.camel@suse.com>
			 <aCIRUwt5BueQmlMZ@redhat.com>
	 <d51d6f85b5728648fe9c584f9cb3acee12c4873f.camel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid]
X-Spam-Score: -4.30

On Tue, 2025-05-13 at 10:00 +0200, Martin Wilck wrote:
> On Mon, 2025-05-12 at 17:18 +0200, Kevin Wolf wrote:
>=20
> >=20
> > Ben already fixed up the missing check.
>=20
> I missed that.

Saw it now.

Martin
