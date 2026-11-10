Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794349275;
	b=xK1ZUfXNbjc/hh1IyVWSPbRS4aTtsmun+BdZrKxiUUJKIlLOhUGfWSmU1Ze8ZcGnLmO7
	 b7MZHReEGZsraV3qXO2RqXJobFIYGlQNHkYvcENGrSAMn8Jw0AMP2ydlOZZJnAuGiV6GZ
	 k6iCT4rF2cgei96IQKc+KXw3Av60Tt/Pb9nlmxJeLCbCJhh4RE2XpgavjDF2XH2yt1G0r
	 jHa078JhLlPHgmZqxXbX0l/UVx1zYTmkIkKjljFCMESgMkT+McOQd7cXY2j7oAfL+jCqk
	 2enSKUXO8KyAngS05LSRRbpOI17Y/z2WM6cSRm4K1xJuew1G6O1Ia5BweJM4KYaHmMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794349275;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version:
	 X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:
	 X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=XJWaWNh6UscFaMuBg3yHAXqUELGNUAyMMO78IojlHdA=;
	b=MoOJPg+8EEIJm1I0FeCBPRIOfwMKN7/swSASIPM4xaOt3pmJgDuQI9G0YJ6p7S3ZP+rz
	 OIPLii/ZmbBxoT/doSiTfNhN7Ytyik1VPSOXkWYiT0SnPSLBnulk2pgHQer+AVVfRqxFg
	 oBXn7J0NplKhHrRHF5vAE9NuEXoQ6cIjbDWmFK1qbHXzDKOcwyH5K9jlVedTSlCBGUnZ9
	 S3mviLCoSMBKOVtOtJivCw8bbNQ6IGW6suumdQsxCO7MmL1Jj4bBnlo+SAKBTiYLANHY3
	 IVqLESTNwLPYj4MUsArzmPoVmwxv8aQ5QYullIqvv8VQBubrn8bmZXaIzMexrwSmoKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=qd6Y2gaE;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=qd6Y2gaE;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5BE606A326
	for <dm-devel@lists.linux.dev>; Tue, 10 Nov 2026 22:21:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1D5BE606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=qd6Y2gaE;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=qd6Y2gaE
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 113021F80B;
	Tue, 10 Nov 2026 22:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794349273; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XJWaWNh6UscFaMuBg3yHAXqUELGNUAyMMO78IojlHdA=;
	b=qd6Y2gaE94Fw8lRlGAs6eEqsyMw3ogXDH0p0+E+Uw9NerOdzQI2nR8HjhMazjSevDl+Oya
	B1qtHXjSbsUhq34YwEEo6R1VsHa59MmbbHQKpkRYD5t/w+P1YX5TJihqtHoNZhgLE2P/aA
	7e9s/42ZyLOmn4v3Gx/FWswJlOuKjbY=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=qd6Y2gaE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794349273; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XJWaWNh6UscFaMuBg3yHAXqUELGNUAyMMO78IojlHdA=;
	b=qd6Y2gaE94Fw8lRlGAs6eEqsyMw3ogXDH0p0+E+Uw9NerOdzQI2nR8HjhMazjSevDl+Oya
	B1qtHXjSbsUhq34YwEEo6R1VsHa59MmbbHQKpkRYD5t/w+P1YX5TJihqtHoNZhgLE2P/aA
	7e9s/42ZyLOmn4v3Gx/FWswJlOuKjbY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A243C13479;
	Tue, 10 Nov 2026 22:21:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BveLHdiY82rmAQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Tue, 10 Nov 2026 22:21:12 +0000
Message-ID: <214d18ebabeca8318352dfa5456bc5b37cdefdeb.camel@suse.com>
Subject: Re: [PATCH v3 0/1] multipathd: check re-added paths' WWIDs against
 sysfs
From: Martin Wilck <mwilck@suse.com>
To: Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev, 
	bmarzins@redhat.com
Cc: christophe.varoqui@opensvc.com
Date: Tue, 10 Nov 2026 23:21:11 +0100
In-Reply-To: <20261109185556.27139-1-brian@purestorage.com>
References: <20261109185556.27139-1-brian@purestorage.com>
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
X-Spamd-Result: default: False [-13.51 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -13.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 113021F80B

On Mon, 2026-11-09 at 10:55 -0800, Brian Bunker wrote:
> During an array controller failover on an iSCSI host, multipathd
> briefly put a path to one LUN into the map of another LUN, and I/O
> meant for the first LUN landed on the second. See the v1 cover letter
> for the full sequence.
>=20
> Changes in v3, after Martin's review:
>=20
> - No SG_IO. The re-add check now compares the udev WWID with one
> built
> =C2=A0 from the VPD page 0x83 data the kernel caches in sysfs, so it does
> no
> =C2=A0 I/O on the device and can't hang. The new get_sysfs_wwid() in
> =C2=A0 libmultipath shares get_vpd_uid() and get_uid()'s WWID clean-up
> with
> =C2=A0 the existing sysfs fallback, so both produce the same string.

I am confused. Does this really fix the problem in your use case?

You reported that the udev-derived WWID was false in some uevents, and
you said that, as the test was running under RHEL9, udev had obtained
the WWID from scsi_id, which uses SG_IO. While my previous argument
that SG_IO can block is valid, it's clear that *if* SG_IO works, it's a
better approximation for the REAL device WWID than the kernel's cached
value in sysfs, which might be stale. It makes only limited sense to me
that reading a cached sysfs value in multipathd would be more reliable
than what happened during udev rule processing.

Also, talking about consistency, on a RHEL system it would actually be
more consistent to use SG_IO than to read the WWID from sysfs.

I'd like to go back to your original problem description for a moment.

> 1. A change uevent for sdq (verify3) carried verify1's WWID. The next
>    uevent 4.5 s later carried the correct one. We don't know whether
>    the array answered the INQUIRY (VPD 0x83, run by scsi_id) wrongly
>    during the takeover or the bad value arose elsewhere in the udev
>    path; we have no packet capture.

"Elsewhere in the udev path" makes little sense to me. As we discussed,
udev on RHEL9 uses a VPD 83 INQUIRY, sent by scsi_id via SG_IO. The
WWID that multipathd reads from the uevent represents (part of) what
the storage had sent to scsi_id. If multipathd uses SG_IO and obtains a
different value, then either the storage must have answered one of the
two INQUIRYs wrongly, or something must have changed in the meantime.

(Of course we could have a blatant bug in multipathd that mixes up the
WWIDs in some corner case. But if that's the case, your patch wouldn't
help).

IMO, if we can't trust the reply of the storage array, all bets are
off. Why would the reply that multipathd obtains directly be more
trustworthy than what scsi_id had got? (Under SUSE you could see this
differently, because SUSE reads from sysfs, but you observed the issue
on RHEL).

You wrote that you'd seen this problem in an "array controller
failover" scenario while some test script was generating uevent
storms.=C2=A0I'd like to understand better what happens in this concrete
failover scenario. One possible case for a WWID change is that a
a Linux SCSI disk is removed, and another disk is added later, taking
over the previous device's dev_t. In this case we'd expect "remove" and
"add" uevents. With the uevent storm ongoing, these events may be
delayed. So multipathd may see a change event for the old device while
the kernel had already added the new one. This makes some sense, but
unfortunately it doesn't match your description:

> A change uevent for sdq (verify3) carried verify1's WWID. The next
> uevent 4.5 s later carried the correct one.

This sounds as if the WWID of sdq was that of "verify3", then
"verify1", and then "verify3" again. In my scenario above, sdq might
change from "verify3" to "verify1", but it wouldn't change back again,
unless there was another array failover in a very short time span.

Question about your test: Apparently the problem is reproducible,
otherwise you wouldn't be able to verify your patch. But you said "we
have no packet capture". If the test is actually reproducible, it
should be possible to create a capture and verify that the storage is
not the culprit. That would be very important IMO, because like I said
above, if this can happen, all bets are off.

I would really appreciate if we could clarify these open questions.

Back to the patch set:

IMO if you want to determine the *real* WWID, you _must_ use SG_IO. I
am contradicting my previous statement here, I know. I still hold that
SG_IO may block and that I'd rather avoid using it in multipathd. But
again, if you want to be certain (ignoring the fact that the storage
may provide false replies), SG_IO is you best bet.=C2=A0

With this in mind, I suggest that you go back to v2 and SG_IO. Sorry
for having led you on the wrong track previously.=C2=A0

Because I am generally sceptical of the use of SG_IO in multipathd in
its current form, and because the the overall idea is very similar to
the "recheck_wwid" feature, I further suggest that you make this code
path conditional on "recheck_wwid".

In the long run, we may want to redesign our WWID detection. We do have
a general framework for asynchronous jobs now. Thus we actually could
run asynchronous VPD inquries. This would eliminate the problem of
multipathd getting stuck on a hanging INQUIRY. But this needs more
thought and experiments.

Regards
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Stefan Gaiser, Jochen Jaser, Abhinav Puri (HRB
36809,AG N=C3=BCrnberg)
