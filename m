Return-Path: <SRS0=qgW3=JQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70684C433B4
	for <dm-devel@archiver.kernel.org>; Mon, 19 Apr 2021 19:49:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0134361354
	for <dm-devel@archiver.kernel.org>; Mon, 19 Apr 2021 19:49:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0134361354
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=vermwa.re
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-bmyMBTUQMmWGapGC-NPbCA-1; Mon, 19 Apr 2021 15:49:28 -0400
X-MC-Unique: bmyMBTUQMmWGapGC-NPbCA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 01D7581425A;
	Mon, 19 Apr 2021 19:49:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ED3955B4B5;
	Mon, 19 Apr 2021 19:49:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 27B5F1806D17;
	Mon, 19 Apr 2021 19:49:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13JIcOw0029876 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 19 Apr 2021 14:38:24 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4CFB1637A2; Mon, 19 Apr 2021 18:38:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 469F953A0
	for <dm-devel@redhat.com>; Mon, 19 Apr 2021 18:38:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 949798028BE
	for <dm-devel@redhat.com>; Mon, 19 Apr 2021 18:38:18 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
	d=dkim.mimecast.com; s=201903; t=1618857497;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=WpW75MhsYSR17fTSAZLBWEmtn+gxGoDFbp1f+vwVlQU=;
	b=h6oaeOgtWhjeUU9XuhvG9ap7btqtOGKtfzvf59BiZUQuBT/uJG32jZGt2J4tQLDW0HTPot
	gAlwKqCI22D4SNCWHmkS9MlXwQ9T/iXGC7/fsjm0x+F3O/ZkFSf954SMWPx2ykLNFrteZ7
	VKa5n1jEKqx7v5jBCsYqPWZmRBWcDvgccMsePP51X2KyVn38pIkmWkdesKli2BsGMfM4QJ
	wKTK4s56M5pSauS+wRyKmM6mYG2Rj8b1fiPeNvpZq7dc3tYq+TolQVpzwLJl9xdvY4Yk0C
	tYSxhASggNhDbsTYnxV3jtv+I81K6wlIRcFtjSzx0MnOHAyDz7mwSrI02aoBgw==
ARC-Seal: i=1; s=201903; d=dkim.mimecast.com; t=1618857497; a=rsa-sha256;
	cv=none;
	b=UKaofSC57firckWu5phevT4ch0zC6h2dwN7QR/koIJsPF7hTVXGgmVmpWjulBQsmt8RzZK
	Zx+p4WHGAr/7sg8+rYFgtD2fbKnpb4lMpxtup92JxjI6UmiLg2DFRefg3TjmK+1tYd/Xgh
	C1VvWaCPbL8MPeRPmxUG3uCnfpvU1+XJC1hYXO7mqAF1eON8w8xgNXU+jJnzmufdYi0MXK
	Opb2wQSHAXiffkYB8GEIZGINvOYGnRrB4SyM8UaqzLBFBjix8HxuWZrzF7rCaI0dQ28dMJ
	JincJcU5Ux6+RQHPd+GlYzYz623WUjo/Z1BXJbs3RtSximVjtScAUsGZTf8+tw==
ARC-Authentication-Results: i=1; relay.mimecast.com; dkim=none; dmarc=none;
	spf=pass (relay.mimecast.com: domain of vermeeren@vermwa.re designates
	5.255.86.113 as permitted sender)
	smtp.mailfrom=vermeeren@vermwa.re
Received: from victorique.vermwa.re (victorique.vermwa.re [5.255.86.113])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-536-xA58Pp19OsmI-6Ufmzwo7Q-1; Mon, 19 Apr 2021 14:38:14 -0400
X-MC-Unique: xA58Pp19OsmI-6Ufmzwo7Q-1
Received: from victorique.vermwa.re (localhost [127.0.0.1])
	by victorique.vermwa.re (Postfix) with ESMTP id 4D2AEA02D3
	for <dm-devel@redhat.com>; Mon, 19 Apr 2021 20:29:22 +0200 (CEST)
Received: from verm-r4e.localnet ([fd17:3171:f888:364d::1000])
	by victorique.vermwa.re with ESMTPSA id dU8DEgLMfWDaBAAAjH0QZw
	(envelope-from <vermeeren@vermwa.re>)
	for <dm-devel@redhat.com>; Mon, 19 Apr 2021 20:29:22 +0200
From: Melvin Vermeeren <vermeeren@vermwa.re>
To: dm-devel@redhat.com
Date: Mon, 19 Apr 2021 20:29:17 +0200
Message-ID: <4219669.2KqOsUsilv@verm-r4e>
Organization: vermware
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com; dkim=none; dmarc=none;
	spf=pass (relay.mimecast.com: domain of vermeeren@vermwa.re designates
	5.255.86.113 as permitted sender)
	smtp.mailfrom=vermeeren@vermwa.re
X-Mimecast-Spam-Score: -1
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 19 Apr 2021 15:49:17 -0400
Subject: [dm-devel] Integrity discard/trim extremely slow on NVMe SSD
	storage (~10GiB/minute)
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
Content-Type: multipart/mixed; boundary="===============4182435658866240561=="
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11

--===============4182435658866240561==
Content-Type: multipart/signed; boundary="nextPart2363745.zeDGEfpfzb";
	micalg="pgp-sha512"; protocol="application/pgp-signature"

--nextPart2363745.zeDGEfpfzb
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Melvin Vermeeren <vermeeren@vermwa.re>
To: dm-devel@redhat.com
Subject: Integrity discard/trim extremely slow on NVMe SSD storage
	(~10GiB/minute)
Date: Mon, 19 Apr 2021 20:29:17 +0200
Message-ID: <4219669.2KqOsUsilv@verm-r4e>
Organization: vermware

Note: This was originally posted on cryptsetup GitLab.
Note: Reposting here for better visibility as it appears to be a kernel bug.
Ref: https://gitlab.com/cryptsetup/cryptsetup/-/issues/639

Issue description
-----------------

With a Seagate FireCuda 520 2TB NVMe SSD running in PCIe 3.0 x4 mode (my 
motherboard does not have PCIe 4.0), discards through `dm-integrity` layer are 
extremely slow to the point of being almost unusable or in some cases fully 
unusable.

This is so slow that having the `discard` option on swap in not possible, as 
it takes around 3 minutes to complete for 32GiB swap causing timeouts during 
boot which in turn causes various other services to fail resulting in a drop 
to the emergency shell.

`blkdiscard` directly to NVMe device takes I think 10 sec or so for the entire 
2TB, but through `dm-integrity` the rate is approx 10GiB per minute, meaning 
over 3 hours to discard the entire 2TB. Normal read and write operations are 
not affected and are high performance, easily reaching 2GiB/s through the 
entire layer: `disk dm-integrity mdadm luks lvm ext4`.

Checking the kernel thread usage in htop quite some `dm-integrity-offload` 
threads are in the `D` state with `0.0` CPU usage when discarding, which is 
rather odd. No integrity threads are actually working and read-write disk 
usage measured with `dstat` is not even 1MiB/s.

To detail the above, `dstat` shows extremely clear timings: 2 seconds 0k 
write, 1 second 512k write, repeat. Possible timeout in locks somewhere or 
other problematic lock situation?

Steps for reproducing the issue
-------------------------------

1. Create two 10G partitions on SSD.
2. Setup `dm-integrity` on one of these and open the device with `--allow-
discards`.
3. `blkdiscard` both partitions.
	* Raw partition is done instantly.
	* Integrity partition takes around a minute.

Additional info
---------------

The NVMe device is formatted to native 4096 byte sectors and the `dm-
integrity` layer also uses 4096 byte sectors.

Debian bullseye (testing), kernel 5.10.0-6-rt-amd64 5.10.28-1. Same issue 
occurred during testing with Arch Linux liveiso which is kernel 5.11.x. 
Cryptsetup package version 2.3.5.

On another server system (IBM POWER9, ppc64le) with SAS 3.0 SSD discard is 
working properly at more than acceptable speeds, showing significant CPU usage 
while discarding. In this case it is a regular Intel amd64 desktop system.

Debug log
---------

Nothing really fails, dmesg and syslog show no issues/warnings at all, not 
sure what to include.

Only appears to effect NVMe
---------------------------

Further tests on the same machine show that SATA SSD is not affected by this 
issue and discards at high performance. Appears to be NVMe-specific bug:
Ref: https://gitlab.com/cryptsetup/cryptsetup/-/issues/639#note_555208783

If there is anything I can do to help feel free to let me know.
Note that I am not subscribed to dm-level, please CC me directly.

Thanks,

-- 
Melvin Vermeeren
Systems engineer
--nextPart2363745.zeDGEfpfzb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiu1YAh/qzdXye6Dmpy9idxbqnZYFAmB9y/0ACgkQpy9idxbq
nZaJ3g//R86K5YUQQOhs1h/K+n+lnvykWjdlqEfpHxLgDrqLkU9Y7Hgoo/gRrPPm
8pCFyz3hqbci9WbUK6POLGSS8bDbu7CHAB/XD8VGaDXJ6OZzEZI2+7HCmolhPCcx
OkM0dZNjxgaLUxVZnnBXJ7DRCho09iy21/ZlB3laclDJVTbcz+mnz5ubdookADRn
YLdt4m9SOIZw4eHl0YFkvwfi24k37cNnn9tdShU6re8UsMDcSaUhUh+9J26ntxsK
bCYh/D4SYdNQj7o5E+w+XtCpmMH5bbeKCe8lyTKr8RuY2Ba29Yp5WBXpZf9HdyEU
8JhXP7Vs8IGBlkoPyDqIaXVTji/NwAPgXhSSyP13lBQGlSv6AaFqvVTsD+NLyIyM
3sQ9gJpEie1C0tGpDfi3lw+WfOKADOByCGiPVMXC/NkLOUZM+kCWN+wIfdMq1FzC
fWRLMHF4mY2DYkcg21BGYuLR0kXaods+MKTXDeIJJMrjTHI+nTQnNrBGvORdLJw+
DWbLBXocpZy87sJdVsta8DESt0RReWpeg3DGk2qonCipcK6yrHSXBql4gdgXw+S/
/YNCSCZAfh+aAQ1Q7pAQBA5ReX42vDEyJksZaZhhfhNkZkNftyQ2oVxyD/zc6fIg
4B/nTpSNr3Uz5hhuUaGU+rU3lxJt6Sj+KNwl+kyWE/DSl6d5LYE=
=8B5g
-----END PGP SIGNATURE-----

--nextPart2363745.zeDGEfpfzb--




--===============4182435658866240561==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============4182435658866240561==--



