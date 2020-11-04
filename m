Return-Path: <SRS0=DU+z=EK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C746C2D0A3
	for <dm-devel@archiver.kernel.org>; Wed,  4 Nov 2020 16:09:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 834E220786
	for <dm-devel@archiver.kernel.org>; Wed,  4 Nov 2020 16:09:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T1r0pehu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 834E220786
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1604506167;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ibqOK1QD5pIXoQMAgc7m2ElOrLCAu0iFxCx3gtofg8U=;
	b=T1r0pehu2mmyF1K55AnIlntqW5xcTzCA5i8S+gDuc5J+a2wFD6Q+sGUZkTqz5FfKFaWBn3
	0BCN9YyiH5A4F7upfnP3vKLQ0ZrbWSjLzO+79V8Qbt8gYeqifyB98Rrpyxo0SrwIbUbl53
	J5i7bFDVt1m85bqWAVWgbjC1Cpkae1o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-8Mf6mTT3NIupRUVHm5vM3A-1; Wed, 04 Nov 2020 11:09:24 -0500
X-MC-Unique: 8Mf6mTT3NIupRUVHm5vM3A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF19E1018F77;
	Wed,  4 Nov 2020 16:09:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 367E719C4F;
	Wed,  4 Nov 2020 16:09:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6D258181A06B;
	Wed,  4 Nov 2020 16:09:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A4G9HZP027977 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 4 Nov 2020 11:09:17 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1C1A51E2; Wed,  4 Nov 2020 16:09:17 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 934E15C5FD;
	Wed,  4 Nov 2020 16:09:13 +0000 (UTC)
Date: Wed, 4 Nov 2020 10:08:48 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <20201104150847.GB32761@redhat.com>
References: <20201020065420.124885-1-jefflexu@linux.alibaba.com>
	<20201021203906.GA10896@redhat.com>
	<da936cfa-93a8-d6ec-bd88-c0fad6c67c8b@linux.alibaba.com>
	<20201026185334.GA8463@redhat.com>
	<33c32cd1-5116-9a42-7fe2-b2a383f1c7a0@linux.alibaba.com>
	<20201102152822.GA20466@redhat.com>
	<f165f38a-91d1-79aa-829d-a9cc69a5eee6@linux.alibaba.com>
MIME-Version: 1.0
In-Reply-To: <f165f38a-91d1-79aa-829d-a9cc69a5eee6@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 04 2020 at  1:47am -0500,
JeffleXu <jefflexu@linux.alibaba.com> wrote:

>=20
> On 11/2/20 11:28 PM, Mike Snitzer wrote:
> >On Sun, Nov 01 2020 at 10:14pm -0500,
> >JeffleXu <jefflexu@linux.alibaba.com> wrote:
> >
> >>On 10/27/20 2:53 AM, Mike Snitzer wrote:
> >>>What you detailed there isn't properly modeling what it needs to.
> >>>A given dm_target_io could result in quite a few bios (e.g. for
> >>>dm-striped we clone each bio for each of N stripes).  So the fan-out,
> >>>especially if then stacked on N layers of stacked devices, to all the
> >>>various hctx at the lowest layers is like herding cats.
> >>>
> >>>But the recursion in block core's submit_bio path makes that challengi=
ng
> >>>to say the least.  So much so that any solution related to enabling
> >>>proper bio-based IO polling is going to need a pretty significant
> >>>investment in fixing block core (storing __submit_bio()'s cookie durin=
g
> >>>recursion, possibly storing to driver provided memory location,
> >>>e.g. DM initialized bio->submit_cookie pointer to a blk_qc_t within a =
DM
> >>>clone bio's per-bio-data).
> >>>
> >>>SO __submit_bio_noacct would become:
> >>>
> >>>    retp =3D &ret;
> >>>    if (bio->submit_cookie)
> >>>           retp =3D bio->submit_cookie;
> >>>    *retp =3D __submit_bio(bio);
> >>Sorry for the late reply. Exactly I missed this point before. IF you
> >>have not started working on this, I'd like to try to implement this as
> >>an RFC.
> >I did start on this line of development but it needs quite a bit more
> >work.  Even the pseudo code I provided above isn't useful in the context
> >of DM clone bios that have their own per-bio-data to assist with this
> >implementation.  Because the __submit_bio_noacct() recursive call
> >drivers/md/dm.c:__split_and_process_bio() makes is supplying the
> >original bio (modified to only point to remaining work).
>=20
> Yes I noticed this recently. Since the depth-first splitting
> introduced in commit 18a25da84354
>=20
> ("dm: ensure bio submission follows a depth-first tree walk"), one
> bio to dm device can be
>=20
> split into multiple bios to this dm device.
>=20
> ```
>=20
> one bio to dm device (dm0) =3D one dm_io (to nvme0) + one bio to this
> same dm device (dm0)
>=20
> ```
>=20
>=20
> In this case we need a mechanism to track all split sub-bios of the
> very beginning original bio.

Yes, splitting causes additional potential for sub-bios.  There are
other cases that cause a 1-to-many bio generation (e.g. dm-striped) or
splitting cases where a DM target makes use of dm_accept_partial_bio
(e.g. dm-snapshot, dm-integrity, dm-writecache, etc).


> I'm doubted if this should be implemented in block layer like:
>=20
> ```
>=20
> struct bio {
>=20
> =A0=A0=A0 ...
>=20
> =A0=A0=A0 struct list_head=A0 cookies;
>=20
> };
>=20
> ```
>=20
> After all it's only used by bio-based queue, or more specifically
> only dm device currently.

I do think this line of work really should be handled in block core
because I cannot see any reason why MD or bcache or whatever bio-based
device wouldn't want the ability to better support io_uring (with IO
poll).

> Another design I can come up with is to maintain a global data
> structure for the very beginning
> original bio. Currently the blocking point is that now one original
> bio to the dm device (@bio of dm_submit()) can correspond to multiple
> dm_io and thus we have nowhere to place the @cookies list.

Yes, and that will always be the case.  We need the design to handle an
arbitrary sprawl of splitting from a given bio.  The graph of bios
resulting from that fan-out needs to be walked at various levels -- be
it the top-level original bio's submit_bio() returned cookie or some
intermediate point in the chain of bios.

The problem is the lifetime of the data structure created for a given
split bio versus layering boundaries (that come from block core's
simplistic recursion via bio using submit_bio).

> Now we have to maintain one data structure for every original bio,
> something like
>=20
> ```
>=20
> struct dm_poll_instance {
>=20
> =A0=A0=A0 ...
>=20
> =A0=A0=A0 struct list_head cookies;
>=20
> };
>=20
> ```

I do think we need a hybrid where at the point of recursion we're able
to make the associated data structure available across the recursion
boundary so that modeling the association in a chain of split bios is
possible. (e.g. struct dm_poll_data or dm_poll_instance as you named it,
_but_ that struct definition would live in block core, but would be part
of per-bio-data; so 'struct blk_poll_data' is more logical name when
elevated to block core).

It _might_ be worthwhile to see if a new BIO_ flag could be added to
allow augmenting the bio_split + bio_chain pattern to also track this
additional case of carrying additional data per-bio while creating
bio-chains.  I may not be clear yet, said differently: augmenting
bio_chain to not only chain bios, but to _also_ thread/chain together
per-bio-data that lives within those chained bios.  SO you have the
chain of bios _and_ the chain of potentially opaque void * that happens
to point to a list head for a list of 'struct blk_poll_data'.

Does that make sense?

> We can transfer this dm_poll_instance between split bios by
> bio->bi_private, like
>=20
> ```
>=20
> dm_submit_bio(...) {
>=20
> =A0=A0=A0 struct dm_poll_instance *ins;
>=20
> =A0=A0=A0 if (bio->bi_private)
>=20
> =A0=A0=A0 =A0=A0=A0 ins =3D bio->bi_private;
>=20
> =A0=A0=A0 else {
>=20
> =A0=A0=A0 =A0=A0=A0 ins =3D alloc_poll_instance();
>=20
> =A0=A0=A0 =A0=A0=A0 bio->bi_private =3D ins;
>=20
> =A0=A0=A0 }
>=20
> =A0=A0=A0 ...
>=20
> }
>=20
> ```

Sadly, we cannot (ab)use bi_private for this given its (ab)used via the
bio_chain() interface.  It's almost like we need to add a new pointer in
the bio that isn't left for block core to hijack.

There is the well-worn pattern of saving off the original bi_private,
hooking a new endio method and then when that endio is called restoring
bi_private but we really want to avoid excessive indirect function calls
for this usecase.  The entire point of implementing blk_poll support is
for performance after all.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

