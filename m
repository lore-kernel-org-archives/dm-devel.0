Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7FD9EEB561
	for <dm-devel@archiver.kernel.org>; Fri,  8 Sep 2023 17:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694193751;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=nPLZn52S5IBClYjc5gJG+4k44IQcw1d6mkOMUlwQWko=;
	b=hPguMe3UP/91fyBgSV2Qujx3C+8IcNLfUDI1eiboVEQ1os9mXocTK+p6y72zTscKiuOhJW
	JIab9orBThwYDWHvP5251/mmyaa6nU7R2bpmUcuACTlVKklAZ5smsS8GP4RVB1/N/VEo6j
	xNcn7GjcPty0CttgMNdalM9DxlqShE4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-581-q1hppNtLM9mGEBHga8cZGw-1; Fri, 08 Sep 2023 13:22:28 -0400
X-MC-Unique: q1hppNtLM9mGEBHga8cZGw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25E50816525;
	Fri,  8 Sep 2023 17:22:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 95ADB493112;
	Fri,  8 Sep 2023 17:22:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 48A61194658C;
	Fri,  8 Sep 2023 17:22:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0E5E91946586
 for <dm-devel@listman.corp.redhat.com>; Fri,  8 Sep 2023 17:22:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D4773C03299; Fri,  8 Sep 2023 17:22:24 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AF21AC03296;
 Fri,  8 Sep 2023 17:22:24 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 388HMGqD006937;
 Fri, 8 Sep 2023 12:22:16 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 388HMFRa006936;
 Fri, 8 Sep 2023 12:22:15 -0500
Date: Fri, 8 Sep 2023 12:22:15 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Message-ID: <20230908172215.GI7412@octiron.msp.redhat.com>
References: <20230901180235.23980-1-mwilck@suse.com>
 <20230901180235.23980-19-mwilck@suse.com>
 <20230906224708.GC7412@octiron.msp.redhat.com>
 <5cef84987794cc449028055a63c522c1ea690738.camel@suse.com>
 <20230907191404.GG7412@octiron.msp.redhat.com>
 <20230907200257.GH7412@octiron.msp.redhat.com>
 <97ae2fd39a6f927441ebb861bf62d2e1a3223b9b.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <97ae2fd39a6f927441ebb861bf62d2e1a3223b9b.camel@suse.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 07, 2023 at 10:43:27PM +0200, Martin Wilck wrote:
> On Thu, 2023-09-07 at 15:02 -0500, Benjamin Marzinski wrote:
> > On Thu, Sep 07, 2023 at 02:14:04PM -0500, Benjamin Marzinski wrote:
> > > On Thu, Sep 07, 2023 at 12:30:53PM +0200, Martin Wilck wrote:
> > > > On Wed, 2023-09-06 at 17:47 -0500, Benjamin Marzinski wrote:
> > > > > On Fri, Sep 01, 2023 at 08:02:31PM +0200,
> > > > > mwilck@suse.com=A0wrote:
> > > > > > From: Martin Wilck <mwilck@suse.com>
> > > Doh! You even mentioned this issue in your "fix alias tests"
> > > commit. I
> > > just didn't pay enough attention to it. But I believe there is a
> > > way to
> > > make sure that we are dealing with a correctly sorted list of
> > > potential
> > > bindings when calling get_free_id(), if we decide it's worth the
> > > extra
> > > work.
> > >=20
> > > The global_bindings isn't guaranteed to have all the bindings for
> > > our
> > > prefix correctly sorted, but they will all be in a group.=A0 If we
> > > wanted,
> > > we could create a new vector that just included these bindings, and
> > > sort
> > > it using the current prefix and a comparison function to do alias-
> > > sytle
> > > sorting. the msort_r() function takes an extra argument to pass to
> > > the
> > > compar() function, which could be the prefix.
> > >=20
> > > It would be great if we could just sort part of the global_bindings
> > > vector in place, once we knew the prefix.=A0 Unfortunately, that
> > > would
> > > only work if we could know that no prefix can ever match a starting
> > > substring of another prefix. Otherwise, sorting using one can make
> > > the
> > > other not be in a single continuous group.=A0 For instance, if some
> > > device
> > > configs used "mpatha" as a prefix, they would expect "mpathaaa" to
> > > follow immediately after "mapthaz", but if the bindings file had
> > > already
> > > been sorted using the "mpath" prefix, then "mpathba" would follow
> > > "mpathaz", and "mpathaaa" would come much later. Keeping the global
> > > file
> > > alphabetically sorted guarantees that no matter the prefix that
> > > devices
> > > were added under, all device aliases that are valid with that
> > > prefix
> > > will be in a group together.
> > > =A0
> > > So, is it worth it to make another vector, copy the alises which
> > > are
> > > valid with the current prefix into it, and then sort it?
> > > get_free_id()
> > > will be cleaner, and gap detection won't break down after you get
> > > past
> > > mpathaa, which it currently does with an alpahbetically sorted
> > > bindings
> > > list.
> > >=20
> > > Alternatively, we could just decide that setting a prefix in a
> > > device
> > > config that matches the starting substring of a another prefix is a
> > > config error (obviously using the exact same prefix is fine), and
> > > ignore
> > > that prefix from the device config when we parse the configuration.
> > > Then
> > > we could read in the bindings alphabetically like we currently do,
> > > find
> > > the prefix groups in them, and sort them once, in-place. When
> > > allocating
> > > a binding, we would need to search backwards through the bindings
> > > till
> > > we found the end of the group matching our prefix (or an alias that
> > > comes alphabetically before our prefix). Then we would have to
> > > search
> > > backwards through our prefix group using the id, till we found a
> > > binding
> > > with a smaller id.
> >=20
> > So, thinking about this a little more, assuming we would be writing
> > out
> > the bindings file in full alias sorted order, it's stupid to sort it
> > alphabetically, and then resort it back to alias order.=A0 We should
> > obviously read it in using the same method as when allocating a
> > binding.
> > Where you search backwards till you find your prefix group, and then
> > find the proper spot in the prefix group using alias sorting.=A0
> > Aliases
> > that aren't valid for any configured prefix (these could have been
> > added
> > by hand to the bindings file, or possibly they were created with a
> > different multipath configuration) will just get sorted
> > alphabetically
> > into the bindings list, between the prefix groups.
> >=20
> > Also, it's not enough to just ignore any device config prefix that is
> > a
> > starting substring of another prefix. The device config prefixes also
> > cannot be superstrings of the default prefix, so if the default
> > prefix
> > is "mpath", both of the device config prefixes "mp" and "mpathdev"
> > would
> > need to be ignored.
>=20
> I don't quite understand yet. Assume we read the bindings file and
> encounter an alias "mpathab". Is this alias #28 with prefix "mpath", or
> is it #2 with prefix "mpatha", or perhaps alias guess-what  (order
> "thab") with prefix "mpa"? How would we know at this point in the code?
> Are you suggesting that we create a list of all configured prefixes and
> compare the bindings we read with each of them?

So, the crux of my idea is that we disallow setting the alias_prefix to
conflicting values like this in the config. After we parse the
configuration, we have to go through all the alias_prefix settings and
sanitize them.  If there's a alias_prefix in the overrides section,
there's nothing to do, since all devices will use the same prefix.
Otherwise, we need to make sure that no prefixes in the devices section
are either starting substrings or starting superstrings of the default
alias prefix. Additionally, we need to make sure that no devices section
alias prefixes are starting substrings of another devices section alias
prefix. If there is an invalid devices section alias_prefix, we need to
print an error message and ignore it.

For instance, say that the default prefix is "mpath". If there was a
devices section prefix that was "mp" or "mpathdev", we would print a
error and simply ignore that setting, since "mp" is a starting
substring of the default prefix, and "mpathdev" is a staring superstring
of the default prefix. Devices of that type would just use the default
"mpath" prefix.  Similarly, if there were two separate device section
configs that had alias prefixes of "emc" and "emcdev", we would ignore
the "emc" prefix, since it is a staring substring of "emcdev" (or we
could choose to ignore the superstring prefixes for conflicts between
two device section configs, it doesn't really matter which one we
ignore).

I realize that this is a new limitiation we are adding to multipath.
Users were previously able to have device specific alias prefixes of
"mp", for instance. But I would argue that we don't need to support
conflicting prefixes.  Obviously, distrubutions may want to avoid adding
this change until they are able to safely make non-backwards compatible
changs. But I have pretty strong doubts that this change would
negatively effect anyone.=20

After parsing the config file, we will have a list of valid prefixes
that do not conflict. Thus if strncmp(bdg->alias, prefix,
strlen(prefix)) matches for one of the prefixes, it will not match for
any other. Armed with this list of valid prefixes, when we add bindings
to our list, we are able to sort them in alias order.  Now, when we read
the the bindings from the bindings file, it's possible that some of them
will not match any of our valid prefixes, but that's fine. If an alias
doesn't match a valid prefix, we won't sort it in alias order, because
we can't.  But since we only give out aliases that use the valid
prefixes, we will never need to search through those non-matching
aliases to find a free one. So we don't care how they are ordered, just
so long as they don't come in the middle of a valid prefix group.

To add a new binding, we first figure out if its alias matches a valid
prefix. If it doesn't, we simply scan backwards through our existing
list of bindings till we find an alias that comes alphabetically before
it, and add the binding after that. If it does match a valid prefix, we
scan backwards looking for the first alias that matches the prefix or is
before it alphabetically. If we find a binding whose alias comes before
it, then there are no devices with this prefix, and we add the new
binding after it. If we find a binding with an alias whose start matches
this prefix, we found our prefix group. Then we start searching
backwards by ID until we either find a binding with an ID smaller than
ours or we find a binding whose alias doesn't match our prefix, and we
add the binding after it.


=20
> Our bindings list is now partially sorted, which is an improvement wrt
> the previous situation. "missing the gap" is not really an awful
> problem [*]. Perhaps we could postpone this for after this patch set,
> and give it some more time to sink in?

Yep. I'm fine with going ahead with this patchset as it is. Both sorting
the bindings in alias order and updating the bindings if
/etc/multipath/bindings has changed are things that can get looked at
afterwards. And I'm fine with doing this work, if you want.

-Ben
=20
> Martin
>=20
> [*] I admit that with my patch, we _know_ now that the bindings list
> will be sub-optimally sorted as soon as mpathaa is reached, whereas
> before the ordering might be perfect even with a large number of
> aliases, depending on the history of the bindings file. That's not a
> change for the better; it will cause the gap to be missed in some
> situations where we don't miss it now. I am not sure how bad this is.
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

