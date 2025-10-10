Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280181C5F27
	for <dm-devel@lists.linux.dev>; Fri, 10 Oct 2025 13:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760101542; cv=none; b=WPxTWJgUW38Jdh1uJu+56/QH9WfQZuMy/7EOEnCCiPm6j4OBDGue7YnhxI3e+GWP5tRB+KcZJb+brBrt5qStXZZoy5wG7t/8NnDYCjWV6nTNZsPzq5b426TTrz9n/TzvY5q0b6sAqP85dX++I47rbME8MmgLdE8t1rx0MaHYHmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760101542; c=relaxed/simple;
	bh=YfM4EfNnzwBwAiLYKYm5wRh4edjeeIkWIJeZJgc1kxE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NCB1JhHAqW1XZOh1/elarAcG9/ylp86qMlsFtNXH1Vv+Pey85BTIAm7W4O2ItmNvNZZqBRWLrXZ+iFrc47RbywVn4JD9wmfAPw0qvLQokFjCHf5aZ1gGpKmGGq67yItq9Z+UnXot5pNGKstjWWtYqvkmYU0GqAuvxFVhTBrTDmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=nJ9t+0Rc; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=nJ9t+0Rc; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="nJ9t+0Rc";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="nJ9t+0Rc"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6315E21D04;
	Fri, 10 Oct 2025 13:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1760101538; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YfM4EfNnzwBwAiLYKYm5wRh4edjeeIkWIJeZJgc1kxE=;
	b=nJ9t+0Rcy2tiROQjyAX/AMYqyHayimoehLjIRI+E/cfGzvYhwygIF4JGwcQifnGaK8lED2
	t0mDGTdG2FDr8ixsrntrOZfdRRrWJE8AMjFafhs0C4I06r1efItYROY1oK90MBVi8eStvV
	T/o4kTGYP2l74Bv9CQ3lIO2eHiDxe5c=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1760101538; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YfM4EfNnzwBwAiLYKYm5wRh4edjeeIkWIJeZJgc1kxE=;
	b=nJ9t+0Rcy2tiROQjyAX/AMYqyHayimoehLjIRI+E/cfGzvYhwygIF4JGwcQifnGaK8lED2
	t0mDGTdG2FDr8ixsrntrOZfdRRrWJE8AMjFafhs0C4I06r1efItYROY1oK90MBVi8eStvV
	T/o4kTGYP2l74Bv9CQ3lIO2eHiDxe5c=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4346613A40;
	Fri, 10 Oct 2025 13:05:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nixPD6IE6WiGRgAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 10 Oct 2025 13:05:38 +0000
Message-ID: <6db4511afaef029f99590d818ba410cc7db9293c.camel@suse.com>
Subject: Re: [PATCH 1/2] multipath-tools: fix mandoc errors in man pages
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM_DEVEL-ML <dm-devel@lists.linux.dev>
Date: Fri, 10 Oct 2025 15:05:37 +0200
In-Reply-To: <a2923472-331c-43ea-9ba2-f7208b9869c9@gmail.com>
References: <20251010092211.57426-1-xose.vazquez@gmail.com>
	 <0580f369a7102ae07aaa2c23fd4bd9165cbafd35.camel@suse.com>
	 <a2923472-331c-43ea-9ba2-f7208b9869c9@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	URIBL_BLOCKED(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

On Fri, 2025-10-10 at 14:37 +0200, Xose Vazquez Perez wrote:
> On 10/10/25 1:20 PM, Martin Wilck wrote:
>=20
> > I believe our man pages have more serious issues; for example, we
> > use
> > so deep indentation in multipath.conf.5 that the page is hardly
> > readable on narrow terminals.
>=20
> I do not think so:
>=20
> export LC_ALL=3Den_US.UTF-8 MANROFFSEQ=3D"" MANWIDTH=3D80
> man ./multipath/multipath.conf.5.in
>=20
> It is displayed correctly, except for these three lines:

Yes it's "correct". But it's very hard to read. Lots of empty space on
the left and narrow text column on the right.

Martin
