Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4AA34CF9
	for <dm-devel@lists.linux.dev>; Thu, 15 May 2025 14:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747320644; cv=none; b=P4NUeiQh+GhmPGnkJA2AQa0bjyY2UlJLV3sz1IWlK+Sr/bazvqG0SfxptStmFyQ4WYGatHEKuZXPv8aqK+vXuDFl9NQJq3y61iKobVBjc54MmV7vBwny1BXaZMOGvnCkIMZQHJTHOhBG9IyFB8baIa9W5lk9oHR13cMop4j/j50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747320644; c=relaxed/simple;
	bh=iNPPWSSjkux2vHUUvYMs1kFOANwWm0iuVqNOjO5Mcf8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NJJsX60Gia3HGyiLEb8kzqV5JvZGly4JaoPHyWs4drn66oWfEWR9A3u8Kzwp3SkriLfHYF1VDxjIN6N/Os3eEI9MZIHRrxW1MKL+rb9rEnHScFEk7KIDZlQhAP7bN4YccZHD6SLU2mtkGMyASVzCvo6R1XWxrwoVnj8GzacVCa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ZM8Zvx54; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ZM8Zvx54; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ZM8Zvx54";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ZM8Zvx54"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 492341F387;
	Thu, 15 May 2025 14:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1747320639; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iNPPWSSjkux2vHUUvYMs1kFOANwWm0iuVqNOjO5Mcf8=;
	b=ZM8Zvx54WX9irnyij+Lz+cLbYu3X+YT8LgN8Gvm1RPXcgqyWs+EdxRbJqKlPinTBTT1krk
	5EzlzE8AFEwjpFvy+PJZxbWGgfkfvpMZab0ok0N3DPidSmfEGAQYEnWJ1MBEVYwLHcLEA+
	ohRv9n649lWpoWXfN+f09tEL2R/5FLA=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=ZM8Zvx54
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1747320639; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iNPPWSSjkux2vHUUvYMs1kFOANwWm0iuVqNOjO5Mcf8=;
	b=ZM8Zvx54WX9irnyij+Lz+cLbYu3X+YT8LgN8Gvm1RPXcgqyWs+EdxRbJqKlPinTBTT1krk
	5EzlzE8AFEwjpFvy+PJZxbWGgfkfvpMZab0ok0N3DPidSmfEGAQYEnWJ1MBEVYwLHcLEA+
	ohRv9n649lWpoWXfN+f09tEL2R/5FLA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DE918137E8;
	Thu, 15 May 2025 14:50:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xOrEND7/JWjFOQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Thu, 15 May 2025 14:50:38 +0000
Message-ID: <71b42e5b613628642abeba5bd1e61089ca59c643.camel@suse.com>
Subject: Re: [PATCH 0/2] dm mpath: Interface for explicit probing of active
 paths
From: Martin Wilck <mwilck@suse.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christoph Hellwig	
 <hch@infradead.org>, Kevin Wolf <kwolf@redhat.com>,
 dm-devel@lists.linux.dev,  Hanna Czenczek <hreitz@redhat.com>, Mikulas
 Patocka <mpatocka@redhat.com>, snitzer@kernel.org, "Kernel Mailing List,
 Linux" <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.com>
Date: Thu, 15 May 2025 16:50:38 +0200
In-Reply-To: <CABgObfZVbKcAua_=+C_0eC5Ec2ZDY4Bsz_b1memF1KifVGhoQw@mail.gmail.com>
References: <20250429165018.112999-1-kwolf@redhat.com>
	 <47dd225b433b0df585a25084a2e793344eeda239.camel@suse.com>
	 <aCIRUwt5BueQmlMZ@redhat.com> <aCLe5UT2kfzI96TQ@infradead.org>
	 <aCMQ5S-gI6vZJxmq@redhat.com> <aCQiz88HksKg791Z@infradead.org>
	 <aCTDiHMuMncwdp_X@redhat.com>
	 <50beb356b4dc000446fd186ab754c87f386eaeae.camel@suse.com>
	 <CABgObfaEiMN=YANk02EWini+jAXU1MxSvo8_jYWaMiu3ds7hgQ@mail.gmail.com>
	 <2f0fc8ef7d04c590893bd6d54a6c0c842c4b21d7.camel@suse.com>
	 <CABgObfZVbKcAua_=+C_0eC5Ec2ZDY4Bsz_b1memF1KifVGhoQw@mail.gmail.com>
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
X-Rspamd-Queue-Id: 492341F387
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_ALL(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MID_RHS_MATCH_FROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.com:mid,suse.com:dkim];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Score: -4.51

On Thu, 2025-05-15 at 12:51 +0200, Paolo Bonzini wrote:
> On Thu, May 15, 2025 at 12:34=E2=80=AFPM Martin Wilck <mwilck@suse.com>=
=20
> >=20
> > Thanks for mentioning this. However, I suppose that depends on the
> > permissions with which the qemu process is started, no? Wouldn't
> > qemu need CAP_SYS_RAWIO for PCI passthrough as well?
>=20
> Generally you want to assume that the VM is hostile and run QEMU with
> as few privileges as possible (not just capabilities, but also in
> separate namespaces and with restrictions from device cgroups,
> SELinux, etc.). PCI passthrough is not an issue, it only needs access
> to the VFIO inodes and you can do it by setting the appropriate file
> permissions without extra capabilities. The actual privileged part is
> binding the device to VFIO, which is done outside QEMU anyway.

Thanks for the clarification.

> > I admit that I'm confused by the many indirections in qemu's scsi-
> > block
> > code flow. AFAICS qemu forwards everything except PRIN/PROUT to the
> > kernel block device in "scsi-block" mode. Correct me if I'm wrong.
>=20
> Yes, that's correct. The code for PRIN/PROUT calls out to a separate
> privileged process (in scsi/qemu-pr-helper.c if you're curious) which
> is aware of multipath and can be extended if needed.

Sure, I was aware of the helper. I just wasn't 100% clear about how it
gets called. Found the code in the meantime [1].

[1] https://github.com/qemu/qemu/blob/864813878951b44e964eb4c012d832fd21f8c=
c0c/block/file-posix.c#L4286

> > > .Of the ones that aren't simple I/O, mode parameters and TUR are
> > > the
> > > important cases. A TUR failure would be handled by the ioctl that
> > > Kevin proposed here by forcing a path switch. Mode parameters
> > > might
> > > not be shared(*) and would need to be sent down all the paths in
> > > that
> > > case; that can be fixed in userspace if necessary.
> >=20
> > Passing TUR from a multipath device to a random member doesn't make
> > much sense to me. qemu would need to implement some logic to
> > determine
> > whether the map has any usable paths.
>=20
> As long as one path replies to a TUR and the host is able to
> (eventually, somehow) steer I/O transparently to that path, that
> should be good enough. If the one path that the kernel tries is down,
> QEMU can probe which paths are up and retry. That seems consistent
> with what you want from TUR but maybe I'm missing something.

It's ok-ish, in particular in combination with Kevin't patch. But using
an equivalent of "multipath -C" would be closer to the real thing for
TUR.

Regards
Martin
