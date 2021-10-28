Return-Path: <SRS0=rauK=PQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9094C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 28 Oct 2021 23:57:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3773F610A4
	for <dm-devel@archiver.kernel.org>; Thu, 28 Oct 2021 23:57:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3773F610A4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-mWBl8Y7HNFmaHlMyx9SKfg-1; Thu, 28 Oct 2021 19:57:49 -0400
X-MC-Unique: mWBl8Y7HNFmaHlMyx9SKfg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 17E065074E;
	Thu, 28 Oct 2021 23:57:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 117265D9DE;
	Thu, 28 Oct 2021 23:57:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4C5244A703;
	Thu, 28 Oct 2021 23:57:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19SNveRR006898 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 28 Oct 2021 19:57:40 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 0CB9D2166B26; Thu, 28 Oct 2021 23:57:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 06D262166B25
	for <dm-devel@redhat.com>; Thu, 28 Oct 2021 23:57:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EBD85800883
	for <dm-devel@redhat.com>; Thu, 28 Oct 2021 23:57:36 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
	d=dkim.mimecast.com; s=201903; t=1635465456;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BBq1Yspji0vJm9R7zIGdVaVx2DU7+FD6B6UrqSLpbPg=;
	b=LXV9CzMo/1vHTZSTF2Nxihv9BCkpUUZzcSfXdVb8xraTe3w7Ie0RvnlP+CYEMV/w4Mc9pQ
	8ex+drRdEvYE34DzR7Czkica7t8DE/HGTcb+EgD+RMq6t8ky6fH1tCxCurEByyykwndnBL
	j+t7zlzr7Mir6FsPjL7wUR/z8z3x0SHG1Lfwaj4MYIiF3K9xmOm2rneHJbgKFnd8NKt08Z
	z1iesRG+Ht2H6mdKFNSQvF+E5luqleCQSKmux2TMFmcOXjiQjmkIQBI9u+w6CnLOR7UJ0T
	7nHxvYhwYtbVxtyqVrWA/qKfOdyXbni7m8AIJnKK+NDHxLgyluXbEaTB2qymRw==
ARC-Seal: i=1; s=201903; d=dkim.mimecast.com; t=1635465456; a=rsa-sha256;
	cv=none;
	b=XERdEDPr0gDz4fyZ16vDv/gpdIXRP6o9qt9u+xU+zU2PmTBV7cDEfSODUPXkj8pYiVNt6X
	r8CT2OOYmv5iowNPexmgDQhDAtjFi6wWSvhiTW6qJEKqaY8376nawQx3mGfPaERHUOT9Md
	adbvzRHBUeYJUh5DPONB0gNZxP1qqxE87VfABQknMghH1LYtb36FFOviywLgRcu48I15MJ
	ikLrOEjXbOCY5baSJdcOAjtEmvo43FAGqibMSO6x0vsJSRa+f5rY/+e+Hbz828/kvfmHZz
	DL0jW54gH/sNepVZy8qhNSckrT95efaAmX/iiW+xkQnpgk7s0Zp5Q8UgZlZiZg==
ARC-Authentication-Results: i=1; relay.mimecast.com;
	dkim=pass header.d=canb.auug.org.au header.s=201702 header.b=YD23+ciz; 
	dmarc=none;
	spf=pass (relay.mimecast.com: domain of sfr@canb.auug.org.au designates
	150.107.74.76 as permitted sender)
	smtp.mailfrom=sfr@canb.auug.org.au
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-533-iYkbz19ePmG1IKS--6dbWQ-1; Thu, 28 Oct 2021 19:57:35 -0400
X-MC-Unique: iYkbz19ePmG1IKS--6dbWQ-1
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits)
	server-digest SHA256) (No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4HgMlw4DB8z4xYy;
	Fri, 29 Oct 2021 10:51:40 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1635465102;
	bh=BBq1Yspji0vJm9R7zIGdVaVx2DU7+FD6B6UrqSLpbPg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=YD23+cizlmSgewjdmhU7noKEZETmDps4i3fEy4IW/h0x6VStpgpxY1SvfXRmhLtgC
	R73C2AZR/Zrym+A1IeFvOgQbitR7EGkFxQf2ORBS1apsKDtBt+EQj4fHovArvkT+kf
	nxR1Bm0IAGIfvB3B4H1UIssoHggQZvP8YWpJU7ptHk1b99ZDJ8zxYcQOkZ6KEP84P1
	vmYaqwCIDQ6FGWqA0g1ZhEHfTSfvaWL9UZW2oNOXFweire0ERYucF3+NhB82qjA5Id
	NJ/2F+0+PVhmuDV3uC5qLEVXNIGPdBL1KvnMm3S66zK15p/TeHFQGImQ+t3EncV3RW
	XO4GmcNhtz05g==
Date: Fri, 29 Oct 2021 10:51:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dan Williams <dan.j.williams@intel.com>
Message-ID: <20211029105139.1194bb7f@canb.auug.org.au>
In-Reply-To: <CAPcyv4iEt78-XSsKjTWcpy71zaduXyyigTro6f3fmRqqFOG98Q@mail.gmail.com>
References: <20211018044054.1779424-1-hch@lst.de>
	<CAPcyv4iEt78-XSsKjTWcpy71zaduXyyigTro6f3fmRqqFOG98Q@mail.gmail.com>
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
	dkim=pass header.d=canb.auug.org.au header.s=201702 header.b=YD23+ciz; 
	dmarc=none;
	spf=pass (relay.mimecast.com: domain of sfr@canb.auug.org.au designates
	150.107.74.76 as permitted sender)
	smtp.mailfrom=sfr@canb.auug.org.au
X-Mimecast-Spam-Score: -5
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Mike Snitzer <snitzer@redhat.com>,
	linux-s390 <linux-s390@vger.kernel.org>, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs <linux-xfs@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ira,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Weiny <ira.weiny@intel.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] futher decouple DAX from block devices
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
Content-Type: multipart/mixed; boundary="===============6936643711748699438=="
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14

--===============6936643711748699438==
Content-Type: multipart/signed; boundary="Sig_/SsoWmhnAUHONY.PedkLs.lt";
	protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/SsoWmhnAUHONY.PedkLs.lt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dan,

On Wed, 27 Oct 2021 13:46:31 -0700 Dan Williams <dan.j.williams@intel.com> =
wrote:
>
> My merge resolution is here [1]. Christoph, please have a look. The
> rebase and the merge result are both passing my test and I'm now going
> to review the individual patches. However, while I do that and collect
> acks from DM and EROFS folks, I want to give Stephen a heads up that
> this is coming. Primarily I want to see if someone sees a better
> strategy to merge this, please let me know, but if not I plan to walk
> Stephen and Linus through the resolution.

It doesn't look to bad to me (however it is a bit late in the cycle :-(
).  Once you are happy, just put it in your tree (some of the conflicts
are against the current -rc3 based version of your tree anyway) and I
will cope with it on Monday.

You could do a test merge against next-<date>^^ (that leaves out
Andrew's patch series) and if you think there is anything tricky please
send me a "git diff-tree --cc HEAD" after you have resolved the
conflicts to your satisfaction and committed the test merge or just
point me at the test merge in a tree somewhere (like this one).

--=20
Cheers,
Stephen Rothwell

--Sig_/SsoWmhnAUHONY.PedkLs.lt
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmF7N4sACgkQAVBC80lX
0Gxw2gf/TsRhRytrNIQkXZwCrlHR+hjJ895jJhg4Hp+ig2QzzYRjM/GrSPzXAXF3
s5SscPXv7egnMo+fHKY9d/CscYD6kDg4FtBuvoJqx/ApGN4PQLme5S3KbxrNRgd2
2vpBRjXN+26toUw0W2PK1gzHRJXaB6waOFbA6crbuWU1BDzVZoeRHfjKtlBMax7Q
g6pzcvDzs7ia50KBJvi6hNkxCy7xuNAsLlm96930v/bLvnUYo6dOGrzZ6/Kjzjcw
LpWIuVQGxkzBiILaGSiHuNfzZEbSvoSXMfMRJ5KBpAhB8M1dhuyqP4QBWMwe7+Tn
Oo6WLOwKx89LL+uStt4yje6yx9483w==
=+eTD
-----END PGP SIGNATURE-----

--Sig_/SsoWmhnAUHONY.PedkLs.lt--


--===============6936643711748699438==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============6936643711748699438==--

