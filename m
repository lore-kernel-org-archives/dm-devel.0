Return-Path: <SRS0=u0Zu=J6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9513C433ED
	for <dm-devel@archiver.kernel.org>; Mon,  3 May 2021 11:13:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9F4F6611CB
	for <dm-devel@archiver.kernel.org>; Mon,  3 May 2021 11:13:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F4F6611CB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=vermwa.re
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-VJW__LlUM5GXK71JqAIkLA-1; Mon, 03 May 2021 07:13:18 -0400
X-MC-Unique: VJW__LlUM5GXK71JqAIkLA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C9CB1107B46F;
	Mon,  3 May 2021 11:13:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 979E95D703;
	Mon,  3 May 2021 11:13:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 11B9B180B464;
	Mon,  3 May 2021 11:13:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13UJeKRZ022045 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 30 Apr 2021 15:40:20 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E7BDB11FC69; Fri, 30 Apr 2021 19:40:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DFAA711FC70
	for <dm-devel@redhat.com>; Fri, 30 Apr 2021 19:40:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A37C106655B
	for <dm-devel@redhat.com>; Fri, 30 Apr 2021 19:40:17 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
	d=dkim.mimecast.com; s=201903; t=1619811617;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	in-reply-to:in-reply-to:references:references;
	bh=/JlHMbhC7aGa20BQw4aCyF9KKaT4RUydP+DgmBS+9Yg=;
	b=k13zRsX9LprrvO0mivAQvAJMFy1PEcEFr+0jz9s5k8IeR+CsRa6r+yhZOS2nrPlvXtdzz/
	uAC6yCVOM+ixLcAhv38yIU4X3oFSfnjWpV9sTmHUka9oDDAl9A5d5S10H2wsnuqHuOQmq1
	IElPKIedZYG/O3PWJ7rKwrqdK0AnsDjtBUZoDShGno/9DLLXy45PvGSQnZAKn0Fbf5KW88
	cy3TSO6IlGUrVTU7R9lo/6LoYsLSVEdB+fvcXAHjuTIsDuwJGQjidY6u5vyskLvwW2EnHa
	Or8Lf/g12r+nLP5OloYqzcWhmO3EXwPW8eR5rHyrAl/jL+zea/JeS3RJa/0xfw==
ARC-Seal: i=1; s=201903; d=dkim.mimecast.com; t=1619811617; a=rsa-sha256;
	cv=none;
	b=afY5uhf3QNIpjAE7ZSdTvjPOyOJCsVIFGSPjrQ2Y2gDeSE6/aYYyhpwKdZl59pHpHwbvlt
	uQ8Il7qhpEtKlQlR5qRvZ5qdAV2Dv8nE0dQUFTb9yO0Cg/1LHQNcXnITuYFsLiQ+MLUsXC
	cSdKzQLPfAleYcWhj+iJkjAcvv1A7CZZge5DK0O9e5r/KitCpcz1+brTtwjzpKgMl3M1bv
	yV2X55PsdGGJ0Px/GztPZY/U5/wkP4rISfctln2sh8C3VtlRnGCzxR3GB/g6jpVmwhDFd3
	MiAVFlnBk8WNTWdTSmjUIulxpGgbpGzP4L8KdnB1OOTr3exbc+U/5bcGhQn5ug==
ARC-Authentication-Results: i=1; relay.mimecast.com; dkim=none; dmarc=none;
	spf=pass (relay.mimecast.com: domain of vermeeren@vermwa.re designates
	5.255.86.113 as permitted sender)
	smtp.mailfrom=vermeeren@vermwa.re
Received: from victorique.vermwa.re (victorique.vermwa.re [5.255.86.113])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-556-r_i7UHoENjGCdUiJtCRzPQ-1; Fri, 30 Apr 2021 15:40:12 -0400
X-MC-Unique: r_i7UHoENjGCdUiJtCRzPQ-1
Received: from victorique.vermwa.re (localhost [127.0.0.1])
	by victorique.vermwa.re (Postfix) with ESMTP id E3C8CA02C0;
	Fri, 30 Apr 2021 21:40:09 +0200 (CEST)
Received: from verm-r4e.localnet ([fd17:3171:f888:364d::1000])
	by victorique.vermwa.re with ESMTPSA id fYNSNBldjGCRCAAAjH0QZw
	(envelope-from <vermeeren@vermwa.re>); Fri, 30 Apr 2021 21:40:09 +0200
From: Melvin Vermeeren <vermeeren@vermwa.re>
To: Mike Snitzer <msnitzer@redhat.com>, Milan Broz <mbroz@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Date: Fri, 30 Apr 2021 21:39:46 +0200
Message-ID: <6810395.sd9NxXGo4T@verm-r4e>
Organization: vermware
In-Reply-To: <alpine.LRH.2.02.2104281658430.9959@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2104281658430.9959@file01.intranet.prod.int.rdu2.redhat.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 03 May 2021 07:13:02 -0400
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2] dm-integrity: if we have discard support,
	use it when recalculating
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
Content-Type: multipart/mixed; boundary="===============6441874485121207954=="
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15

--===============6441874485121207954==
Content-Type: multipart/signed; boundary="nextPart6356666.CjSi1WKuK9";
	micalg="pgp-sha512"; protocol="application/pgp-signature"

--nextPart6356666.CjSi1WKuK9
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Melvin Vermeeren <vermeeren@vermwa.re>
To: Mike Snitzer <msnitzer@redhat.com>, Milan Broz <mbroz@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
Subject: Re: [PATCH v2] dm-integrity: if we have discard support,
	use it when recalculating
Date: Fri, 30 Apr 2021 21:39:46 +0200
Message-ID: <6810395.sd9NxXGo4T@verm-r4e>
Organization: vermware
In-Reply-To: <alpine.LRH.2.02.2104281658430.9959@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2104281658430.9959@file01.intranet.prod.int.rdu2.redhat.com>

Hi again,

On Wednesday, 28 April 2021 23:00:23 CEST Mikulas Patocka wrote:
> Here I'm sending version 2 of the patch - it increases version number of
> the target, so that userspace can test if this feature is present.
> 
> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> If we have discard support, we don't have to recalculate hash - we can
> just fill the metadata with the discard pattern.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

I had a look at this patch. If I understand correctly, this logic only applies 
to dm-integrity recalculation, so for example from userspace with:
$ integritysetup --integrity-recalculate --allow-discards open <dev> <name>

In such a case, it will fill all tag values with discard filler instead of 
reading from the drive and computing the tags. If that is true I think this is 
not desired behaviour, consider the following:

* SSD with existing data /dev/sda1.
* Device for dm-integrity metadata /dev/vg/is_sda1_meta.
* $ integritysetup --data-device /dev/sda1 --no-wipe /dev/vg/is_sda1_meta
* $ integritysetup --data-device /dev/sda1 --integrity-recalculate \
	--allow-discards open /dev/vg/is_sda1_meta is_sda1

In current production version, this causes a full read of the SSD to 
recalculate integrity tags, which is as expected and works very nicely. With 
this patch, wouldn't it result in all integrity tags being set to the discard 
filler? Does this patch assume a device is fully discarded when recalculating?
Perhaps I am reading it wrong, I am not familiar with the dm kernel modules.


Also, a bit unrelated to any of the above. When doing a format operation 
(without --no-wipe) on a device supporting discard, would it not be possible 
to format via discards instead of the current data write operations? That 
would significantly improve speed for SSDs and also reduce wear on the drive.

Thanks,

-- 
Melvin Vermeeren
Systems engineer
--nextPart6356666.CjSi1WKuK9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiu1YAh/qzdXye6Dmpy9idxbqnZYFAmCMXQIACgkQpy9idxbq
nZZqhA/9F5R8ilnBzt+0rKIx0Ak4jiGLR1Ofi9SBNkLuWzkUqW9GbjBro1Se09J6
hCe6cS6p77s8936NHsaLBHr4brjOHwJQ+X39/ReUIXgUk8RmLdYlqFigDJZh5/pi
afqWFDZWze7K5dfUf/Lk9czM0/oTGqNAomfb4z5vl5GNrNHsV129MjiMbqqljnEx
p7eKap3DsDqrBRjLBkqFtmx187uTCwMgCPaQSE7Pkh8kd0CRGb8q26jSDNfSUMJU
TIy0Zud7pPN2/1rUyUjGvhemabkY03ZT64/A7r8e5wi3rKBRyxxiNPi2bnLoCZbR
9Zuo4LxaSgHpZiS6c3jvTGnb7QgFJREid24IlLOmMJvo7toE8pV95HZhLToCK74k
EOpQ7I07JgqEpou0FUf1wIXYl/iIUN049lvWsTYoPEuAuCQnebMr/KbCpCVKQmQD
jIBX5x9ntVi8LGw0Ac2Hoapp5IsTY70XrQmWNAcup8ViWUIarChamvV7QR3Y49Pd
3jBXo5c+M6aKhhfc8QZt7Y9TS5TWSlvzcZpvhcg50q64pthp5yWKckghpWLaz8/b
26bHKQok8+ItxyuhCv4FmWQObkWgMDJEG8rx11Uek3aEG++7/1VqmO1mjlKuadsU
eMfpr+r917bTJN6UV2IB00ynNQmBh7rhQrAGSYYsfu1pCvcEZ+c=
=CfgJ
-----END PGP SIGNATURE-----

--nextPart6356666.CjSi1WKuK9--




--===============6441874485121207954==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============6441874485121207954==--



