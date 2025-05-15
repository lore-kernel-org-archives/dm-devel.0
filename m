Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBCF31FF608
	for <dm-devel@lists.linux.dev>; Thu, 15 May 2025 15:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747322292; cv=none; b=Y+I+WRChOgaWKCZiVcm5LQEUFeUQWa2+Xz4gQg4btj3QeygkaRUe/mqDVrxgcrjzipAMiFEYGtYb07OPEOLBoLQefnjT5iPEMJCWOgP4qPolaJQLk40LUr0BVAXYcMVFAX8e5mGOp5UmFmPj6xc3uyiGxu/k/54kX7Pkzb4swfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747322292; c=relaxed/simple;
	bh=7VnizUWK/lVjOFaq7NAaMlRlSrGMpuLOKsqj4k/9nDg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WXaUEt6PIl52eVWGsNf86fVtoLo6xdGcoiLf/x5+xjYgXiC3ZNlovg9sg4Ir5Gi+3QUUCRPMJdqFGYGls+EaTE9ArcARtbHGIQUKD3obi8gDEznHxFhI8OHlCZvWJQc2mDK+50iOFH3AlOUUKALaTseiLAVh/0Xwssp5/kwECKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=kYklDV/H; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=kYklDV/H; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="kYklDV/H";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="kYklDV/H"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0AF361F6E6;
	Thu, 15 May 2025 15:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1747322289; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7VnizUWK/lVjOFaq7NAaMlRlSrGMpuLOKsqj4k/9nDg=;
	b=kYklDV/HZ0nHYbEGVoNYC0wOmkhjaZ7wA2I1o20HaRD0aIzTmpT5ST6gY8VjkdVKQHN6y/
	VlVdvyr2zUYx4G96usSje+LgHjUZsNiKdOtZEn2d30FydUAvPyQaxwiUZ4/I8NgdbSyn2V
	kadu6x0uUnfLAXkrZ7P+1K+u20xBcF0=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="kYklDV/H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1747322289; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7VnizUWK/lVjOFaq7NAaMlRlSrGMpuLOKsqj4k/9nDg=;
	b=kYklDV/HZ0nHYbEGVoNYC0wOmkhjaZ7wA2I1o20HaRD0aIzTmpT5ST6gY8VjkdVKQHN6y/
	VlVdvyr2zUYx4G96usSje+LgHjUZsNiKdOtZEn2d30FydUAvPyQaxwiUZ4/I8NgdbSyn2V
	kadu6x0uUnfLAXkrZ7P+1K+u20xBcF0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ACB26139D0;
	Thu, 15 May 2025 15:18:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id D4MvKLAFJmhwQgAAD6G6ig
	(envelope-from <mwilck@suse.com>); Thu, 15 May 2025 15:18:08 +0000
Message-ID: <86402acdc74de0ed42f41fea0f3ac55af56e0cdb.camel@suse.com>
Subject: Re: [PATCH 0/2] dm mpath: Interface for explicit probing of active
 paths
From: Martin Wilck <mwilck@suse.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Kevin Wolf <kwolf@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Benjamin Marzinski
	 <bmarzins@redhat.com>, dm-devel@lists.linux.dev, hreitz@redhat.com, 
	mpatocka@redhat.com, snitzer@kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 15 May 2025 17:18:08 +0200
In-Reply-To: <22f811d4-d327-41dc-9daa-7c4aa75a5cba@redhat.com>
References: <20250429165018.112999-1-kwolf@redhat.com>
	 <47dd225b433b0df585a25084a2e793344eeda239.camel@suse.com>
	 <aCIRUwt5BueQmlMZ@redhat.com>
	 <d51d6f85b5728648fe9c584f9cb3acee12c4873f.camel@suse.com>
	 <cc2ec011cf286cb5d119f2378ecbd7b818e46769.camel@suse.com>
	 <aCW95f8RGpLJZwSA@redhat.com>
	 <22f811d4-d327-41dc-9daa-7c4aa75a5cba@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 0AF361F6E6
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim]
X-Rspamd-Action: no action

On Thu, 2025-05-15 at 13:09 +0200, Paolo Bonzini wrote:


> However, EBADE handling dates back to 2011 (commit 63583cca745f,
> "[SCSI]=20
> Add detailed SCSI I/O errors", 2011-02-12) and yet the Windows tests
> for=20
> PR were failing before QEMU switched to SG_IO for reads and writes.=C2=A0
> I=20
> guess I have to try reverting that and retest, though.

Thanks! This makes me realize that we could summarize the goal for
future efforts (independent of the current patch set) roughly like
this:

"Emulate a SCSI disk on top of a (host) multipath device in a way that
1) failover works properly (like it would work for regular IO from the
host itself),=C2=A0
2) Windows tests for PR (plus test case X, Y, ...) can be run
successfully".

Does this make sense? It implies that PR commands don't just need to be
forwarded appropriately, we also need to pass meaningful error codes
back to the guest.

Martin
