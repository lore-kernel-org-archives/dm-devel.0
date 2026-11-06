Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794003569;
	b=EVCQ1pqAXuLT6WzeYX4XbJEswbrNJzR0WyX+Ttnwtyzgj7GY3WR/vbsYJb11FfriADOT
	 SahGYIae/FFmXOc1EuLrbVgO5vGZvoRll56VWmLD32zLyG/MNv3Ymim4AXoh0QNxxr+E4
	 RnnGyyryfMEUpBQpG3ETLfvlIFhOz8pGYqSdVPmq4ks6wV246iq8lAm2ojsTT7o9E+R25
	 s/NY6KoZrkKmlKLhiCs5l9icF1lbji5hW5wofl5r8U64CwKKIyuSM+fkkKDxYkVsdRLbX
	 Cr+CH83nI8OpPmhFeDJAh59N32upqu/GKStxduR3F5GVSEbY++NjEVvlt5zNw2urudg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794003569;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version:
	 X-Rspamd-Queue-Id:X-Spam-Level:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spamd-Result:X-Spam-Score;
	bh=jIqDcvXfkm5IPjRiBnwLw0YDD67QA48sp8o3hWJpEzM=;
	b=s+0BujHM3xFPXZ2vymTfaIehjWgWLb/Pn2hFi/ihXe+P/3VWozStn8V1IySMAUdjDbTa
	 PnXMG2jjukuPK073qqisRvqsH7ny1PPV77VpO3CbDsxh3A28cKOhnHxqAQXC7N/PL9GuQ
	 2nYnLc1Fn7pvA0To1Ky/U6Btbw02yEGHSQyuSjjf6eKY/YlRDtrmswDt8KPrCd9YrNrzD
	 QDK5ThMTLlwRCY6aLVy83qGHMPew0Z6/ij/HuyhcdjwX8dCGWuPK7WPMdNOaRbiFabxfz
	 pK8U6bbXX6oexTYAzhqe0tffd0z7ZdIj0QSoP7xR6nUM7rT/e/YgSTpkC6OuPultXVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="kjE/LBB5";
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="kjE/LBB5";
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C35606A326
	for <dm-devel@lists.linux.dev>; Fri,  6 Nov 2026 22:19:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 49C35606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=kjE/LBB5;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=kjE/LBB5
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 47C3921DDE;
	Fri,  6 Nov 2026 22:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794003566; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jIqDcvXfkm5IPjRiBnwLw0YDD67QA48sp8o3hWJpEzM=;
	b=kjE/LBB5pJIYPnzZKeMm9+i1ryU5YyRUjv8joZOp1Q7ugPfPljN3D5Ft+NJJiGazYdISLu
	ZZt/SEcMmxLaLi0sz+zD6cAcvOyqe2GJfmZGGzoUN364X+3qPlh/ixUANYHStaJQkl/gXO
	ISbn+3tU+LKwr0rUYaWF+4036lSrePE=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="kjE/LBB5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794003566; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jIqDcvXfkm5IPjRiBnwLw0YDD67QA48sp8o3hWJpEzM=;
	b=kjE/LBB5pJIYPnzZKeMm9+i1ryU5YyRUjv8joZOp1Q7ugPfPljN3D5Ft+NJJiGazYdISLu
	ZZt/SEcMmxLaLi0sz+zD6cAcvOyqe2GJfmZGGzoUN364X+3qPlh/ixUANYHStaJQkl/gXO
	ISbn+3tU+LKwr0rUYaWF+4036lSrePE=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D93FC134E9;
	Fri,  6 Nov 2026 22:19:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xSC4Km1S7moqVwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 06 Nov 2026 22:19:25 +0000
Message-ID: <f9a399429d9c7ac2e4079e7cd89ae7c304ee3b24.camel@suse.com>
Subject: Re: [PATCH v2 1/1] multipathd: verify udev WWIDs with the device
 before moving paths
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Brian Bunker
	 <brian@purestorage.com>
Cc: dm-devel@lists.linux.dev, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Date: Fri, 06 Nov 2026 23:19:25 +0100
In-Reply-To: <auTdZn84HV8DjGZ0@redhat.com>
References: <20261029235241.97614-1-brian@purestorage.com>
	 <20261029235241.97614-2-brian@purestorage.com>
	 <auTdZn84HV8DjGZ0@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.62.1 
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Rspamd-Queue-Id: 47C3921DDE
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-13.51 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Score: -13.51

On Fri, 2026-10-30 at 14:09 -0400, Benjamin Marzinski wrote:
> On Thu, Oct 29, 2026 at 04:52:41PM -0700, Brian Bunker wrote:
> > multipathd takes a path's WWID from udev. When a change uevent
> > reports
> > a different WWID, uev_update_path() removes the path from its map
> > and
> > re-adds it through uev_add_path(), which places it in whatever map
> > owns
> > the new WWID. Nothing checks the new value against the device
> > itself;
> > recheck_wwid only covers paths coming back up in the checker and
> > "multipathd add path". If udev reports the wrong WWID, or the
> > uevent is
> > stale by the time it is processed, the path goes into the map of a
> > different LUN and I/O for one LUN is silently sent to another.
> >=20
> > Use SG_IO to read VPD page 0x83 from the device in two places, for
> > paths where can_recheck_wwid() is true:
> >=20
> > - In uev_update_path(), if the device still reports the cached
> > WWID,
> > =C2=A0 ignore the udev value and leave the path where it is.
> >=20
> > - In ev_add_path(), when a path is being re-added because its udev
> > =C2=A0 data was missing or changed, refuse to add it if the device
> > doesn't
> > =C2=A0 confirm its WWID. The path is orphaned, its WWID is cleared and
> > it
> > =C2=A0 is marked INIT_MISSING_UDEV, so the checker retriggers udev
> > (bounded
> > =C2=A0 by retrigger_tries) and the path is re-added from fresh data.
> >=20
> > To tell re-adds from ordinary adds, turn the need_do_map argument
> > of
> > uev_add_path() and ev_add_path() into enum path_add_mode, with a
> > new
> > PATH_ADD_REINIT value that behaves like PATH_ADD_MAP and also
> > requests
> > the WWID check. Ordinary adds are unchanged and never read the WWID
> > from the device.
> >=20
> > If the SG_IO read fails, behavior is unchanged.
> >=20
> > Split the SG_IO read out of check_path_wwid_change() into
> > get_sgio_wwid() so all the checks share it.
> >=20
> > Signed-off-by: Brian Bunker <brian@purestorage.com>
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

You will need convince me that this doesn't do more harm than good.=C2=A0
We can't just use udev in one place and other methods elsewhere.

I am open for a general redesign that uses sysfs for retrieving
WWIDs, rather than udev. But using SG_IO seems wrong to me in general,
because it can hang. If anything, we'd need to make this configurable,
and we'd then need to use SG_IO consistently throughout the code (and
SG_IO has significant disadvantages, as already mentioned). Also, SG_IO
works for SCSI only. That may be a minor issue these days, because
almost all disks handled by dm-multipath are SCSI disks, but at least
formally we still support other block devices like NVMe and DASD.

Unfortunately there's already a zoo of options for WWID detection which
has grown over time.

> About how likely this is: we hit it because a test tool was opening
> and closing the sd devices read-write many times a second, and with
> udev's "watch" rule every close generates a change uevent that runs
> scsi_id against the device.=20

I wouldn't call this a valid test. It's a deliberate abuse of udev
functionality. If you do this, you need to disable udev's watch
functionality, which is merely a convenience for users anyway. It's
questionable if it's a useful feature on production servers in general.

Thinking about it, I wonder if we should simply set "nowatch" for
multipath members by default. AFAIU that would avoid the issue Brian
encountered, at least in this test scenario.

Regards
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Stefan Gaiser, Jochen Jaser, Abhinav Puri (HRB
36809,AG N=C3=BCrnberg)
