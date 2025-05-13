Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B69F1E5B8A
	for <dm-devel@lists.linux.dev>; Tue, 13 May 2025 08:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747124284; cv=none; b=GvFC7/Ajg70rXshbUukTRrnBV2x+EHwv/M1T4zT9wruxhR7qoqGV/UJtq6+eBwogHk4NklrR+9MxiOZrf8x763ZZ1BxQ9Dr6u0PNWCilwjOKDRS5Sg0vHFrDb0QS6AsoeG3IusDdE8IJjmdoXeUw7lD21bgXA3QwIhti2fH2EuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747124284; c=relaxed/simple;
	bh=kHXmzNEPIJbMeMV7Horji6OVagXfu1MdTqnzQF+5Nmk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=d1VLlSJWaBOhz26E+6SBbR6PPWmpaW3tFg3thmoRxQzVIH2pwQOyoBSMNbpbI32CrLZtK2GPCDZyIGpEk5uYMXEnxUhNI/BDmiWv7YIWJagLAPAPzsRMdrxaMCNuT4hIjBVqgamIJvNduwZ9Ukf4sOeyc3t6y/rHxGCm/piV/mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=gc/VocSf; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=HVq7/9mI; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="gc/VocSf";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="HVq7/9mI"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 63ED02119C;
	Tue, 13 May 2025 08:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1747124280; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kHXmzNEPIJbMeMV7Horji6OVagXfu1MdTqnzQF+5Nmk=;
	b=gc/VocSfhgbKK6Pdjaz3Sy75GeMgteVF1bbWYdQE0GHAA1m2krup8TI6vdge7KNDwgK3iP
	JoUSqHRWdXlp0D57nMiJIYycxJ0ojWzFXoRNiGd11usqr+lXQXhLVt9jehw5WL1BqlIBQ/
	UyPxINAzdUVbHh5yHklOohDfCQEHXh4=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="HVq7/9mI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1747124279; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kHXmzNEPIJbMeMV7Horji6OVagXfu1MdTqnzQF+5Nmk=;
	b=HVq7/9mIHGFw96MQ/KCMt0Xwc9iJWoa8T1MLC8uRzm/Xq3PToQu0ayQoqH14uc7Zl8Un7W
	0IvYyz/lwbA3Axgn0wzGXyK8480c67yDIE/mTYOpUgCisA5MygBwN+/UJMm1sCMXLfJa6H
	g9JAUxzxcUWWqoRl9QiBqWlVY9vjNWM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 15BE2137E8;
	Tue, 13 May 2025 08:17:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zJBgAzcAI2jcbAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Tue, 13 May 2025 08:17:59 +0000
Message-ID: <265961162cf0747a82c66c6cae38aecb85acfec9.camel@suse.com>
Subject: Re: [PATCH 0/2] dm mpath: Interface for explicit probing of active
 paths
From: Martin Wilck <mwilck@suse.com>
To: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>
Cc: Kevin Wolf <kwolf@redhat.com>, dm-devel@lists.linux.dev,
 hreitz@redhat.com, 	mpatocka@redhat.com, snitzer@kernel.org,
 bmarzins@redhat.com, 	linux-kernel@vger.kernel.org
Date: Tue, 13 May 2025 10:17:58 +0200
In-Reply-To: <aCLrbz3bRLwUbA8p@infradead.org>
References: <20250429165018.112999-1-kwolf@redhat.com>
	 <47dd225b433b0df585a25084a2e793344eeda239.camel@suse.com>
	 <aCIRUwt5BueQmlMZ@redhat.com> <aCLe5UT2kfzI96TQ@infradead.org>
	 <0340c51e-6f89-4799-b2f1-19c785a19ff2@suse.de>
	 <aCLjPLCztuXhgpnA@infradead.org>
	 <d2a7fa68-1890-4367-a2ac-59ec220779bd@suse.de>
	 <aCLrbz3bRLwUbA8p@infradead.org>
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
X-Rspamd-Queue-Id: 63ED02119C
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Score: -4.51

On Mon, 2025-05-12 at 23:49 -0700, Christoph Hellwig wrote:
> On Tue, May 13, 2025 at 08:32:12AM +0200, Hannes Reinecke wrote:
> > Reservations and stuff.
>=20
> They should use the kernel persistent reservation API.
>=20
> > There are customer who use GPFS ...
>=20
> Supporting illegal binary only modules that is already enough of a
> reason to NAK this.

GPFS is not the only use case.=20

The reason why we have "scsi-block" in qemu is simply SCSI emulation.
If we emulate a SCSI device to a VM, the device should support commands
like persistent reservations properly. "scsi-block" supports this,
while still offering decent IO performance to VMs. In the multipath
case, the idea is to be able to hide from the VM the fact that the
device in question is actually a multipath device, and still allow this
sort of SCSI commands to be passed through to the storage.

And no, passing the SCSI devices to the VM and doing multipath in the
the guest doesn't work. The transport layer isn't properly emulated
(bluntly speaking, we have no FC emulation).

Regards
Martin
