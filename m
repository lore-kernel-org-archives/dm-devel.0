Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364B31BD01D
	for <dm-devel@lists.linux.dev>; Mon, 19 May 2025 17:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747676048; cv=none; b=dMXoXGggCYcZmsoFsPKtMQAIU1t8tQ2wjb5vIE563kgavJrFNvjvVBmp5Tx1iP7T0EnT1Emghrw1bNpBeCuOBk0Ak+gQMi9KeNxWBLIad8D1i6ouMBZUWnSraM6Lng4OjJkDK316lPaaNdCYFK90V4egX0lIUy0ESKIQKgWNmoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747676048; c=relaxed/simple;
	bh=soUWVotbkkPRGuzJ5h72BMPmsZ4YC7rwHPlMAUx9rCk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AiYWeiccWI4P4g8q98I5oVp/Cx8IvEBWsHZaOazu8WL1zD3ZnX5qlhlGIsMuNN4zSoXvS+GRMCHaq4rHUI6QfsOF5lZ8kWi+E0Utj1zbjG+HQq8iGGoQxNbQ1WWqtbLgNQpwdVY45vyuwT/J+RoqQ5hJygSSnjDMLwAYUQ6GJUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=fn8xRRtJ; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=fn8xRRtJ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="fn8xRRtJ";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="fn8xRRtJ"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2C88C203FA;
	Mon, 19 May 2025 17:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1747676044; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=afqcAyMEWhDg/X6AbdQWIN3do8w2PdHrulOvuB61EUI=;
	b=fn8xRRtJohlDN9hqWTU+Ed4AlDpbThX1VU7zm96WYsmx35UnZLrXrYLzKIjEaME4PBvpMQ
	ZK1AHnLuRhLTajVVQSj/decfOuLlM+y6k8MRMT2KYpOypi6pNP/iwkhDW7SMTxAxLKQzgN
	Df2RJeEjRRF177hJarGEhEZixBeLhDw=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=fn8xRRtJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1747676044; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=afqcAyMEWhDg/X6AbdQWIN3do8w2PdHrulOvuB61EUI=;
	b=fn8xRRtJohlDN9hqWTU+Ed4AlDpbThX1VU7zm96WYsmx35UnZLrXrYLzKIjEaME4PBvpMQ
	ZK1AHnLuRhLTajVVQSj/decfOuLlM+y6k8MRMT2KYpOypi6pNP/iwkhDW7SMTxAxLKQzgN
	Df2RJeEjRRF177hJarGEhEZixBeLhDw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 922431372E;
	Mon, 19 May 2025 17:33:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iSd6JoRrK2hiaQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 19 May 2025 17:33:56 +0000
Message-ID: <f114a8d8497da0c452af33cbf02a55e91c47d94e.camel@suse.com>
Subject: Re: [PATCH 0/2] dm mpath: Interface for explicit probing of active
 paths
From: Martin Wilck <mwilck@suse.com>
To: Christoph Hellwig <hch@infradead.org>, Kevin Wolf <kwolf@redhat.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev, 
	hreitz@redhat.com, mpatocka@redhat.com, snitzer@kernel.org, 
	linux-kernel@vger.kernel.org
Date: Mon, 19 May 2025 19:33:50 +0200
In-Reply-To: <aCbUcdew393RZIkV@infradead.org>
References: <20250429165018.112999-1-kwolf@redhat.com>
	 <47dd225b433b0df585a25084a2e793344eeda239.camel@suse.com>
	 <aCIRUwt5BueQmlMZ@redhat.com>
	 <d51d6f85b5728648fe9c584f9cb3acee12c4873f.camel@suse.com>
	 <cc2ec011cf286cb5d119f2378ecbd7b818e46769.camel@suse.com>
	 <aCW95f8RGpLJZwSA@redhat.com> <aCbUcdew393RZIkV@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Score: -4.51
X-Rspamd-Queue-Id: 2C88C203FA
X-Spam-Level: 
X-Spam-Flag: NO

On Thu, 2025-05-15 at 23:00 -0700, Christoph Hellwig wrote:
> On Thu, May 15, 2025 at 12:11:49PM +0200, Kevin Wolf wrote:
> > If you're talking about SG_IO in dm-mpath, then PRIN/PROUT commands
> > are
> > actually the one thing that we don't need. libmpathpersist sends
> > the
> > commands to the individual path devices, so dm-mpath will never see
> > those. It's mostly about getting the full results on the SCSI level
> > for
> > normal I/O commands.
> >=20
> > There has actually been a patch series on qemu-devel last year
> > (that I
> > haven't found the time to review properly yet) that would add
> > explicit
> > persistent reservation operations to QEMU's block layer that could
> > then
> > be used with the emulated scsi-hd device. On the backend, it only
> > implemented it for iscsi, but I suppose we could implement it for
> > file-posix, too (using the same libmpathpersist code as for
> > passthrough). If that works, maybe at least some users can move
> > away
> > from SCSI passthrough.
>   x
> Please call into the kernel PR code instead of hacking up more of
> this, which will just run into problems again.

I still don't get what this buys us. The guest (which might be Windows
or whatever else) sends SCSI reservation commands. qemu will have to
intercept these anyway, unless the backend device is a plain SCSI
device (in which case transformation into generic PR command would be a
strange thing to do).

If the backend device is multipath on SCSI, qemu-pr-helper would take=20
the most appropriate action and return the most appropriate result
code. The dm-multipath layer can't do it as well, as it doesn't have
the full information about the target that's available in user space
(see Ben's note about ALL_TG_PT for example). I don't see any benefit
from using a generic reservation on dm-mpath instead of using qemu-pr-
helper for this important use case.=C2=A0

I also don't see why this way of handling SCSI PR commands would be
dangerous. You are of course right to say that passthrough of other
SCSI commands (except regular IO and PR) is highly dangerous, but in
the concept that Kevin described that wouldn't happen.

Transforming the SCSI reservation commands into generic reservation
commands makes sense for _other_ types of backend devices. NVMe=C2=A0comes
to mind, but (for real-world applications) not much else. (But does it
make sense to present NVMe devices to guests as SCSI devices?).

Regards
Martin
