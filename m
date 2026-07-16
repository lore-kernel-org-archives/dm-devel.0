Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DDF424D71
	for <dm-devel@lists.linux.dev>; Thu, 16 Jul 2026 13:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209792; cv=none; b=iSbXVoMwtGyWGJ5Th9Yb5vL4VkEKom3cIPpj47vbem2X/W0nEEp7y9ZelixGTGHkyWzexk1oZ6ofG9dJotTRtnMoMK/SwcgbiI/GWhhXutKzFf6lkw66QI52ZNFtZSfApbmUGV/g+AHLXzxQ67h3nrkXvBPl9bHuu28ADCp3P5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209792; c=relaxed/simple;
	bh=2IV4ufsLkvM0F6M8w0toDvl5ZVQuULGGhf+52/PJKb0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Lmam3K5+SeL0yCO+QodmCnlh52HrRN5RuJRKCNPvn1FLSC+g+MkYTns7yOTO2miJY5Xc6XdRoVBsVJlB7eafjmDyBodT5AyRy63n1KoraLJmuDejQuGsoUfW0bWvx+7yiSZHfnRRSPxIEO3KIvXQzozWi8XCwmkF5h/V6HUffeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Y3ZdNk+S; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=JpxYyHia; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Y3ZdNk+S";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="JpxYyHia"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D53477899B;
	Thu, 16 Jul 2026 13:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784209785; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wb5GeVputG7oH+A+1FLm2q94QkCUu9g02TboGXMVfYo=;
	b=Y3ZdNk+Smhockm5C/itAqJmvc1jxB0bAOs0T8kEuGAozsn0qbqVuI6zUX4lZZCZM+bK1o7
	jwUWuEiWtfSOkQkFUkJiBk7XFCxMMkoESDd/PIOQ1HPrc9OJS2elv9h5/Uxt6Lh8IjNGXG
	CgxqUi1sGk3vR+J8T5+JbvIW7j5d3uo=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=JpxYyHia
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784209783; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wb5GeVputG7oH+A+1FLm2q94QkCUu9g02TboGXMVfYo=;
	b=JpxYyHia+gDuGWwz6v4Gqz6V5EoOI+FgEfG3yAUK40BXqZe7fQR28n3yutDtGw6xfjuSHa
	dD2MnQogAilpWnUt4ocFlPX5G9mesnOSXFuQ6VuS4Nkno+85rgCXYGXfoHne7x86Kmhm++
	BW9UNGcyDIhENzq+P2Xe6un3Bmq4tnk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B4A73779AD;
	Thu, 16 Jul 2026 13:49:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dwH7KnfhWGp+HAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Thu, 16 Jul 2026 13:49:43 +0000
Message-ID: <9c287af301748a1246a1383ca41109d3f94d1491.camel@suse.com>
Subject: Re: [PATCH v3] kpartx: fix crash and truncated device creation with
 long -p delimiter
From: Martin Wilck <mwilck@suse.com>
To: 303146950@qq.com
Cc: bmarzins@redhat.com, dm-devel@lists.linux.dev, kouwenqi@kylinos.cn
Date: Thu, 16 Jul 2026 15:49:43 +0200
In-Reply-To: <tencent_918E34F67972258FC8072E2DFE38C0989B05@qq.com>
References: <0594c64fe12ae0ea0ecee5b032f50e6842b120ed.camel@suse.com>
	 <tencent_918E34F67972258FC8072E2DFE38C0989B05@qq.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: D53477899B
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FREEMAIL_ENVRCPT(0.00)[qq.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[qq.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[qq.com:email,suse.com:mid,suse.com:dkim,kylinos.cn:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Thu, 2026-07-16 at 16:20 +0800, 303146950@qq.com wrote:
> From: Kou Wenqi <kouwenqi@kylinos.cn>
>=20
> When the -p delimiter is long enough to make the formatted partition
> name exceed PARTNAME_SIZE (128 bytes), three issues occur:
>=20
> 1. format_partname() fails but snprintf has already written a
> truncated
> =C2=A0=C2=A0 name into the buffer. dm_find_part() returns 0 and the calle=
r
> =C2=A0=C2=A0 proceeds to dm_addmap() with the truncated name, creating a =
device
> =C2=A0=C2=A0 that was never intended.
>=20
> 2. dm_find_part() returns early without setting *part_uuid. The
> =C2=A0=C2=A0 uninitialized local variable part_uuid then gets passed to
> =C2=A0=C2=A0 check_uuid() -> strchr(), causing a SIGSEGV.
>=20
> 3. The callers cannot distinguish between "partition not found,
> create
> =C2=A0=C2=A0 new" and "name construction failed" since both return 0.
>=20
> Fix by:
> - Having dm_find_part() return -1 when format_partname() fails, with
> =C2=A0 an error message printed by dm_find_part() itself, so that callers
> =C2=A0 can test the return value directly (negative for error,
> =C2=A0 0 for not found, positive for found)
> - In the ADD/UPDATE loops (both main and container), checking the
> =C2=A0 return value: negative means name too long (skip with error count)=
,
> =C2=A0 0 means not found (create), positive means found (reload)
> - In the DELETE loop, only proceeding with removal when
> dm_find_part()
> =C2=A0 returns positive (partition found), skipping when it returns zero
> =C2=A0 (not found) or negative (error)
> - Initializing part_uuid to NULL in all three partition loop bodies
> =C2=A0 (ADD/UPDATE main loop, container partition loop, DELETE loop) so
> =C2=A0 that the "if (part_uuid && uuid)" guard correctly skips the UUID
> =C2=A0 check when dm_find_part() returns early
>=20
> Reproduce steps:
>=20
> =C2=A0 # Create test image
> =C2=A0 dd if=3D/dev/zero of=3D/tmp/vhlg-test.img bs=3D1M count=3D10
> =C2=A0 parted /tmp/vhlg-test.img mklabel msdos
> =C2=A0 parted /tmp/vhlg-test.img mkpart primary ext4 1MiB 5MiB
>=20
> =C2=A0 # Reproduce
> =C2=A0 kpartx -a -p $(python3 -c "print('A'*200)") /tmp/vhlg-test.img
>=20
> =C2=A0 # Cleanup
> =C2=A0 kpartx -d /tmp/vhlg-test.img
> =C2=A0 rm -f /tmp/vhlg-test.img
>=20
> Signed-off-by: Kou Wenqi <kouwenqi@kylinos.cn>
> ---
> =C2=A0kpartx/devmapper.c |=C2=A0 5 ++---
> =C2=A0kpartx/kpartx.c=C2=A0=C2=A0=C2=A0 | 46 ++++++++++++++++++++++++++++=
++--------------
> --
> =C2=A02 files changed, 32 insertions(+), 19 deletions(-)
>=20

Thanks again. This looks quite good. However, what about this?

enum {
	DFP_DEVICE_CREATE =3D DM_DEVICE_CREATE,
	DFP_DEVICE_RELOAD =3D DM_DEVICE_RELOAD,
	DFP_ERR =3D -1,
};

Then use values of this enum as return values of dm_find_part().
If it returns DFP_ERR, bail out; otherwise use the return value as
"op", like this:

        if ((op =3D dm_find_part(...)) =3D=3D DFP_ERR)
                continue;

If you want to be extra careful, you could add something like
this at the beginning of dm_find_part():

BUILD_BUG_ON(DM_DEVICE_CREATE < 0 || DM_DEVICE_RELOAD < 0);

But I think we can trust that these values will always be positive.

Martin
