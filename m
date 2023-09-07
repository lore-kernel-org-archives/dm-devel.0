Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4056EC8750
	for <dm-devel@archiver.kernel.org>; Thu,  7 Sep 2023 19:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694114064;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ttQ2q+9KfBma5pj+caI+GxU5pfcgOQvDGAgBkOxxI5s=;
	b=ZuqPXHvKxnAM3HXfLee4yQ/9/lW0xyzxJe+2DStY1gja9nNZrsxjs51wYIvCljCG3IZVms
	UfIwcYXY4QU7LWWvb+D0vVkRK0GGEavxfczbvioM9HhrGCazJdLDxec2iAfe4a6IiNufJA
	FfFsrReIDZ3dmwc2lN+lNI4IHB3trC8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-454-Qou-i6JZNcW0DTF5BHRJ4Q-1; Thu, 07 Sep 2023 15:14:21 -0400
X-MC-Unique: Qou-i6JZNcW0DTF5BHRJ4Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 27DD23C11A0C;
	Thu,  7 Sep 2023 19:14:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 203567B62;
	Thu,  7 Sep 2023 19:14:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C7B6B194658F;
	Thu,  7 Sep 2023 19:14:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 368A3194658C
 for <dm-devel@listman.corp.redhat.com>; Thu,  7 Sep 2023 19:14:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 12356C03295; Thu,  7 Sep 2023 19:14:14 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E145DC03293;
 Thu,  7 Sep 2023 19:14:13 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 387JE5xv001550;
 Thu, 7 Sep 2023 14:14:05 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 387JE5BZ001549;
 Thu, 7 Sep 2023 14:14:05 -0500
Date: Thu, 7 Sep 2023 14:14:04 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Message-ID: <20230907191404.GG7412@octiron.msp.redhat.com>
References: <20230901180235.23980-1-mwilck@suse.com>
 <20230901180235.23980-19-mwilck@suse.com>
 <20230906224708.GC7412@octiron.msp.redhat.com>
 <5cef84987794cc449028055a63c522c1ea690738.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <5cef84987794cc449028055a63c522c1ea690738.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH 18/21] libmultipath: keep bindings in memory
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 07, 2023 at 12:30:53PM +0200, Martin Wilck wrote:
> On Wed, 2023-09-06 at 17:47 -0500, Benjamin Marzinski wrote:
> > On Fri, Sep 01, 2023 at 08:02:31PM +0200, mwilck@suse.com=A0wrote:
> > > From: Martin Wilck <mwilck@suse.com>
> > >=20

> > > +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(bindings, bdg, i) {
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0int curr_id =3D scan_de=
vname(bdg->alias, prefix);
> >=20
> > If we know that the bindings will be sorted by alias order, we don't
> > need to do all this. Something like this should work:
>=20
> That's true. Unfortunately, we can't ensure ordering "by alias order".
> The reason is that our configuration allows using different alias
> prefixes for different devices. The current sorting is simply
> alphabetical. It detects duplicates, but it ensures "alias order" only
> between "mpatha" and "mpathz".
>=20
> I've thought of just removing the "different aliases for different
> devices" feature. I don't know if any users out there actually set
> device-specific alias_prefix values in the devices section of
> multipath.conf. I don't recall having seen such a configuration so far;
> almost every config I have seen simply uses "mpath" everywhere. But I
> recognize that it may feel tempting in some cases. One could use the
> "NETAPP" prefix for some arrays and the "EMC" prefix for others, for
> example, making it easier to see which is what. And we simply don't
> know if we'd break existing user setups with such a change. So if at
> all, we can't do it in a minor release without deprecating it first.
>=20
> When we add a binding in add_binding(), we don't know which
> alias_prefix is configured for a given WWID, and we have no easy way to
> figure it out. We know the alias, but we don't know which portion of it
> is the prefix and which is the ID (it's not forbidden to use "aaaa" as
> alias_prefix). I wouldn't want to start guessing.
>=20
> If you can think of a way to keep the bindings cleanly sorted, please
> let me know.

Doh! You even mentioned this issue in your "fix alias tests" commit. I
just didn't pay enough attention to it. But I believe there is a way to
make sure that we are dealing with a correctly sorted list of potential
bindings when calling get_free_id(), if we decide it's worth the extra
work.

The global_bindings isn't guaranteed to have all the bindings for our
prefix correctly sorted, but they will all be in a group.  If we wanted,
we could create a new vector that just included these bindings, and sort
it using the current prefix and a comparison function to do alias-sytle
sorting. the msort_r() function takes an extra argument to pass to the
compar() function, which could be the prefix.

It would be great if we could just sort part of the global_bindings
vector in place, once we knew the prefix.  Unfortunately, that would
only work if we could know that no prefix can ever match a starting
substring of another prefix. Otherwise, sorting using one can make the
other not be in a single continuous group.  For instance, if some device
configs used "mpatha" as a prefix, they would expect "mpathaaa" to
follow immediately after "mapthaz", but if the bindings file had already
been sorted using the "mpath" prefix, then "mpathba" would follow
"mpathaz", and "mpathaaa" would come much later. Keeping the global file
alphabetically sorted guarantees that no matter the prefix that devices
were added under, all device aliases that are valid with that prefix
will be in a group together.
=20
So, is it worth it to make another vector, copy the alises which are
valid with the current prefix into it, and then sort it? get_free_id()
will be cleaner, and gap detection won't break down after you get past
mpathaa, which it currently does with an alpahbetically sorted bindings
list.

Alternatively, we could just decide that setting a prefix in a device
config that matches the starting substring of a another prefix is a
config error (obviously using the exact same prefix is fine), and ignore
that prefix from the device config when we parse the configuration. Then
we could read in the bindings alphabetically like we currently do, find
the prefix groups in them, and sort them once, in-place. When allocating
a binding, we would need to search backwards through the bindings till
we found the end of the group matching our prefix (or an alias that
comes alphabetically before our prefix). Then we would have to search
backwards through our prefix group using the id, till we found a binding
with a smaller id.

Thoughts?

-Ben

> >=20
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (curr_id <=3D 0)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0continue;
> >=20
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0while (id < curr_id) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0if (!id_already_taken(id, prefix, map_wwid))
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0return id;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0id++;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (id =3D=3D INT_MAX)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0break;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0id++;
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0if (id =3D=3D INT_MAX)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "no more ava=
ilable user_friendly_names");
> > =A0=A0=A0=A0=A0=A0=A0=A0return id < INT_MAX ? id : -1;
> > }
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

