Return-Path: <SRS0=SKY2=EP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82815C388F7
	for <dm-devel@archiver.kernel.org>; Mon,  9 Nov 2020 18:15:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E4B0C20644
	for <dm-devel@archiver.kernel.org>; Mon,  9 Nov 2020 18:15:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UBqgFVEV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E4B0C20644
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1604945748;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=vv7iurXFrG3SjHPLRNM1UpaWZ4+Fe4ow0acnrri/zrY=;
	b=UBqgFVEViT8hWWX9m6w/Te4jUgKD0yc+XiLwUhfcHcbMKzKxNpOaCvOQQnF65fio232xBj
	3HgPu1aAOHAfuo0befC2LUEcpbWVcKPsD3afjVVeO80hAxIWl1nbEcvZ6mcefXNbPiO0+L
	eMaY8nvHpQTocYbEwHivEWLbrBQO6CU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-NqkMZaDqOGqYRbj2A0stMw-1; Mon, 09 Nov 2020 13:15:46 -0500
X-MC-Unique: NqkMZaDqOGqYRbj2A0stMw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AABB4106B342;
	Mon,  9 Nov 2020 18:15:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1461B5D9CC;
	Mon,  9 Nov 2020 18:15:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5AF3BCF68;
	Mon,  9 Nov 2020 18:15:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A9IFajk027006 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 9 Nov 2020 13:15:36 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7DB1375123; Mon,  9 Nov 2020 18:15:36 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 750467513A;
	Mon,  9 Nov 2020 18:15:29 +0000 (UTC)
Date: Mon, 9 Nov 2020 13:15:28 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <20201109181528.GA8599@redhat.com>
References: <20201021203906.GA10896@redhat.com>
	<da936cfa-93a8-d6ec-bd88-c0fad6c67c8b@linux.alibaba.com>
	<20201026185334.GA8463@redhat.com>
	<33c32cd1-5116-9a42-7fe2-b2a383f1c7a0@linux.alibaba.com>
	<20201102152822.GA20466@redhat.com>
	<f165f38a-91d1-79aa-829d-a9cc69a5eee6@linux.alibaba.com>
	<20201104150847.GB32761@redhat.com>
	<2c5dab21-8125-fcdf-078e-00a158c57f43@linux.alibaba.com>
	<20201106174526.GA13292@redhat.com>
	<23c73ad7-23e3-3172-8f0e-3c15e0fa5a87@linux.alibaba.com>
MIME-Version: 1.0
In-Reply-To: <23c73ad7-23e3-3172-8f0e-3c15e0fa5a87@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, xiaoguang.wang@linux.alibaba.com,
	linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
	dm-devel@redhat.com, haoxu@linux.alibaba.com, io-uring@vger.kernel.org
Subject: Re: [dm-devel] [RFC 0/3] Add support of iopoll for dm device
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
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 07 2020 at  8:09pm -0500,
JeffleXu <jefflexu@linux.alibaba.com> wrote:

>=20
> On 11/7/20 1:45 AM, Mike Snitzer wrote:
> >On Thu, Nov 05 2020 at  9:51pm -0500,
> >JeffleXu <jefflexu@linux.alibaba.com> wrote:
> >
> >>blk-mq.c: blk_mq_submit_bio
> >>
> >> =A0=A0=A0 if (bio->orig)
> >>
> >> =A0=A0=A0 =A0=A0=A0 init blk_poll_data and insert it into bio->orig's =
@cookies list
> >>
> >>```
> >If you feel that is doable: certainly give it a shot.
>=20
> Make sense.
>=20
> >But it is not clear to me how you intend to translate from cookie passed
> >in to ->blk_poll hook (returned from submit_bio) to the saved off
> >bio->orig.
> >
> >What is your cookie strategy in this non-recursive implementation?  What
> >will you be returning?  Where will you be storing it?
>=20
> Actually I think it's a common issue to design the cookie returned
> by submit_bio() whenever it's implemented in a recursive or
> non-recursive way. After all you need to translate the returned cookie
> to the original bio even if it's implemented in a recursive way as you
> described.

Yes.

> Or how could you walk through the bio graph when the returned cookie
> is only 'unsigned int' type?

You could store a pointer (to orig bio, or per-bio-data stored in split
clone, or whatever makes sense for how you're associating poll data with
split bios) in 'unsigned int' type but that's very clumsy -- as I
discovered when trying to do that ;)

> How about this:
>=20
>=20
> ```
>=20
> typedef uintptr_t blk_qc_t;
>=20
> ```
>=20
>=20
> or something like union
>=20
> ```
>=20
> typedef union {
>=20
> =A0=A0=A0 unsigned int cookie;
>=20
> =A0=A0=A0 struct bio *orig; // the original bio of submit_bio()
>=20
> } blk_qc_t;
>=20
> ```
> When serving for blk-mq, the integer part of blk_qc_t is used and it
> stores the valid cookie, while it stores a pointer to the original bio
> when serving bio-based device.

Union looks ideal, but maybe make it a void *?  Initial implementation
may store bio pointer but it _could_ evolve to be 'struct blk_poll_data
*' or whatever.  But not a big deal either way.

> By the way, would you mind sharing your plan and progress on this
> work, I mean, supporting iopoll for dm device. To be honest, I don't
> want to re-invent the wheel as you have started on this work, but I do
> want to participate in somehow. Please let me know if there's something
> I could do here.

I thought I said as much before but: I really don't have anything
meaningful to share.  My early exploration was more rough pseudo code
that served to try to get my arms around the scope of the design
problem.

Please feel free to own all aspects of this work.

I will gladly help analyze/test/refine your approach once you reach the
point of sharing RFC patches.

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

