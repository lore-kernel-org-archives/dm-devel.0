Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FD31095F
	for <dm-devel@lists.linux.dev>; Mon, 30 Oct 2023 11:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Oc5bYFqQ"
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 969C51FEF0;
	Mon, 30 Oct 2023 11:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1698666095; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UhItp19HRQmEvM1m83eAqHT/INDlWKc9Ck8WexWcJ4s=;
	b=Oc5bYFqQBH8Ol3uXrDXZlcQhvzLWBYyYgrCIP+v1KmiGi0OVq3zJzhusccsrgLPU0f+NoE
	eEmRHyMgUMRvcVxQoeikPOLxiU5vmBKSI+5ZeebN6LTHPFg3AiDYPB+5Cx0qbBrKiTpNR3
	RlDgxhxMsr4Qty6iGYOPjZO6jCzybac=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 66692138F8;
	Mon, 30 Oct 2023 11:41:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id BGU/F2+WP2WYVQAAMHmgww
	(envelope-from <mwilck@suse.com>); Mon, 30 Oct 2023 11:41:35 +0000
Message-ID: <dde398a814cc2cdaa63931087cc97a0c88ba5120.camel@suse.com>
Subject: Re: [PATCH v2 12/14] README.md: update mailing list and
 contributing information
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev, Xose Vazquez Perez <xose.vazquez@gmail.com>
Date: Mon, 30 Oct 2023 12:41:34 +0100
In-Reply-To: <ZTwPnti1mnkGK19V@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231026174153.1133-1-mwilck@suse.com>
	 <20231026174153.1133-13-mwilck@suse.com>
	 <ZTwPnti1mnkGK19V@bmarzins-01.fast.rdu2.eng.redhat.com>
Autocrypt: addr=mwilck@suse.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.0 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Fri, 2023-10-27 at 15:29 -0400, Benjamin Marzinski wrote:
> On Thu, Oct 26, 2023 at 07:41:51PM +0200, mwilck@suse.com=A0wrote:
> > =A0
> > +Mailing list
> > +------------
> > +
> > +The mailing list for multipath-tools is
> > `dm-devel@lists.linux.dev`.
> > +To subscribe, send an email to
> > `dm-devel+subscribe@lists.linux.dev`.
> > +Mailing list archives are available on
> > +[lore.kernel.org](https://lore.kernel.org/dm-devel/) and
> > +[marc.info](https://marc.info/?l=3Ddm-devel). See also the
> > +[lists.linux.dev home
> > page](https://subspace.kernel.org/lists.linux.dev.html).
> > +
> > +When sending patches to the mailing list, lease add a `Signed-off-
> > by:`
>=20
> Missed the 'p' in please. Otherwise this looks fine.

I'll take the liberty to add the "p" and add your Acked-by.
Let me know if you disagree.

Martin

