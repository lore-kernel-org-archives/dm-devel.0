Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BABB23D2AF
	for <dm-devel@lists.linux.dev>; Fri,  9 May 2025 13:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746798859; cv=none; b=mou1qNFnhljqkazc8IL4HI8Qia69F5MnmxcY1tow6vyAEBnIKDMhBLgqP8PL3n+5wpS97tsUaCi3pgrrcwjvQqDRg03J3PhneR0PHNdGoLTATwklerP6ZluPS/tSOeaBobo7EW7VdkyjGe2hYeFhZlUbnMaAstWaUdOHE5ViJjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746798859; c=relaxed/simple;
	bh=mse/VOX+IFZwIbSRx1rH5VQyKCBLbQakAg9R+em8NGg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QbozmAkc1cLu/uHzJENF6IvFlDbQxpPMoT02BPj86o+cHUERrzZx5MWOBndik2uzcGYheL0vdgkr+cjDXMCYBp6aFaaEJ1EXnSi9VCcJzwTPbqr+BNcRhxvsRExA7gj+o3+4nQLCs+vAqGJuX8Wy5u+B/pSPiJzXdPw/FCxrkX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=HwFMgQnT; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=HwFMgQnT; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="HwFMgQnT";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="HwFMgQnT"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9C8651F38A;
	Fri,  9 May 2025 13:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1746798854; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mse/VOX+IFZwIbSRx1rH5VQyKCBLbQakAg9R+em8NGg=;
	b=HwFMgQnTwRwwBTi0KyD2RGxzYofluxgzqaOavl6tOXnraCRB2ThBXTcfrGobj6fXQaxp5X
	9fUUK6fG9Uk7XkqyIjFQu0QD9d4yTZxeE0RQanI75V4LH3rpu/eu+O2LCzREcyUZgpMyYe
	4Y3WXiw6eeCBUzCmrVdTmgG4axAX6K4=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=HwFMgQnT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1746798854; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mse/VOX+IFZwIbSRx1rH5VQyKCBLbQakAg9R+em8NGg=;
	b=HwFMgQnTwRwwBTi0KyD2RGxzYofluxgzqaOavl6tOXnraCRB2ThBXTcfrGobj6fXQaxp5X
	9fUUK6fG9Uk7XkqyIjFQu0QD9d4yTZxeE0RQanI75V4LH3rpu/eu+O2LCzREcyUZgpMyYe
	4Y3WXiw6eeCBUzCmrVdTmgG4axAX6K4=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5D5C41399F;
	Fri,  9 May 2025 13:54:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id whWbFAYJHmhKQgAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 09 May 2025 13:54:14 +0000
Message-ID: <69290f5c57f084ea7169a25fadeb7aa51d40c511.camel@suse.com>
Subject: Re: [PATCH] multipath-tools: update Path Selector descriptions on
 the man page
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM-DEVEL ML <dm-devel@lists.linux.dev>
Date: Fri, 09 May 2025 15:54:13 +0200
In-Reply-To: <20250509112826.160900-1-xose.vazquez@gmail.com>
References: <20250509112826.160900-1-xose.vazquez@gmail.com>
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
X-Rspamd-Queue-Id: 9C8651F38A
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_DN_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,suse.com:mid]
X-Rspamd-Action: no action

On Fri, 2025-05-09 at 13:28 +0200, Xose Vazquez Perez wrote:
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
> =C2=A0multipath/multipath.conf.5.in | 23 +++++++++++++----------
> =C2=A01 file changed, 13 insertions(+), 10 deletions(-)
>=20
> diff --git a/multipath/multipath.conf.5.in
> b/multipath/multipath.conf.5.in
> index d0f6c6ac..9884df93 100644
> --- a/multipath/multipath.conf.5.in
> +++ b/multipath/multipath.conf.5.in
> @@ -197,22 +197,25 @@ kernel multipath target:
> =C2=A0.RS
> =C2=A0.TP 12
> =C2=A0.I "round-robin 0"
> -Loop through every path in the path group, sending the same amount
> of I/O to
> -each. Some aspects of behavior can be controlled with the
> attributes:
> -\fIrr_min_io\fR, \fIrr_min_io_rq\fR and \fIrr_weight\fR.
> +Choose the path for the next bunch of I/O based on a rotational
> distribution,

"rotational distribution" sounds weird. "by looping through every path
in the path group" is easier to understand.

> +sending \fBthe same number of I/Os\fR to each path. Some aspects of
> behavior can be
> +controlled with the attributes: \fIrr_min_io\fR, \fIrr_min_io_rq\fR
> and \fIrr_weight\fR.
> =C2=A0.TP
> =C2=A0.I "queue-length 0"
> -(Since 2.6.31 kernel) Choose the path for the next bunch of I/O
> based on the amount
> -of outstanding I/O to the path.
> +(Since 2.6.31 kernel) Choose the path for the next bunch of I/O
> based on \fBthe lowest
> +number of outstanding in-flight I/Os\fR to the path.

I suggest using "I/O requests" rather than "I/Os".

> =C2=A0.TP
> =C2=A0.I "service-time 0"
> -(Since 2.6.31 kernel) Choose the path for the next bunch of I/O
> based on the amount
> -of outstanding I/O to the path and its relative throughput.
> +(Since 2.6.31 kernel) Choose the path for the next bunch of I/O
> based on \fBthe
> +lowest total size (in bytes) of outstanding in-flight I/Os\fR to the

same as above, or use "in-flight I/O".

> path. If
> +\fIrelative_throughput\fR argument is defined for each path, it's
> also used to
> +calculate the best service time.

This is misleading, as multipath-tools currently don't support path
weights, except for round-robin.

> =C2=A0.TP
> =C2=A0.I "historical-service-time 0"
> -(Since 5.8 kernel) Choose the path for the next bunch of I/O based
> on the
> -estimation of future service time based on the history of previous
> I/O submitted
> -to each path.
> +(Since 5.8 kernel) Choose the path for the next bunch of I/O with
> \fBa dinamyc

Typo.

> +algorithm based on the historical service time and the number
> outstanding
> +in-flight I/Os\fR to the path. It can be tuning with

See above wrt "I/Os". Also, use "tuned" ...

> \fIbase_weight\fR and
> +\fIthreshold_multiplier\fR arguments.
> =C2=A0.TP
> =C2=A0The default is: \fBservice-time 0\fR
> =C2=A0.RE

... but again, this is misleading. As the trailing "0" implies,
multipath-tools currently doesn't support passing parameters to path
selector algorithms. In the multipath.conf man page, we shouldn't
mention features that we don't support.

Regards
Martin
