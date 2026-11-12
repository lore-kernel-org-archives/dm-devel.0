Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794510082;
	b=AX86AOcjjjLXKnvXqe950p5cwovK1LvSiS4+hj4fXI4BzbF1T6lgnmJpmi9G8pQIzJ/u
	 rYCew/V56l0zf+24OH5ir3IGbUqL58ufaE39zKh34P/7sxPqsWFd07FQmmtCTGIe6th7T
	 BOwVbooGT40uz4xoluNzKRQ0zla5SZEB7HJf+h8r+YAt5FJQlnMPy+y0a1bNKeyti8YFt
	 r+bq/Zce1TlbX8BpTdfyEXb3gxBre49hls0EOdKw91xb8etb5eOhrgLHYN9yFFeGLszRs
	 VjcycJc+at8lS8QV61AtVYf1L/xUw4hov/UWaRQBmBOxj3/+FNX9tZhOxVHGa8LtWKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794510082;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version:
	 X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=78FwxNDzob964VP+xTbi7Ib7ncbsmC2bOtWsooaZcSE=;
	b=1T2ARrzSp7Bzitein87uIzM6hbaWS28axDBSX2nGmkgcbA+Pm8ci1EkjIi97IM6bb3rN
	 ZrVSonLLcFvIWhXU0Z8DVjlEZSVPaotRhBfs52/ctkYcApKTwBd6+EQsZkiJhqhwaQRe+
	 3bWbBOXz0RYZm29BXE75HmnrzYLCSXYyTxMN0Zqym/3yqT7qALmev6K9sz4WroilsgWKD
	 azY+wG4UcQLz5SO2JkHuER+Y7ZXA7YhvXxv1YgSLAZ4AwM7kak8KMZ+goWUFN8R6RfdDI
	 +i4qWqc46VvkpT1EIYj+XBk/PzcJIEvBFsQITjsSl3jRog2kvhXTwGsfCC+i067Ff2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=vWW23FWr;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=vWW23FWr;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B034606A321
	for <dm-devel@lists.linux.dev>; Thu, 12 Nov 2026 19:01:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7B034606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=vWW23FWr;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=vWW23FWr
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 97D2521F28;
	Thu, 12 Nov 2026 19:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794510060; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=78FwxNDzob964VP+xTbi7Ib7ncbsmC2bOtWsooaZcSE=;
	b=vWW23FWr5qVY3iPy26SzLvHqyOUx+zQzuUWmuv32ObihSFl7pyBoaEPT5Q4S10DHdeWihg
	5gyZAkDIzP42MHSXMy8t/ar8pVNW/nOJykf8D6Vc5f7g83e+51wyoOsy8BNSFhTdXZNyWF
	OMFT0F66fNht9BARAQ7TtkuEwCos3ro=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794510060; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=78FwxNDzob964VP+xTbi7Ib7ncbsmC2bOtWsooaZcSE=;
	b=vWW23FWr5qVY3iPy26SzLvHqyOUx+zQzuUWmuv32ObihSFl7pyBoaEPT5Q4S10DHdeWihg
	5gyZAkDIzP42MHSXMy8t/ar8pVNW/nOJykf8D6Vc5f7g83e+51wyoOsy8BNSFhTdXZNyWF
	OMFT0F66fNht9BARAQ7TtkuEwCos3ro=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4AE2A13432;
	Thu, 12 Nov 2026 19:01:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Z9rnCOwM9mr2WwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Thu, 12 Nov 2026 19:01:00 +0000
Message-ID: <83f73b9cb1506eb80220759e3e0aae18648f80c4.camel@suse.com>
Subject: udev / multipath-tools: WWID determination with SG_IO vs. sysfs
From: Martin Wilck <mwilck@suse.com>
To: Brian Bunker <brian@purestorage.com>, Benjamin Marzinski
	 <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, dm-devel@lists.linux.dev
Date: Thu, 12 Nov 2026 20:00:58 +0100
In-Reply-To: <20261111230535.12947-1-brian@purestorage.com>
References: <20261109185556.27139-1-brian@purestorage.com>
	 <214d18ebabeca8318352dfa5456bc5b37cdefdeb.camel@suse.com>
	 <20261111174259.41911-1-brian@purestorage.com>
	 <cad66f75079fe0a89150e304d753527f140c67d9.camel@suse.com>
	 <20261111230535.12947-1-brian@purestorage.com>
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
X-Spamd-Result: default: False [-13.30 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -13.30
X-Spam-Level: 
X-Spam-Flag: NO

Brian, Ben, Hannes,

Following up the discussion on Brian's latest patch, I've researched a
bit into the SG_IO vs. sysfs topic. I wondered why, under RHEL and
other distributions, where scsi_id is being used for device
identification, udev rules hanging in SCSI device ID determination
doesn't seem to be an issue, whereas SUSE has switched to sg_inq --
inhex --raw on sysfs files more than 10 years ago for precisely that
reason.

# About SG_IO blocking in udev rules:

SUSE switched from scsi_id to sg_inq in 2014, before releasing SLE12.
We got reports about udev rules hanging in device detection, but
AFAICS, only for USB devices. Actually, for those, it seems that the
hanging syscall was not the SG_IO ioctl itself, but the initial open()
on the device node (we have no evidence about the reasons; it's likely
that device probing was stuck in the kernel because of misbehaving
cheap USB hardware).

The reason that these hangs in udev rules have been seen under
(open)SUSE and apparently not on RHEL or other distros is rather
trivial: In 60-persistent-storage.rules, scsi_id is only called if
ID_SERIAL is not set yet [1].=C2=A0For those USB devices that SUSE has seen
trouble with, ID_SERIAL would be set by usb_id, and thus scsi_id is
never invoked; therfore no hang. OTOH, 55-scsi-sg3_id.rules calls
sg_inq unconditionally [2], which may cause hangs with badly behaving
USB devices. To fix that, SUSE switched from SG_IO to reading sysfs
files a while after it had switched to sg_inq.

So far I haven't found evidence for a hanging sg_inq on hardware that
actually matters for multipath. That doesn't mean that it can't happen,
network-based I/O can always suffer from timeouts or delays, of course,
we have observed it quite a few times. But if this was a frequent
issue, I would expect it to get noticed by users.

@Ben, have you ever observed SG_IO ioctls blocking in scsi_id in udev
rules?

@Hannes, am I overlooking something? Do you recall cases of hanging
sg_inq processes on devices other than USB?

# About SG_IO blocking in multipathd:

Broken USB devices are not an issue for multipathd. W have ignored USB
devices since 0.6.0, 51957eb ("Skip USB devices during discovery").
Since 0.8.5, 5bd2645 ("libmultipath: Allow discovery of USB devices"),
they can be re-enabled, but I suppose that that's not a frequently used
feature.

We mostly avoid ioctls for paths that are down or otherwise unusable in
multipathd, except for the checker, where we use threads. Still, even
if the checker has seen a path in UP state, it can happen that SG_IO
would stall when retrieving the priority. There is sporadic evidence
that this has happened, but not much (surprisingly few, actually, and
most reports that I could find are quite old already).

I am not aware of any cases where the recheck_wwid code had caused
hanging ioctls.

Brian's patch would add more such ioctls and thus increase the
likelihood of observing a stall. To be observed.


# About sysfs data being stale:

The kernel will update the VPD pages when a UNIT ATTENTION with
ASC/ASCQ 3f/03 occurs ("INQURIY data has changed"; since kernel v4.6).
Normally, the VPD page update happens synchronously before the uevent
is sent to user space.=C2=A0Therefore reading the sysfs attribute from the
udev rule is guaranteed (almost, see below) to return the data that was
current right after the UA had been processed (the uevent is sent from
a kernel thread, thus a small delay is possible).=20

However, it is possible that the update of the VPD data is skipped
because the device is not running, or the queue is quiesced. In this
case, the sysfs VPD data would also be stale (but later SG_IO would be
likely to fail as well).

It is also possible that the VPD data changes between establishing the
UA and calling scsi_id or sg_inq, but the probability should be rather
low.

Similar considerations hold for "add" events; for a device just added,
I'd expect the VPD data to be correct with very high likelihood,
especially if it is in "running" state.

The kernel does *not* rescan devices on receiving a UA with ASC/ASCQ
3f/0e ("REPORT LUNS data has changed").=C2=A0AFAIU, it isn't well defined
what condition a given storage array actually establishes when a LUN
mapping changes. 3f/03 and 3f/0e are both possible, as is 29/xx "Power
on or device reset occured". 3f/0e may actually be received on a
different LUN than the one that had actually changed.

So, of 3f/0e or 29/xx occurs, the VPD data may be stale. And of course
also if the LUN mapping changes without any event occuring, as
discussed in the past in the context of the "recheck_wwid" option. Only
actively writing to the "rescan" sysfs attribute would fix this.

Thinking about this, it might make sense to switch from sysfs to SG_IO
in udev rules if we observe a 3f/0e or 29/xx UA.

@Hannes, what do you think?

IIRC we've discussed handling UA events in multipathd before, but
nobody has started working on it so far. If we do, we'd need to handle
all 3 kinds of events.

Regards & sorry for the long post,
Martin


[1] https://github.com/systemd/systemd/blob/6ec3ff3f41b7569d96a475a11db716f=
5feb35a6f/rules.d/60-persistent-storage.rules.in#L75
[2] https://github.com/doug-gilbert/sg3_utils/blob/8799caa3741b2b1640970747=
aeb84f17dbbaad86/scripts/55-scsi-sg3_id.rules#L67

--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Stefan Gaiser, Jochen Jaser, Abhinav Puri (HRB
36809,AG N=C3=BCrnberg)
