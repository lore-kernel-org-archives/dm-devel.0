Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E99D6C43334
	for <dm-devel@archiver.kernel.org>; Thu, 16 Jun 2022 17:20:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-348-KnAmMt-XP2eKP7uHYDH92A-1; Thu, 16 Jun 2022 13:20:24 -0400
X-MC-Unique: KnAmMt-XP2eKP7uHYDH92A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ABF653C0D85C;
	Thu, 16 Jun 2022 17:20:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 75E3D1121319;
	Thu, 16 Jun 2022 17:20:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2BE041947069;
	Thu, 16 Jun 2022 17:20:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7DC3D194705D
 for <dm-devel@listman.corp.redhat.com>; Thu, 16 Jun 2022 17:09:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2BF6740CFD0A; Thu, 16 Jun 2022 17:09:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 27C7B40CF8E4
 for <dm-devel@redhat.com>; Thu, 16 Jun 2022 17:09:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EB6198517C2
 for <dm-devel@redhat.com>; Thu, 16 Jun 2022 17:09:00 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-502-9EFktPZ5NVSoCxORf56_nQ-1; Thu, 16 Jun 2022 13:08:56 -0400
X-MC-Unique: 9EFktPZ5NVSoCxORf56_nQ-1
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2
 (Red Hat Linux)) id 1o1rzE-003Jg0-9g; Thu, 16 Jun 2022 16:04:48 +0000
Date: Thu, 16 Jun 2022 09:04:48 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Pankaj Raghav <p.raghav@samsung.com>
Message-ID: <YqtUoK4KzvG7NQS0@bombadil.infradead.org>
References: <20220615101920.329421-1-p.raghav@samsung.com>
 <CGME20220615101931eucas1p15ed09ae433a2c378b599e9086130d8eb@eucas1p1.samsung.com>
 <20220615101920.329421-3-p.raghav@samsung.com>
 <857c444a-02b9-9cef-0c5b-2ecdb2fd46f6@acm.org>
 <e04db101-5628-2a1d-6b5c-997090484d7d@samsung.com>
MIME-Version: 1.0
In-Reply-To: <e04db101-5628-2a1d-6b5c-997090484d7d@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v7 02/13] block: allow blk-zoned devices to
 have non-power-of-2 zone size
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
Cc: axboe@kernel.dk, Bart Van Assche <bvanassche@acm.org>, pankydev8@gmail.com,
 gost.dev@samsung.com, damien.lemoal@opensource.wdc.com,
 jiangbo.365@bytedance.com, linux-nvme@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 snitzer@redhat.com, jonathan.derrick@linux.dev, Johannes.Thumshirn@wdc.com,
 dsterba@suse.com, jaegeuk@kernel.org, hch@lst.de
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 16, 2022 at 12:09:35PM +0200, Pankaj Raghav wrote:
> On 2022-06-15 22:28, Bart Van Assche wrote:
> >> +=A0=A0=A0=A0=A0=A0=A0 if (!is_power_of_2(zone->len) && zone->capacity=
 < zone->len) {
> >> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pr_warn("%s: Invalid zone capacity =
for non power of 2
> >> zone size",
> >> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 disk->disk_name);
> >> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -ENODEV;
> >> =A0=A0=A0=A0=A0=A0=A0=A0=A0 }
> >=20
> > The above check seems wrong to me. I don't see why devices that report =
a
> > capacity that is less than the zone size should be rejected.
> >=20
> This was brought up by Damien during previous reviews. The argument was
> that the reason to allow non power-of-2 zoned device is to remove the
> gaps between zone size and zone capacity. Allowing a npo2 zone size with
> a different capacity, even though it is technically possible, it does
> not make any practical sense. That is why this check was introduced.
> Does that answer your question?

Perhaps just add a comment because unless you are involved in the prior
reviews this might not be clear.

  Luis

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

