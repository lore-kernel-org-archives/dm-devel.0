Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AA34C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 12 Apr 2022 18:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649789260;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=CgqdQ9WMoLFUdXYJoQbU5qYupG8enXtRQXIsQtjnAlM=;
	b=D8v7XE2/u4ZFGGmd0TBBQFoC6b5VRT6v9gWi4TUVKm+2JF7JfDfruyPzEP3tvyl0M0Fn9i
	nGwbRgCTD0XrWwkDFlElt5Zpsf7Oyc2M+4BU0MHxIMNJ+kUNaWHkHfbravn2CAhkSDiagS
	lDr4BPANAKJSTwXj33DwSDPYHuBuCe8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-549-2R1HdblDMbOycbrXVjHAIA-1; Tue, 12 Apr 2022 14:47:37 -0400
X-MC-Unique: 2R1HdblDMbOycbrXVjHAIA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C0D03820F63;
	Tue, 12 Apr 2022 18:47:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9114B404D2C2;
	Tue, 12 Apr 2022 18:47:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 15F9D194036A;
	Tue, 12 Apr 2022 18:47:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1DA531947BBE
 for <dm-devel@listman.corp.redhat.com>; Tue, 12 Apr 2022 18:47:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0DC07492CA9; Tue, 12 Apr 2022 18:47:30 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E3FC1492CA7;
 Tue, 12 Apr 2022 18:47:29 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 23CIlSMh016390;
 Tue, 12 Apr 2022 13:47:28 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 23CIlS3p016389;
 Tue, 12 Apr 2022 13:47:28 -0500
Date: Tue, 12 Apr 2022 13:47:28 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20220412184728.GF24684@octiron.msp.redhat.com>
References: <1649728799-11790-1-git-send-email-bmarzins@redhat.com>
 <95a66d760a1ad8ac943de611ebb3e61d5a41afdb.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <95a66d760a1ad8ac943de611ebb3e61d5a41afdb.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH 0/9] Add protocol specific config subsection
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 12, 2022 at 10:31:50AM +0000, Martin Wilck wrote:
> On Mon, 2022-04-11 at 20:59 -0500, Benjamin Marzinski wrote:
> > Some storage arrays can be accessed using multiple protocols at the
> > same
> > time.=A0 I've have customers request the ability to set different
> > values
> > for the path specific timeouts, like fast_io_fail_tmo, based on the
> > protocol used to access the path. In order to make this possible,
> > this
> > patchset adds a new protocol subsection to the device subsection and
> > the
> > overrides section. This allows users to set a device config's path
> > specific timeouts, such as dev_loss_tmo, fast_io_fail_tmo, and
> > eh_deadline on a per-protocol basis.
>=20
> Sigh... I am not happy about this amount of additional complexity in
> the multipath configuration. It is already so complicated that hardly
> anyone really understands how it works.
>=20
> I fully agree that some properties, in particular fast_io_fail_tmo [1],
> are rather properties of protocol or fabrics than a storage array.
> But do we really need to differentiate by both "device" and "protocol"?
> IOW, do users need different fast_io_fail_tmo value for the same
> protocol, but different arrays? My feeling is that making this property
> depend on a 2-D matrix of (protocol x storage) is overcomplicating
> matters. And _if_ this is necessary, what do we gain by adding an
> "overrides" on top? [2]

I agree that setting fast_io_fail_tmo to different values based on both
array and protocol is usually overkill. This is why I added it to the
overrides section as well. If you just put it there, it will work for
all devices. I assumed that would be the common case. It wouldn't make
sense to have it be in the defaults section and override things in
devices section, but it's a natural fit for the overrides section. Plus,
since I added the protocol table to the hwentry, enabling it in the
overrides section wasn't much new code.
=20
> What about adding simply adding "protocols" as a new top section in the
> conf file, and have the per-protocol settings override built-in hwtable
> settings for any array, but not explicit storage-device settings in the
> conf file?

I'm not really enamored with the idea of only working on the built-in
hwtable. I feel like the people that want to tune things based on the
protocol are the same sort of people that want tune things per array.
More importantly, we don't have anything else in multipath that only
applies to some of the device config entries. That change seems more
confusing to me than adding a new subsection. The protocol subsection is
visually part of the device config it is modifying. A separate protocol
section that only modified some of the device configs seems less
obvious. Plus we don't have a good way to code that.  Also, what happens
to merged configs, where some of the timeouts came from a builtin
config, and some came from the user config.  If you are really against
the subsection idea, I would rather have the protocol section override
all the device configs. Users would need to be o.k. with picking a
protocol for which all their arrays have the same timeout values. But
again, that should be the common case.

> Regards,
> Martin
>=20
> [1]: wrt dev_loss_tmo, I tend to think that the best value must be
> found based on neither protocol nor array, but data center staff.

I do agree that fast_io_fail_tmo and eh_deadline make more sense than
dev_loss_tmo (especially since FC/iSCSI setups seem the most common, and
iSCSI doesn't support dev_loss_tmo), but since the section is there, and
dev_loss_tmo is a per-path timeout setting, I put it in.  I thought
about letting people change the checker type per protocol, but figured
that could wait till someone asked for it. This would make less sense if
we had a seperate top level protocol section. So would things like
per-protocol manginal path handling, and other path specific things
which could reasonably go in a protocol subsection of a device config.

> [2]: I strongly dislike "overrides", in general. I wonder what we need
> it for, except for quick experiments where people are too lazy to add
> explicit settings for devices and/or multipaths.

The biggest reason is that some of the builtin device configs do things
like set no_path_retry to "queue". I know people have used it to
override dev_loss_tmo and fast_io_fail_tmo, but the big one is
no_path_retry. But in general, some builtin device configs make choices
that aren't applicable for all environments, but are what the vendors
have validated and want for the default.

While you can call it lazy, it's always possible that a new builtin
config will be added, or and existing one changed, and suddenly your
devices are hanging instead of failing like expected when all the paths
go down, because the devices are now configured with a different
no_path_retry value.  It's safer to simply disallow this possiblity.

Also, the overrides section exists so that it is possible to set up a
multipath config that will work within some environment's constraints,
regardless of the hardware that is attached. For instance, in
virtualized setups, no_path_retry "queue" can be really annoying.  So
virtualization solutions that use multipath can distribute a
multipath.conf that overrides these settings on all types of possible
devices, without having to go through and modify every problematic
builtin device entry, and update their config as new entries are added.
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

