Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F5920A5F2
	for <dm-devel@lists.linux.dev>; Wed, 11 Dec 2024 20:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733950123; cv=none; b=ZAAjQA8lgVXLUdt+tMrp81i2OYShQwgWf1pE0vN3P+ucsUWnlrGcnDLCDz27J/CMmwcuqYAi0texFTdkti5AqTVlNP5kscp43y5MkYTn5QqWdjfHyp4pmRnrS69EgGNU34usoxX4zVcjBcT7gAvcjshoZ6yA0rkmoXdcgAOb++4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733950123; c=relaxed/simple;
	bh=5+d+P6ks7tOCeC839xuGFmQ8ndxK/57SI7WDotzAH70=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aHbO6qcUW/PbH6H6xaaVg4fKBu+d0ns1RtENxnEGs3n92n9Ra15IXB9yo4NgEXyzx944n1EuwiniDB9PU1DZixiVy9RYM35d4qBHzu02i+7p2DfdPWPodfsxOfpgLwBdbbBbsPdlcMuoATXQiCZnbY6SG10i4Fp7C5ajTeYbNo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Ds2PQFNm; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Ds2PQFNm; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Ds2PQFNm";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Ds2PQFNm"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9D92D21180;
	Wed, 11 Dec 2024 20:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1733950119; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5+d+P6ks7tOCeC839xuGFmQ8ndxK/57SI7WDotzAH70=;
	b=Ds2PQFNmrw04RmNEYOtxdCHtreZc0JIn2ePUOZcsiCcZ2Ab2Z3Or859Tm4JgLsKGgtW2kM
	ErByig/Ymu2YgG1Ps555fB5knE2nagAI5fKzr3rPrnSZlA5JrPnDOBSdz/etn4+H2CLbhI
	GgoHPNk7fn2UqGmrB9yf3jd6ebhh8Xc=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1733950119; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5+d+P6ks7tOCeC839xuGFmQ8ndxK/57SI7WDotzAH70=;
	b=Ds2PQFNmrw04RmNEYOtxdCHtreZc0JIn2ePUOZcsiCcZ2Ab2Z3Or859Tm4JgLsKGgtW2kM
	ErByig/Ymu2YgG1Ps555fB5knE2nagAI5fKzr3rPrnSZlA5JrPnDOBSdz/etn4+H2CLbhI
	GgoHPNk7fn2UqGmrB9yf3jd6ebhh8Xc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7550913927;
	Wed, 11 Dec 2024 20:48:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Ury3Gqf6WWdiIwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Wed, 11 Dec 2024 20:48:39 +0000
Message-ID: <af423c7e2cc54cd306448bcdf53fbd07cfcbabde.camel@suse.com>
Subject: Re: [PATCH 03/13] multipathd: allow map removal in do_sync_mpp()
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev
Date: Wed, 11 Dec 2024 21:48:38 +0100
In-Reply-To: <Z1jFf_1kLqfWAfp-@redhat.com>
References: <20241206233617.382200-1-mwilck@suse.com>
	 <20241206233617.382200-4-mwilck@suse.com> <Z1iQR-9hszoQOq-W@redhat.com>
	 <9c2270f4bd6ac65e37e120d2e8c254c4fa3e2c61.camel@suse.com>
	 <Z1jFf_1kLqfWAfp-@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid]
X-Spam-Flag: NO
X-Spam-Level: 

On Tue, 2024-12-10 at 17:49 -0500, Benjamin Marzinski wrote:
> On Tue, Dec 10, 2024 at 10:05:14PM +0100, Martin Wilck wrote:
> > On Tue, 2024-12-10 at 14:02 -0500, Benjamin Marzinski wrote:
> > > On Sat, Dec 07, 2024 at 12:36:07AM +0100, Martin Wilck wrote:
> > > > We previously didn't allow map removal inside the checker loop.
> > > > But
> > > > with the late updates to the checkerloop code, it should be
> > > > safe to
> > > > orphan
> > > > paths and delete maps even in this situation. We remove such
> > > > maps
> > > > everywhere
> > > > else in the code already, whenever refresh_multipath() or
> > > > setup_multipath()
> > > > is called.
> > >=20
> > > I don't think that this is safe. It's possible that the multipath
> > > device
> > > has paths in the INIT_REMOVED or INIT_PARTIAL state. These will
> > > get
> > > silently removed from the pathvec if we remove the map here. This
> > > will
> > > mess up our iteration through the pathvec in update_paths().=C2=A0
> >=20
> > Hm. You're right.=C2=A0But that applies to the current code in 0.11.0 P=
R
> > as
> > well, because we'd call=20
> >=20
> > =C2=A0=C2=A0 do_sync_mpp()
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 update_multipath_strings()=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sync_paths()
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 chec=
k_removed_paths()
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 vector_del_slot(pathvec, i--);
> >=20
> > Or am I missing something?
>=20
> Nope. Your right. Nuts.
> =C2=A0
> > It seems to me that the only safe way to handle this is to refrain
> > from
> > deleting paths from the pathvec anywhere deep in the call stack.
> > Even
> > if we can avoid this situation now by moving the sync towards the
> > end
> > of the checker loop, I believe that in the long run we need to fix
> > these traps in our code, because it's just so easy to get this
> > wrong.
> >=20
> > I wonder if we need yet another path state, of if we could simply
> > set
> > these entries in the pathvec to NULL. That sounds crazy, but it
> > might
> > actually be doable. Not 0.11.0 material, though.
>=20
> I think we could just not call check_removed_paths() in sync_paths().
> We
> would still orphan all the paths that were no longer part of the
> multipath device, and set pp->mpp for all the paths that are part of
> the
> device just like before, but we wouldn't delete the paths from
> pathvec there. Instead we would call check_removed_paths() in
> refresh_multipath(), so we did it after loads and in
> update_multipath.
>=20
> I'm pretty sure that should be fine. If the device table changed and
> removed a path so that we can free it, either we reloaded the device,
> and we will call setup_multipath() after the reload, or something
> external did, and multipathd will see an event for that and call
> setup_multipath() via update_multipath().
>=20
> Does that make sense?

I think we'll be fine with my upcoming patch set, which will call
reload_and_sync_map() only from checker_finished().=C2=A0I don't change
sync_paths() in this set so far.

I'm a little concerned about refresh_multipath() and
reload_and_sync_map() being called from various CLI functions. But I
won't start digging into that now. Maps may get removed in CLI calls,
so what.

Thanks,
Martin

