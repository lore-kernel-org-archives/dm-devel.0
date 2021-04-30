Return-Path: <SRS0=u0Zu=J6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7D34C433B4
	for <dm-devel@archiver.kernel.org>; Mon,  3 May 2021 11:13:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 079B861278
	for <dm-devel@archiver.kernel.org>; Mon,  3 May 2021 11:13:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 079B861278
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=vermwa.re
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-492-1BeJiOEUONyNuWkCh_n94A-1; Mon, 03 May 2021 07:13:15 -0400
X-MC-Unique: 1BeJiOEUONyNuWkCh_n94A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD489100A91C;
	Mon,  3 May 2021 11:13:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4BC0560C0F;
	Mon,  3 May 2021 11:13:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DF0661800BBE;
	Mon,  3 May 2021 11:13:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13UJeKD8022047 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 30 Apr 2021 15:40:20 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 27A27117C2CD; Fri, 30 Apr 2021 19:40:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 23310117C2CC
	for <dm-devel@redhat.com>; Fri, 30 Apr 2021 19:40:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D287805A30
	for <dm-devel@redhat.com>; Fri, 30 Apr 2021 19:40:20 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
	d=dkim.mimecast.com; s=201903; t=1619811619;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	in-reply-to:in-reply-to:references:references;
	bh=Zs5nSvghcREy/2CkTm4/4HcN/B0nvGxcfgiqcUYGOrc=;
	b=f4CiczrM15g0TImIux5cQ13y+9XlHau5BryGMSrhopmq5JkZUmQMbWy1483A+5SEfrKdh5
	CgUwtkVJl/uYEFVPNTg1wUOleULg76efGfKyO9XWXfF2/phXEJ0KW4sMDBzBw9WKC/VHN9
	GYE/cYBzdCm24pbpuZ5MxvmKQ3n1vvGNjdhVkPQq02DO8FIbq5vgiWHL2/nwlqh517za2P
	Lrvrr9D9Rs3BhSFJTwk7HSRrb9DHFhMVbgXyUPEa3f6MksXNtwSczkJ72O11M2J0tYo/hG
	g+UekNNJWiR4wGm/IHrWcbjkNH5/K4+yjYyNxOklDPshAISTMzt3i6C77ZJemg==
ARC-Seal: i=1; s=201903; d=dkim.mimecast.com; t=1619811619; a=rsa-sha256;
	cv=none;
	b=qagAENzGR62kImsYdwU2/5q/p+/6F/XgrLd9gUTmqkBNitb/TRz8XA5fw2+qbIiUJEoq06
	hwqkrWg3TgbAlL6lcfRYWMLk1Z8bK1uil37dhUBH1ZI6dUktXo0GG3gda74/ameClQ8GqW
	7G1o+aR445vRXnKJLS4VCXfndrUQh7zuxmiJSBnYRqzzUKKJJwvaKh221UKDgwLdwLKB22
	Qh76+ta/Mi6GNC1LFWN5c0GcqlfXzBfiEZ8WJ6Og0pk6l6LXB5xC0n+RuIAGNkpqPQkze7
	TzrSdQr+I9Kf96Wm0t/op2nXFG91EqOS4e0lfdonexU8gau5GZnt67d/8fGGzw==
ARC-Authentication-Results: i=1; relay.mimecast.com; dkim=none; dmarc=none;
	spf=pass (relay.mimecast.com: domain of vermeeren@vermwa.re designates
	5.255.86.113 as permitted sender)
	smtp.mailfrom=vermeeren@vermwa.re
Received: from victorique.vermwa.re (victorique.vermwa.re [5.255.86.113])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-346-1lNGjWZ2Npm133WsbahxYg-1; Fri, 30 Apr 2021 15:40:16 -0400
X-MC-Unique: 1lNGjWZ2Npm133WsbahxYg-1
Received: from victorique.vermwa.re (localhost [127.0.0.1])
	by victorique.vermwa.re (Postfix) with ESMTP id 7BE2AA0D0E;
	Fri, 30 Apr 2021 21:40:10 +0200 (CEST)
Received: from verm-r4e.localnet ([fd17:3171:f888:364d::1000])
	by victorique.vermwa.re with ESMTPSA id 4VDLHRpdjGCbCAAAjH0QZw
	(envelope-from <vermeeren@vermwa.re>); Fri, 30 Apr 2021 21:40:10 +0200
From: Melvin Vermeeren <vermeeren@vermwa.re>
To: Mikulas Patocka <mpatocka@redhat.com>
Date: Fri, 30 Apr 2021 21:23:48 +0200
Message-ID: <2551336.spOdxr4IAQ@verm-r4e>
Organization: vermware
In-Reply-To: <alpine.LRH.2.02.2104261124360.24039@file01.intranet.prod.int.rdu2.redhat.com>
References: <4219669.2KqOsUsilv@verm-r4e>
	<alpine.LRH.2.02.2104261124360.24039@file01.intranet.prod.int.rdu2.redhat.com>
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
Content-Type: multipart/mixed; boundary="===============5577638266579895696=="
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12

--===============5577638266579895696==
Content-Type: multipart/signed; boundary="nextPart21040965.293KVUxhqv";
	micalg="pgp-sha512"; protocol="application/pgp-signature"

--nextPart21040965.293KVUxhqv
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Melvin Vermeeren <vermeeren@vermwa.re>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-devel] Integrity discard/trim extremely slow on NVMe SSD
	storage (~10GiB/minute)
Date: Fri, 30 Apr 2021 21:23:48 +0200
Message-ID: <2551336.spOdxr4IAQ@verm-r4e>
Organization: vermware
In-Reply-To: <alpine.LRH.2.02.2104261124360.24039@file01.intranet.prod.int.rdu2.redhat.com>
References: <4219669.2KqOsUsilv@verm-r4e>
	<alpine.LRH.2.02.2104261124360.24039@file01.intranet.prod.int.rdu2.redhat.com>

Hi Mikulas,

Got around to checking the patches today, apologies for the delay.

On Monday, 26 April 2021 17:33:32 CEST Mikulas Patocka wrote:
> I tried it on my nvme device (Samsung SSD 960 EVO 500GB) and I could
> discard 32GB in 5 seconds.
> 
> I assume that it is specific to the nvme device you are using. The device
> is perhaps slow due to a mix of dicard+read+write requests that
> dm-integrity generates.

This makes sense to me as well.

> Could you try it on other nvme disks?

I cannot myself personally, but I asked a friend with Crucial P5 NVMe SSD to 
test and there the discards passed through dm-integrity are also well 
performing, so it seems specific so Seagate FireCuda 520.

I contacted Seagate about this problem with some refs and reproduction steps, 
hopefully they will resolve this in a firmware update or I will have to return 
the drives eventually. (The worst part is all I/O blocks hard while handling 
integrity discards, causing really system freeze like experience.)

Thanks,

-- 
Melvin Vermeeren
Systems engineer
--nextPart21040965.293KVUxhqv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiu1YAh/qzdXye6Dmpy9idxbqnZYFAmCMWUQACgkQpy9idxbq
nZYOIg//bSu2iTZPHw2r8ZqOTQeqXpmnM0dkmXXH4mXbyixx9hdVqhvIV+XiXBuo
jOdvbsekYL//XRdLAIuDxl643HEiHYdoj63zvPet1C+VfsBJOU6TJbcuCsX61sUg
ohEfrrthhlA7C5vePGvnWyiwcp+oRylPOBjv0C68ke7OkoiVTXq1Lq7kcktSNp2w
8nyr1xBZXuYM8N03vBHG0gIdyoS5jYY14W593gCOgDJu9PjXyXeKXaDdakYI1FoO
+t1I1QK4JqzIpQ+aAuAbSkW2w5Sj7LI7AQSi8xjMnRJeMcabivQTO9mvtfgNPTMa
CHHnMdAF3OX+TCxYdi26nBS7qlZj5lagsI91jxT/uot7Lv02DXD912v48eOjMPig
1JMyasGubZgkfmPAsA6LZDFzVN7CTcCZZJMbt1hcqJ1ptvpDQEiiXSnUTrueLtTq
xJU1sMyZOfT8HLYmHit0mtI3VkruCJBvOtOaalC+kqCL3XN2ImcFrFq6AG8zaPwy
tJh82KEGY3K0xBB//arix7U3sb3z5tyjSzGCsAINCLYVw6Z20Z/DJniy8U8Ssrd8
JnGZn3i//2j2UU1m88QsiF9al+Azsep+OU22eqmnJW4Dlm+k00KwUXJFKn5CQRVo
HuSabNSrm5dyP8jm/BSz6aKhy1CSlYpX/uPol9TlJbnXuoVdx48=
=X0KS
-----END PGP SIGNATURE-----

--nextPart21040965.293KVUxhqv--




--===============5577638266579895696==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============5577638266579895696==--



