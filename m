Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93400EB64D8
	for <dm-devel@archiver.kernel.org>; Fri, 16 Jun 2023 16:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686933987;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=hhlvRHK5ybtoqTu1jmkbLYqrTO6IKxWvbdVM01C9I0I=;
	b=awa9MCvgKC71+dVCXxVo5IIae0zGMKBJpICH6n3+uoPXOkxPPtivSlTuCTxN/MU6CENVLd
	JPbhuONPoVXYy4bwABrlb6Cv4QJ8KK9QalzIF3SghaPZ5IkQV/telq0QZEXbIxqkcKMPrF
	6RSTNXHsYFD1jzWqYaaxlzkZ9U2AbAI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-331-T3JEUrrYNRyiQWxDbSVsew-1; Fri, 16 Jun 2023 12:46:24 -0400
X-MC-Unique: T3JEUrrYNRyiQWxDbSVsew-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09F6E101A528;
	Fri, 16 Jun 2023 16:46:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 831EB175AE;
	Fri, 16 Jun 2023 16:46:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5FD5C1946594;
	Fri, 16 Jun 2023 16:46:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BBC2D1946589
 for <dm-devel@listman.corp.redhat.com>; Fri, 16 Jun 2023 16:46:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 87A6F492C38; Fri, 16 Jun 2023 16:46:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7FF40492B06
 for <dm-devel@redhat.com>; Fri, 16 Jun 2023 16:46:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 62B818007CE
 for <dm-devel@redhat.com>; Fri, 16 Jun 2023 16:46:18 +0000 (UTC)
Received: from mout.web.de (mout.web.de [217.72.192.78]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-458-3GZRA75CMwmcmbXtJE9HWA-1; Fri,
 16 Jun 2023 12:46:16 -0400
X-MC-Unique: 3GZRA75CMwmcmbXtJE9HWA-1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
 s=s29768273; t=1686933974; x=1687538774; i=lukasstraub2@web.de;
 bh=PIYModiwswVwXX9tY1EEMbfG/dsKQA/mI49askyJbyw=;
 h=X-UI-Sender-Class:Date:From:To:Cc:Subject:In-Reply-To:References;
 b=OXvvIaScvBGaNqjP1emXtpUcKWsbN56y+bqYmeUHM0xr1QK5PfjbKUej6PdwQNEI0e8IGE1
 0k3SMyXU0iWGQ0cteRNGREg23tZqcRZbWi153/Q3cmJsc0BYD6VVywhkpd9B7iqvMp3XNp7aN
 J73atL1gp/+pRaK/N+RHxe2jGhd8Cnize45XDS5TfuU96b9/BLO5nKJj41GNslupmxy1NrU4s
 UVJdLAgocsw1oZNvs3jStUqDX111Dza/Myv0B6g7cMnZYno5EgsIYd0QpCRS5MW29CELyLkju
 cvBDK1EuMxnop7ZBLJGZCHQvufQxGgFS86bX6ccBzKdplXgq5B2w==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from mobian.usb.local ([82.207.254.102]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MTfol-1qXfBf14tJ-00U4WZ; Fri, 16
 Jun 2023 18:33:38 +0200
Date: Fri, 16 Jun 2023 18:33:10 +0200
From: Lukas Straub <lukasstraub2@web.de>
To: Marc Smith <msmith626@gmail.com>
Message-ID: <20230616183310.66b9734c@mobian.usb.local>
In-Reply-To: <CAH6h+heB57N4StY-Nhs+QV+Z8UkD8x8K+C1T-NVbsz55fT+kfg@mail.gmail.com>
References: <CAH6h+heB57N4StY-Nhs+QV+Z8UkD8x8K+C1T-NVbsz55fT+kfg@mail.gmail.com>
MIME-Version: 1.0
X-Provags-ID: V03:K1:RzUMNcJ5w4YWvtQDSa2nqsc/QX+7or2MnkyZXtGYAUchNo5/A8x
 gATfiwMvb0JQZ9qqHFtvsoowZPTLV2K+1UifrPk3iiYJpB5/Dq5CU7eQVZnoz4/XXi7hDYR
 FbV1uKLQ8HYidhNbB8VEYKJMQe5SwJXJBgdmuakXuAbIulmWf2zzpSZY01j60I92TWj4AkB
 vaQXAkLMScSf3dIAPXXWg==
UI-OutboundReport: notjunk:1;M01:P0:juVAfrnVeMQ=;NIGrxNkmXcTNbE21qgCNXRXMFot
 Nm5bbrs9QQU6pvfPY+x4vkLIeKSdZ/OcJwmPq7xRSazjiTShFxrf0y4hNA7udfrCaaTjANWtN
 fQcCt1GShCWxxGCUul8zN95wIxKiYqCk84ARw4yKpBMi3u2ejxDxf+mQfmNznJLtJIq76YvHJ
 WAnN6cOXvzdce6PcrlrU7Nw18cTJqSyNDu6dHHv//4T11FtqLCX60HBPmAJAnCg/1cdDZJiLB
 qHONnoS0jOR74cwl3/rnP/lqpt1MDJ5UyAASPTIIDMh8eOl8fwyRaRt77ZjMs3ARPTXDU74t+
 wVWcrfTz5wAJrgHAcdTU35Pm7xSjUJPoZgAjWLN5eL43Q2I6H4MgK8xh29ax0+ERd9ESaUHHK
 y8tl/Jmf432lcaUe3K/CLPnqKat3j7+zIXgyFpavM6iStkp5OPQ8q6JPkmMBPH/ELyxswdXQe
 bLFWCwWHh7fROEvUyWCFFbtJWuNhiw7ehj34ixElA3Ua0vb8jHmNsUw2bGcBBYdkdi4rBu7je
 JhKMS6OKfBH+W4b9Q/Rsmj4HOCWIGGOtpcLS4eTlHcJkiwzMLmZj0Ww0DHZPVvE3iBrAYpMOW
 EtJ4u0nJkkpmwS+FGQItRYOeyYfn/RseejzMREtSdpSE6qTbnysHFv5oyvA71IXUtOl+EAelp
 q6859qbiSb4zAoaDpfU9k8pOQg0JYbwDEnZbRIU29ekFAatC24BNeFB0tmD0buAUnQizHDYoA
 F4Q8YGDrF5n9/yRNj5PiiF8uQUbxxaZRURDGVq/f00hcd+0Cyhc/FqSZFoQajdSkoM3fJNofK
 Fvv3oucdKyv/C2zpEJr7Et3DuWTWHUCxLfMNBkmLNDojWNgMzL+DxNYR0F62iX/p45Z3pJy/v
 MFFIx7HBaCgWigN9IUonQ9CPaQfPR3qga+UVS0Y6GJcSKd3w71yGBoYr3zRYp8hFmX51rLq0b
 X8WHPhTJLUQ1M3TP86/Nxl3bZnM=
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] dm-writecache - Unexpected Data After Host Crash
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
Cc: dm-devel@redhat.com
Content-Type: multipart/mixed; boundary="===============3621032522201103227=="
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5

--===============3621032522201103227==
Content-Type: multipart/signed; boundary="Sig_/8shWJV.crYDwyCAm+i7f8YI";
 protocol="application/pgp-signature"; micalg=pgp-sha512

--Sig_/8shWJV.crYDwyCAm+i7f8YI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 14 Jun 2023 17:29:17 -0400
Marc Smith <msmith626@gmail.com> wrote:

> Hi,
>=20
> I'm using dm-writecache via 'lvmcache' on Linux 5.4.229 (vanilla
> kernel.org source). I've been testing my storage server -- I'm using a
> couple NVMe drives in an MD RAID1 array that is the cache (fast)
> device, and using a 12-drive MD RAID6 array as the origin (backing)
> device.
>=20
> I noticed that when the host crashes (power loss, forcefully reset,
> etc.) it seems the cached (via dm-writecache) LVM logical volume does
> not contain the bits I expect. Or perhaps I'm missing something in how
> I understand/expect dm-writecache to function...
>=20
> I change the auto-commit settings to larger values so the data on the
> cache device is not flushed to the origin device:
> # lvchange --cachesettings "autocommit_blocks=3D1000000000000"
> --cachesettings "autocommit_time=3D3600000" dev_1_default/sys_dev_01
>=20
> Then populate the start of the device (cached LV) with zeros:
> # dd if=3D/dev/zero of=3D/dev/dev_1_default/sys_dev_01 bs=3D1M count=3D10=
 oflag=3Ddirect

Missing flush/fsync.

> Force a flush from the cache device to the backing device (all zero's
> in the first 10 MiB):
> # dmsetup message dev_1_default-sys_dev_01 0 flush
>=20
> Now write a different pattern to the first 10 MiB:
> # fio --bs=3D1m --direct=3D1 --rw=3Dwrite --buffer_pattern=3D0xff
> --ioengine=3Dlibaio --iodepth=3D1 --numjobs=3D1 --size=3D10M
> --output-format=3Dterse --name=3D/dev/dev_1_default/sys_dev_01

Again, no flush/fsync is issued.

> And then induce a reset:
> # echo b > /proc/sysrq-trigger
>=20
> Now after the system boots back up, assemble the RAID arrays and
> activate the VG, then examine the data:
> # vgchange -ay dev_1_default
> # dd if=3D/dev/dev_1_default/sys_dev_01 bs=3D1M iflag=3Ddirect count=3D10
> status=3Dnoxfer | od -t x2
> 0000000 0000 0000 0000 0000 0000 0000 0000 0000
> *
> 10+0 records in
> 10+0 records out
> 50000000
>=20
>=20
> So I'm expecting all "ffff" in the first 10 MiB, but instead, I'm
> getting what's on the origin device, zeros (not what was written to
> the cache device).
>=20
> Obviously in a crash scenario (power loss, reset, panic, etc.) the
> dirty data in the cache won't be flushed to the origin device,
> however, I was expecting when the DM device started on the subsequent
> boot (via activating the VG) that all of the dirty data would be
> present -- it seems like it is not.
>=20
>=20
> Thanks for any information/advice, it's greatly appreciated.

This is the expected behavior. If you don't issue flushes, no guarantees
are made about the durability of the newly written data.

>=20
> --Marc
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel
>=20


--Sig_/8shWJV.crYDwyCAm+i7f8YI
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEg/qxWKDZuPtyYo+kNasLKJxdslgFAmSMjsYACgkQNasLKJxd
slhFZw/8CrNv3QhWQPkjVaygil5ANP6F73zc2ZmAS0PXSXMjW/ILW2FtnXLmgs/H
X4FSEx1qqVvfasOnvsb5y40QJePZqAL3KezhAPL07TVTXSxd9/8pOZDQXQDOjris
KTEN+4GOmbdvEf/JXVc7WIQ8pdDLb/4YXyFJg8ejbEn4yA2r1qTD4kCvho552tzN
l4Dy/WOIghRU9HZMq1PJbBkejJ40lVUMMIwvYEHYt72tAntMr87WlcD71r0W6pmD
oRFRB11oTk6pAz4rIFFZLi9r7TIkGjdJ8ny1zH752mGWH20l4dEG0Ow3czSjlXiZ
HYc/fPeoo35HC6JG21j4JkbUVOofS3vJpN/6lpKl/B252n8rLHczWr3cATqD0nz3
MNiPMiCOLkMQYQ4E+0y/gyuRxK6m7h2C1WFgy5O59q36v294QAeEFIh8553UA6Ac
sB50nqm/aQlDSkInz+1OnDwcamD1wcUQrr+bCTdgUjdfSIxZxdc0cCnwdVlhR+ia
s9UzLON3Tgdh2KFCWKktjDHOkOb6iNeJfMhCzuZ4pFij0PxUy6KQ+7CTqf9xsXId
rEUw5NQ4rflozJtdtcLsejJO0w5FHvhg5QCH5Fk/mH9AxcDmG4GreTvaMg/jwWb1
1XP21o48nke5dqOXiiepH0TIZXdT+RsYr+EUC18jzedSqGZ415s=
=esaI
-----END PGP SIGNATURE-----

--Sig_/8shWJV.crYDwyCAm+i7f8YI--


--===============3621032522201103227==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============3621032522201103227==--

