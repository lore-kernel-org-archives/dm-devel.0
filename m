Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522A623024D
	for <dm-devel@lists.linux.dev>; Tue, 10 Dec 2024 21:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733864719; cv=none; b=KIx5TBliwF+AbR/ZVqbtB42sO9octFC6enwwBVH0s2ZxJlvG7LBnxweHCfPgof6JkWMRdjn5BZFsGW6s4DyVPgFGdatFCJJHR1bG+IED9G4BNZXe9ICEWywH3Vex1tJCP/SsbaaMo2vwEN1hWjy3hz6EdmD71NITHR0lZotqi2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733864719; c=relaxed/simple;
	bh=RrPvX0aNHdSc9VCuK3BDRDahcNbS50P9Gz9Jgi6EU4Y=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZjfJFAuA3zcqbugVGsdX3BMfkfo8Q4A/6W29C3Ke9fcsMxp5WA7dXuBs0Llbn4gIRcQepBMWo6umpOQrBwpVBmKnWVNFyPEl9Eh2wNY3wpuhu6+bkFm4dos/s7FmUstjs3ysZBxluw2pnP8tz/DTX30Bu8VvCQhWCkCExdtaAi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=oMLkcMK7; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=oMLkcMK7; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="oMLkcMK7";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="oMLkcMK7"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5870A21167;
	Tue, 10 Dec 2024 21:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1733864715; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DopCasZNIQMNige/71PF9BJJOSdL64SpqfthCEU54zQ=;
	b=oMLkcMK7fmDQsnmEr3Eyxf7OiJ7f3Dtlf51TYIgCjvPo5XMiSxEaqKtqjnzAiEtEbToL++
	XHmEDFP6YwhMgNzatT6cFZNBk4Httv+4AFdlwdi2aewbRSiyDvgNlbdacg5x2b0hNwchr7
	uYFI8kL0bjQZrJsK/j67uTaR7TeS958=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=oMLkcMK7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1733864715; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DopCasZNIQMNige/71PF9BJJOSdL64SpqfthCEU54zQ=;
	b=oMLkcMK7fmDQsnmEr3Eyxf7OiJ7f3Dtlf51TYIgCjvPo5XMiSxEaqKtqjnzAiEtEbToL++
	XHmEDFP6YwhMgNzatT6cFZNBk4Httv+4AFdlwdi2aewbRSiyDvgNlbdacg5x2b0hNwchr7
	uYFI8kL0bjQZrJsK/j67uTaR7TeS958=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3411E138D2;
	Tue, 10 Dec 2024 21:05:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7TsqCwutWGc3DQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Tue, 10 Dec 2024 21:05:15 +0000
Message-ID: <9c2270f4bd6ac65e37e120d2e8c254c4fa3e2c61.camel@suse.com>
Subject: Re: [PATCH 03/13] multipathd: allow map removal in do_sync_mpp()
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev
Date: Tue, 10 Dec 2024 22:05:14 +0100
In-Reply-To: <Z1iQR-9hszoQOq-W@redhat.com>
References: <20241206233617.382200-1-mwilck@suse.com>
	 <20241206233617.382200-4-mwilck@suse.com> <Z1iQR-9hszoQOq-W@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Rspamd-Queue-Id: 5870A21167
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51
X-Spam-Flag: NO

On Tue, 2024-12-10 at 14:02 -0500, Benjamin Marzinski wrote:
> On Sat, Dec 07, 2024 at 12:36:07AM +0100, Martin Wilck wrote:
> > We previously didn't allow map removal inside the checker loop. But
> > with the late updates to the checkerloop code, it should be safe to
> > orphan
> > paths and delete maps even in this situation. We remove such maps
> > everywhere
> > else in the code already, whenever refresh_multipath() or
> > setup_multipath()
> > is called.
>=20
> I don't think that this is safe. It's possible that the multipath
> device
> has paths in the INIT_REMOVED or INIT_PARTIAL state. These will get
> silently removed from the pathvec if we remove the map here. This
> will
> mess up our iteration through the pathvec in update_paths().=C2=A0

Hm. You're right.=C2=A0But that applies to the current code in 0.11.0 PR as
well, because we'd call=20

   do_sync_mpp()
      update_multipath_strings()=20
         sync_paths()
            check_removed_paths()
               vector_del_slot(pathvec, i--);

Or am I missing something?

It seems to me that the only safe way to handle this is to refrain from
deleting paths from the pathvec anywhere deep in the call stack. Even
if we can avoid this situation now by moving the sync towards the end
of the checker loop, I believe that in the long run we need to fix
these traps in our code, because it's just so easy to get this wrong.

I wonder if we need yet another path state, of if we could simply set
these entries in the pathvec to NULL. That sounds crazy, but it might
actually be doable. Not 0.11.0 material, though.

> Perhaps a
> better idea would be to set mpp->sync_ticks to 0 if
> update_multipath_strings() fails in do_sync_mpp(). This would force a
> refresh by sync_mpp() at the start of the next loop in checkerloop(),
> where it can safely remove the multipath device.

I like the idea of your other post to move the sync to the
CHECKER_FINISHED state.

Thanks,
Martin


