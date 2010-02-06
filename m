From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [Fwd: [PATCH] Latest git -master is not compilable]
Date: Sat, 06 Feb 2010 10:01:58 +0100
Message-ID: <1265446918.4273.3.camel@zezette>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-X6kPA2JZTNyYEdtoTCmt"
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: alex.zeffertt@eu.citrix.com
Cc: rumcic@gmail.com, dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids


--=-X6kPA2JZTNyYEdtoTCmt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Can you confirm the fix from Rumko does not break your ulibc setup ?

-- 
cvaroqui,
http://www.opensvc.com

--=-X6kPA2JZTNyYEdtoTCmt
Content-Disposition: inline
Content-Description: Forwarded message - [PATCH] Latest git -master is not
	compilable
Content-Type: message/rfc822

Return-Path: rumcic@gmail.com
Received: from zimbra16-e3.priv.proxad.net (LHLO
	zimbra16-e3.priv.proxad.net) (172.20.243.166) by
	zimbra16-e3.priv.proxad.net with LMTP;
	Fri, 5 Feb 2010 21:02:37 +0100 (CET)
Received: from relay1-v.mail.gandi.net (mx28-g26.priv.proxad.net
	[172.20.243.98]) by zimbra16-e3.priv.proxad.net (Postfix) with ESMTP id
	3C5EC2DA0F for <christophe.varoqui@free.fr>; Fri,  5 Feb 2010 21:02:37
	+0100 (CET)
Received: from relay1-v.mail.gandi.net ([217.70.178.75]) by mx1-g20.free.fr
	(MXproxy) for christophe.varoqui@free.fr ;
	Fri,  5 Feb 2010 21:02:32 +0100 (CET)
X-ProXaD-SC: state=HAM score=0
Received: from spool.mail.gandi.net (mspool1-v.mgt.gandi.net [10.0.21.71])
	by relay1-v.mail.gandi.net (Postfix) with ESMTP id 3F8C2362B5 for
	<christophe.varoqui@free.fr>; Fri,  5 Feb 2010 21:02:32 +0100 (CET)
Received: from mfilter5-d.gandi.net (mfilter5-d.gandi.net [217.70.178.39])
	by spool.mail.gandi.net (Postfix) with ESMTP id 2EA886A80B5 for
	<christophe.varoqui@free.fr>; Fri,  5 Feb 2010 21:02:32 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at mfilter5-d.gandi.net
Received: from spool.mail.gandi.net ([10.0.21.71]) by mfilter5-d.gandi.net
	(mfilter5-d.gandi.net [217.70.178.39]) (amavisd-new,
	port 10024) with ESMTP
	id Ik01MRQO6weJ for <christophe.varoqui@free.fr>;
	Fri,  5 Feb 2010 21:02:31 +0100 (CET)
Received: from mail-fx0-f216.google.com (mail-fx0-f216.google.com
	[209.85.220.216]) by spool.mail.gandi.net (Postfix) with ESMTP id
	C1EAD6A80B9 for <christophe.varoqui@opensvc.com>;
	Fri,  5 Feb 2010 21:02:28 +0100 (CET)
Received: by fxm8 with SMTP id 8so2824682fxm.6 for
	<christophe.varoqui@opensvc.com>; Fri, 05 Feb 2010 12:02:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=gamma;
	h=domainkey-signature:received:received:from:to:subject:date
	:user-agent:mime-version:content-type:content-transfer-encoding
	:message-id; bh=y4RA7FLVINH1hXmCpM8nUq84T2Z1Sc2Tr6avbSrxlZc=;
	b=UNkj30zUWn8vqJN+DDUwo2yEB3UhyobpvTx/1Cfwk1EikuC0Nz6TuAMLV+ALWr4q7C
	4SVG8xn9/12Z2G6ewWPQIA+9veIYG/nmuls+Yxwf9G5E/81NKqXDMEdvZQXQp07ugtj+
	0ixTPuVy+wPbHwMOtaZNWci4kYMxg8u0OSQu8=
DomainKey-Signature: a=rsa-sha1; c=nofws; d=gmail.com; s=gamma;
	h=from:to:subject:date:user-agent:mime-version:content-type
	:content-transfer-encoding:message-id;
	b=NhzKhnVtLYPXf51QrRJrKoqYfXcT6WofFBwKBSHX2YT2K+MSnIEFlYOYTPxsIeCfc7
	aCDkgAubiRt6SPI7vUH3b2x3BIO7n6+n2+Uxo0IpHokDuLqPyhsv4xSGlAr/4sYyO9Ky
	v68wi8AgJFNpu1QzaM9XMFdeLRPA/eGPV6zB0=
Received: by 10.223.94.211 with SMTP id a19mr3587635fan.59.1265400148528;
	Fri, 05 Feb 2010 12:02:28 -0800 (PST)
Received: from ?192.168.0.2? (84-255-193-183.static.t-2.net
	[84.255.193.183]) by mx.google.com with ESMTPS id
	28sm2853242fkx.28.2010.02.05.12.02.27 (version=SSLv3 cipher=RC4-MD5);
	Fri, 05 Feb 2010 12:02:27 -0800 (PST)
From: Rumko <rumcic@gmail.com>
To: christophe.varoqui@opensvc.com
Subject: [PATCH] Latest git -master is not compilable
Date: Fri, 5 Feb 2010 21:02:23 +0100
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1681857.SM6GsaD6WG";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201002052102.27089.rumcic@gmail.com>

--nextPart1681857.SM6GsaD6WG
Content-Type: multipart/mixed;
  boundary="Boundary-01=_PlHbLmcCyk7NmgQ"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_PlHbLmcCyk7NmgQ
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi!

In latest git -master on line 1443 of multipathd/main.c lock() is called on=
=20
exit_mutex, but since exit_mutex is a pthread_mutex_t, pthread_mutex_lock()=
=20
is needed.

Attached is the one-liner patch, tested it on a gentoo machine and seems to=
 be=20
working.
=2D-=20
Regards,
Rumko

--Boundary-01=_PlHbLmcCyk7NmgQ
Content-Type: text/x-diff; charset="iso 8859-15";
	name="0001-Use-pthread_mutex_lock-instead-of-lock-since-we-are-.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-Use-pthread_mutex_lock-instead-of-lock-since-we-are-.patch"

=46rom a6bf54d588c2d0c9d3a97541bcb7b605fd1f3ae0 Mon Sep 17 00:00:00 2001
=46rom: Rumko <rumcic@gmail.com>
Date: Fri, 5 Feb 2010 20:59:21 +0100
Subject: [PATCH] Use pthread_mutex_lock() instead of lock() since we are de=
aling with a
 mutex directly.

=2D--
 multipathd/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index e7955bd..3f7eb49 100644
=2D-- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1440,7 +1440,7 @@ child (void * param)
 	pthread_create(&uxlsnr_thr, &misc_attr, uxlsnrloop, vecs);
 	pthread_attr_destroy(&misc_attr);
=20
=2D	lock(&exit_mutex);
+	pthread_mutex_lock(&exit_mutex);
 	pthread_cond_wait(&exit_cond, &exit_mutex);
=20
 	/*
=2D-=20
1.6.6


--Boundary-01=_PlHbLmcCyk7NmgQ--

--nextPart1681857.SM6GsaD6WG
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (DragonFly)

iEYEABECAAYFAktseVMACgkQxV3ce2RZW73+9QCgmV+wJWK/xxHFz55tTbjrI6Wz
8NYAnjKiuKilgTGt1/er3rNexxdtuTCZ
=IWHq
-----END PGP SIGNATURE-----

--nextPart1681857.SM6GsaD6WG--

--=-X6kPA2JZTNyYEdtoTCmt
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=-X6kPA2JZTNyYEdtoTCmt--
