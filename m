Return-Path: <SRS0=u0Zu=J6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCA93C43460
	for <dm-devel@archiver.kernel.org>; Mon,  3 May 2021 11:13:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C827561249
	for <dm-devel@archiver.kernel.org>; Mon,  3 May 2021 11:13:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C827561249
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=vermwa.re
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-9Jxw8fiIM1GaW2-NMLNZUg-1; Mon, 03 May 2021 07:13:15 -0400
X-MC-Unique: 9Jxw8fiIM1GaW2-NMLNZUg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1E79801B38;
	Mon,  3 May 2021 11:13:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C1F732B168;
	Mon,  3 May 2021 11:13:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 413821800BC1;
	Mon,  3 May 2021 11:13:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13UJeJD0022036 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 30 Apr 2021 15:40:19 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 02E87117C2CD; Fri, 30 Apr 2021 19:40:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F29F8117C2D0
	for <dm-devel@redhat.com>; Fri, 30 Apr 2021 19:40:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A18C980D180
	for <dm-devel@redhat.com>; Fri, 30 Apr 2021 19:40:16 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
	d=dkim.mimecast.com; s=201903; t=1619811616;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	in-reply-to:in-reply-to:references:references;
	bh=EGgQul0fcJWJF4wJdeEYpDz0krBUebzfydoNWzZ5fhw=;
	b=rrUI3ti/VPxcZddE9QI2hBENHpBd0Llpe+uMiJY+feDYLbcYkzJC4qmgVnxjD/p898jV1q
	FhovFpCvZNTe8JjqY/lTdEFeg+S1lQ2kcrEHEvPcpue2MGmQuouC8qlWCdP+SaRKkRHbHa
	MFPZQgoW2OfHH1ZImk2SndmsOfYSJHJXT3XwCiP1hMVgGxZWzfzgxROle6vzD9oFJ1CEoq
	9ANh/WcjfRw6JJTpcKNS3AQ+opKlWjJWGs1IzO9BvjsBAVHEtZhYY9pCzEkwLUZiA/9cqj
	WeihsG2VGjA1lYJ/M7USIZPFNUth5Tcwvwcwv4+5tcxE+nDZ8DXRfC0JiXF4kA==
ARC-Seal: i=1; s=201903; d=dkim.mimecast.com; t=1619811616; a=rsa-sha256;
	cv=none;
	b=dzpfsj2kyuUV8Z+pG1R8HPDqiGTWMH4H8YmvooZiOBpix6+/x66vKyQT1tbD0oczO3IcOP
	0vwftVnR1Fr8Qyey3Zww757APWTxBPcSF0TNqjhb/dv6vQ0iQSsUIH8XxTu50IKD9YoUi2
	k1D2vzdY50zAUPnUp4mtkPjTec56wFX1jv3XUq95twhmMiOCir/DDcm+jF+3J6kbalLzD4
	OAHS81DUtjHhnwStyp1lEjucJcI0gUUN9IGVlwK7Ej6Nm4D64nyQAXJzzTdGTGXUAcJqFr
	vktAMZVvV5SMRh0+mMgyFpbow9TIPIbGlOmaAyB3+DMTEhB1egiKyfpzFjQv3Q==
ARC-Authentication-Results: i=1; relay.mimecast.com; dkim=none; dmarc=none;
	spf=pass (relay.mimecast.com: domain of vermeeren@vermwa.re designates
	5.255.86.113 as permitted sender)
	smtp.mailfrom=vermeeren@vermwa.re
Received: from victorique.vermwa.re (victorique.vermwa.re [5.255.86.113])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-599-wRgGmp6SOOuzegNs1jTd2Q-1; Fri, 30 Apr 2021 15:40:12 -0400
X-MC-Unique: wRgGmp6SOOuzegNs1jTd2Q-1
Received: from victorique.vermwa.re (localhost [127.0.0.1])
	by victorique.vermwa.re (Postfix) with ESMTP id 31C84A02E9;
	Fri, 30 Apr 2021 21:40:10 +0200 (CEST)
Received: from verm-r4e.localnet ([fd17:3171:f888:364d::1000])
	by victorique.vermwa.re with ESMTPSA id ItuMCxpdjGCYCAAAjH0QZw
	(envelope-from <vermeeren@vermwa.re>); Fri, 30 Apr 2021 21:40:10 +0200
From: Melvin Vermeeren <vermeeren@vermwa.re>
To: Mikulas Patocka <mpatocka@redhat.com>
Date: Fri, 30 Apr 2021 21:26:23 +0200
Message-ID: <4782666.JkfDSx4nLX@verm-r4e>
Organization: vermware
In-Reply-To: <alpine.LRH.2.02.2104261200140.27678@file01.intranet.prod.int.rdu2.redhat.com>
References: <4219669.2KqOsUsilv@verm-r4e>
	<alpine.LRH.2.02.2104261124360.24039@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.2104261200140.27678@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com; dkim=none; dmarc=none;
	spf=pass (relay.mimecast.com: domain of vermeeren@vermwa.re designates
	5.255.86.113 as permitted sender)
	smtp.mailfrom=vermeeren@vermwa.re
X-Mimecast-Spam-Score: -5
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 03 May 2021 07:13:02 -0400
Cc: dm-devel@redhat.com, Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-devel] Integrity discard/trim extremely slow on NVMe SSD
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
Content-Type: multipart/mixed; boundary="===============6276611893689228261=="
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11

--===============6276611893689228261==
Content-Type: multipart/signed; boundary="nextPart2481238.kdupNq9QNG";
	micalg="pgp-sha512"; protocol="application/pgp-signature"

--nextPart2481238.kdupNq9QNG
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Melvin Vermeeren <vermeeren@vermwa.re>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-devel] Integrity discard/trim extremely slow on NVMe SSD
	storage (~10GiB/minute)
Date: Fri, 30 Apr 2021 21:26:23 +0200
Message-ID: <4782666.JkfDSx4nLX@verm-r4e>
Organization: vermware
In-Reply-To: <alpine.LRH.2.02.2104261200140.27678@file01.intranet.prod.int.rdu2.redhat.com>
References: <4219669.2KqOsUsilv@verm-r4e>
	<alpine.LRH.2.02.2104261124360.24039@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.2104261200140.27678@file01.intranet.prod.int.rdu2.redhat.com>

Hi Mikulas,

On Monday, 26 April 2021 18:02:12 CEST Mikulas Patocka wrote:
> Try this patch - it will avoid writing discard filler to metadata if it is
> already there. It won't help on the first discard, but it may help when
> discarding already discarded blocks.

I applied the patch and verified the patched kernel module is being used. 
Unfortunately there is no real difference while discarding. Presumably the 
drive is choking on the read requests alone? (As mentioned in other mail I 
contacted Seagate about this, it should be fixed in drive firmware.)

Still, the patch itself seems good and does avoid unnecessary writes, so it 
seems like a good thing to be merged in my opinion.

Thanks,

-- 
Melvin Vermeeren
Systems engineer
--nextPart2481238.kdupNq9QNG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiu1YAh/qzdXye6Dmpy9idxbqnZYFAmCMWd8ACgkQpy9idxbq
nZZbeg/9H5YHLKiU2rmBKRWhaibF4kekn7kq5WNx8Bm5xe9dCOWCt6G00Zc+YGfQ
5y6SzlCSPfs/qC/dmrVSjKVCBk+4lMOMLvvKnUpbQ0AR1urkZZyfpiTAg4rK+7EA
yzux7krW/evBtX6dWr8C5/Mv5FYS/HFHuwGKmYOeDiXtC0efI8JJo8YrXDlHH5Cr
49C0CnElwPjfOEHfnLAX/CfotZO7A6bMNa8OBDm5ttSwiU51eht1NRxvHuHrbGQ6
WzfooOtbVL+JRqjEGUYPoJpKMwWAbd+xkzhla7E/D6eBpopVhdZbBC9FdbNLMsH9
TW5UT6eVlVx4o8EMc9WV7LoBV2KEK+Qvy00A2riOjebyY0uav0V+/Pbh1vFax6PZ
wiFrFMjzsp9aBeKev5teDu8cAGw4XSprRopRfowTVL6LKHidvsc/3LWWgrpeQ+Je
aBnEuzyROSXiU4rNMwR1fn6P5qeXOR1bkyDY2nV3mzOOkR1qN1agedX2vS0WffDF
PMRw/LNcNDK1AsmCgdlYUDq/juGMjOStw7e7blgW1rnwS6biwWYUwB0/snIlaymY
aMxIv91WnDc1pUU01tF3Pbeg47ONlDAeokqeXYxLRZbNn2gGu6PgOoUedyruJ/E7
3mH6Xfjc55JU9deQT8nivnG++Ra8atwb7B6N/mF0Gvsfe12m/as=
=pLC3
-----END PGP SIGNATURE-----

--nextPart2481238.kdupNq9QNG--




--===============6276611893689228261==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============6276611893689228261==--



