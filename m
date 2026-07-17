Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2216F3DD53C
	for <dm-devel@lists.linux.dev>; Fri, 17 Jul 2026 10:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784283207; cv=none; b=BRzZuwgXBy7+dpjgu48V2l/+W1EIFDyKp3PY8Weh1+LBF22hDXUidzldeRTHWkG5Z6LLaEZehceZ3ypMGB//roIQEBWCCTa4OUUYY0yRn2I87o19g5fHB8b+252ZeG3TMChYcHl9rkcXD7hQQCJO1siPt98se7hklHXFr9cI7ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784283207; c=relaxed/simple;
	bh=x1B6HtrTjA8aJOyck6YbT+TedDrZE0SbblwiQzoUPQ0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qxq851zaEqwqkssraU8Qo8piyjpWWJ8UNghc8/bZNWMxFHJ9UcWEJhDY2I6cxk8ZZkd5lpXpwCTvSEZx1mbA/caqHYYTmCzIDdeFVX4qNzEPK2lIp+hgwaVpcoIww4r59upaMPgxZhTCum2kVI09lhO4Rv7ny/o/G92bkPfDsf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=M3d58A3C; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=czZRat5/; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="M3d58A3C";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="czZRat5/"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E48CA78DD0;
	Fri, 17 Jul 2026 10:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784283203; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x1B6HtrTjA8aJOyck6YbT+TedDrZE0SbblwiQzoUPQ0=;
	b=M3d58A3CDirq7CixMzXyayy1KybahQkXoSROvRL/v5Slp2jGUdasVIsYLYfVR80wemGkxZ
	FQwiXe128DI1rxzLAceq3DNa2Tx3TVaxeIP1gHEFfp7+oKVST7Cj4qJ7GgWCWkEyM8OLO+
	tixNVSGM91Xssyn2JF3M714FucdfjYM=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="czZRat5/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784283202; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x1B6HtrTjA8aJOyck6YbT+TedDrZE0SbblwiQzoUPQ0=;
	b=czZRat5/AsNEVLSpsYYqgWUEjFWTp9zy9S+6NYOjorCkunGFKsgIAUEzVrDnZLLm0F6d/5
	1WQGhdXMGCavAzGZcVjmdKSpb9ggB57MLJeEjlssRWE5peVBOxrn+6qmTlGTKhPiN8V2S+
	aWBGCkhX4FqTlASEbykHXmtdt1TWIz8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C24F5779AA;
	Fri, 17 Jul 2026 10:13:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UXdYLkIAWmomJgAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 17 Jul 2026 10:13:22 +0000
Message-ID: <b846135c8c104ba30acd28401c3290ba781bbca0.camel@suse.com>
Subject: Re: [PATCH v4] kpartx: fix crash and truncated device creation with
 long -p delimiter
From: Martin Wilck <mwilck@suse.com>
To: 303146950@qq.com
Cc: bmarzins@redhat.com, dm-devel@lists.linux.dev, kouwenqi@kylinos.cn
Date: Fri, 17 Jul 2026 12:13:22 +0200
In-Reply-To: <tencent_2F027EB83F48459E115634898CE03EE35509@qq.com>
References: <9c287af301748a1246a1383ca41109d3f94d1491.camel@suse.com>
	 <tencent_2F027EB83F48459E115634898CE03EE35509@qq.com>
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
X-Rspamd-Queue-Id: E48CA78DD0
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[qq.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_TO(0.00)[qq.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	TO_DN_NONE(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kylinos.cn:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:email,suse.com:mid]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Fri, 2026-07-17 at 11:34 +0800, 303146950@qq.com wrote:
> From: Kou Wenqi <kouwenqi@kylinos.cn>
>=20
> On Thu, 2026-07-16 at 15:49 +0200, mwilck@suse.com=C2=A0wrote:
> > Thanks again. This looks quite good. However, what about this?
> >=20
> > enum {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 DFP_DEVICE_CREATE =3D DM_DEVICE_CREATE,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 DFP_DEVICE_RELOAD =3D DM_DEVICE_RELOAD,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 DFP_ERR =3D -1,
> > };
>=20
> Good idea. I've defined this enum in kpartx/devmapper.h (which now
> also includes <libdevmapper.h> to make the header self-contained),
> and dm_find_part() uses these enum values explicitly in all return
> statements.
>=20
> > Then use values of this enum as return values of dm_find_part().
> > If it returns DFP_ERR, bail out; otherwise use the return value as
> > "op", like this:
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if ((op =3D dm_find_part(...=
)) =3D=3D DFP_ERR)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 continue;
>=20
> Done. In the ADD/UPDATE loops, the return value is assigned directly
> to 'op', and DFP_ERR is handled with r++ and continue. In the DELETE
> loop, I check against DFP_DEVICE_RELOAD to proceed with removal.
>=20
> > If you want to be extra careful, you could add something like
> > this at the beginning of dm_find_part():
> >=20
> > BUILD_BUG_ON(DM_DEVICE_CREATE < 0 || DM_DEVICE_RELOAD < 0);
> >=20
> > But I think we can trust that these values will always be positive.
>=20
> I've omitted this check, as I agree that DM_DEVICE_CREATE and
> DM_DEVICE_RELOAD are defined by libdevmapper as positive constants
> and are unlikely to change.
>=20
> Changes since v3:
> =C2=A0 - Defined enum { DFP_DEVICE_CREATE, DFP_DEVICE_RELOAD, DFP_ERR }
> =C2=A0=C2=A0=C2=A0 in kpartx/devmapper.h
> =C2=A0 - dm_find_part() returns enum values explicitly in all return path=
s
> =C2=A0 - Callers assign return value directly to 'op' and check for
> DFP_ERR
> =C2=A0 - kpartx/devmapper.h now includes <libdevmapper.h> directly
>=20
> Here is the new patch.
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
> 3. The callers cannot distinguish between 'partition not found,
> create
> =C2=A0=C2=A0 new' and 'name construction failed' since both return 0.
>=20
> Fix by:
> - Having dm_find_part() return DFP_ERR when format_partname() fails,
> =C2=A0 with an error message printed by dm_find_part() itself
> - Defining an enum to represent the return values of dm_find_part():
>=20
> =C2=A0 enum {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 DFP_DEVICE_CREATE =3D DM_DEVICE_CREATE,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 DFP_DEVICE_RELOAD =3D DM_DEVICE_RELOAD,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 DFP_ERR =3D -1
> =C2=A0 };
>=20
> =C2=A0 This enum is placed in kpartx/devmapper.h, which now also includes
> =C2=A0 <libdevmapper.h> directly to make the header self-contained.
> =C2=A0 dm_find_part() uses these enum values explicitly in all return
> =C2=A0 statements.
> - In the ADD/UPDATE loops (both main and container), assigning the
> =C2=A0 return value directly to 'op' and checking for DFP_ERR to handle
> =C2=A0 errors
> - In the DELETE loop, checking the return value against
> =C2=A0 DFP_DEVICE_RELOAD to proceed with removal, skipping on error or
> =C2=A0 not-found
> - Initializing part_uuid to NULL in all three partition loop bodies
> =C2=A0 (ADD/UPDATE main loop, container partition loop, DELETE loop) so
> =C2=A0 that the 'if (part_uuid && uuid)' guard correctly skips the UUID
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

Thanks a lot!

Reviewed-by: Martin Wilck <mwilck@suse.com>

I also added a test case for this problem in the "test-kpartx" script.
The code is currently on my "tip" branch:

https://github.com/openSUSE/multipath-tools/tree/tip

--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Jochen Jaser, Andrew McDonald (HRB 36809,AG N=C3=
=BCrnberg)
