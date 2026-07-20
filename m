Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C482138F255
	for <dm-devel@lists.linux.dev>; Mon, 20 Jul 2026 19:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784575790; cv=none; b=DO0E4mAWDxtFmD1RcnnRCC2I+NbtqaQCoVW8n8GyBXcXhzN2+xsd0ls04G7cJP9S/dHdK2/274xddL9UzP9TM5/gsSXV4pKO2WT6w/dIoA1W6/eOU7RCdd2QxFIRc/QEqK39NnJkkc/rLRIMfESgXACUSYy8I2lEXvrEag/l1Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784575790; c=relaxed/simple;
	bh=PLN5QKafMzDO+VKeUSEd+acs4iaHsOfW8YM42fh5gsk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Y6d3DeKqcq9zsRNkL0+iLrXHJAYfeuuiKJ+GDPhWFGqqVUznX/vvEtspJzEn4uVfu0g6dujbyu7CppgNTM6YR+sJOMVhkbMm8qfdQbs44dId7VsMCXIliJXaz5fRk+Y+M6ck1GVv6SGXF3ieVRKDT1MP/G5xz0/HALaqM+3BLgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=OnyY9f50; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=OnyY9f50; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="OnyY9f50";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="OnyY9f50"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BA9D13E09;
	Mon, 20 Jul 2026 19:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784575786; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PLN5QKafMzDO+VKeUSEd+acs4iaHsOfW8YM42fh5gsk=;
	b=OnyY9f50sU8JUEpuMhtV19XhHGTyms/STa99njaoAuI6YVboeFeZ2fWvEF5hCzu3PP4eVE
	TRQwp9Gt5GlkxryhU97uztqUdkakY088ZubczL+18pElCRSYIzUi16/kC62UjqeSY4wUus
	MOMwfEkJLYrZWF5xULMJSNluMgWaJbw=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784575786; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PLN5QKafMzDO+VKeUSEd+acs4iaHsOfW8YM42fh5gsk=;
	b=OnyY9f50sU8JUEpuMhtV19XhHGTyms/STa99njaoAuI6YVboeFeZ2fWvEF5hCzu3PP4eVE
	TRQwp9Gt5GlkxryhU97uztqUdkakY088ZubczL+18pElCRSYIzUi16/kC62UjqeSY4wUus
	MOMwfEkJLYrZWF5xULMJSNluMgWaJbw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 94DA1779AA;
	Mon, 20 Jul 2026 19:29:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4z3JIip3XmqLdAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 20 Jul 2026 19:29:46 +0000
Message-ID: <4eac328f2dcc1d8303de61bf6e34d260270e4a95.camel@suse.com>
Subject: Re: Obsolete features (was Re: [PATCH 0/4] minio cleanup patches.)
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Xose Vazquez Perez
	 <xose.vazquez@gmail.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Mon, 20 Jul 2026 21:29:46 +0200
In-Reply-To: <al4_1Ad2useO9bNR@redhat.com>
References: <20260615190711.797573-1-bmarzins@redhat.com>
	 <8b715fda-3e14-4a6d-bba0-a3e53481f567@gmail.com>
	 <ajCDBM2lH7NvcuX8@redhat.com>
	 <50a665f3-8bcc-42bf-ab33-5cdafa70440b@gmail.com>
	 <467670f5-2a5e-4051-9d24-eafa15e2f565@gmail.com>
	 <al4_1Ad2useO9bNR@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_TO(0.00)[redhat.com,gmail.com];
	TAGGED_RCPT(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_DN_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 

On Mon, 2026-07-20 at 11:33 -0400, Benjamin Marzinski wrote:
> On Sun, Jul 19, 2026 at 04:57:00PM +0200, Xose Vazquez Perez wrote:
> > On 6/16/26 9:47 AM, Xose Vazquez Perez wrote:
> >=20
> > > On 6/16/26 12:56 AM, Benjamin Marzinski wrote:
> > >=20
> > > > On Mon, Jun 15, 2026 at 11:00:48PM +0200, Xose Vazquez Perez
> > > > wrote:
> > > > > On 6/15/26 9:07 PM, Benjamin Marzinski wrote:
> > > > >=20
> > > > > > This patchset is to deprecate the rr_weight, rr_min_io_rq,
> > > > > > and rr_min_io
> > > > > > multipath config options. It's a companion of the patchset
> > > > > > to handle
> > > > > > their deprecation in the man pages.
> > > > > > https://lore.kernel.org/all/20260607103831.336833-2-xose.vazque=
z@gmail.com/
> > > > > >=20
> > > > > > It does not completely remove the minio setting code, since
> > > > > > there are
> > > > > > ideas for reusing this in the future. The final patch is
> > > > > > simply a change
> > > > > > to avoid a kernel warning message that I hit while testing
> > > > > > these
> > > > > > patches.
> > >=20
> > > > > Ben, thanks for this cleanup.
> > > > >=20
> > > > > I ran grep to see what remains of these options in the
> > > > > codebase.
> > > > > Could you please check if any of the following occurrences
> > > > > should have been
> > > > > removed, or if they are intended to stay for now?
> > > > >=20
> > > > > 8<---
> > > > > $ git grep -Ei "rr_weight|minio|min_io" | grep -vE
> > > > > "multipath.conf.5.in|deprecated"
> > > > >=20
> > > >=20
> > > > Good catch. It appears I misses some things.
> >=20
> > > I ran the following command to locate previous "deprecated
> > > keywords":
> > > $ for i in $(git grep -h=C2=A0 deprecated libmultipath/dict.c | grep
> > > install_keyword | sort | uniq | awk -F\"=C2=A0 '{print $2}') ; do
> > > printf "\\n\n--- $i\n\n" ; git grep -i $i | grep -vE
> > > "install_keyword| multipath.conf.5.in|\.md|deprecated_handler" ;
> > > done
> > >=20
> > > It looks like there is some leftover code that could also be
> > > cleaned up, such as:
> > >=20
> > > --- disable_changed_wwids
> > >=20
> > > libmultipath/defaults.h:#define DEFAULT_DISABLE_CHANGED_WWIDS 1
> > >=20
> > > and also some checks in tests/hwtable.c.
> > Is this still necessary in "write_defaults : tests/hwtable.c" ?
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 { "bindings_file", NULL },
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 { "config_dir", NULL },
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 { "multipath_dir", NULL },
> >=20
>=20
> Yeah. don't think we need to included deprecated config options in
> our
> tests, except possibly in a test to make sure that deprecated values
> aren't used.

Embarassingly I don't fully recall why I put these items there, but I
do recall that I had a reason. I'd rather keep them there unless they
cause real breakage. The hwtable test is sensitive to small changes,
and fixing it is cumbersome.

I'll remove them; if the CI still passes, fine; otherwise we'll have to
postpone this.

Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Jochen Jaser, Andrew McDonald (HRB 36809,AG N=C3=
=BCrnberg)
