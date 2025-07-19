Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A6E238C08
	for <dm-devel@lists.linux.dev>; Sat, 19 Jul 2025 12:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752928453; cv=none; b=AYSxjpIhgj4kleHfFg3dBKEYM/Gvzqs/XikfhSaXwdIa2t7enlwPsVEXXgdJMbdQGJBfxL56eV90WW85J6nt0NPenmb4v9f00xl2V2WMo8c45/kh427/BGTBVDRIherq+tT+haYo5kd9Lg9WtztqmDxBNsHg3bTJWQHW8SesyoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752928453; c=relaxed/simple;
	bh=Rm0zbEwk9KHzDBMQzX9y4GKYY3gBP0Ni04OTqXxNEEg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gxTnEj7+zLqfYzdLdv7WojtPYENjt9d3Nr1xqEIrw/mHFPWd6V8V5AD5PnUJ7BQpDRpgXbi5dxsLFjIbTX9NvyKeJGEd1rt+pcwQ9MB0z2RuedFbM+q4nzI4QYF+0ZaUGDk53ZVllYv8LXp0vuWe1+8L5/pa326JHHzobMoUZmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=R+X0qvTY; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=R+X0qvTY; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="R+X0qvTY";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="R+X0qvTY"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E8630211F5;
	Sat, 19 Jul 2025 12:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1752928444; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rm0zbEwk9KHzDBMQzX9y4GKYY3gBP0Ni04OTqXxNEEg=;
	b=R+X0qvTYFWwhoz/BDnNraNsW25p4kcYSZTz3HseyXG7mQnVfM+g+oH7ZIX+2RgHEPgWtD7
	1dz+kxriFqJswx/lQus1e8QFL3ZHEHw4vSzDJBz23Y7MY8U9u7hFnjrJP9DZfq8vFaQJMV
	DIQUp/w+vtyEUGLOc3U12ZftxeS4L7Q=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=R+X0qvTY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1752928444; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rm0zbEwk9KHzDBMQzX9y4GKYY3gBP0Ni04OTqXxNEEg=;
	b=R+X0qvTYFWwhoz/BDnNraNsW25p4kcYSZTz3HseyXG7mQnVfM+g+oH7ZIX+2RgHEPgWtD7
	1dz+kxriFqJswx/lQus1e8QFL3ZHEHw4vSzDJBz23Y7MY8U9u7hFnjrJP9DZfq8vFaQJMV
	DIQUp/w+vtyEUGLOc3U12ZftxeS4L7Q=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 978F9136A8;
	Sat, 19 Jul 2025 12:34:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OCHyI7uQe2jpcgAAD6G6ig
	(envelope-from <mwilck@suse.com>); Sat, 19 Jul 2025 12:34:03 +0000
Message-ID: <cc3cf74ef6c394b371f4ce0e0dfe09f783403617.camel@suse.com>
Subject: Re: [PATCH] multipath-tools: fix default blacklist of s390 devices
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, Stefan Haberland
	 <sth@linux.ibm.com>
Cc: Nigel Hislop <hislop_nigel@emc.com>, Matthias Rudolph	
 <Matthias.Rudolph@hitachivantara.com>, Heiko Carstens <hca@linux.ibm.com>, 
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger	
 <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Hannes
 Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui	 <christophe.varoqui@opensvc.com>, S390-ML
 <linux-s390@vger.kernel.org>,  DM-DEVEL-ML <dm-devel@lists.linux.dev>,
 Nigel Hislop <hislop_nigel@dell.com>
Date: Sat, 19 Jul 2025 14:34:03 +0200
In-Reply-To: <2c83b76c-46cc-4632-a930-d023c7d3d7b0@gmail.com>
References: <20250712201454.215404-1-xose.vazquez@gmail.com>
	 <76bde3f1-0f06-46fc-8e0a-729e6629024c@gmail.com>
	 <d5e08375-211d-405b-9a00-f44c857cedac@linux.ibm.com>
	 <2c83b76c-46cc-4632-a930-d023c7d3d7b0@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: E8630211F5
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,linux.ibm.com];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:mid]
X-Spam-Score: -3.01

On Fri, 2025-07-18 at 22:54 +0200, Xose Vazquez Perez wrote:
> On 7/14/25 2:38 PM, Stefan Haberland wrote:
>=20
> > > Is PAV really supported on FBA devices ???
> > > And other than 3390 and 3380(3390 model 2/3 in track-
> > > compatibility mode) ECKD types ?
> >=20
> > Currently there is no support in the driver for PAV with FBA
> > devices.
> > But the devices itself are capable of PAV.
>=20
> If there is no PAV support for FBA devices on Linux, and it looks
> like it won't be
> implemented even in the distant future. The detection code, and the
> device, could
> be deleted from multipath-tools:

I agree. @Stefan, it would be appreciated if you or someone from your
group could send a patch.

Martin

> https://github.com/opensvc/multipath-tools/blob/de16cf82c5263fc148118be56=
ebf44c8f0ee60b8/libmultipath/hwtable.c#L688-L697
> https://github.com/opensvc/multipath-tools/blob/de16cf82c5263fc148118be56=
ebf44c8f0ee60b8/libmultipath/discovery.c#L1674-L1685
>=20
> Is PAV supported on 9343/9345 (cutype/devtype) ECKD devices?
>=20
>=20
> Thanks.
