Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49887C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 17 Feb 2022 19:06:34 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-330-NHOHNOtXMN-B7zEjRM84NQ-1; Thu, 17 Feb 2022 14:06:29 -0500
X-MC-Unique: NHOHNOtXMN-B7zEjRM84NQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53DC481424D;
	Thu, 17 Feb 2022 19:06:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 96E83418E;
	Thu, 17 Feb 2022 19:06:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 703A71806D1C;
	Thu, 17 Feb 2022 19:06:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21HJ6JV6000785 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 17 Feb 2022 14:06:19 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3EF5C1457F07; Thu, 17 Feb 2022 19:06:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3AC591457F04
	for <dm-devel@redhat.com>; Thu, 17 Feb 2022 19:06:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 210FD3C1EA4B
	for <dm-devel@redhat.com>; Thu, 17 Feb 2022 19:06:19 +0000 (UTC)
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com
	[209.85.218.46]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-563-LtKUuG8EP0yu8gYdwo5whA-1; Thu, 17 Feb 2022 14:06:15 -0500
X-MC-Unique: LtKUuG8EP0yu8gYdwo5whA-1
Received: by mail-ej1-f46.google.com with SMTP id a8so9508156ejc.8
	for <dm-devel@redhat.com>; Thu, 17 Feb 2022 11:06:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
	h=message-id:date:mime-version:user-agent:from:subject:to
	:content-language:cc;
	bh=mdQgPE+MN4QXHCuZfmZr4u+SAK0aRFpH7cy102uny4s=;
	b=lovDBq9Erxlw4cKfCvIYc4CcTnSbbCtrpjWaUDMz00ZUyXGIYzIuHQ4ayzSrtFhhxf
	pBkAnsZLMvhX5hcZA6otjJpEinMLld4xepz5JHofTqS7YDTxeiOCzKiVX18HTgnNnxps
	BxKY18hJh2xJR5ydT/8TXMjQRtYQyjP06XfoAos/VWFb891aTfKTioo2Px1kab0w7aov
	c5N+b0Qn8FiIUCzeJ435ZuofpUNdzwHT9IkhdNx3j8M8XjJtyXxmVaQYcvTwxIkUKfrM
	MalLK6hIWVnDc8eU50+lNwAHVOqc1ESx7MxSMbq5gPckkBkvWcodBjB/XbRqffV1gI1X
	aaDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:message-id:date:mime-version:user-agent:from
	:subject:to:content-language:cc;
	bh=mdQgPE+MN4QXHCuZfmZr4u+SAK0aRFpH7cy102uny4s=;
	b=uzDzOVE6Ju7H0nm+VgficTel0B7ucsGrkL+xD98bjEXLad9YVV15JzAGRCNAlrY857
	/Y5jnqlJyDvoJXwfPHDsjmOIR+FGGohTR3fqXZcUADKq8luDbBBZuC/Co1E1DkGTZmMU
	iamIdaFXNr8ClistoGNMer7uUpjFzUmAHA9HehsgQctSsEWaY3rNWVOwGAzsL7n3euR5
	slxESOnBagyW6ULAQWsxuO0HnE/8ePSaw1cnmpklnzNFGNePcbQ94xYGNube5BHyVl5r
	wNY5H1nlnHADKxs1HoFqxTRwcO+r+Ot3sgLljveUhBRDydXwGsLx1qDPMF0F0TDP49Tr
	opzQ==
X-Gm-Message-State: AOAM530zNL4RIY8fTypdNOsiqNJbktAAiQxPoyNaLFXpib+AqIJFjTCR
	R1HdMEaRlMwGFuf/2DWJenE=
X-Google-Smtp-Source: ABdhPJz4mZPoxPTj/F/hc3ejJunRwV/8KTjie4cNRFNXc1jNIsyPb+N/OzWVPWfA2zN3SqMau36cQg==
X-Received: by 2002:a17:907:1384:b0:6cd:5c6a:eec0 with SMTP id
	vs4-20020a170907138400b006cd5c6aeec0mr3635144ejb.35.1645124774509;
	Thu, 17 Feb 2022 11:06:14 -0800 (PST)
Received: from [192.168.2.27] (85-70-151-113.rcd.o2.cz. [85.70.151.113])
	by smtp.gmail.com with ESMTPSA id j5sm1464417ejs.69.2022.02.17.11.06.13
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Thu, 17 Feb 2022 11:06:13 -0800 (PST)
Message-ID: <82c29d3e-7b15-dcb1-8f00-450b6eb336f3@gmail.com>
Date: Thu, 17 Feb 2022 20:05:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.6.0
From: Milan Broz <gmazyland@gmail.com>
To: dm-crypt <dm-crypt@saout.de>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
Cc: cryptsetup development <cryptsetup@lists.linux.dev>,
	device-mapper development <dm-devel@redhat.com>
Subject: [dm-devel] New cryptsetup development list
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
Content-Type: multipart/mixed; boundary="===============1002895486828584637=="
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============1002895486828584637==
Content-Language: en-US
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="------------C8w92hyBx71fPxVzbGuVcyg7"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------C8w92hyBx71fPxVzbGuVcyg7
Content-Type: multipart/mixed; boundary="------------yqyfB77wE6lLWa2tyPJl8IVR";
	protected-headers="v1"
From: Milan Broz <gmazyland@gmail.com>
To: dm-crypt <dm-crypt@saout.de>
Cc: device-mapper development <dm-devel@redhat.com>,
	cryptsetup development <cryptsetup@lists.linux.dev>
Message-ID: <82c29d3e-7b15-dcb1-8f00-450b6eb336f3@gmail.com>
Subject: New cryptsetup development list

--------------yqyfB77wE6lLWa2tyPJl8IVR
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGVsbG8sDQoNCnRoZXJlIGlzIGEgbmV3IG1haWxpbmcgbGlzdCA8Y3J5cHRzZXR1cEBsaXN0
cy5saW51eC5kZXY+IGRlZGljYXRlZA0KdG8gY3J5cHRzZXR1cCBkZXZlbG9wbWVudC4NCg0K
UGxlYXNlIGNvbnNpZGVyIHN1YnNjcmliaW5nIGlmIHlvdSB3YW50IHRvIHJlY2VpdmUgbmV3
IHJlbGVhc2VzDQphbm5vdW5jZW1lbnRzIGFuZCBwYXJ0aWNpcGF0ZSBpbiBkaXNjdXNzaW9u
cy4NCg0KVGhlIGxpc3QgaXMgaG9zdGVkIGF0IGtlcm5lbC5vcmcgc3Vic3BhY2UNCmh0dHBz
Oi8vc3Vic3BhY2Uua2VybmVsLm9yZy9saXN0cy5saW51eC5kZXYuaHRtbA0KDQpZb3UgY2Fu
IHN1YnNjcmliZSBieSBlbWFpbGluZyA8Y3J5cHRzZXR1cCtzdWJzY3JpYmVAbGlzdHMubGlu
dXguZGV2Pg0KKFlvdSBjYW4gdXNlIGxpbmtzIGluIFVSTCBhYm92ZS4gRW1wdHkgbWFpbCBt
ZXNzYWdlIGlzIGVub3VnaC4pDQoNClVuc3Vic2NyaWJlIGJ5IGVtYWlsaW5nIDxjcnlwdHNl
dHVwK3Vuc3Vic2NyaWJlQGxpc3RzLmxpbnV4LmRldj4uDQoNClBvc3RzIGFyZSBtYWRlIGJ5
IGVtYWlsaW5nIDxjcnlwdHNldHVwQGxpc3RzLmxpbnV4LmRldj4uDQoNCkZvciBvdGhlciBp
bmZvcm1hdGlvbiBhbmQgaGVscCBhYm91dCB0aGlzIGxpc3QsIHNlbmQgYSBtZXNzYWdlIHRv
DQo8Y3J5cHRzZXR1cCtoZWxwQGxpc3RzLmxpbnV4LmRldj4uDQoNClRoZSBsaXN0IGlzIGVu
dGlyZWx5IG9wZW4uIE5vIG1vZGVyYXRpb24gaXMgaW4gcGxhY2UuDQpGb3IgcHJpdmFjeSBy
ZWFzb25zLCB0aGUgbGlzdCBvZiBzdWJzY3JpYmVycyBpcyBub3QgYXZhaWxhYmxlIGV2ZW4N
CnRvIGxpc3Qgb3duZXJzLg0KDQpUaGUgYXJjaGl2ZSBpcyBhdmFpbGFibGUgYXQgaHR0cHM6
Ly9sb3JlLmtlcm5lbC5vcmcvY3J5cHRzZXR1cC8uDQpPdGhlciBhY2Nlc3MgbGlrZSBOTlRQ
LCBBdG9tIGZlZWQsIG9yIGdpdC1iYXNlZCBhY2Nlc3MgaXMgYXZhaWxhYmxlDQp0aHJvdWdo
IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnLyBzZXJ2aWNlLg0KDQpUaGlzIG1haWxpbmcgbGlz
dCBzaG91bGQgcmVwbGFjZSB0aGUgZXhpc3RpbmcgZG0tY3J5cHQgbWFpbGluZyBsaXN0Lg0K
DQpUaGFua3MsDQpNaWxhbg0K

--------------yqyfB77wE6lLWa2tyPJl8IVR--

--------------C8w92hyBx71fPxVzbGuVcyg7
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEKikYJD/eRmSNBob52bBXe9k+mPwFAmIOnJgACgkQ2bBXe9k+
mPyjwhAAmfMKushuUXaKAv1bY2UrlKZRzT/yrfqzvfXt+xt1UYdg/l0t7K5V13Hc
ZlnhDjnsqhyD8Wkrrz3Ee6SxdZC73h4ig8ZaWGwTMxY07xqg/TyNPp7StFlL6Zfm
hU4G4fhRw6fzOh6cUCQFjaODMAaiqClgU5jedzSTRqsubwbM5PPqFaMtuO/EMGkH
coKSwskNbEnasKfxNuXMiOkxQUfalDJkwhKsSOdxsF7ZUUd29QNeDH7tLnErQBYe
d6sswN1H4lOeTKG/tHjhFaqMILRhnzQT1GKRidGyFus5DCXBeNhP1KXMD5d6Q2qn
vHRSQ2ATBa2KekWn73ZSU8DjhAjzpz1BJhAvg5v+y/qwQ/q45tXppLzEiI9of2qs
xcuR8lR+eWvsjQI2q/z1NSBOCvDcBbvivgiS+YzByMf3jSRugW+02eqOM/ZxXQpv
yLv7bUVKcdTux9pyWzUTzMfNyBf2noXNbtRrNdPgz+TLS2IaF1Ph7tNjzgirQfKd
N53MZc5P8uDBzqAr82yHlmmIjxmv7B1buLedmzfQQs8jEBM2lPC1c0pT+07TO0DC
qP+yd1wYSEu3xkxPhPh9ALj7SO1J0uzJeU3M/ujeXhaNAu1NQLo+1hb+uwGixJYh
Ll2/K2NRVxV1c8BzMSlCvhXM8Oh/W5KIPD5DNW5Phb9T6ZzCVwU=
=kWVy
-----END PGP SIGNATURE-----

--------------C8w92hyBx71fPxVzbGuVcyg7--


--===============1002895486828584637==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============1002895486828584637==--

