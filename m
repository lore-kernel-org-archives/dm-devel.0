Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81752EB64D7
	for <dm-devel@archiver.kernel.org>; Fri, 16 Jun 2023 21:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686950281;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=JUDNPoUTtzQSB/KeHRIPF5Vsy5vhhAuScp1/s0EN8LA=;
	b=MTKVLA33DczDV2oHor7yp/0eZ543FWElIWDZJ7xt0aRJ4OnJBCMXNpX8w/gYMtwoTzlRn8
	ubKq3zfjCmqeyXfpZSPCNG6pqXbrryOUPGc0NSMvcTVL0UzfV496XIDTgCpoVTsQkeVDL5
	JsFMl6EkKxtjc1O+XoCcAjtjFyMG/vk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-497-fDyYLbjFOhSTTV67quViIA-1; Fri, 16 Jun 2023 17:17:58 -0400
X-MC-Unique: fDyYLbjFOhSTTV67quViIA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F17B5101A531;
	Fri, 16 Jun 2023 21:17:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A61C31121314;
	Fri, 16 Jun 2023 21:17:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 700021946594;
	Fri, 16 Jun 2023 21:17:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6DD531946589
 for <dm-devel@listman.corp.redhat.com>; Fri, 16 Jun 2023 21:17:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 44B8C1121315; Fri, 16 Jun 2023 21:17:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3D62F1121314
 for <dm-devel@redhat.com>; Fri, 16 Jun 2023 21:17:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1FFB5803DBE
 for <dm-devel@redhat.com>; Fri, 16 Jun 2023 21:17:54 +0000 (UTC)
Received: from mout.web.de (mout.web.de [212.227.15.4]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-320-nlkroJvsPC2vR6O06W9sTQ-1; Fri,
 16 Jun 2023 17:17:52 -0400
X-MC-Unique: nlkroJvsPC2vR6O06W9sTQ-1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
 s=s29768273; t=1686950270; x=1687555070; i=lukasstraub2@web.de;
 bh=JNCzc0EgQlDRqZfB5FrG/Dj779nMF52JmcR+wFzONMc=;
 h=X-UI-Sender-Class:Date:From:To:Cc:Subject:In-Reply-To:References;
 b=KWttK0cEIzLeM6v3cs1k4O7Ls7nfQlvpNzG60S9CjmiHjpE2igSmFVqzpsBMXeOWHsik2ST
 Ik7vqSseYqIW+y99YO554zMcnTZ08iDRf/x291KLqZ4ac/rSz2git7fDteQrJ1LeFmn+qTgkv
 yNFW1l0VlNM3ED8A6Ztb2EQ2dAcVhRmwWEx0IZpT7+LUgPny8XeNgcPRjkcW12NHQxE+D2jMK
 NEqs0yHCZ61FdSlkSXUGcYpX9hdIzJPhLBBgUwYz6x0mGTwo5THreIl+jhPWEFnxP7ydOBH8+
 Emco6mO8ZFYLNFysx8C5N9apPlA5OiVhWiV3Pxon4LtbMMYaUwow==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from gecko.fritz.box ([82.207.254.102]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MHVen-1qNlHy3KWv-00DGR4; Fri, 16
 Jun 2023 23:12:47 +0200
Date: Fri, 16 Jun 2023 23:12:39 +0200
From: Lukas Straub <lukasstraub2@web.de>
To: Marc Smith <msmith626@gmail.com>
Message-ID: <20230616211239.30ca1616@gecko.fritz.box>
In-Reply-To: <CAH6h+he=Q+5bV777PDyCsGpxbd68kSt5R6ORqu3y9my+=P=ysw@mail.gmail.com>
References: <CAH6h+heB57N4StY-Nhs+QV+Z8UkD8x8K+C1T-NVbsz55fT+kfg@mail.gmail.com>
 <20230616183310.66b9734c@mobian.usb.local>
 <CAH6h+he=Q+5bV777PDyCsGpxbd68kSt5R6ORqu3y9my+=P=ysw@mail.gmail.com>
MIME-Version: 1.0
X-Provags-ID: V03:K1:E0okuzsC3NE1HoD/+rJQAhqEuFlxsisjx4yuDK7SNDhD2RW8Vq0
 qJ/7xWMlNIqvjGLbdr6/inhqlx0ajqQ4JKIUX+QA1RtPBcQd2DDeHJXMNsg1nSmDHpmG2g+
 ZUYmdwMBulhdla1KLHteIbrQpP7PiDqgIPtdIpaaa9yvkcin3SwwwA+dYlLJ5fn8BbDTHMP
 0TPSCz+jVoj7+uijSOmBQ==
UI-OutboundReport: notjunk:1;M01:P0:ZIwZGff4i7I=;2J0d3WCEEKe4QcTy+PG6No5fxc6
 9EkFfedZPEUaTa5xgHDe/dCEJGVWOLgzMNbO2fD6gEF6pbJxB1VKsitnEL1+qGULle6dPsnb+
 U4bTbhKHKFnYD/mgIlCRlz940sL+VUXs0KSeLbav2n5LiiqQ63+1ynQ9Wd3xCKqGs3jp7KW6f
 lIa5KEqx2dgC0WE93nHNTGG87y0gdZcdm0ucPYZWZqutsPy6GX2qeneRDFivOSM9wz68pGEaj
 CPLj6ol9gugQhaJMoc2p3EL2Rq+yNTJK3m3AAczjBVyN2S+V1Ck0lgZ6MOCvOmvwRuERtG3aR
 wfGFNQXcJYv6KCNENk+o4n6op6Redtzop1yOKTWF7W6IT+l4gIcFhydYswwx06LWS3k9j0Fqw
 Uv5iEGFc4sNTqO1trBOBK2AJ4nhY3xW+AfWpYafhI9BR55d9XKdM428Lu3a20KmuqnrBDWFNK
 w9HxSQa5lweghtpShrPg4a+8OhJmSd1NrUCv8iLoNjlZ1F0paGovbxruJWATMRVTF375QUDlo
 qkWgBd6PWYput9cc7ggy9Br1C/1X4DomGKcIDvku0L5ncQ+Wa5QVEDujuCLIZOO75bVrI9Zt1
 3nSLw2uwa8C7PvF79F2jrCqzMpsCHb9WKqXT2uj1s+66ONZMy8mgjK21HMoZpvQ32nIs788Ax
 oaijxbr2xRCfoCRCKucQSwVlpz5a4rxTLuzBf6Rqu3E326g/dRAQ9OBHYPWzFL19rnbOKCs1x
 EEh0m16UZguRJ6I21MEqY5J2sSs6LK6lX8dZEa2M+/6ijTZu3utS1FXaUq3Gw65/D0yI+oAtQ
 pnafKPlz7+vAaM0nD74wrJOPzxdkFq/g/ZQ4bTFVDteFoaj7LxazwbfmbkaJ2gPOyzFyXxkQC
 ft1SFd24n1S6HQosOUma2HkH/IgUSg6pgAFV6UsfO6QTaYpRwfiWa9JqQNF+hfL2cQabkx92m
 lgiLaeDjLnlXkUkuow4hd+6UAIE=
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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
Content-Type: multipart/mixed; boundary="===============1292534855850701653=="
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3

--===============1292534855850701653==
Content-Type: multipart/signed; boundary="Sig_/FYBfDYxROGPISt+Dp9Lu6cK";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/FYBfDYxROGPISt+Dp9Lu6cK
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 16 Jun 2023 16:43:47 -0400
Marc Smith <msmith626@gmail.com> wrote:

> On Fri, Jun 16, 2023 at 12:33=E2=80=AFPM Lukas Straub <lukasstraub2@web.d=
e> wrote:
> >
> > On Wed, 14 Jun 2023 17:29:17 -0400
> > Marc Smith <msmith626@gmail.com> wrote:
> > =20
> > > Hi,
> > >
> > > I'm using dm-writecache via 'lvmcache' on Linux 5.4.229 (vanilla
> > > kernel.org source). I've been testing my storage server -- I'm using a
> > > couple NVMe drives in an MD RAID1 array that is the cache (fast)
> > > device, and using a 12-drive MD RAID6 array as the origin (backing)
> > > device.
> > >
> > > I noticed that when the host crashes (power loss, forcefully reset,
> > > etc.) it seems the cached (via dm-writecache) LVM logical volume does
> > > not contain the bits I expect. Or perhaps I'm missing something in how
> > > I understand/expect dm-writecache to function...
> > >
> > > I change the auto-commit settings to larger values so the data on the
> > > cache device is not flushed to the origin device:
> > > # lvchange --cachesettings "autocommit_blocks=3D1000000000000"
> > > --cachesettings "autocommit_time=3D3600000" dev_1_default/sys_dev_01
> > >
> > > Then populate the start of the device (cached LV) with zeros:
> > > # dd if=3D/dev/zero of=3D/dev/dev_1_default/sys_dev_01 bs=3D1M count=
=3D10 oflag=3Ddirect =20
> >
> > Missing flush/fsync.
> > =20
> > > Force a flush from the cache device to the backing device (all zero's
> > > in the first 10 MiB):
> > > # dmsetup message dev_1_default-sys_dev_01 0 flush
> > >
> > > Now write a different pattern to the first 10 MiB:
> > > # fio --bs=3D1m --direct=3D1 --rw=3Dwrite --buffer_pattern=3D0xff
> > > --ioengine=3Dlibaio --iodepth=3D1 --numjobs=3D1 --size=3D10M
> > > --output-format=3Dterse --name=3D/dev/dev_1_default/sys_dev_01 =20
> >
> > Again, no flush/fsync is issued. =20
>=20
> I'm doing direct I/O so I wasn't anticipating the need for a flush/fsync.
>=20
>=20
> > =20
> > > And then induce a reset:
> > > # echo b > /proc/sysrq-trigger
> > >
> > > Now after the system boots back up, assemble the RAID arrays and
> > > activate the VG, then examine the data:
> > > # vgchange -ay dev_1_default
> > > # dd if=3D/dev/dev_1_default/sys_dev_01 bs=3D1M iflag=3Ddirect count=
=3D10
> > > status=3Dnoxfer | od -t x2
> > > 0000000 0000 0000 0000 0000 0000 0000 0000 0000
> > > *
> > > 10+0 records in
> > > 10+0 records out
> > > 50000000
> > >
> > >
> > > So I'm expecting all "ffff" in the first 10 MiB, but instead, I'm
> > > getting what's on the origin device, zeros (not what was written to
> > > the cache device).
> > >
> > > Obviously in a crash scenario (power loss, reset, panic, etc.) the
> > > dirty data in the cache won't be flushed to the origin device,
> > > however, I was expecting when the DM device started on the subsequent
> > > boot (via activating the VG) that all of the dirty data would be
> > > present -- it seems like it is not.
> > >
> > >
> > > Thanks for any information/advice, it's greatly appreciated. =20
> >
> > This is the expected behavior. If you don't issue flushes, no guarantees
> > are made about the durability of the newly written data. =20
>=20
> Interesting... was not expecting that. I guess I was thrown by the use
> of persistent media (SSD / PMEM). If dm-writecache has dirty data that
> isn't flushed to the origin device yet (no flush/fsync from the
> application) and we lose power, the data is gone... why not just use
> volatile RAM for the cache then?

Because flushing is the very thing that dm-writecache should accelerate.
If your application isn't going to flush the data, it may just as well
throw the data away.

>=20
> I'm still experimenting and learning the code, but from what I've seen
> so far, the dirty data blocks do reside on the SSD/PMEM device,

Not even that, many storage devices will buffer written data internally
in volatile caches. This is obvious on HDDs for performance reasons,
but SSDs too need to commit metadata internally before writen data is
visible after a crash.

And consider other scenarios:
When you're running inside a VM, with the virtual disk being backed by
a file on a normal filesystem (perhaps without O_DIRECT even).

> it's
> just the entry map that lives in metadata that isn't up-to-date if a
> crash / power loss occurs. I assume writing out all of the metadata on
> each cache change would be very expensive in terms of I/O performance.
>=20
>=20
> > =20
> > >
> > > --Marc
> > >
> > > --
> > > dm-devel mailing list
> > > dm-devel@redhat.com
> > > https://listman.redhat.com/mailman/listinfo/dm-devel
> > > =20
> > =20



--=20


--Sig_/FYBfDYxROGPISt+Dp9Lu6cK
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEg/qxWKDZuPtyYo+kNasLKJxdslgFAmSM0EcACgkQNasLKJxd
sliLkw/+Ja/Hc/wIYxiaFgD9/4D+AAgdl2cMbpcCdXIC0yi8xJCWlLAVGb+Wkb6L
6nVRATCqKjwtdoeFbjVgvofxnRPqhBOXnf9bd8/gOEa0kO4tq1r5u3eN9o2Dyh6q
fEMOIv4yN3l+1ZSxKjkCUvVRCCpTxAWgENEDrldvLUXR2wrV4iQdiThaxV1cGOCl
uikQHwPzB0W6PECva2xzteD1guWbUnzCx43hZpCCYUpT9akbn8FezRbi7dG7xlYf
hoslBZWWyVmHF01MzrNHoFKFW03O6HLQaobBTbqjcWwhALswgPgVp8IYI/IX66Ue
4/eTX56t9BQbX1MsiyJZpVM9/cCuX5OOo9UpyWVxYAzHsq6tNNWE3CQK82yTXCs6
Gihrqakqal+t1yqBa64LdiTYXZnqqao4B6bUekrDKxcOIdaZeVpQBLL4FjyF6QAh
9NO/WG+gIO22GsetT2MgUt1lURTMFYKKIUMeGlCnvchGeovomMgSepFcSNd9NJAi
dDJ+WwhXtptYxeQ6/4RHpgts94huPicqv6PgX4llAGKMWyvT7aWcntlheeWxH0Wa
UziGO5oOWALuCzTeVr5u3FKU8m3skbd567ktgHZ8ghOOsh5nLwk2toQZiCP8p9NA
ZuQ2ayDk2V9YEsRLX1fl1geEoZZDRAaPJkPfST5EiFgnCbUHJrw=
=W6SR
-----END PGP SIGNATURE-----

--Sig_/FYBfDYxROGPISt+Dp9Lu6cK--


--===============1292534855850701653==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============1292534855850701653==--

