Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C743213E71
	for <dm-devel@lists.linux.dev>; Wed, 14 May 2025 21:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747257673; cv=none; b=L2wvzKhyEifsmLcxTUdhrJwGhgJMRuu+sXn0LsmczIRWPenPKaUA0OMZluP6PRDxHrrPUbKTSTw0egREg5omTgVxfZGXTWmNkiflcDGCQ3BbkkCiqEB3QA+TVEHbo69Yb6duGuhiE23mTZKw5Te4MhN1a/HvWkvxmDsSAjWUSAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747257673; c=relaxed/simple;
	bh=g92IOEz/RjN3ycXG20CvI981r6yj0rJaWCkLUZq+oGM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ghXBn3qNaKd7m3zEZSuap7yj6znCPjCSjpp/uulOVY5acadjPJksfvQDL1RAbKveaJdIm1bZ/gBzw0qIsENAsFCHTLMnEATpAMf45pxulQScI99MFvK58RJmKY0cvkKMTyjLMRG8b7vp+LpT46Gltm8/qY5v8GUOsYcUtC77ZyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Rp72ydfk; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Rp72ydfk; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Rp72ydfk";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Rp72ydfk"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9318A1F38A;
	Wed, 14 May 2025 21:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1747257669; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g92IOEz/RjN3ycXG20CvI981r6yj0rJaWCkLUZq+oGM=;
	b=Rp72ydfkcN4z0I4Gtsv4LlYyinjVhtVgizd0Ooygt0qklQeDd5NBO7KulX97ZkmqQ5NfV1
	E571KctsqpSJEGOnmjJJFUtnrSFy56H3F5yTam96uYAd+b7JKzioKjoyNo+H+xWwc5DkpY
	7hdnfJcofQbNtfbND2hxFQ/a/b9rJ1c=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1747257669; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g92IOEz/RjN3ycXG20CvI981r6yj0rJaWCkLUZq+oGM=;
	b=Rp72ydfkcN4z0I4Gtsv4LlYyinjVhtVgizd0Ooygt0qklQeDd5NBO7KulX97ZkmqQ5NfV1
	E571KctsqpSJEGOnmjJJFUtnrSFy56H3F5yTam96uYAd+b7JKzioKjoyNo+H+xWwc5DkpY
	7hdnfJcofQbNtfbND2hxFQ/a/b9rJ1c=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 463B5137E8;
	Wed, 14 May 2025 21:21:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 75orD0UJJWibCwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Wed, 14 May 2025 21:21:09 +0000
Message-ID: <cc2ec011cf286cb5d119f2378ecbd7b818e46769.camel@suse.com>
Subject: Re: [PATCH 0/2] dm mpath: Interface for explicit probing of active
 paths
From: Martin Wilck <mwilck@suse.com>
To: Kevin Wolf <kwolf@redhat.com>, Christoph Hellwig <hch@infradead.org>, 
 Benjamin Marzinski
	 <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev, hreitz@redhat.com, mpatocka@redhat.com, 
	snitzer@kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 14 May 2025 23:21:08 +0200
In-Reply-To: <d51d6f85b5728648fe9c584f9cb3acee12c4873f.camel@suse.com>
References: <20250429165018.112999-1-kwolf@redhat.com>
			 <47dd225b433b0df585a25084a2e793344eeda239.camel@suse.com>
			 <aCIRUwt5BueQmlMZ@redhat.com>
	 <d51d6f85b5728648fe9c584f9cb3acee12c4873f.camel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -4.30

On Tue, 2025-05-13 at 10:00 +0200, Martin Wilck wrote:

>=20

> > If you think it does, is there another reason why you didn't try
> > this
> > before?
>=20
> It didn't occur to me back then that we could fail paths without
> retrying in the kernel.
>=20
> Perhaps we could have the sg driver pass the blk_status_t (which is
> available on the sg level) to device mapper somehow in the sg_io_hdr
> structure? That way we could entirely avoid the layering violation
> between SCSI and dm. Not sure if that would be acceptible to
> Christoph,
> as blk_status_t is supposed to be exclusive to the kernel. Can we
> find
> a way to make sure it's passed to DM, but not to user space?

I have to correct myself. I was confused by my old patches which
contain special casing for SG_IO. The current upstream code does of
course not support special-casing SG_IO in any way. device-mapper
neither looks at the ioctl `cmd` value nor at any arguments, and has
only the Unix error code to examine when the ioctl returns. The device
mapper layer has access to *less* information than the user space
process that issued the ioctl. Adding hooks to the sg driver wouldn't
buy us anything in this situation.

If we can't change this, we can't fail paths in the SG_IO error code
path, end of story.

With Kevin's patch 1/2 applied, it would in principle be feasible to
special-case SG_IO, handle it in the dm-multipath, retrieve the
blk_status_t somehow, and possibly initiate path failover. This way
we'd at least keep the generic dm layer clean of SCSI specific code.
But still, the end result would look very similar attempt from 2021 and
would therefore lead us nowhere, probably.

I'm still not too fond of DM_MPATH_PROBE_PATHS_CMD, but I can't offer a
better solution at this time. If the side issues are fixed, it will be
an improvement over the current upstream, situation where we can do no
path failover at all.

In the long term,=C2=A0we should evaluate alternatives. If my conjecture in
my previous post is correct we need only PRIN/PROUT commands, there
might be a better solution than scsi-block for our customers. Using
regular block IO should actually also improved performance.

Regards
Martin
