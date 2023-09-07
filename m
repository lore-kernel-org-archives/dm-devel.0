Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8030BEC875C
	for <dm-devel@archiver.kernel.org>; Thu,  7 Sep 2023 20:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694119422;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OnZjg2YXZ0OydlsRZ/WsGwTmWFK/dSIknUcu61R2sag=;
	b=b3xWO8WKJE5dOOy5AuiENoj8yHeEcKFOjn3mZWyuGFopgfAgm6XWwp2Hbo7hF0G2BvC8LU
	Lz+SaC3x06StLmUmQNIuigURSmETt5MdBlUggo/I1h7FVEYicztdNCy7ggbl0NtrFinC9u
	Nvm1vmXR/QVy5wBohIcUUuH6s/N0HzU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-PoLqNjw4PRWkIpvkPyhLoA-1; Thu, 07 Sep 2023 16:43:39 -0400
X-MC-Unique: PoLqNjw4PRWkIpvkPyhLoA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E38F68E4EAE;
	Thu,  7 Sep 2023 20:43:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7B6F9C03293;
	Thu,  7 Sep 2023 20:43:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4CCFF194658F;
	Thu,  7 Sep 2023 20:43:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E8084194658C
 for <dm-devel@listman.corp.redhat.com>; Thu,  7 Sep 2023 20:43:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 97492C03295; Thu,  7 Sep 2023 20:43:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8EEA2C03293
 for <dm-devel@redhat.com>; Thu,  7 Sep 2023 20:43:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 70EDA1C11803
 for <dm-devel@redhat.com>; Thu,  7 Sep 2023 20:43:33 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-562-ZPlxd32qNnW-zFBUsLeNjA-1; Thu,
 07 Sep 2023 16:43:29 -0400
X-MC-Unique: ZPlxd32qNnW-zFBUsLeNjA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 0D2A01F461;
 Thu,  7 Sep 2023 20:43:28 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DE2AE138F9;
 Thu,  7 Sep 2023 20:43:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id htXGNO81+mSRDgAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 07 Sep 2023 20:43:27 +0000
Message-ID: <97ae2fd39a6f927441ebb861bf62d2e1a3223b9b.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 07 Sep 2023 22:43:27 +0200
In-Reply-To: <20230907200257.GH7412@octiron.msp.redhat.com>
References: <20230901180235.23980-1-mwilck@suse.com>
 <20230901180235.23980-19-mwilck@suse.com>
 <20230906224708.GC7412@octiron.msp.redhat.com>
 <5cef84987794cc449028055a63c522c1ea690738.camel@suse.com>
 <20230907191404.GG7412@octiron.msp.redhat.com>
 <20230907200257.GH7412@octiron.msp.redhat.com>
User-Agent: Evolution 3.48.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2023-09-07 at 15:02 -0500, Benjamin Marzinski wrote:
> On Thu, Sep 07, 2023 at 02:14:04PM -0500, Benjamin Marzinski wrote:
> > On Thu, Sep 07, 2023 at 12:30:53PM +0200, Martin Wilck wrote:
> > > On Wed, 2023-09-06 at 17:47 -0500, Benjamin Marzinski wrote:
> > > > On Fri, Sep 01, 2023 at 08:02:31PM +0200,
> > > > mwilck@suse.com=A0wrote:
> > > > > From: Martin Wilck <mwilck@suse.com>
> > > > >=20
> >=20
> > > > > +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(bindings, bdg, i) {
> > > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0int curr_id =3D sca=
n_devname(bdg->alias,
> > > > > prefix);
> > > >=20
> > > > If we know that the bindings will be sorted by alias order, we
> > > > don't
> > > > need to do all this. Something like this should work:
> > >=20
> > > That's true. Unfortunately, we can't ensure ordering "by alias
> > > order".
> > > The reason is that our configuration allows using different alias
> > > prefixes for different devices. The current sorting is simply
> > > alphabetical. It detects duplicates, but it ensures "alias order"
> > > only
> > > between "mpatha" and "mpathz".
> > >=20
> > > I've thought of just removing the "different aliases for
> > > different
> > > devices" feature. I don't know if any users out there actually
> > > set
> > > device-specific alias_prefix values in the devices section of
> > > multipath.conf. I don't recall having seen such a configuration
> > > so far;
> > > almost every config I have seen simply uses "mpath" everywhere.
> > > But I
> > > recognize that it may feel tempting in some cases. One could use
> > > the
> > > "NETAPP" prefix for some arrays and the "EMC" prefix for others,
> > > for
> > > example, making it easier to see which is what. And we simply
> > > don't
> > > know if we'd break existing user setups with such a change. So if
> > > at
> > > all, we can't do it in a minor release without deprecating it
> > > first.
> > >=20
> > > When we add a binding in add_binding(), we don't know which
> > > alias_prefix is configured for a given WWID, and we have no easy
> > > way to
> > > figure it out. We know the alias, but we don't know which portion
> > > of it
> > > is the prefix and which is the ID (it's not forbidden to use
> > > "aaaa" as
> > > alias_prefix). I wouldn't want to start guessing.
> > >=20
> > > If you can think of a way to keep the bindings cleanly sorted,
> > > please
> > > let me know.
> >=20
> > Doh! You even mentioned this issue in your "fix alias tests"
> > commit. I
> > just didn't pay enough attention to it. But I believe there is a
> > way to
> > make sure that we are dealing with a correctly sorted list of
> > potential
> > bindings when calling get_free_id(), if we decide it's worth the
> > extra
> > work.
> >=20
> > The global_bindings isn't guaranteed to have all the bindings for
> > our
> > prefix correctly sorted, but they will all be in a group.=A0 If we
> > wanted,
> > we could create a new vector that just included these bindings, and
> > sort
> > it using the current prefix and a comparison function to do alias-
> > sytle
> > sorting. the msort_r() function takes an extra argument to pass to
> > the
> > compar() function, which could be the prefix.
> >=20
> > It would be great if we could just sort part of the global_bindings
> > vector in place, once we knew the prefix.=A0 Unfortunately, that
> > would
> > only work if we could know that no prefix can ever match a starting
> > substring of another prefix. Otherwise, sorting using one can make
> > the
> > other not be in a single continuous group.=A0 For instance, if some
> > device
> > configs used "mpatha" as a prefix, they would expect "mpathaaa" to
> > follow immediately after "mapthaz", but if the bindings file had
> > already
> > been sorted using the "mpath" prefix, then "mpathba" would follow
> > "mpathaz", and "mpathaaa" would come much later. Keeping the global
> > file
> > alphabetically sorted guarantees that no matter the prefix that
> > devices
> > were added under, all device aliases that are valid with that
> > prefix
> > will be in a group together.
> > =A0
> > So, is it worth it to make another vector, copy the alises which
> > are
> > valid with the current prefix into it, and then sort it?
> > get_free_id()
> > will be cleaner, and gap detection won't break down after you get
> > past
> > mpathaa, which it currently does with an alpahbetically sorted
> > bindings
> > list.
> >=20
> > Alternatively, we could just decide that setting a prefix in a
> > device
> > config that matches the starting substring of a another prefix is a
> > config error (obviously using the exact same prefix is fine), and
> > ignore
> > that prefix from the device config when we parse the configuration.
> > Then
> > we could read in the bindings alphabetically like we currently do,
> > find
> > the prefix groups in them, and sort them once, in-place. When
> > allocating
> > a binding, we would need to search backwards through the bindings
> > till
> > we found the end of the group matching our prefix (or an alias that
> > comes alphabetically before our prefix). Then we would have to
> > search
> > backwards through our prefix group using the id, till we found a
> > binding
> > with a smaller id.
>=20
> So, thinking about this a little more, assuming we would be writing
> out
> the bindings file in full alias sorted order, it's stupid to sort it
> alphabetically, and then resort it back to alias order.=A0 We should
> obviously read it in using the same method as when allocating a
> binding.
> Where you search backwards till you find your prefix group, and then
> find the proper spot in the prefix group using alias sorting.=A0
> Aliases
> that aren't valid for any configured prefix (these could have been
> added
> by hand to the bindings file, or possibly they were created with a
> different multipath configuration) will just get sorted
> alphabetically
> into the bindings list, between the prefix groups.
>=20
> Also, it's not enough to just ignore any device config prefix that is
> a
> starting substring of another prefix. The device config prefixes also
> cannot be superstrings of the default prefix, so if the default
> prefix
> is "mpath", both of the device config prefixes "mp" and "mpathdev"
> would
> need to be ignored.

I don't quite understand yet. Assume we read the bindings file and
encounter an alias "mpathab". Is this alias #28 with prefix "mpath", or
is it #2 with prefix "mpatha", or perhaps alias guess-what  (order
"thab") with prefix "mpa"? How would we know at this point in the code?
Are you suggesting that we create a list of all configured prefixes and
compare the bindings we read with each of them?

Our bindings list is now partially sorted, which is an improvement wrt
the previous situation. "missing the gap" is not really an awful
problem [*]. Perhaps we could postpone this for after this patch set,
and give it some more time to sink in?

Martin

[*] I admit that with my patch, we _know_ now that the bindings list
will be sub-optimally sorted as soon as mpathaa is reached, whereas
before the ordering might be perfect even with a large number of
aliases, depending on the history of the bindings file. That's not a
change for the better; it will cause the gap to be missed in some
situations where we don't miss it now. I am not sure how bad this is.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

