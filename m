Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0ABD202F87
	for <dm-devel@lists.linux.dev>; Wed,  6 Nov 2024 15:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730907363; cv=none; b=PCUVqYNL4fX16RyxqT5/AEAsJ0ZeXlM80cA4UWtj/C+BlDX5n2fVtscRHYIJrqQjTRoG3tBTQI81y7bp6tnF8Z4+0ibHOQDMjFGPNZvW94wR2WSrDbBbSe6KfPF2xTwT0Q1sCajngokCRrclm9UxwJ5GdPDD3bqDKh187No3qz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730907363; c=relaxed/simple;
	bh=ok67shfAiW+UhnsoT1+zDZdYi82K2oaYypVqi+jrOw0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=C4KHYIrpqVbdDAeb7ZXLZFgryPQiwGk8ZZd0chhPiPQa/kXX+3dSQRm7cg1fvcwK94Vg0AyqjxmIfTs51Y3ZNctWyqLDUkqh/I4tLScSNTbRbATvKvotnD1jE1tiY6nVIwzQkrAmzQHTtWO0ESFgsMNXWlf7jqIWMSQbgqnzIlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=d4mARuXh; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=SYFdXILy; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="d4mARuXh";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="SYFdXILy"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 022CB1F86A;
	Wed,  6 Nov 2024 15:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1730907358; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ok67shfAiW+UhnsoT1+zDZdYi82K2oaYypVqi+jrOw0=;
	b=d4mARuXhMC4KAuK5Zzy7viEPtQmvPLByEUHwd3umAUjVcRNVNfKSLlMoFQCJ8yjsfW8YCw
	OxaDNFbLOzpz4OanoGqpZXgDXYHbzpsj59086pM8NXSvuTBhD4YquBbk+wu6vH9UdkVXT7
	HrWaT9YoxuSnyKyiDnf56J9l3h87iU4=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1730907357; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ok67shfAiW+UhnsoT1+zDZdYi82K2oaYypVqi+jrOw0=;
	b=SYFdXILy1TuiPNmWX85qkO5CO5CgIIlsgYYCx8VSD4tnK4R+Fl1295Dgb5gdKM8ali8wRg
	RezfaDFog4SWdmICr42nJyW1G716MtL9HkYVpxVxsQtU9lBYnrLSOnZBzYj+pj70TqaFPy
	Z4qLUiv6iPJ4+EUxgm8a36CMU908asg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BD8DC13736;
	Wed,  6 Nov 2024 15:35:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4n2pLNyMK2ebTwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Wed, 06 Nov 2024 15:35:56 +0000
Message-ID: <a81456e104d04ec5dc73a71d8b230fe77b214829.camel@suse.com>
Subject: Re: [PATCH] multipath-tools: remove hwhandler from all hwtable
 configs
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM-DEVEL ML <dm-devel@lists.linux.dev>
Date: Wed, 06 Nov 2024 16:35:56 +0100
In-Reply-To: <2cea56e4-d065-41a4-aa12-54243f738717@gmail.com>
References: <20241010161806.14950-1-xose.vazquez@gmail.com>
	 <1ecfb9236dd2703d90727b3468dfe3381987b4b4.camel@suse.com>
	 <2cea56e4-d065-41a4-aa12-54243f738717@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,linux.dev:email]
X-Spam-Score: -2.80
X-Spam-Flag: NO

On Tue, 2024-11-05 at 00:50 +0100, Xose Vazquez Perez wrote:
> On 11/3/24 10:21 PM, Martin Wilck wrote:
>=20
> > On Thu, 2024-10-10 at 18:18 +0200, Xose Vazquez Perez wrote:
> > > Useless, automatically handled by the kernel since 4.3.
> > > (4.3 was released nine years ago)
> > >=20
> > > Cc: Martin Wilck <mwilck@suse.com>
> > > Cc: Benjamin Marzinski <bmarzins@redhat.com>
> > > Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> > > Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
> > > Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> > > ---
> > > =C2=A0=C2=A0libmultipath/hwtable.c | 44 -----------------------------=
------
> > > -----
> > > --
> > > =C2=A0=C2=A01 file changed, 44 deletions(-)
> >=20
> > Reviewed-by: Martin Wilck <mwilck@suse.com>
>=20
> Two previous ones are pending:
> https://marc.info/?l=3Ddm-devel&m=3D172722205013845
> https://marc.info/?l=3Ddm-devel&m=3D172842303913121
>=20
> Thanks.

Applied to "queue" branch now. Sorry for the delay.

