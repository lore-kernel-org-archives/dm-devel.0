Return-Path: <SRS0=/P3g=KH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6BD6C433B4
	for <dm-devel@archiver.kernel.org>; Wed, 12 May 2021 19:53:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5FEBA613F7
	for <dm-devel@archiver.kernel.org>; Wed, 12 May 2021 19:53:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5FEBA613F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1620849206;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=gNj/qdB1a7lUJW3iossmMVhN9maVqfJhafVtI5Yw6i8=;
	b=Y3TWwnSxwJOYYutAkUV7YifcRGi2MndDySUP3m7VY5FUxP5XgoV1sNgjB79B16TEs8VPoQ
	kCQtCANDAUIicQ8e4wjLUAnVp/tJMJhCsv/ck+ISSAOi9i0zALXdUBPJVBvMEL4YlZWBvH
	g7oVw9V2iJOQeEuM8Bn1OZclRFttEHY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-9JbOKbpmMhO_P7TV30fTpw-1; Wed, 12 May 2021 15:53:22 -0400
X-MC-Unique: 9JbOKbpmMhO_P7TV30fTpw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 288B71854E27;
	Wed, 12 May 2021 19:53:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3BD6A5D9D7;
	Wed, 12 May 2021 19:53:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 975F01800BB0;
	Wed, 12 May 2021 19:53:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14CJrCFa012621 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 12 May 2021 15:53:12 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A4D0860916; Wed, 12 May 2021 19:53:12 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E525E6086F;
	Wed, 12 May 2021 19:53:08 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 14CJr6PM004670; 
	Wed, 12 May 2021 14:53:06 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 14CJr5FY004669;
	Wed, 12 May 2021 14:53:05 -0500
Date: Wed, 12 May 2021 14:53:05 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20210512195305.GE25887@octiron.msp.redhat.com>
References: <1620775324-23984-1-git-send-email-bmarzins@redhat.com>
	<1620775324-23984-4-git-send-email-bmarzins@redhat.com>
	<66c4ca02bb90a7a4c18819082d2ec554ddc56205.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <66c4ca02bb90a7a4c18819082d2ec554ddc56205.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 3/5] multipathd: make ev_remove_path return
 success on path removal
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

On Wed, May 12, 2021 at 11:38:08AM +0000, Martin Wilck wrote:
> On Tue, 2021-05-11 at 18:22 -0500, Benjamin Marzinski wrote:
> > When ev_remove_path() returns success, callers assume that the path
> > (and
> > possibly the map) has been removed.=A0 When ev_remove_path() returns
> > failure, callers assume that the path has not been removed. However,
> > the
> > path could be removed on both success or failure. This could cause
> > callers to dereference the path after it was removed. Change
> > ev_remove_path() to return success whenever the path is removed, even
> > if
> > the map was removed due to a failure when trying to reload it. Found by
> > coverity.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>=20
> This looks ok, but I'd like to discuss it in some more depth.
>=20
> We need to clarify the meaning of the return code of ev_remove_path().
> We guarantee that, when ev_remove_path() returns, either the path is
> removed from internal data structures and kernel maps, or INIT_REMOVED
> is set. We can't guarantee whether the path
>=20
>  a) is not referenced any more by any kernel map,
>  b) was actually removed from pathvec and other data structures in
> multipathd.
>=20
> We have to agree on whether it means a) or b) if we can't make these
> two cases equivalent. Assuming multipathd has correct information about
> the kernel mappings, the only difference between a) and b) is the
> unlikely failure in setup_multipath(), where a) is true and b) is not
> (because sync_map_state() won't be called).=A0Your patch assumes the
> semantics of a), which is correct AFAICS, but should be more clearly
> documented.

Well, actually because of wait_for_udev and !need_do_map, a successful
return can still leave the kernel maps and internal structures
unchanged. It's just that callers have to assume that b is the case.
=20
> Actually, I think we can fix the discrepancy between a) and b) - if
> domap() was successful, we should be able to orphan the path, even if
> update_multipath_strings() failed for some reason.

I'm pretty sure that this is already the case.  This comment

 /*
  * Successful map reload without this path:
  * sync_map_state() will free it.
  */

is a lie. If setup_multipath() succeeds, the path will get removed by
check_removed_paths() via:

__setup_multipath -> update_path_strings -> sync_paths -> check_removed_pat=
hs

If setup_multipath() fails, the path will get removed by
remove_map_and_stop_waiter() via:

__setup_multipath -> remove_map_and_stop_waiter -> remove_map -> orphan_pat=
hs

So AFAICS, the only way for a path not to get removed is if you succeed
with wait_for_udev or !need_do_map, or if you fail in domap.

> IMO we should consequently change the retval for the cases where
> ev_remove_path() returns without deleting the path for a non-"failure"
> case (wait_for_udev and !need_do_map).

So you think these should return failure? For need_do_map, I think we
would want to distinguish between cases where everything worked
correctly and we're just waiting to update the map, and cases where
something went wrong. Since wait_for_udev can happen in more situations,
it's a lot harder to say what the right answer is. For cli_add_path and
uev_add_path, it seems like we want to know if the path was really
removed. So returning failure there makes sense.  For cli_del_path and
uev_remove_path, it seems like we want to avoid spurious error messages
when everything went alright and we're just waiting to update the map.
So returning success makes sense there.

Perhaps the answer is to return symbolic values, to describe what
actually happened, rather than success or failure. They could either be
bitmask values or we could have helper functions to help checking
for multiple valid return values.

> Thoughts? Whatever we decide wrt the semantics of the return code, we
> should document it clearly in comments at the function header.
>=20
> Here's a quick review of callers:
>=20
>  - cli_add_path(): AFAICS this needs b) semantics. We shouldn't set up
> a new path unless it had been successfully removed internally.
>  - cli_del_path(): needs a) semantics.
>  - handle_path_wwid_change(): needs a).
>  - uev_add_path(): needs a).
>  - uev_remove_path(): the return code of ev_remove_path doesn't matter
> much here. This is the only caller that sets need_do_map =3D false.
>  - uev_update_path(): we currently don't look at the return code.
> uev_add_path() will make another attempt at removing the path if
> necessary.
>=20
> Regards
> Martin
>=20
> P.S.: The remaining failure cases in ev_remove_path() are the failures
> in update_mpp_paths() and setup_map(). The former can only fail with
> ENOMEM, afaics. The latter, likewise, or if the map is fundamentally
> misconfigured (which to me means that a previous call to setup_map()
> would have failed as well). I'm wondering why we remove the entire map
> in these failure cases. This goes back all the way to 45eb316=A0
> ("[multipathd] DM configuration final cut") from 2005. It's true that
> both failures are pretty much fatal, but why is removing the map the
> answer here?

I don't think it has to be the answer. There are other cases where
setup_map() fails and we don't automatically wipe the map.  I did
consider changing it when I was looking through ev_remove_path(), but
I've never known this code to cause any issues, and as you mention,
it isn't wrong to do so, just not really necessary AFAICS.

> However, this goes beyond the purpose of your patch. *If* we remove the
> map, returning 0 is correct for either a) or b).
>=20
> P.S. 2: I wonder if the logic in uev_update_path() is correct. Rather
> than calling uev_add_path() after rescan_path() directly, I think we
> should rather wait for another uevent (and possibly trigger another
> "add" event, I don't think "rescan" automatically generates one).
>=20

Yep. You're correct. I'll fix that.

-Ben

>=20
> > ---
> > =A0multipathd/main.c | 6 ++++--
> > =A01 file changed, 4 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index 6090434c..4bdf14bd 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -1284,7 +1284,7 @@ ev_remove_path (struct path *pp, struct vectors *
> > vecs, int need_do_map)
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0strlcpy(devt, pp->dev_t, sizeof(devt));
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0if (setup_multipath(vecs, mpp))
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0/*
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 * Successful map reload without this path:
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 * sync_map_state() will free it.
> > @@ -1304,8 +1304,10 @@ out:
> > =A0=A0=A0=A0=A0=A0=A0=A0return retval;
> > =A0
> > =A0fail:
> > +=A0=A0=A0=A0=A0=A0=A0condlog(0, "%s: error removing path. removing map=
 %s", pp->dev,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp->alias);
> > =A0=A0=A0=A0=A0=A0=A0=A0remove_map_and_stop_waiter(mpp, vecs);
> > -=A0=A0=A0=A0=A0=A0=A0return 1;
> > +=A0=A0=A0=A0=A0=A0=A0return 0;
> > =A0}
> > =A0
> > =A0static int

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

