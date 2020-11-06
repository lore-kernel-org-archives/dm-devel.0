Return-Path: <SRS0=owAl=EM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EFD7C388F2
	for <dm-devel@archiver.kernel.org>; Fri,  6 Nov 2020 18:46:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BE08420702
	for <dm-devel@archiver.kernel.org>; Fri,  6 Nov 2020 18:46:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FT9ijN4L"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE08420702
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1604688370;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ogX6xTA7NL8KzwtKrWzBJU0VWcLVe1dWnrb7sIh2N3Q=;
	b=FT9ijN4LXlywUM1MAzPWsf+5XpN2VTVgDnk22bq0q0zolpNAVLWtckoUF75JjMxbQQGY/s
	t3Mi+RoMGUIDy0YlHyIWMw9y53p9PGOMwZBlP3BNAXa2ABCDiznULtvUXnaO6XGw6dQOaS
	qPO35xvCPfq7eKspSsywyEE4tBId9pY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-80-5OPjjmGsOaS4zhye_9VJaQ-1; Fri, 06 Nov 2020 13:46:07 -0500
X-MC-Unique: 5OPjjmGsOaS4zhye_9VJaQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E59C78049F3;
	Fri,  6 Nov 2020 18:46:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C71527664C;
	Fri,  6 Nov 2020 18:46:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D28B718037C6;
	Fri,  6 Nov 2020 18:45:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A6IjtcG025991 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 6 Nov 2020 13:45:55 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B15ED5B4C6; Fri,  6 Nov 2020 18:45:55 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D5E876645;
	Fri,  6 Nov 2020 18:45:52 +0000 (UTC)
Date: Fri, 6 Nov 2020 12:45:26 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <20201106174526.GA13292@redhat.com>
References: <20201020065420.124885-1-jefflexu@linux.alibaba.com>
	<20201021203906.GA10896@redhat.com>
	<da936cfa-93a8-d6ec-bd88-c0fad6c67c8b@linux.alibaba.com>
	<20201026185334.GA8463@redhat.com>
	<33c32cd1-5116-9a42-7fe2-b2a383f1c7a0@linux.alibaba.com>
	<20201102152822.GA20466@redhat.com>
	<f165f38a-91d1-79aa-829d-a9cc69a5eee6@linux.alibaba.com>
	<20201104150847.GB32761@redhat.com>
	<2c5dab21-8125-fcdf-078e-00a158c57f43@linux.alibaba.com>
MIME-Version: 1.0
In-Reply-To: <2c5dab21-8125-fcdf-078e-00a158c57f43@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 05 2020 at  9:51pm -0500,
JeffleXu <jefflexu@linux.alibaba.com> wrote:

>=20
> On 11/4/20 11:08 PM, Mike Snitzer wrote:
> >>I'm doubted if this should be implemented in block layer like:
> >>
> >>```
> >>
> >>struct bio {
> >>
> >> =A0=A0=A0 ...
> >>
> >> =A0=A0=A0 struct list_head=A0 cookies;
> >>
> >>};
> >>
> >>```
> >>
> >>After all it's only used by bio-based queue, or more specifically
> >>only dm device currently.
> >I do think this line of work really should be handled in block core
> >because I cannot see any reason why MD or bcache or whatever bio-based
> >device wouldn't want the ability to better support io_uring (with IO
> >poll).
> >
> >>Another design I can come up with is to maintain a global data
> >>structure for the very beginning
> >>original bio. Currently the blocking point is that now one original
> >>bio to the dm device (@bio of dm_submit()) can correspond to multiple
> >>dm_io and thus we have nowhere to place the @cookies list.
> >Yes, and that will always be the case.  We need the design to handle an
> >arbitrary sprawl of splitting from a given bio.  The graph of bios
> >resulting from that fan-out needs to be walked at various levels -- be
> >it the top-level original bio's submit_bio() returned cookie or some
> >intermediate point in the chain of bios.
> >
> >The problem is the lifetime of the data structure created for a given
> >split bio versus layering boundaries (that come from block core's
> >simplistic recursion via bio using submit_bio).
> >
> >>Now we have to maintain one data structure for every original bio,
> >>something like
> >>
> >>```
> >>
> >>struct dm_poll_instance {
> >>
> >> =A0=A0=A0 ...
> >>
> >> =A0=A0=A0 struct list_head cookies;
> >>
> >>};
> >>
> >>```
> >I do think we need a hybrid where at the point of recursion we're able
> >to make the associated data structure available across the recursion
> >boundary so that modeling the association in a chain of split bios is
> >possible. (e.g. struct dm_poll_data or dm_poll_instance as you named it,
> >_but_ that struct definition would live in block core, but would be part
> >of per-bio-data; so 'struct blk_poll_data' is more logical name when
> >elevated to block core).
> >
> >It _might_ be worthwhile to see if a new BIO_ flag could be added to
> >allow augmenting the bio_split + bio_chain pattern to also track this
> >additional case of carrying additional data per-bio while creating
> >bio-chains.  I may not be clear yet, said differently: augmenting
> >bio_chain to not only chain bios, but to _also_ thread/chain together
> >per-bio-data that lives within those chained bios.  SO you have the
> >chain of bios _and_ the chain of potentially opaque void * that happens
> >to point to a list head for a list of 'struct blk_poll_data'.
> >
> >Does that make sense?
>=20
>=20
> I'm doubted if it really makes sense to maintain a *complete* bio
> chain across the recursive
>=20
> call boundary.
>=20
>=20
> Considering the following device stack:
>=20
> ```
>=20
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0=A0=A0 =A0=
=A0=A0 =A0=A0=A0 dm0
>=20
> =A0=A0=A0 =A0=A0=A0 dm1=A0=A0=A0 =A0=A0=A0 =A0=A0 =A0=A0=A0 =A0=A0=A0 dm2=
=A0=A0=A0 =A0=A0=A0 =A0=A0 dm3
>=20
> nvme0=A0 nvme1=A0=A0=A0=A0=A0=A0=A0=A0=A0 ....=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 ....
>=20
> ```
>=20
>=20
> We have the following bio graph (please let me know if it's wrong or
> the image can't display)
>=20
>=20
> For example, for dm1 there are three bios containing valid cookie in
> the end, that is
>=20
> bio 9/10/11. We only need to insert the corresponding blk_poll_data
> (containing
>=20
> request_queue, cookie, etc) of these three bios into the very
> beginning original
>=20
> bio (that is bio0). Of course we can track all the sub-bios down
> through the device
>=20
> stack, layer by layer, e.g.,
>=20
> - get bio 1/2/3 from bio 0
>=20
> - get bio 4 from bio 3
>=20
> - finally get bio 9 from bio 4
>=20
> But I'm doubted if it's overkill to just implement the iopoll.
>=20
>=20
> Another issue still unclear is that, if we should implement the
> iopoll in a recursive way.
>=20
> In a recursive way, to poll dm 0, we should poll all its
> sub-devices, that is, bio 4/5/7/8.
>=20
> Oppositely we can insert only the bottom bio (bio 9/10/11 which have
> valid cookie) at
>=20
> the very beginning (at submit_bio() phase), and to poll dm 0, we
> only need to poll bio 9/10/11.

I feel we need the ability to walk the entire graph and call down to
next level.  The lowest level would be what you call a "valid cookie"
that blk-mq returned.  But the preceding cookies need to be made valid
and used when walking the graph (from highest to lowest) and calling
down to the underlying layers.

>=20
>=20
> To implement this non-recursive design, we can add a field in struct bio
>=20
> ```
>=20
> struct bio {
>=20
> =A0=A0=A0 ...
>=20
> =A0=A0=A0 struct bio *orig;
>=20
> }
>=20
> ```
>=20
> @orig points to the original bio inputted into submit_bio(), that is, bio=
 0.
>=20
>=20
> @orig field is transmitted through bio splitting.
>=20
> ```
>=20
> bio_split()
>=20
> =A0=A0=A0 split->orig =3D bio->orig ? : bio
>=20
>=20
> dm.c: __clone_and_map_data_bio
>=20
> =A0=A0=A0 clone->orig =3D bio->orig ? : bio
>=20
> ```
>=20
>=20
> Finally bio 9/10/11 can be inserted into bio 0.
>=20
> ```
>=20
> blk-mq.c: blk_mq_submit_bio
>=20
> =A0=A0=A0 if (bio->orig)
>=20
> =A0=A0=A0 =A0=A0=A0 init blk_poll_data and insert it into bio->orig's @co=
okies list
>=20
> ```

If you feel that is doable: certainly give it a shot.

But it is not clear to me how you intend to translate from cookie passed
in to ->blk_poll hook (returned from submit_bio) to the saved off
bio->orig.

What is your cookie strategy in this non-recursive implementation?  What
will you be returning?  Where will you be storing it?

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

