Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358DB194C83
	for <dm-devel@lists.linux.dev>; Mon, 12 Aug 2024 20:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723493138; cv=none; b=ObgJDlrPsWoSB8qMF5zRaOlq7CW4qnsnRIXPqYBXt64rqsimCp6J4u8AzWCyqUfvKYqtbUMlAQWdQHnnxq5+iUKT5nQdT23NU3sZv19aHYoTbJr5P7P3me08LjYrzsX1CPWke0tVCx+tTtfzK7EHRMsVFFvyYGlrLJrMU2bfmRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723493138; c=relaxed/simple;
	bh=WRrerikHJ7lDi7b6+Dpa6zYefP4NDDrPv14XgRuKfyM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XB+TQ1IgjlfokBzk4p2wXlRMbU+R0Jn+qvt1BZDTgtrtmqk651Laq8xmiVVzNwjijxG4Z4/8EWLrOAQuRv5+hS//QD9TupMfk7UtZMcwPlLDoq99L3J9sCQaOyhum7S4sEOAdKbSn+4J2vw0vKJmYlLj77CNopBHu4snfEkzewU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=PhjBhoh7; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=PhjBhoh7; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="PhjBhoh7";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="PhjBhoh7"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 14F27202D4;
	Mon, 12 Aug 2024 20:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1723493134; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WRrerikHJ7lDi7b6+Dpa6zYefP4NDDrPv14XgRuKfyM=;
	b=PhjBhoh7Mil8o7x6Z+Q9e+iMXs4Vy7qe6Oiubmz/K7qQNcwVIzEz0Q+pQLKkGJxzHW8hYh
	kN5q2Z4A68AMX0OFpNg7dVqCzmxOshSamOaXmxTZzPURJkqyoPfm+ihkH6QamQddx6QuHA
	G91ZUQKbLk3z0Um0IfWYqC8iDWymaCw=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1723493134; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WRrerikHJ7lDi7b6+Dpa6zYefP4NDDrPv14XgRuKfyM=;
	b=PhjBhoh7Mil8o7x6Z+Q9e+iMXs4Vy7qe6Oiubmz/K7qQNcwVIzEz0Q+pQLKkGJxzHW8hYh
	kN5q2Z4A68AMX0OFpNg7dVqCzmxOshSamOaXmxTZzPURJkqyoPfm+ihkH6QamQddx6QuHA
	G91ZUQKbLk3z0Um0IfWYqC8iDWymaCw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D8E3C13983;
	Mon, 12 Aug 2024 20:05:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0DALMw1rumaNcwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 12 Aug 2024 20:05:33 +0000
Message-ID: <faefa584f2536773402be7b765277d3401fffa79.camel@suse.com>
Subject: Re: [PATCH] multipath-tools: add more info about the tur checker to
 the man page
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM-DEVEL ML <dm-devel@lists.linux.dev>
Date: Mon, 12 Aug 2024 22:05:33 +0200
In-Reply-To: <20240812191338.284581-1-xose.vazquez@gmail.com>
References: <20240812191338.284581-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Flag: NO
X-Spam-Level: 

On Mon, 2024-08-12 at 21:13 +0200, Xose Vazquez Perez wrote:
> Hardware dependent, and only for SCSI devices.
>=20
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
> =C2=A0multipath/multipath.conf.5.in | 3 ++-
> =C2=A01 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/multipath/multipath.conf.5.in
> b/multipath/multipath.conf.5.in
> index e0794bac..f70cdc2f 100644
> --- a/multipath/multipath.conf.5.in
> +++ b/multipath/multipath.conf.5.in
> @@ -526,7 +526,8 @@ second, until \fIchecker_timeout\fR seconds have
> elapsed. Possible values are:
> =C2=A0deprecated, please use \fItur\fR or \fIdirectio\fR instead.
> =C2=A0.TP
> =C2=A0.I tur
> -Issue a \fITEST UNIT READY\fR command to the device.
> +(Hardware-dependent)
> +Issue a \fITEST UNIT READY\fR command to a SCSI device.
> =C2=A0.TP
> =C2=A0.I emc_clariion
> =C2=A0(Hardware-dependent)

