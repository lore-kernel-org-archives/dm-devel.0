Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F463AD4B
	for <dm-devel@lists.linux.dev>; Mon,  8 Dec 2025 14:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765204357; cv=none; b=FfVIglaPDlESMotzyvWwleZGuNZfNPsMdT72tnnbcCFmtctPUzuEjkirYIp+S8ki9aNiHRibEDB8ofrt2F1usvJKlNvquvwV6ECjgtyz14w/4h9R9LHDWHQXcwp720VcOjvMxEd68bFxQKWzZDaB3OKeLPiBb/ZZijKR2UJbZrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765204357; c=relaxed/simple;
	bh=R/939Sf2UIyjln8xWO4t+oIGb13CSJF2jFGx7hCBfrc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oemLpatfrtJQ1j1CH3uLaaCJn+FrS77yv5VDeUy4E2th/l1nz5qH8mvTVzRTtQ5SuI/7gD/IagW8Cn00S2HeqIoALBCATNw4ztkrjGUNk9ezT7yiz5/06VSofcBpsG7I9qXdhTPwImxZQn/1dUXHsNcu3mKiPl2uycI+JXKEV/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=qA5X15CM; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=qA5X15CM; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="qA5X15CM";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="qA5X15CM"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 352985BCC9;
	Mon,  8 Dec 2025 14:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1765204354; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R/939Sf2UIyjln8xWO4t+oIGb13CSJF2jFGx7hCBfrc=;
	b=qA5X15CM09DaDNLN82ChomxQQBIRLWK4LKhtKzVSFOUZHpM4uTOpVTtpR9nYV5YY3l0/bp
	ejsSPghggIUEqJ0/cl/Hcf8vgmMtiwNH0RIfrMERN0wON3vsAcI/INJJJLo5Lgx8qYxxtV
	VkTDVsMOvsGpRhWa9I6lRT12oIKhx1E=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1765204354; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R/939Sf2UIyjln8xWO4t+oIGb13CSJF2jFGx7hCBfrc=;
	b=qA5X15CM09DaDNLN82ChomxQQBIRLWK4LKhtKzVSFOUZHpM4uTOpVTtpR9nYV5YY3l0/bp
	ejsSPghggIUEqJ0/cl/Hcf8vgmMtiwNH0RIfrMERN0wON3vsAcI/INJJJLo5Lgx8qYxxtV
	VkTDVsMOvsGpRhWa9I6lRT12oIKhx1E=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 169653EA63;
	Mon,  8 Dec 2025 14:32:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Ho1nBILhNmkIOgAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 08 Dec 2025 14:32:34 +0000
Message-ID: <a46352e210a47a1ae23db16bd7791000d81be6e0.camel@suse.com>
Subject: Re: [PATCH] Release lock before scsi_remove_device and don't block
From: Martin Wilck <mwilck@suse.com>
To: Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev
Cc: bmarzins@redhat.com
Date: Mon, 08 Dec 2025 15:32:33 +0100
In-Reply-To: <20251201235908.43162-1-brian@purestorage.com>
References: <20251201235908.43162-1-brian@purestorage.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Flag: NO
X-Spam-Score: -4.26
X-Spam-Level: 
X-Spamd-Result: default: False [-4.26 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.16)[-0.785];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_TWO(0.00)[2];
	URIBL_BLOCKED(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo]

On Mon, 2025-12-01 at 15:59 -0800, Brian Bunker wrote:
> Martin, I have added a couple of changes to the patch. Here is the
> diff
> from the v2 that I posted. I have made the scsi_remove_device a non-
> blocking
> call. I also release the lock before removing the device decreasing
> the
> potential for lock contention since what is done under the lock is
> minimal.

Let's rather not start with patches to patches ;-)

I've looked at your v3; Ben has already provided feedback and I've just
added a quick remark.

>=20
> I definitely would prefer multipath-tools to be the mechanism for the
> purging.
> Any other option would be in competetion with multipath-tools in
> obtaining
> the path state and acting on it. A single point of control seems
> advantagous.

OK. But as noted in my reply to the v3 patch, I'd like to keep the
access to multipathd's internal data structures to a minimum,
preferrably zero. I think it's doable.

>=20
> There are two issues where multipath-tools is a victim. The first one
> is
> addressed in the recheck_wwid function. The second one however also
> leads
> to an unexpected I/O error when running I/O to the multipath device.
> There
> are issues in volume mobility between two arrays where the inquiry
> data changes
> and the resurrection of the path with its original inquiry data with
> the now
> incorrect inquiry data also leads to an I/O error. In this case
> multipath-tools
> is the victim of the kernel not being able to update inquiry data
> with either
> inquiry data changed unit attentions or rescans. If you needd more
> details
> please letme know.
>=20
> There may be other reasons to have a purge of disconnected (orphaned
> sd
> devices) that we have not encountered. Having a way to purge them
> seems like
> a nice step forward.

I am not questioning that. I appreciate your efforts.

Regards,
Martin
