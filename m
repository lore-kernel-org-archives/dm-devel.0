Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB8B34B43C
	for <dm-devel@lists.linux.dev>; Wed, 22 Oct 2025 14:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761142331; cv=none; b=JFz5pste0BniIwTrbmeObfovim80ffowHLAnq8RW3D2cGdqI6Dg4c0FoBvlzZQZuOeWSuPikaolRDOhTZ+48Yhbo95AIlkaXhS/ALApHvS7IPlKnREDa/bw7yf8rilaanz1f+cTpKTe4SdjKs6h3Mt+xkaDWQ3sj/FfeXNBJgI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761142331; c=relaxed/simple;
	bh=Sc9A960i0gy6IrMjcasg2sOYXZ+mEfp8kz1Jsm+nUPA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DJci1VpCmTj4Zuy/yrprtX/V/bq01b7z3s8IWNrBgkLAruB7n7HdvXyUe0+YbATSus3kgoyGGZhzmas2NrljDRyvrSjV1QfUWfEf3/T72HykarUIKiogrTQIMjvMRk5/hhl6NM8E0ccryT57YFEuUb/wBZuYYh1X+DrhM5lTF6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=SOCjXIZA; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VEHD8W9H; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="SOCjXIZA";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VEHD8W9H"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 75B3A21211;
	Wed, 22 Oct 2025 14:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1761142323; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sc9A960i0gy6IrMjcasg2sOYXZ+mEfp8kz1Jsm+nUPA=;
	b=SOCjXIZAyzzoogP7X+MJJdIPr3pVbwjJS3KVdZDUVjRK1HuKmsKrNDne5tLwSm39GA3/WK
	lwJlVkaXdaouv74l81sIcBqhcbfb7b1cQ3ylTWbP+suv5I9gUj15/tsDYMgKOG3Acc0QWj
	tLTN92shABcAaWCI/tqW5Myw/RKlQiA=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1761142319; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sc9A960i0gy6IrMjcasg2sOYXZ+mEfp8kz1Jsm+nUPA=;
	b=VEHD8W9HzpEMZx+CmHK5pgb38W2j3O3cJovtpVxFDMR5kXDlOkOOMNu92zoTPxeJs92VVC
	rTBfvUWIHjI4e2UqlTF8tzd/1CzCxpCPWn4TZK6reuT5fKeOt7YYkgghQKVGqYpmxVPdpq
	48CKfX2+qfTG9LKkJsXYO/RYl7dTVP8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 48A4E13A29;
	Wed, 22 Oct 2025 14:11:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id R9WtEC/m+Gh/EwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Wed, 22 Oct 2025 14:11:59 +0000
Message-ID: <a186416aa03bb995b2f04fdb47315c1d12a87cab.camel@suse.com>
Subject: Re: [PATCH] dm: Fix deadlock when reloading a multipath table
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Mikulas Patocka
	 <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	dm-devel@lists.linux.dev, linux-block@vger.kernel.org
Date: Wed, 22 Oct 2025 16:11:58 +0200
In-Reply-To: <aPfcAfn6gsgNLwC7@redhat.com>
References: <20251009030431.2895495-1-bmarzins@redhat.com>
	 <ed792d72a1ca47937631af6e12098d9a20626bcf.camel@suse.com>
	 <aOg2Yul2Di4Ymom-@redhat.com>
	 <e407b683dceb9516b54cede5624baa399f8fa638.camel@suse.com>
	 <aPfcAfn6gsgNLwC7@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

On Tue, 2025-10-21 at 15:16 -0400, Benjamin Marzinski wrote:
> On Fri, Oct 10, 2025 at 12:19:51PM +0200, Martin Wilck wrote:
> > On Thu, 2025-10-09 at 18:25 -0400, Benjamin Marzinski wrote:
> >=20
> >=20
> > > I did check to see if holding it for the entire suspend would
> > > cause
> > > issues, but I didn't see any case where it would. If I missed a=20
> > > case where __noflush_suspending() should only return true if we
> > > are
> > > actually in the process of suspending, I can easily update that
> > > function to do that.
> >=20
> > If this is necessary, I agree that the flag an related function
> > should
> > be renamed. But there are already generic DM flags to indicate that
> > a
> > queue is suspend*ed*. Perhaps, instead of changing the semantics of
> > DMF_NOFLUSH_SUSPENDING, it would make more sense to test=C2=A0
> >=20
> > =C2=A0 (__noflush_suspending || test_bit(DMF_BLOCK_IO_FOR_SUSPEND)
> >=20
> > in dm_swap_table()?
>=20
> Won't we ALWAYS be suspended when we are in dm_swap_table()? We do
> need
> to refresh the limits in some cases (the cases where multipath-tools
> currently reloads the table without setting noflush). What we need to
> know is "is this table swap happening in a noflush suspend, where
> userspace understands that it can't modify the device table in a way
> that would change the limits". For multipath, this is almost always
> the
> case.=20

Ok, getting it now. The semantics of the flag are changed from "device
is noflush-suspending" to "device is either noflush-suspending or
noflush-suspended". It isn't easy to express this in a simple flag
name. I'm fine with not renaming the flag, if a comment is added that
explains the semantics clearly.

> >=20
> > I find Bart's approach very attractive; freezing might not be
> > necessary
> > at all in that case. We'dd just need to avoid a race where paths
> > get
> > reinstated while the operation that would normally have required a
> > freeze is ongoing.
>=20
> I agree. Even just the timing out of freezes, his
> "[PATCH 2/3] block: Restrict the duration of sysfs attribute changes"
> would be enough to keep this from deadlocking the system.
>=20

OK, let's see how it goes. Given your explanations, I'm ok with your
patch, too.

Martin
