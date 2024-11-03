Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9C414F9FD
	for <dm-devel@lists.linux.dev>; Sun,  3 Nov 2024 21:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730668912; cv=none; b=Z4i5tAecJN40cQfYQoUNJ0MVRSInuaYzIXRI/fib8fucKMaC2fB2VMttaC2U9AUnIqtStxw9yBra/b03m0i/EpYaM+jdsGj5/O5X8wkdBcl6R9auj2aYpMIAHI/MtMArLwFIMnuLlFVFjmm08HFFP7zS0iCDsWUQtAGE2oIQsYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730668912; c=relaxed/simple;
	bh=+iNrAmhL9M0OJS765/kAxqy9OpuUzmAlFCGpjtE5bkc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UOmeC/MAz3MHahTzeaboB9PethnRZBrNLnVnikKwsJJ+C9AO6K63HpKbNwWJTyFyFnrkxk0+//awxfy1G6oKvwlzGl7s5ONvUmzr6OWibVbP+n9cjzdBBcdjYKLMlWphH/q3bTCEVG08nS67l/gH0dahAep6cxWnpPiF2/pRbyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=dyPPlbb4; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=QD+z39OS; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="dyPPlbb4";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="QD+z39OS"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7ED401F388;
	Sun,  3 Nov 2024 21:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1730668901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+iNrAmhL9M0OJS765/kAxqy9OpuUzmAlFCGpjtE5bkc=;
	b=dyPPlbb4GtlRKW38/Ohdm/Y8yvGifxSQUNPPU2wqXGl3qvnv9USjdGoLBVD8eA+QMxh7Vs
	lZswvh421C4DXXpb4KouQsdxrlTQbG1s5t0LSxk9DHLuOy6or/gDijEI+JChcornvTp6Ww
	XiMpI9NO0agTovsvCkfApfzeMiklX60=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1730668900; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+iNrAmhL9M0OJS765/kAxqy9OpuUzmAlFCGpjtE5bkc=;
	b=QD+z39OSEQe0U6PrJahHZSHWiaZnORlHBInB6y0sz3MOsL01vg0Qu+BGGe03CNiMlES+kR
	GRDUvbMjhKFLOmYVXr6VyJsFYOmg4OJw0rmhVRq2aIj2oW9j2Q0ID4szhhZYSOxfl9CHJB
	vO8ycWRezLh9aXSet4t/rd76WIqLWjY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 479BE137D4;
	Sun,  3 Nov 2024 21:21:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9MJED2TpJ2dyZwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Sun, 03 Nov 2024 21:21:40 +0000
Message-ID: <1ecfb9236dd2703d90727b3468dfe3381987b4b4.camel@suse.com>
Subject: Re: [PATCH] multipath-tools: remove hwhandler from all hwtable
 configs
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM-DEVEL ML <dm-devel@lists.linux.dev>
Date: Sun, 03 Nov 2024 22:21:39 +0100
In-Reply-To: <20241010161806.14950-1-xose.vazquez@gmail.com>
References: <20241010161806.14950-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Score: -2.76
X-Spamd-Result: default: False [-2.76 / 50.00];
	BAYES_HAM(-3.00)[99.98%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.16)[-0.819];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,opensvc.com:email,suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Level: 

On Thu, 2024-10-10 at 18:18 +0200, Xose Vazquez Perez wrote:
> Useless, automatically handled by the kernel since 4.3.
> (4.3 was released nine years ago)
>=20
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
> =C2=A0libmultipath/hwtable.c | 44 ---------------------------------------=
-
> --
> =C2=A01 file changed, 44 deletions(-)

Reviewed-by: Martin Wilck <mwilck@suse.com>

