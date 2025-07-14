Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E777E246799
	for <dm-devel@lists.linux.dev>; Mon, 14 Jul 2025 10:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752490237; cv=none; b=JH676AOthx4NSrfpDZlHkHrXdMgVBaHbk2qzG5j9R16UtDG6u1GySlA6Hd3dX0RJvKxCNuQi4sq1ivPmDPJjfOxiDm3Gsv1/4SISt9rccmsWVHaCB6xGy6EzrcB4a7KH9TLhLRUd67141JTbfwKnygVtpOMwlC97gmQP80NJwYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752490237; c=relaxed/simple;
	bh=Kw+/VsqfKqmVqKbFzuYqh0wASb4uwQU94Cn13rJq7XM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ojH9ADL9rqOD9AQnAYT0oueoSkQ03SV4uaDiKeNvx6iP19EFF22/xHRaeN4jj4tHGvllo/PJ4ydRX8eslAnVn9U6ZKftixi5wi/UkT/VDHZ5/lwaGXQnZR6kAzKhud5AvppGxqNUbwTgP7/HE3WwHJQYXoDmqX9OVtMY5MxEuyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Hj1la05q; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=nyUM4JaC; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Hj1la05q";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="nyUM4JaC"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D0CCC1F38F;
	Mon, 14 Jul 2025 10:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1752490232; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4QUQ+BscEGDTbnvAGFZ4Yjouan6dNKIM89CIQaWzv1A=;
	b=Hj1la05q/JheHGOVJ0BwlcLuIQ42LhGhANXDje93aWWBkR791ksSNLfvEssTl+eOlxe+gb
	QbhEoaUvLZM1AmVfZTgHOXxlhr2Qi2vPHKPc1YUYDTUIHrljpo/z+Q/i4f3Qtan9ExWyLv
	V0/s4IXLF/NnbcrDjttvsnNzAnv8N5w=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=nyUM4JaC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1752490231; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4QUQ+BscEGDTbnvAGFZ4Yjouan6dNKIM89CIQaWzv1A=;
	b=nyUM4JaCuYXfEM0aLvpTLAQno8RonUQ9r//ifxRvawGyTU+1cX7mFJ4oumnftwrIVm9cDd
	u+qQW35lHrkkFN9wi6L4qV/orhO3mqHkhHOLJJdwyxHesikYKumkWQ+U/yumAhTDUpKkiz
	FO/vT0wgds2Z8O+PeygRd58kfGKpXas=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 49445138A1;
	Mon, 14 Jul 2025 10:50:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id COMPEPfgdGh+WgAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 14 Jul 2025 10:50:31 +0000
Message-ID: <5472d0c871c77e41176b3a5f29f88ce32f81d861.camel@suse.com>
Subject: Re: [PATCH] multipath-tools: fix default blacklist of s390 devices
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Stefan Haberland <sth@linux.ibm.com>, Nigel Hislop
 <hislop_nigel@emc.com>,  Matthias Rudolph
 <Matthias.Rudolph@hitachivantara.com>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik	 <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger
 <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Hannes
 Reinecke <hare@suse.de>,  Benjamin Marzinski	 <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,  S390-ML
 <linux-s390@vger.kernel.org>, DM-DEVEL-ML <dm-devel@lists.linux.dev>, Nigel
 Hislop	 <hislop_nigel@dell.com>
Date: Mon, 14 Jul 2025 12:50:30 +0200
In-Reply-To: <76bde3f1-0f06-46fc-8e0a-729e6629024c@gmail.com>
References: <20250712201454.215404-1-xose.vazquez@gmail.com>
	 <76bde3f1-0f06-46fc-8e0a-729e6629024c@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: D0CCC1F38F
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -3.01

On Sun, 2025-07-13 at 00:11 +0200, Xose Vazquez Perez wrote:
> On 7/12/25 10:14 PM, Xose Vazquez Perez wrote:
>=20
> > =C2=A0 libmultipath/hwtable.c | 4 ++--
> > =C2=A0 1 file changed, 2 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> > index 081d119c..4ca4245c 100644
> > --- a/libmultipath/hwtable.c
> > +++ b/libmultipath/hwtable.c
> > @@ -687,7 +687,7 @@ static struct hwentry default_hw[] =3D {
> > =C2=A0=C2=A0		/* PAV DASD FBA */
> > =C2=A0=C2=A0		.vendor=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D "IB=
M",
> > =C2=A0=C2=A0		.product=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D "S/390 D=
ASD FBA",
> > -		.bl_product=C2=A0=C2=A0=C2=A0 =3D "S/390",
> > +		.bl_product=C2=A0=C2=A0=C2=A0 =3D "S/390 DASD FBA",
> > =C2=A0=C2=A0		.uid_attribute =3D "ID_UID",
> > =C2=A0=C2=A0		.no_path_retry =3D NO_PATH_RETRY_QUEUE,
> > =C2=A0=C2=A0		.pgpolicy=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D MULTIBUS,
>=20
> Is PAV really supported on FBA devices ???
> And other than 3390 and 3380(3390 model 2/3 in track-compatibility
> mode) ECKD types ?

I don't know, but either way I don't think blacklisting them would
hurt.

Martin

>=20
> Source, z/vm docs: https://www.vm.ibm.com/storman/pav/pav2.html#2001
>=20
> Thanks.
