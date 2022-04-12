Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D3C4C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 12 Apr 2022 22:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649800897;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zsBjfNfakJErkKCpWL5qVu3lkRx2B6lJkG+OLBjMZrM=;
	b=XD9vGnhNi09j9JI3slFpDSCN7GXd7+PhVk+8tVY+6e8B8McWi6We3Mf4dIcCIVYfcJXqiR
	TyicLeMxHDh/CG0RBeZ8KhkIusauiH89J0wOXU2ZNtwGwETSDWRwIkDuiUcmIStwyFpMlI
	9gcnwcjwVVG5I/QYSSzEGmu0gr4N/qo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-208-F27DPyM5NMeeW9kihoVP0Q-1; Tue, 12 Apr 2022 18:01:34 -0400
X-MC-Unique: F27DPyM5NMeeW9kihoVP0Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 88B2A1C05EBE;
	Tue, 12 Apr 2022 22:01:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 41835C27EA6;
	Tue, 12 Apr 2022 22:01:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7C0201949763;
	Tue, 12 Apr 2022 22:01:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9DE0E1947BBE
 for <dm-devel@listman.corp.redhat.com>; Tue, 12 Apr 2022 22:01:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8E07CC27EA6; Tue, 12 Apr 2022 22:01:27 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 75009C27EA0;
 Tue, 12 Apr 2022 22:01:27 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 23CM1Q2d017173;
 Tue, 12 Apr 2022 17:01:26 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 23CM1PwK017172;
 Tue, 12 Apr 2022 17:01:25 -0500
Date: Tue, 12 Apr 2022 17:01:25 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20220412220125.GH24684@octiron.msp.redhat.com>
References: <1649728799-11790-1-git-send-email-bmarzins@redhat.com>
 <95a66d760a1ad8ac943de611ebb3e61d5a41afdb.camel@suse.com>
 <20220412184728.GF24684@octiron.msp.redhat.com>
 <92f53b4d9679a2d958643fe3cc72a09bda4c73fb.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <92f53b4d9679a2d958643fe3cc72a09bda4c73fb.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 12, 2022 at 08:47:38PM +0000, Martin Wilck wrote:
> On Tue, 2022-04-12 at 13:47 -0500, Benjamin Marzinski wrote:
> > On Tue, Apr 12, 2022 at 10:31:50AM +0000, Martin Wilck wrote:
> > >=20
> > I agree that setting fast_io_fail_tmo to different values based on
> > both
> > array and protocol is usually overkill.
>=20
> If we doubt that there is a serious use case for this level of
> differentiation, I think we shouldn't implement it. Doing that would
> violate the KISS principle.
>=20
> > >=20
> > > What about adding simply adding "protocols" as a new top section in
> > > the
> > > conf file, and have the per-protocol settings override built-in
> > > hwtable
> > > settings for any array, but not explicit storage-device settings in
> > > the
> > > conf file?
> >=20
> > I'm not really enamored with the idea of only working on the built-in
> > hwtable.
> > I feel like the people that want to tune things based on the
> > protocol are the same sort of people that want tune things per array.
>=20
> Hm, maybe we are misunderstanding each other. Let me give an example
> what I meant. We've got dev_loss =3D inifinity for ONTAP in the builtin
> hwtable. My idea would be that users could override this in the
> protocols section for all devices using a certain protocol:
>=20
> protocols {
>     protocol {
>     =09type scsi:fcp
> =09dev_loss_tmo 120
>     }
> }
>=20
> This would take precedence over the built-in hwtable, but not over an
> explicit config file entry:
>=20
> devices {
>     device {
>         vendor NETAPP
>         product LUN
>         # With the dev_loss_tmo line below, RDAC would use 300 for
>         # every protocol. Without it, it would use 120 for FC and
>         # "infinity"=A0for other protocols.
>         dev_loss_tmo 300
>     }
> }     =20
>=20
> Admittedly, the problem on the implementation side is that we don't
> distinguish between built-in hwentries and those from explicit
> configuration. Changing this would be considerable effort; perhaps more
> effort than what you did in your patch set. I haven't thought it
> through.
>=20
> > More importantly, we don't have anything else in multipath that only
> > applies to some of the device config entries. That change seems more
> > confusing to me than adding a new subsection.
>=20
> The main change would be to differentiate between built-in and user-
> configured hardware properties. I hope most users would be able to
> understand the concept.
>=20
> >  The protocol subsection is
> > visually part of the device config it is modifying. A separate
> > protocol
> > section that only modified some of the device configs
> >  seems less
> > obvious. Plus we don't have a good way to code that.=A0 Also, what
> > happens
> > to merged configs, where some of the timeouts came from a builtin
> > config, and some came from the user config.
>=20
> To clarify once more: this is what I meant, built-in configs would be
> overridden, user configs wouldn't be. This is different from
> "defaults", as "defaults" don't override hardware-specific built-ins.

But what do you call a device config that is the result of merging (via
merge_hwe()) a built-in and a non-built-in config.  Do we really want to
track that some of the values of this merged config need to check the
protocol section, and some don't? We could remove merging identical
configs, but that simply makes it harder for users to figure out how
their device will be configured from the configuration output.

I understand your idea. I'd just rather that it worked on all the device
configs, instead of only the built-in ones. I think overriding only the
built-in configs is needlessly complicated, both from a coding and from
an explaining point of view.

> > =A0 If you are really agains the subsection idea,
> >  I would rather have the protocol section override
> > all the device configs. Users would need to be o.k. with picking a
> > protocol for which all their arrays have the same timeout values. But
> > again, that should be the common case.
>=20
> The question is whether a "protocol" entry should override device
> settings, or vice versa (as in my hypothetical ONTAP example above). We
> seem to agree that that device subsection would implement a level of
> complexity that hardly any user needs. If this is the case, we'd just
> need to determine the precedence between "devices" and "protocols"
> sections. If we determine that "protocols" should always take
> precedence, we might as well allow it under "overrides" only. We'd need
> no "protocols" section in that case, and no differentiation between
> built-in and user-configured hwentries.

That seems reasonable.

> > > [1]: wrt dev_loss_tmo, I tend to think that the best value must be
> > > found based on neither protocol nor array, but data center staff.
> >=20
> > I do agree that fast_io_fail_tmo and eh_deadline make more sense than
> > dev_loss_tmo (especially since FC/iSCSI setups seem the most common,
> > and
> > iSCSI doesn't support dev_loss_tmo), but since the section is there,
> > and
> > dev_loss_tmo is a per-path timeout setting, I put it in.
> > ...
>=20
> I'm fine with treating dev_loss_tmo as a protocol/path property.
>=20
> > > [2]: I strongly dislike "overrides", in general. I wonder what we
> > > need
> > > it for, except for quick experiments where people are too lazy to
> > > add
> > > explicit settings for devices and/or multipaths.
> >=20
> > The biggest reason is that some of the builtin device configs do
> > things
> > like set no_path_retry to "queue".=A0
>=20
> You don't need to use "overrides" for that:
>=20
> devices {
>         device {
>                 vendor .*
>                 product .*
>                 no_path_retry 75
>         }
> }
> You can follow up with more device entries that define exceptions for
> the general rule above. Am I missing something?
>=20
> AFAICT the only thing you can do with "overrides" but not with the
> trick above is override actual hardware-specific user configs, and I
> have a hard time figuring out why someone would work out detailed
> device-specific configs just to override them again with a big hammer.

Fair enough. I added the overrides section before you made paths have a
vector of device configs. Back then, there was no way to have a device
config that would work like your above example.  My original idea was to
be able to have a special device section like this:

device {
        all_devs yes
=09no_path_retry 75
}

that would get merged with all the device sections. The overrides
section was the compromise after my original idea was NAKed. We probably
could deprecate the overrides section now that we have a vector of
device configs. But then we shouldn't go putting the protocol stuff
there.=20

-Ben

> Regards,
> Martin
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

