Return-Path: <SRS0=cSVF=KM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B20D8C433ED
	for <dm-devel@archiver.kernel.org>; Mon, 17 May 2021 07:51:16 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B1B4861206
	for <dm-devel@archiver.kernel.org>; Mon, 17 May 2021 07:51:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B1B4861206
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=vermwa.re
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-o7IDKhVdOkusCDVEnsstpw-1; Mon, 17 May 2021 03:51:08 -0400
X-MC-Unique: o7IDKhVdOkusCDVEnsstpw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72AD9801B13;
	Mon, 17 May 2021 07:51:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 07A455946C;
	Mon, 17 May 2021 07:51:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0482C1800BBE;
	Mon, 17 May 2021 07:51:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14CJQnwh010084 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 12 May 2021 15:26:49 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 0E5742166B4E; Wed, 12 May 2021 19:26:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 08F542166B13
	for <dm-devel@redhat.com>; Wed, 12 May 2021 19:26:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7BBFD80D0E1
	for <dm-devel@redhat.com>; Wed, 12 May 2021 19:26:46 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
	d=dkim.mimecast.com; s=201903; t=1620847606;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	in-reply-to:in-reply-to:references:references;
	bh=WWhvKbkAc3xVC/yVe1BcjQPWvcUaolbELcprMgu80T4=;
	b=eUoaBcMbPWlB6jBYzpzAc6IGbuYdGvrHSUy+BN+/Bfsz3V+0KqJim1slZDGuP2dATcs2Uk
	6pgMyNUrVHtcPkdX9ATKXjL2bi8wJ/tLKBPmWMzatwaW6DvLP0TzMFyzvw41hlhTtCz2zF
	Sf1QMZHvfP8EPY51+69TRKiYUtvk0FoGT27vIjky1dNxvE49QOUG2iMylXMpyxeszZf0mz
	ADKBqlIEjZl09QODUEUICGDFarpA9POZ5IcjNmEawL2eZv9kf3kx5QAwgIujxvPKawwdXe
	1YCLjY0R9V9P8x1gZLuRjHJ3aGZOWaoZtbSXAkSA6lIPLCwVv3OWQXlCRyq0hw==
ARC-Seal: i=1; s=201903; d=dkim.mimecast.com; t=1620847606; a=rsa-sha256;
	cv=none;
	b=gPIRl9yvr/PIIiaBgVFawdV9kLGoR7eU0B1oTMAcWi8LUZ4zuxaUoHHanhmbzmo+S+aGqT
	QbYwgtAvlunhaHADRhMFXO+1QYBqisFnACFGaRIm9HK2R6Cwk66HDG7hpx3TgSz513tows
	LIPBAd5VGFNMWO+maEG5h386ZE/fskKJ2Ixk5sj8M6Mpw7zkWVVUfvdFROnz/HDD6eGeVJ
	H0GbGXBWmgmia00piMVP6thqKjntH+oxrmJXSJ3Qkc5SsevCGpHBEyXC57Sd/pE3y0kM60
	V3p0GxSIBWLWrzpfsgg6PNQ+5jMzeoTlYsbqt2M97B4WgPfpOsMpvp/ji3vkDw==
ARC-Authentication-Results: i=1; relay.mimecast.com; dkim=none; dmarc=none;
	spf=pass (relay.mimecast.com: domain of vermeeren@vermwa.re designates
	5.255.86.113 as permitted sender)
	smtp.mailfrom=vermeeren@vermwa.re
Received: from victorique.vermwa.re (victorique.vermwa.re [5.255.86.113])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-315-0fJZltLoPka9Xpob0dmUBA-1; Wed, 12 May 2021 15:26:27 -0400
X-MC-Unique: 0fJZltLoPka9Xpob0dmUBA-1
Received: from victorique.vermwa.re (localhost [127.0.0.1])
	by victorique.vermwa.re (Postfix) with ESMTP id 4B49AA02F8;
	Wed, 12 May 2021 21:26:25 +0200 (CEST)
Received: from verm-r4e.localnet ([fd17:3171:f888:364d::1000])
	by victorique.vermwa.re with ESMTPSA id JoewDuErnGDtIAAAjH0QZw
	(envelope-from <vermeeren@vermwa.re>); Wed, 12 May 2021 21:26:25 +0200
From: Melvin Vermeeren <vermeeren@vermwa.re>
To: Mikulas Patocka <mpatocka@redhat.com>
Date: Wed, 12 May 2021 21:26:20 +0200
Message-ID: <3832189.ZKCCLTqfco@verm-r4e>
Organization: vermware
In-Reply-To: <4782666.JkfDSx4nLX@verm-r4e>
References: <4219669.2KqOsUsilv@verm-r4e>
	<alpine.LRH.2.02.2104261200140.27678@file01.intranet.prod.int.rdu2.redhat.com>
	<4782666.JkfDSx4nLX@verm-r4e>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 17 May 2021 03:51:00 -0400
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
Content-Type: multipart/mixed; boundary="===============7222068656772726966=="
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11

--===============7222068656772726966==
Content-Type: multipart/signed; boundary="nextPart3447891.LmRZDSJE3x";
	micalg="pgp-sha512"; protocol="application/pgp-signature"

--nextPart3447891.LmRZDSJE3x
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Melvin Vermeeren <vermeeren@vermwa.re>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-devel] Integrity discard/trim extremely slow on NVMe SSD
	storage (~10GiB/minute)
Date: Wed, 12 May 2021 21:26:20 +0200
Message-ID: <3832189.ZKCCLTqfco@verm-r4e>
Organization: vermware
In-Reply-To: <4782666.JkfDSx4nLX@verm-r4e>
References: <4219669.2KqOsUsilv@verm-r4e>
	<alpine.LRH.2.02.2104261200140.27678@file01.intranet.prod.int.rdu2.redhat.com>
	<4782666.JkfDSx4nLX@verm-r4e>

Hi again,

On Friday, 30 April 2021 21:26:23 CEST Melvin Vermeeren wrote:
> (As mentioned in other mail I
> contacted Seagate about this, it should be fixed in drive firmware.)

After some back and forth with testing and diagnostics Seagate has provided 
updated firmware version STNSC016, drives originally had version STNSC014. 
Updating this firmware with nvme-cli utilities has resolved the issue.

For validation, I allocated 500GiB space for testing in the full stack:
FireCuda 520 -> dm-integrity -> mdadm raid1 -> luks cryptsetup -> lvm -> lv

Then I discard the LV. Disk util % of both drives moves to 100% while 
discarding, as checked with dstat. It took 20.920s real seconds to discard 
500GiB on a live system.

With old firmware, rate with this workload was approx 10GiB per 70 seconds or 
so. This means the new firmware is approx (500/10) * (70/20.92) = 167.3 times 
faster in this workload with a rate of approx 1434GiB per minute.

Perhaps there are still optimisations possible for dm-integrity, but in this 
case it really was a device issue as you suspected. Thanks again for all the 
help and work on dm-integrity!

Cheers,

-- 
Melvin Vermeeren
Systems engineer
--nextPart3447891.LmRZDSJE3x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiu1YAh/qzdXye6Dmpy9idxbqnZYFAmCcK9wACgkQpy9idxbq
nZZLNxAAthi9b756TbWmFga1OQP2cNvOhNJk7ITasP5A56dsnfXuFjG0S0d1u65E
S/+mX5HxrkSmzSyAI67JUaHj25Dg1GVCc3c6pYSVU2gNhV49YrX2Xp9FptW8Kfuc
RCL8ItOwN7GhUHcjN2WWwoOoAy6SZzJ38Kx6aZYuRUn6kGIKiOd+4tebvYZmDJNE
u7xaK3YrH/lQExBhyvL/PrvgqHVJlW7fKJXrYR0Jw3RMCP7B4TfurT+PtcDq7Qe2
FZ1Qn9IvjD9JNrbPvXY/BMlVW8WezLtNyplBG2N4NF90cadawHmakKD0jg7f10uj
YbLS8FdrOQTuBR18eT+bohc2WugENjeuRJempzkflVg05Xkxz3KY304Ap5QD4+Ue
L7O0ijXKpw+0Z5vmurNYSd/tjsmEw9cq23xncUhrXxSQckdJp7oPGxKhIxa9rG1F
Imq7Pthmyf+eRFCO6xNO7PxEQ89r5FIMB2lbzGvw4D7RBEKFD8yw1Pg9NHv2a45i
4ZIMuG/Qk1hJcFQWwQFMXTUbMxdhqdX/PdpO7JDNUGdJfxyvlkjLQL1fw+2P8fVL
teS7F+AATMoKeIpFRuf0odzY9fTD7iE/i40aomOR0/z+LiDJMneoO8RtJC4ac8Df
qYmQ9hFdeTQMtztMiRk+M69ScYCXKkV9I+G0TN/ZLpllVO7zysg=
=llfw
-----END PGP SIGNATURE-----

--nextPart3447891.LmRZDSJE3x--




--===============7222068656772726966==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============7222068656772726966==--



