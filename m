Return-Path: <SRS0=l7Hk=GN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F41FDC433DB
	for <dm-devel@archiver.kernel.org>; Sun, 10 Jan 2021 10:09:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 64C7F2396D
	for <dm-devel@archiver.kernel.org>; Sun, 10 Jan 2021 10:09:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 64C7F2396D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=web.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590-dRn3QQzzMViysWe6G8jKvw-1; Sun, 10 Jan 2021 05:09:55 -0500
X-MC-Unique: dRn3QQzzMViysWe6G8jKvw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A6CDB10054FF;
	Sun, 10 Jan 2021 10:09:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B1AD60C43;
	Sun, 10 Jan 2021 10:09:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E664D180954D;
	Sun, 10 Jan 2021 10:09:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10AA9ipT022539 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 10 Jan 2021 05:09:44 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 36A1C44014; Sun, 10 Jan 2021 10:09:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3044B4405F
	for <dm-devel@redhat.com>; Sun, 10 Jan 2021 10:09:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F7DB185A794
	for <dm-devel@redhat.com>; Sun, 10 Jan 2021 10:09:40 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
	d=dkim.mimecast.com; s=201903; t=1610273380;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MDRFgtO9HLXDp4gprZkt+uOIe7zn/W+xchdFVQJq25U=;
	b=QBLZVgFaXQOeFTRi33Xjz0m6/RsRuNdVp7CiMNSO8Z98EcIbyjec2RfUyl/WgJOT56sYzy
	EQP8Z6ewDszbIEziNwc5dqoqQpI8zoPqReVHGPE1hbhmCjDXF0yKu6iTajvKwZdPUsxpEb
	ET8LUfIJ9GOxL7tnaJE63XgmBr2VQvHYcLTEw73y32HvXSecRd1j2hjK8w6T3AhqxdQslk
	oNZzR4c/HFw0N6cHOtomNrJNDb8gpPy7R2aZJj5u8N/oqW4rna4sk2yLN1QuBZTotqKF2t
	ECmhjXrnXzLbjm1tKJkAX0CoLNeMqGMjoImQVdkPeQauJKgr7DmLZYPs/QlFcA==
ARC-Seal: i=1; s=201903; d=dkim.mimecast.com; t=1610273380; a=rsa-sha256;
	cv=none;
	b=ZnTgbb610IcRqzncTbEE/qNzYoRWPKOZMLrFvJrXxg/RpCJps+mV8nOWtYoJIWCoMtkw3E
	ZundoHKWjjBgNm9bPQW2zKrUJ4KvuodbTZXX4f07FyxtI+nc+fOnFQnZQlb7fzCt4Shaua
	g7Xd/WKcNaj/dJgg8p2327HWU78Ts2Nw0bCl7gTeQuDtyThaGEdTCbyLxsDKdTNQIZswPN
	HoqA07q0Qer3fM+EAmWuriGmrbGSK8JNevy2wt3IHa4n3Yq5C//deUAtknjdqyIn6HPL4u
	gSjv+zYdqgQFwBRPq5uzGgrEpGZ0pJ4A2T3Jo5nGYTASaGmFLvogkheo7ldnHw==
ARC-Authentication-Results: i=1; relay.mimecast.com;
	dkim=pass header.d=web.de header.s=dbaedf251592 header.b=mAZwcz6Q;
	dmarc=pass (policy=none) header.from=web.de;
	spf=pass (relay.mimecast.com: domain of lukasstraub2@web.de designates
	212.227.15.14 as permitted sender)
	smtp.mailfrom=lukasstraub2@web.de
Received: from mout.web.de (mout.web.de [212.227.15.14]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-512-PW3nxiekPZKcaFnLHZw7eg-1;
	Sun, 10 Jan 2021 05:09:36 -0500
X-MC-Unique: PW3nxiekPZKcaFnLHZw7eg-1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
	s=dbaedf251592; t=1610273375;
	bh=AxyjR0avIzTuolbHm/HjCdZ2NfdLPX6wKNxqy+3mjk8=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:In-Reply-To:References;
	b=mAZwcz6QDRAAqEF6zWDRmQ6chYHKPGRbky4Obqgyb57aavtlDnJodNeLX0xvjaAfi
	TwZGBv+FpLif9m2wA8zwLNXcx2BLAbwe8/o8nh7roqDxzZ5cbbfTUX343fYLA26UOT
	hdjqCq9kKyCtwpZVNHfZNsVqdARzuZ6BinxejM2I=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from gecko.fritz.box ([94.134.180.121]) by smtp.web.de (mrweb005
	[213.165.67.108]) with ESMTPSA (Nemesis) id 1M76bb-1kslMH2UZz-008UbK;
	Sun, 10 Jan 2021 11:04:30 +0100
Date: Sun, 10 Jan 2021 11:04:22 +0100
From: Lukas Straub <lukasstraub2@web.de>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <20210110110422.3e48d140@gecko.fritz.box>
In-Reply-To: <alpine.LRH.2.02.2101081112090.17896@file01.intranet.prod.int.rdu2.redhat.com>
References: <20201220140222.2f341344@gecko.fritz.box>
	<20210104203042.GB3721@redhat.com>
	<alpine.LRH.2.02.2101081104490.17896@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.2101081112090.17896@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
X-Provags-ID: V03:K1:H8BXHWIg9hG3VSHgwrzJurWl3W9KkMrmpAUBTabhaf3oFRz6OCx
	FrUkFCxh0+f2vcOgwCdDBT0pkWXNSZvNwQ5w1sc60i/O6ER1prgt0JmLE5ZS0eN7MeX0sDZ
	fqhlTT0fsVrO3/6XwXcW2MFOsaVith1gQViaUisrlbWedBTaip8l8zX0dPOr5ba11i0cQMS
	fIARWFFUG5Q1dj7PPYfvw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:RYoKliJfOYU=:pAASHhEMC2nxz+uhdMgka3
	M2CYdUD4/SyUewxbQMSNkCZfHRUhTWuPytB8DUcfooWAWteZclYsTZIlnZ6Z12k2XuadHfZNx
	sWqxPMaeVx9FmTDNY94ehdwc0KvjvOCII+ztA4dQianrstLxntwLAAvs4muFuTPuyNleec7br
	YUZla07N7bxVsRUA7pN8wf4E3NEBDryTH24EAJXf1NuiLE6nIcVhbI2izdecfIZvvWGgFdAEH
	wB4+xSgZit+CjlwJ85va8U3J4Pbqz2Q4w8PgzpNd2lfCRcDhkVBUF0mO3OF21Pw8G2BHqlBku
	eRMtm5uCM/zTmBO7d/1Hbjjpjir/RQwKwSPIXdj7Xw7KTnAz1Wv6DMn9/pYWnSn/W6V1EwVms
	ydadv6UXaI7x3cdIzqKPpIUAswyFEC9G/GE2TjEUVX3assiLKbSNUKIM700gM/NzfhyK+MzoT
	Mx7r31a1AMnaeXphFcsx3sgLQHK0EfyWiJ6fOwdsYxAy8TDaDxlr3CNPgqQva65RI7ZVsNQjd
	a/cHTm2vBWIAkgBtdIcEtS0DTtQftNxa9b0qWSZEIeeU27w0/egkgk6vuju5WZOUjvERuJEnY
	JZtzKLteMhy4wCwDejAffyONA1XBOrRpf9+4RyCSipV0j/VgZICf/0mnUwoxsZFRQaxqIIUeC
	9r02YRW1/TLIFofGuWvmlM3WAFbo5cKd+iQR86cbJAHUM1EJvojiJd06SiobLe4zVBi7Pb6PT
	VtVor4Oa3+RUM9d7YzTK3hjemmobqMfd2BeQaAOikgVHmm8y2QzxQKD6D7dCYGYcci3hQlq6o
	zXrHCSYKo9hbsjBkbN/cSMyh5GMFI1MQtjjfw36h6+wIQDl9jkIfSQ0MZSGdElzjqmi9uAqkJ
	2yDaNXhVRzm1Ssnaiz+oOXeu2euaTyj1/zPstMszg=
Authentication-Results: relay.mimecast.com;
	dkim=pass header.d=web.de header.s=dbaedf251592 header.b=mAZwcz6Q;
	dmarc=pass (policy=none) header.from=web.de;
	spf=pass (relay.mimecast.com: domain of lukasstraub2@web.de designates
	212.227.15.14 as permitted sender)
	smtp.mailfrom=lukasstraub2@web.de
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
Cc: dm-devel <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH] dm-integrity: Fix flush with external
	metadata device
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7674295867305403413=="
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12

--===============7674295867305403413==
Content-Type: multipart/signed; boundary="Sig_/0Vt9dhgwBpz6j5.IXFhOAvA";
	protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/0Vt9dhgwBpz6j5.IXFhOAvA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 8 Jan 2021 11:15:56 -0500 (EST)
Mikulas Patocka <mpatocka@redhat.com> wrote:

> With external metadata device, flush requests are not passed down to the
> data device.
>=20
> Fix this by submitting the flush request in dm_integrity_flush_buffers. I=
n
> order to not degrade performance, we overlap the data device flush with
> the metadata device flush.
>=20
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Reported-by: Lukas Straub <lukasstraub2@web.de>
> Cc: stable@vger.kernel.org

Looks good to me.
Reviewed-by: Lukas Straub <lukasstraub2@web.de>

Regards,
Lukas Straub

> ---
>  drivers/md/dm-bufio.c     |    6 ++++
>  drivers/md/dm-integrity.c |   60 +++++++++++++++++++++++++++++++++++++--=
-------
>  include/linux/dm-bufio.h  |    1=20
>  3 files changed, 56 insertions(+), 11 deletions(-)
>=20
> Index: linux-2.6/drivers/md/dm-integrity.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/md/dm-integrity.c=092021-01-07 17:22:39.000000=
000 +0100
> +++ linux-2.6/drivers/md/dm-integrity.c=092021-01-08 15:51:19.000000000 +=
0100
> @@ -1379,12 +1379,52 @@ thorough_test:
>  #undef MAY_BE_HASH
>  }
> =20
> -static void dm_integrity_flush_buffers(struct dm_integrity_c *ic)
> +struct flush_request {
> +=09struct dm_io_request io_req;
> +=09struct dm_io_region io_reg;
> +=09struct dm_integrity_c *ic;
> +=09struct completion comp;
> +};
> +
> +static void flush_notify(unsigned long error, void *fr_)
> +{
> +=09struct flush_request *fr =3D fr_;
> +=09if (unlikely(error !=3D 0))
> +=09=09dm_integrity_io_error(fr->ic, "flusing disk cache", -EIO);
> +=09complete(&fr->comp);
> +}
> +
> +static void dm_integrity_flush_buffers(struct dm_integrity_c *ic, bool f=
lush_data)
>  {
>  =09int r;
> +
> +=09struct flush_request fr;
> +
> +=09if (!ic->meta_dev)
> +=09=09flush_data =3D false;
> +=09if (flush_data) {
> +=09=09fr.io_req.bi_op =3D REQ_OP_WRITE,
> +=09=09fr.io_req.bi_op_flags =3D REQ_PREFLUSH | REQ_SYNC,
> +=09=09fr.io_req.mem.type =3D DM_IO_KMEM,
> +=09=09fr.io_req.mem.ptr.addr =3D NULL,
> +=09=09fr.io_req.notify.fn =3D flush_notify,
> +=09=09fr.io_req.notify.context =3D &fr;
> +=09=09fr.io_req.client =3D dm_bufio_get_dm_io_client(ic->bufio),
> +=09=09fr.io_reg.bdev =3D ic->dev->bdev,
> +=09=09fr.io_reg.sector =3D 0,
> +=09=09fr.io_reg.count =3D 0,
> +=09=09fr.ic =3D ic;
> +=09=09init_completion(&fr.comp);
> +=09=09r =3D dm_io(&fr.io_req, 1, &fr.io_reg, NULL);
> +=09=09BUG_ON(r);
> +=09}
> +
>  =09r =3D dm_bufio_write_dirty_buffers(ic->bufio);
>  =09if (unlikely(r))
>  =09=09dm_integrity_io_error(ic, "writing tags", r);
> +
> +=09if (flush_data)
> +=09=09wait_for_completion(&fr.comp);
>  }
> =20
>  static void sleep_on_endio_wait(struct dm_integrity_c *ic)
> @@ -2110,7 +2150,7 @@ offload_to_thread:
> =20
>  =09if (unlikely(dio->op =3D=3D REQ_OP_DISCARD) && likely(ic->mode !=3D '=
D')) {
>  =09=09integrity_metadata(&dio->work);
> -=09=09dm_integrity_flush_buffers(ic);
> +=09=09dm_integrity_flush_buffers(ic, false);
> =20
>  =09=09dio->in_flight =3D (atomic_t)ATOMIC_INIT(1);
>  =09=09dio->completion =3D NULL;
> @@ -2195,7 +2235,7 @@ static void integrity_commit(struct work
>  =09flushes =3D bio_list_get(&ic->flush_bio_list);
>  =09if (unlikely(ic->mode !=3D 'J')) {
>  =09=09spin_unlock_irq(&ic->endio_wait.lock);
> -=09=09dm_integrity_flush_buffers(ic);
> +=09=09dm_integrity_flush_buffers(ic, true);
>  =09=09goto release_flush_bios;
>  =09}
> =20
> @@ -2409,7 +2449,7 @@ skip_io:
>  =09complete_journal_op(&comp);
>  =09wait_for_completion_io(&comp.comp);
> =20
> -=09dm_integrity_flush_buffers(ic);
> +=09dm_integrity_flush_buffers(ic, true);
>  }
> =20
>  static void integrity_writer(struct work_struct *w)
> @@ -2451,7 +2491,7 @@ static void recalc_write_super(struct dm
>  {
>  =09int r;
> =20
> -=09dm_integrity_flush_buffers(ic);
> +=09dm_integrity_flush_buffers(ic, false);
>  =09if (dm_integrity_failed(ic))
>  =09=09return;
> =20
> @@ -2654,7 +2694,7 @@ static void bitmap_flush_work(struct wor
>  =09unsigned long limit;
>  =09struct bio *bio;
> =20
> -=09dm_integrity_flush_buffers(ic);
> +=09dm_integrity_flush_buffers(ic, false);
> =20
>  =09range.logical_sector =3D 0;
>  =09range.n_sectors =3D ic->provided_data_sectors;
> @@ -2663,9 +2703,7 @@ static void bitmap_flush_work(struct wor
>  =09add_new_range_and_wait(ic, &range);
>  =09spin_unlock_irq(&ic->endio_wait.lock);
> =20
> -=09dm_integrity_flush_buffers(ic);
> -=09if (ic->meta_dev)
> -=09=09blkdev_issue_flush(ic->dev->bdev, GFP_NOIO);
> +=09dm_integrity_flush_buffers(ic, true);
> =20
>  =09limit =3D ic->provided_data_sectors;
>  =09if (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING)) {
> @@ -2934,11 +2972,11 @@ static void dm_integrity_postsuspend(str
>  =09=09if (ic->meta_dev)
>  =09=09=09queue_work(ic->writer_wq, &ic->writer_work);
>  =09=09drain_workqueue(ic->writer_wq);
> -=09=09dm_integrity_flush_buffers(ic);
> +=09=09dm_integrity_flush_buffers(ic, true);
>  =09}
> =20
>  =09if (ic->mode =3D=3D 'B') {
> -=09=09dm_integrity_flush_buffers(ic);
> +=09=09dm_integrity_flush_buffers(ic, true);
>  #if 1
>  =09=09/* set to 0 to test bitmap replay code */
>  =09=09init_journal(ic, 0, ic->journal_sections, 0);
> Index: linux-2.6/include/linux/dm-bufio.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/include/linux/dm-bufio.h=092020-09-05 10:01:42.0000000=
00 +0200
> +++ linux-2.6/include/linux/dm-bufio.h=092021-01-08 15:12:31.000000000 +0=
100
> @@ -150,6 +150,7 @@ void dm_bufio_set_minimum_buffers(struct
> =20
>  unsigned dm_bufio_get_block_size(struct dm_bufio_client *c);
>  sector_t dm_bufio_get_device_size(struct dm_bufio_client *c);
> +struct dm_io_client *dm_bufio_get_dm_io_client(struct dm_bufio_client *c=
);
>  sector_t dm_bufio_get_block_number(struct dm_buffer *b);
>  void *dm_bufio_get_block_data(struct dm_buffer *b);
>  void *dm_bufio_get_aux_data(struct dm_buffer *b);
> Index: linux-2.6/drivers/md/dm-bufio.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/md/dm-bufio.c=092021-01-08 15:11:20.000000000 =
+0100
> +++ linux-2.6/drivers/md/dm-bufio.c=092021-01-08 15:12:25.000000000 +0100
> @@ -1534,6 +1534,12 @@ sector_t dm_bufio_get_device_size(struct
>  }
>  EXPORT_SYMBOL_GPL(dm_bufio_get_device_size);
> =20
> +struct dm_io_client *dm_bufio_get_dm_io_client(struct dm_bufio_client *c=
)
> +{
> +=09return c->dm_io;
> +}
> +EXPORT_SYMBOL_GPL(dm_bufio_get_dm_io_client);
> +
>  sector_t dm_bufio_get_block_number(struct dm_buffer *b)
>  {
>  =09return b->block;
>=20



--=20


--Sig_/0Vt9dhgwBpz6j5.IXFhOAvA
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEg/qxWKDZuPtyYo+kNasLKJxdslgFAl/60SYACgkQNasLKJxd
sljg+xAAodLk9+/HC6eMIGjRpesK+O+GGUMxZ1EH88CwwSFRibqdTKeDSx8miRvU
9xiZP6OgM3MYL2qvoVdSDwbQRrqRSnCKbN9Nm1LM0oeu0/gtLdlgxCIZ8VxlXYMd
lRglIsvmvb0wTjLpeHkD94sKD/M+lCoA/zy+rqcmZwxtwbJ2Rcn7R9KX2RYFzYP7
88AVeZI2fJVatOueKbarmlOm57EDnbZGlYtTHdU61p3rThV4Hud8hgSXTJ6cUYZX
ScubxDC8snzudjnSvo0a15F62ZaVBm9/fa4jNs0SJ1oq83AbWKGjqrX8LgE0udvC
Xxq50Z7RVNZHET7wjxog2A7lvjfPMBzlzUZP64v53NA47r2PCqqljaR2V/KKU7v6
5O/9Svf3i0LsAKCFa/SZmHzEVILUGKAJglhhDF84ZNa/KMkLdLjWi3ev9jKo0dK9
k5Gd2+MLbtuglI2NSsiWMgZL86yYeQfzc/hETpowWBeh3B16g1e/2pRNJFm3uo/z
YRQ2CVsu1y3xwHmBEeFBYcJYwYObmg9aeMoUW5toXbWI/WL7TTH1+B1BXm6Za6x4
ZPiz8SkU2aNWSVxUt1YFT8bfJCV6WHBZ//7BJDhgZZdsgOtE1pJFt83UfKyKNZPn
Ii2ZNlak5POQGeCDDEE3LkWBT9TAjgPignGdfXFBo2Ldn/qN0Hk=
=73Bl
-----END PGP SIGNATURE-----

--Sig_/0Vt9dhgwBpz6j5.IXFhOAvA--


--===============7674295867305403413==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
--===============7674295867305403413==--

