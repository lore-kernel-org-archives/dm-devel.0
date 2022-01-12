Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9133FC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 12 Jan 2022 16:56:30 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-670-QOwg7i0-MMSMnBx7u6yXUA-1; Wed, 12 Jan 2022 11:56:27 -0500
X-MC-Unique: QOwg7i0-MMSMnBx7u6yXUA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DF02B100C61C;
	Wed, 12 Jan 2022 16:56:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B143B77455;
	Wed, 12 Jan 2022 16:56:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 700A44BB7C;
	Wed, 12 Jan 2022 16:56:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20CGuLjl030302 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 12 Jan 2022 11:56:21 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 686B946D21F; Wed, 12 Jan 2022 16:56:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6488A46D219
	for <dm-devel@redhat.com>; Wed, 12 Jan 2022 16:56:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B2B6101A52D
	for <dm-devel@redhat.com>; Wed, 12 Jan 2022 16:56:21 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
	d=dkim.mimecast.com; s=201903; t=1642006581;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qqbDCDcvAXTpcBXiC+xr+OSvYb3e0DAzpXacHFS/aco=;
	b=XKNuC2iNf9rV0TRvBTmqs7xuhoUCOSTRPcO+VXoQ13ERZn7cfNLuMCsZf5RFlflXWjO8aX
	DBp8UT2wuUxXGWmcz8m3y3/rXZNVavzhDCMQDLA0oFHlU/Fe02P6wYxrkiN0w8KuesfZjI
	mE8y+/4YpGB36l2lLyiRYKNXbkHxKjM+pXmHplHC+Q4gzNovCPgomhKZq224hg33K0D8x4
	kgN6a1oLgUupSUuNHJMfAm7t6JuX/7jqt99JBPzkGCrhUN8xo0UDb7qLhQgKrPlgjlp/aD
	C9S0I7VbyKEEPlNhou1surRzMuewD+lNqeAqOUcqFrGX1JtAzhLpbBH4e9iO+Q==
ARC-Seal: i=1; s=201903; d=dkim.mimecast.com; t=1642006581; a=rsa-sha256;
	cv=none;
	b=JopCxpozICr90IVp4qvHlpwHNxLr0rZIZA9SwHWJyyey6X/VD0t1KRJ+MD+IydNuK3gaZq
	Z+BzNeEaCQGeKddoItWPAicHqOYfxeq6ef++bhJFATWagQOFxzu9sr/PsnQXK8mtMeSYVX
	+VuZs9bInlyfiWU/iOFwVlHpcNkCGFrZ+wBnWzBxYWO9QX6AJZmjEFjI/GIC6fItlwRxTw
	pwTzEV4GmRvpK5M5kTmRXUiIFXbwr0o4EgeaN63pC3tsiZGOGRXfpZ7SRroXOfGfnxXYwU
	mDWiVOuS/zkElVW+rpZtQ89OShqyVfqopDKu6PVfM/bNzh1yl1PIdNogmF+RzQ==
ARC-Authentication-Results: i=1; relay.mimecast.com;
	dkim=pass header.d=web.de header.s=dbaedf251592 header.b=BMTsEV9y;
	dmarc=pass (policy=none) header.from=web.de;
	spf=pass (relay.mimecast.com: domain of lukasstraub2@web.de designates
	212.227.15.3 as permitted sender)
	smtp.mailfrom=lukasstraub2@web.de
Received: from mout.web.de (mout.web.de [212.227.15.3]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-637-1EVzR5rKO-2ABnb-Em-kdg-1; Wed, 12 Jan 2022 11:56:19 -0500
X-MC-Unique: 1EVzR5rKO-2ABnb-Em-kdg-1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
	s=dbaedf251592; t=1642006575;
	bh=VpwX7tXhTbrLuzi1YF8Uzmb4A2oBhdUT14fAMPWrFis=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:In-Reply-To:References;
	b=BMTsEV9yqecF2TRWlL4SzUD8d1pS/jbQ2p0EBSZVJNoO99UjndXU2iv20XcbA+UQ4
	bzp5IWgoyVR9NIn6ASVBdjYO7vSjaSBUlLZTQgfB6No1uFta6zsxmK58hR0AAs5MjC
	+nWUKjOtziq1neWi40zdMtFLTunDkJLqARUQRl20=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from gecko ([46.223.151.70]) by smtp.web.de (mrweb006
	[213.165.67.108]) with ESMTPSA (Nemesis) id 1M91Pe-1n1fJI3tgc-006XPY;
	Wed, 12 Jan 2022 17:56:15 +0100
Date: Wed, 12 Jan 2022 16:56:12 +0000
From: Lukas Straub <lukasstraub2@web.de>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <20220112155351.5b670d81@gecko>
In-Reply-To: <24998019-960c-0808-78df-72e0d08c904e@gmx.com>
References: <0535d6c3-dec3-fb49-3707-709e8d26b538@gmx.com>
	<20220108195259.33e9bdf0@gecko> <20220108202922.6b00de19@gecko>
	<5ffc44f1-7e82-bc85-fbb1-a4f89711ae8f@gmx.com>
	<e209bfe191442846f66d790321f2db672edfb8ca.camel@infradead.org>
	<24998019-960c-0808-78df-72e0d08c904e@gmx.com>
MIME-Version: 1.0
X-Provags-ID: V03:K1:heywFokXSb224cpwvQrsi2v/LXbEHOE0r74vVZ0tAW61GPjbn6c
	eDdc9ppwND/oggCfxDn5DN/mNAEMOVaVO4sSRcD5N3Lu0QPeZ0mcwnxvixwiuMB9gADj3xX
	dVwYWnfBfnpweGh1YlYWJL76eTBrK6kgl6tA9RTyCdIlzfqKoVwEtzccIk2kpvTVW8uMHiR
	nbXSeKAdNKk+mM7NioWjQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:MFIc5YVY8es=:CqRoOpsjVa2ZWpGujqS8Pp
	z2/6frw4XTzKbfWS/CjLRe9lOz83PaN3AMzK11tQozD3fEV8kjKEAhapX1K9yOUmnI6mWvAxA
	evzguANGnRAurTSWsahAsRwPaTkLlTJ9D0/8xef4JgFFAJ4b3yiX9qTs+2RJp0xrOjTzCoAwY
	XzMgcVijUl+nGfTMk+QSZiZLURTcgR52sJqnOsCA4p0PDrnScgC2jKrqePUGBQDVf7B/FXBon
	VIDBFpkLkukvh8+OgyZJiqPc5/K8SDdXWN1z9TGTbiuT6rilEJx8L6oH/ep1lG0mmNIh6W//5
	kxTUKU02oGybaYmyJBuQkyf698wq3Merp3ynqu9NlKbqIrCr3q7yTHmxNHzFOgLh2kIipsutO
	tHnKpbohnQbNP7TpVo0g5blbqYSYtJf5evuJV6vxbbHesrbjZwc/jgJ16zwM1500V5GTg8emO
	J1V9uKgDHFdBAyKUX4w1E1Y9B0qifU+OMEHLccGZK1qpxe1GngRnu/b4/gGtGlVlgc8KBHyZ1
	lwBynGn33dLOFYa73WYOjQDn7s/rwhQ8xe04xMLwEzPAnMoOvMo+EkbBHeaJthvc6FDiLPXDN
	aVEhnGWFt20Y6Ix+6IJ0PreEp/oxcwGZHt0DVk7OwoDFJc0DOA2LmDl4f89pvVLxlD0xE1KZG
	/UxczuimfL0SX9rlyyzUU1VUDLUXKPntad7cw1wY6/UuPNjxio4uW9Y7YBWQpx9phpVs6vsoG
	X6Br4zkM3H78HZsDID56aLhGBLlt0Sg9ZtHAaZnFhG2GqhOMD1I2/X4jlG/7jkI26IdEXy3kP
	W+NRvDMk3OWKU2WtfcCU2w7GKA3nsc0UsqfxbQUGVl2vLiDDDdWIE09mrc46qNVWZqsTeeD90
	xHQzLJLJXkhl7T5gTmM3UQCkFvKXX/mlIgDiz/dOMobTnj/DlA4Du2ypSk2cFrdS8DPMEUsIZ
	JmvmMAioOz2Vt1Lgz0mzn8iBI3k934Na7LxX+Z/IAKIfysx3OzK7SkseHgcHj2g4yhzaxbbI1
	5cCzNvc8XChmxVvLRCXFZubT4Vki9PwsI3rpt0RLk1S+t7geFjpdvnXI0k7MeJ0Ad9lB7/ISa
	sMNB1A77XtAsY0=
Authentication-Results: relay.mimecast.com;
	dkim=pass header.d=web.de header.s=dbaedf251592 header.b=BMTsEV9y;
	dmarc=pass (policy=none) header.from=web.de;
	spf=pass (relay.mimecast.com: domain of lukasstraub2@web.de designates
	212.227.15.3 as permitted sender)
	smtp.mailfrom=lukasstraub2@web.de
X-Mimecast-Spam-Score: -4
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-loop: dm-devel@redhat.com
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>, linux-raid@vger.kernel.org
Subject: Re: [dm-devel] Proper way to test RAID456?
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4401365409080400120=="
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15

--===============4401365409080400120==
Content-Type: multipart/signed; boundary="Sig_/trK2B+bQZg4U+J+J8zLUK/8";
	protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/trK2B+bQZg4U+J+J8zLUK/8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 9 Jan 2022 20:13:36 +0800
Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:

> On 2022/1/9 18:04, David Woodhouse wrote:
> > On Sun, 2022-01-09 at 07:55 +0800, Qu Wenruo wrote: =20
> >> On 2022/1/9 04:29, Lukas Straub wrote: =20
> >>> But there is a even simpler solution for btrfs: It could just not tou=
ch
> >>> stripes that already contain data. =20
> >>
> >> That would waste a lot of space, if the fs is fragemented.
> >>
> >> Or we have to write into data stripes when free space is low.
> >>
> >> That's why I'm trying to implement a PPL-like journal for btrfs RAID56=
. =20
> >
> > PPL writes the P/Q of the unmodified chunks from the stripe, doesn't
> > it? =20
>=20
> Did I miss something or the PPL isn't what I thought?
>=20
> I thought PPL either:
>=20
> a) Just write a metadata entry into the journal to indicate a full
>     stripe (along with its location) is going to be written.
>=20
> b) Write a metadata entry into the journal about a non-full stripe
>     write, then write the new data and new P/Q into the journal
>=20
> And this is before we start any data/P/Q write.
>=20
> And after related data/P/Q write is finished, remove corresponding
> metadata and data entry from the journal.
>=20
> Or PPL have even better solution?

Yes, PPL is a bit better than a journal as you described it (md
supports both). Because a journal would need to be replicated to
multiple devices (raid1) in the array while the PPL is only written to
the drive containing the parity for the particular stripe. And since the
parity is distributed across all drives, the PPL overhead is also
distributed across all drives. However, PPL only works for raid5 as
you'll see.

PPL works like this:

Before any data/parity write either:

 a) Just write a metadata entry into the PPL on the parity drive to
    indicate a full stripe (along with its location) is going to be
    written.

 b) Write a metadata entry into the PPL on the parity drive about a
    non-full stripe write, including which data chunks are going to be
    modified, then write the XOR of chunks not modified by this write in
    to the PPL.

To recover a inconsistent array with a lost drive:

In case a), the stripe consists only of newly written data, so it will
be affected by the write-hole (this is the trade-off that PPL makes) so
just standard parity recovery.

In case b), XOR what we wrote to the PPL (the XOR of chunks not
modified) with the modified data chunks to get our new (consistent)
parity. Then do standard parity recovery. This just works if we lost a
unmodified data chunk.
If we lost a modified data chunk this is not possible and just do
standard parity recovery from the beginning. Again, the newly written
data is affected by the write-hole but existing data is not.
If we lost the parity drive (containing the PPL) there is no need to
recover since all the data chunks are present.

Of course, this was a simplified explanation, see drivers/md/raid5-ppl.c
for details (it has good comments with examples). This also covers the
case where a data chunk is only partially modified and the unmodified
part of the chunk also needs to be protected (by working on a per-block
basis instead of per-chunk).

The PPL is not possible for raid6 AFAIK, because there it could happen
that you loose both a modified data chunk and a unmodified data chunk.

Regards,
Lukas Straub

> >
> > An alternative in a true file system which can do its own block
> > allocation is to just calculate the P/Q of the final stripe after it's
> > been modified, and write those (and) the updated data out to newly-
> > allocated blocks instead of overwriting the original. =20
>=20
> This is what Johannes is considering, but for a different purpose.
> Johannes' idea is to support zoned device. As the physical location a
> zoned append write will only be known after it's written.
>=20
> So his idea is to maintain another mapping tree for zoned write, so that
> full stripe update will also happen in that tree.
>=20
> But that idea is still in the future, on the other hand I still prefer
> some tried-and-true method, as I'm 100% sure there will be new
> difficulties waiting us for the new mapping tree method.
>=20
> Thanks,
> Qu
>=20
> >
> > Then the final step is to free the original data blocks and P/Q.
> >
> > This means that your RAID stripes no longer have a fixed topology; you
> > need metadata to be able to *find* the component data and P/Q chunks...
> > it ends up being non-trivial, but it has attractive properties if we
> > can work it out. =20



--=20


--Sig_/trK2B+bQZg4U+J+J8zLUK/8
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEg/qxWKDZuPtyYo+kNasLKJxdslgFAmHfCCwACgkQNasLKJxd
slj5YRAAriTi+zPKCzdoJ0d2cj8ZkHXtVoQMa5qr3R5f20aEyu/oTPkMFvmtsOKj
ViMcFhTaV5Ceardq7Td7G3N2QzBJjEQsrg0FIl6aD9Jp8XWW49VwXRTyHihXi7xy
HRCziWCxp8HWc6qy3IpOCm/XD3i0i37IDrm8dmA7r62swOALFX5g5zIpDo/CkfNU
Tln3wA97KMEd93dWLzvWZsXFhETQ2lX9l5EMYzTjUqR0PAtbVJlHfeVYTnF1eAnw
S5+TyiwfXa0lqOKUABYR8Ygnelu98VROpNWXUJi25CaY8l2T5jigskFdNvm+Ihy+
era4R8dAsXCBhTEmO4JXNLmE42IU+m+6DnZlGHxn+v3wuh7Tz46sAAC9JX73R6Fk
e925eXQ2e2df7Ej964r3f4u/yiVO+/MaoiLUacz+U3VbZu9LOGYJ+xmnmycjhV3X
NmfBV1nnWIeYU6fHvRigLCMJXnVd9dPlYlqW0alRq/OtLW2rKlUkXf+RWLOpT8By
+ZMyloNz0/84MFLN+XhgdbwpEJ/NStbaJXJtD7T2nUf2l3+kWV6rFrmPIgxdPYyb
7yJMWxj9rGaU+2XmAkqoyC5ahj30apruZbQLyCXqc1EeHlGY8/Wrq5h2ZBAJcDbr
CH22cVV2JzDT77MvzC+9nPWT/rkm8MNna4TRLZgtTauio9bPGHg=
=Jly6
-----END PGP SIGNATURE-----

--Sig_/trK2B+bQZg4U+J+J8zLUK/8--


--===============4401365409080400120==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============4401365409080400120==--

