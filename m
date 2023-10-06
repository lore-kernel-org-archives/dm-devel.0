Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07232E92FF1
	for <dm-devel@archiver.kernel.org>; Fri,  6 Oct 2023 06:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696575572;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=U0vOmeN5lxU7dAdisORN5j91pGWWo4vYuSJDXYBeQQA=;
	b=gxppXDdhaMqZWk+q3/c62CX/IEPCpBUhAzm46c/rj+xZmaiZqoYewI14kERRm1xe1E7q2C
	TzuygQAIzZBD8chIuc9/fk2FmQmPICjWtFNM43cJ9nqvU99k46nLZ3QS1a1n6fBmBAS7hb
	uCG94x9ZK3J8BGdKaloyfJhROJlH/qE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-MjHMMdM5PXqiO9cN5361cQ-1; Fri, 06 Oct 2023 02:59:29 -0400
X-MC-Unique: MjHMMdM5PXqiO9cN5361cQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 368CC8007A4;
	Fri,  6 Oct 2023 06:59:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B1C2B2027046;
	Fri,  6 Oct 2023 06:59:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B7BCB19465B3;
	Fri,  6 Oct 2023 06:59:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id ED7B0194658F
 for <dm-devel@listman.corp.redhat.com>; Fri,  6 Oct 2023 01:04:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B61DB42485F; Fri,  6 Oct 2023 01:04:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AE339442CB1
 for <dm-devel@redhat.com>; Fri,  6 Oct 2023 01:04:41 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E0C33C0ED4A
 for <dm-devel@redhat.com>; Fri,  6 Oct 2023 01:04:41 +0000 (UTC)
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com
 [209.85.167.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-Xbca4E_oNKOvK86Glrj9mg-1; Thu, 05 Oct 2023 21:04:23 -0400
X-MC-Unique: Xbca4E_oNKOvK86Glrj9mg-1
Received: by mail-oi1-f170.google.com with SMTP id
 5614622812f47-3af86819ba9so999635b6e.3; 
 Thu, 05 Oct 2023 18:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=gmail.com; s=20230601; t=1696554263; x=1697159063; darn=redhat.com;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=xbWXVkPufIc/8Du+zQCnrHClPnWAOU4FcdQfVWLhTPM=;
 b=lRAbk5MWCbfQZR8rIKd+mm8sA/WLDu4YzxHM2nvWMi6RppqgTJTleL/36biVtFGkM2
 7pR+NhYXCu/U5baxXA7QtZWC8jOGsI0pUZUVBCyUcbpx4jhAZ6aguMXEoI0du5KriRMK
 fve6ScPbWHMKw5qpc+J95mn0xgU1Qyit/BPZ7Fs9yxAXC9yi2MyealWi7BXfZCbtyT+f
 E4wjvVBGFy8v+amFVZijj0JIUpa2KWK9fWCtBG9EmkbxLARXeKy8KE/6ETWPBORDQyso
 ik9qF0d6thnWZjv+kh1vLmbm54wDA9g7E0E0DxJYpdMX7OfBhJPvtvAPjyitHWshn84u
 sEqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1696554263; x=1697159063;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=xbWXVkPufIc/8Du+zQCnrHClPnWAOU4FcdQfVWLhTPM=;
 b=dixxYzmv2upOEv2paL46X0eTC+a0UcVPBrOxXOMAT6ROVDISEPFQEUW0M+tIwGeg+U
 JPxNFdTrbMiOgMo6dT5wNejPCZIJGHU7JOYJBN9XUhfaGAW0ZTu/n0s/RHsj8ZYO0vDg
 qOd0IEkMwJaetddZJ9nQYtUhaDBs99xdn6m5pp2xjitjboA8PwMHfwhTiErPQlZuJzRK
 cwcZl4pXta2QEVBpKY0BDg8FkhiUlgh3L7zlNdzxaDsFjcv/8gRvcsshwqAKpDzO7wi4
 DxlM6yGgr8/zw1AmggoSQLgibTWfd+scJ1GibyMh0xcZfTBf1Z8RJMy7zafXDDUy6Zuo
 6JnQ==
X-Gm-Message-State: AOJu0Yx6IfS7YhRwefzV7B/VhzlRmQDpsY0Gdfm1XmPjP7R+/eNb0/Zj
 j9PDpCG40MLgdkfjdR+BVRo=
X-Google-Smtp-Source: AGHT+IFh2w6zzhV5IY1apER8J1+pgvye6XXqvRnnMvh23W1RQguKILS+24Zm9m4xUzHHHEty7//QLg==
X-Received: by 2002:a05:6808:138a:b0:3a7:1d15:28fe with SMTP id
 c10-20020a056808138a00b003a71d1528femr7789531oiw.56.1696554262692; 
 Thu, 05 Oct 2023 18:04:22 -0700 (PDT)
Received: from debian.me ([103.131.18.64]) by smtp.gmail.com with ESMTPSA id
 g2-20020a63ad02000000b00584d035c08asm2083377pgf.24.2023.10.05.18.04.21
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 05 Oct 2023 18:04:22 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
 id 777638209CB9; Fri,  6 Oct 2023 08:04:18 +0700 (WIB)
Date: Fri, 6 Oct 2023 08:04:18 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Tatu =?utf-8?B?SGVpa2tpbMOk?= <tatu.heikkila@gmail.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
Message-ID: <ZR9dEiXhQv-wBVA2@debian.me>
References: <f1b8d8f5-2079-537e-9d0f-d58da166fe50@gmail.com>
MIME-Version: 1.0
In-Reply-To: <f1b8d8f5-2079-537e-9d0f-d58da166fe50@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Fri, 06 Oct 2023 06:59:25 +0000
Subject: Re: [dm-devel] (Bisected) Accessing opened Bitlocker partition
 leads to memory fault and kernel panic on Imac8, 1
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Linux Device Mapper <dm-devel@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Alasdair Kergon <agk@redhat.com>,
 Linux Regressions <regressions@lists.linux.dev>
Content-Type: multipart/mixed; boundary="===============5521025675137748195=="
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4


--===============5521025675137748195==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Jb5IqaSpz/f9tNpy"
Content-Disposition: inline


--Jb5IqaSpz/f9tNpy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 05, 2023 at 08:15:43PM +0300, Tatu Heikkil=C3=A4 wrote:
> Hello,
> I think you and the lists are right recipients, forgive me if not, I've
> never reported kernel bugs before. Naively this seems a crypto issue and
> Herbert Xu from crypto maintainers made the buggy commit, but it edits
> drivers/md/dm_crypt.c maintained by dm-devel people per MAINTAINERS, so I=
'm
> going by that.
>=20
> At the center of the issue is my Imac8,1 and an external 2TB SSD with 5
> partitions: an EFI+MBR portable Arch Linux install with LUKS encrypted ex=
t4
> /home, and a 1.7TB exFAT encrypted with Bitlocker.
>=20
> Mounting the LUKS partition works fine on all my 4 computers (Imac8,1,
> Imac12,2, two generic Intels; Fedora's GNOME gvfs volume monitor often
> crashes on mount using this drive), and mounting the Bitlocker partition
> works on all other computers, but my Imac8,1. On my other computers, I can
> boot into the portable install which automounts the Bitlocker partition
> fine. However, on my Imac8,1, regardless if I boot into the external driv=
e's
> portable Arch Linux install, or use the Imac's own internal Debian testing
> install, any post-6.4 kernel reliably panics (50+ times so far, 100% of t=
he
> time) when accessing the unlocked Bitlocker volume:
>=20
> # cryptsetup open /dev/sdb5 --type bitlk crucial
> Enter passphrase for /dev/sdb5:
> # mount /dev/mapper/crucial temp [kernel immediately panics if I try to
> tab-complete the mount point, making the shell also access the decrypted
> device I assume, or try to run the command]
>=20
> I originally ran into this when mounting using XFCE's Thunar implementati=
on.
> Using it, the mount fails with "Operation was cancelled" and the system
> crashes within a minute.
>=20
> Git bisect lead me to:
> # first bad commit: [e3023094dffb41540330fb0c74cd3a019cd525c2] dm crypt:
> Avoid using MAX_CIPHER_BLOCKSIZE
>=20
> If I git revert e3023094dffb41540330fb0c74cd3a019cd525c2 on current Linus'
> git master, the issue goes away. So I'm personally not all that affected
> anymore (if I'm ready to compile my kernels from now on), and I understand
> that you have no clear way to reproduce this as it seems strongly bound to
> hardware, but seems like this could point to a potentially serious securi=
ty
> issue since it involves both crypto and undefined behaviour.
>=20
> Kdump dmesg logs (the error output is not completely consistent between
> panics) & .config can be found in a dummy Bugzilla report
> https://bugzilla.kernel.org/show_bug.cgi?id=3D217982
>=20
> Please let me know if I can help you in any way. I don't mind using this =
as
> a gateway to learn more about kernel debugging etc.
>=20

Thanks for the regression report. I'm adding it to regzbot:

#regzbot ^introduced: e3023094dffb41
#regzbot title: kernel panic when accessing opened bitlocker partition due =
to avoiding MAX_CIPHER_BLOCKSIZE
#regzbot link: https://bugzilla.kernel.org/show_bug.cgi?id=3D217982

--=20
An old man doll... just what I always wanted! - Clara

--Jb5IqaSpz/f9tNpy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZR9dDAAKCRD2uYlJVVFO
oz5dAQCMP/K95ZXJESKmwYJsaJzV2PzQpaGweREO01xriKlshQD9FfLS/rj+AhM0
sYS2+qls+vEXoyzp5laVX3fWeL1l1Ao=
=7sAU
-----END PGP SIGNATURE-----

--Jb5IqaSpz/f9tNpy--


--===============5521025675137748195==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============5521025675137748195==--

