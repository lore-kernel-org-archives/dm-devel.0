Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 310ECC74A5B
	for <dm-devel@archiver.kernel.org>; Tue, 21 Mar 2023 08:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679389079;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=j4Z/PkT9FjmnVr61xhn2kwDJ44mTDPt/rzewxgds9cw=;
	b=cEkJtxYzxbZ8Q73vEpXpSg99FGZlPgIV1TJxiXT9QyAYOosr1EzBFwz6bJ3Bch38uxCmLc
	YhfJSKjBGcxYLywW275+huhnsELRuVVEc8uL+rRNIGXcYs26k3OQqf820uAlFTTYlVfGem
	8XxeZvp2Gn9IudtFc7nElqPH0KV/MGo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-Y3RPzjG3M_KLREwLBeqI9A-1; Tue, 21 Mar 2023 04:57:57 -0400
X-MC-Unique: Y3RPzjG3M_KLREwLBeqI9A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E13F33C16E93;
	Tue, 21 Mar 2023 08:57:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AB19BC15BA0;
	Tue, 21 Mar 2023 08:57:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6D66319465A2;
	Tue, 21 Mar 2023 08:57:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6974A1946594
 for <dm-devel@listman.corp.redhat.com>; Tue, 21 Mar 2023 08:57:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 577E2175AD; Tue, 21 Mar 2023 08:57:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 507F51731B
 for <dm-devel@redhat.com>; Tue, 21 Mar 2023 08:57:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2DECD858F09
 for <dm-devel@redhat.com>; Tue, 21 Mar 2023 08:57:52 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-352-4iw7-RlmMiy_zW9zn6EnoA-1; Tue,
 21 Mar 2023 04:57:49 -0400
X-MC-Unique: 4iw7-RlmMiy_zW9zn6EnoA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 7FA6F21A6E;
 Tue, 21 Mar 2023 08:57:48 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5234613451;
 Tue, 21 Mar 2023 08:57:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id xfyCEoxxGWRCWgAAMHmgww
 (envelope-from <mwilck@suse.com>); Tue, 21 Mar 2023 08:57:48 +0000
Message-ID: <e19fd16143ae04c631f2e6eb6a55b2604876f9f2.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Tue, 21 Mar 2023 09:57:47 +0100
In-Reply-To: <20230320194146.GH19878@octiron.msp.redhat.com>
References: <CD5EC3B3-9A64-416A-A04C-C68EDB82F4C6@purestorage.com>
 <a85c4b5a6603be979ddb9aa0909808519a03fa3e.camel@suse.com>
 <20230320194146.GH19878@octiron.msp.redhat.com>
User-Agent: Evolution 3.46.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH] multipath-tools Consider making 'smart' the
 default
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
Cc: device-mapper development <dm-devel@redhat.com>,
 Brian Bunker <brian@purestorage.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2023-03-20 at 14:41 -0500, Benjamin Marzinski wrote:
> On Mon, Mar 20, 2023 at 03:18:37PM +0100, Martin Wilck wrote:
> > On Thu, 2023-03-16 at 14:47 -0700, Brian Bunker wrote:
> > >=20

> > > Subsequent volumes after the first one are discovered via unit
> > > attentions triggering the udev rule which calls scan-scsi-target.
> > > The SCSI devices being discovered without creating the
> > > corresponding
> > > multipath devices seems to be a bad default. We would like to
> > > control as much as possible from the target side to dictate
> > > initiator
> > > behavior. This comes as a regression to how it previously worked.
> > >=20
> > > Signed-off-by: Brian Bunker <brian@purestorage.com>
> >=20
> > I'm fine with this, but keep in mind that distributions will
> > probably
> > override this anyway. Red Hat and SUSE have had different defaults
> > for
> > this basically forever. At least enterprise distros won't risk
> > regressions because of changing defaults.
> >=20
> > Ben, what's your opinion wrt the patch?
>=20
> tl;dr: I think "yes" makes more sense than "smart".

TL;DR: I'd like to hear the "voice of the user" at this point. So if
anyone except Ben, Brian, and myself has read this far, please speak up
(and read on if you have the patience)!

> I don't know if this is a good idea. The default behavior we set is
> going to be what happens when people don't set up a configuration
> file.
> I get that "strict" means you have to manually set up maps. But that
> actually seems like a reasonable default if you don't have a
> configuration set up.=A0

IIRC we chose "strict" because the previous upstream default had been
the nonsensical "no", and we wanted to stick with a "conservative"
default. This way, we are cautious: we avoid suddenly grabbing a lot of
devices if someone just compiles and runs multipathd on her system.
OTOH, "strict" makes little sense on systems that actually deploy
multipath devices, as Brian described.

> Using "no" or "greedy" means that you have to set
> up a configuration, or multipath will just use all your devices, and
> that seems much worse.=A0

Forget about "no".

SUSE has used "greedy" as default basically forever, and it's working=20
well. The only common case where it's not optimal is systems with
local, non-multipath root device. While there's nothing wrong with
using multipath for such a device, users often don't like it because
they think it's going to impact system performance negatively. It is
possible to avoid using multipath on the root disk by simply not adding
the multipath module to the initramfs. The improvements in device
selection logic that we've made during the last years make this setup
work without additional configuration [1].

> But if we want to make multipath "just do the
> right thing without getting in my way", then I would argue "yes" is a
> better alternative.
>=20
> The benefit of using "yes" is that multipath will almost always
> correctly find your multipath devices, and will never fail in a way
> where it grabs devices it shouldn't.=A0 The only time it will fail is
> on a
> multipathable device that has never been multipathed before, and it
> will
> only not work if something else starts using the first path of the
> device before the second path appears and multipathd creates a
> multipath
> device on it.=A0 This really only happens when this new device has some
> metadata on it that causes something to automatically grab it (for
> instance a LABEL for a filesystem that gets automounted, or LVM
> metadata
> for a device that gets autoactivated).=A0 I don't actually know of any
> real downsides to using "yes", and if there were some, they would
> also
> be downsides to using "smart"

> There are real downsides to using "smart" without setting up a
> configuration file. Every single time you boot, the rest of the
> system's
> access to your possibly multipathable devices is delayed while
> multipath
> waits seconds for a sibling to appear.

This applies only to non-multipath devices. For multipath devices,
"smart" uses the WWIDs file just like "yes". So this is about
situations where you have non-blacklisted, non-multipath devices in
your system. In practice, that's again the "non-multipath root"
scenario discussed above. Like above, you can avoid waiting in that
scenario by not adding multipath to the initramfs; after switching
root, the device will be handled by the "released to systemd" logic.
And if you don't do this: with high likelihood, the
find_multipath_timeout of 1s for "unkown devices" will apply to the
non-multipath devices. udev sets the timer for multiple devices in
parallel, so that the delays don't add up. IMO a 1s delay is hardly
noticeable during a typical server startup.

>  In return for this issue that
> happens on every boot for every possibly multipathable device, the
> only
> benfit you get over "yes", is that when you add a new device to your
> system, if there is data on the device that would cause it to be
> autoassembled and the second path appears within seconds of the first
> path (either 1 or 10, depending on whether or not there is a built-in
> config for the storage array), multipath will correctly grab the
> device,
> instead of whatever was going to autoassemble on it.=A0 This is a very
> rare occurance, still leaves you with a running system, and can
> easily
> be fixed after the fact.
>=20
> There's only one time when RHEL makes use of "smart", and that's
> during
> installation.=A0=A0

Interesting ;-)

> For reasons which I don't understand, the RHEL installer
> will autoassemble LVM/MD devices if there is existing metadata on
> disks
> when it boots. In this case the system is unavoidably seeing all of
> the
> storage devices for the very first time, without multipath being
> configured for these devices, and it not unlikely that we will see
> devices with LVM/MD metadata on them. This means that LVM/MD will
> likely
> autoassemble before the second path appears, and the device gets
> multipathed. This confuses the installer. Since we only do this in
> the
> installer, we only see the "smart" delay on releasing the devices to
> the
> systme one time. In this situation, using "smart" makes sense
> (although
> not as much sense as simply not autoassembling LVM devices when the
> installer boots, IMHO).
>=20
> The only other situation where "smart" would be generally helpful is
> if
> you have your system configured so that all devices are blacklisted
> except the types that are supposed to be multipathed. In this
> situation
> you wouldn't have to worry about the delay on every boot because all
> the
> non-multipathable devices would be blacklisted. If a new
> multipathable
> device appeared, then "smart" would guarantee that nothing else would
> grab it before the second path appeared (assuming that the second
> path
> appeared within the timeout). However, you quite likely still
> shouldn't
> use "smart" in this case.=A0 If you already have your configuration set
> up
> like this, then you can just use "greedy" and get the same benefit,
> without having to worry about the second path showing up on time.

I agree. The idea behind "smart" was to avoid the necessity of
blacklisting, at the cost of a delay. If users go through the procedure
of creating blacklists, they'll be better off with "greedy" most of the
time.

> It is possible that you can't set up you configuration to correctly
> sort
> all the devices that may appear in the future into multipathable and
> non-multipathable. In this case, if it's important that these new
> devices are correctly multipathed the first time they show up, then
> "smart" also makes sense. But I don't think that this case was so
> common that we should assume that it's the default for people who
> install the multipath tools. It takes very little effort to change
> the
> find_multipaths setting. The people who aren't interested enough in
> their multipath setup to do that probably aren't the people that want
> multipath claiming their devices for a couple seconds every boot,
> just
> in case we're in that rare situation where it could make a
> difference.

Most of what you are saying makes sense.=A0Your description of different
scenarios shows that "yes", "greedy", and "smart" all have their pros
and cons. No setting is optimal in every situation. We made this
configurable for a reason.=A0

Now the question is which upstream default suits our users best.
We should ask ourselves: who is using the upstream multipath code?

Multipath is mostly for large data centers; I tend to believe that
enterprise distributions and their clones account for a rather big part
of the installations where multipath is in use. In that case, the
distribution defaults apply, which often differ from the upstream
default. The _very_ big users, who basically create their own distros,
will probably also have their dedicated approach to multipath device
selection; no need for us to bother about them.

Experienced long-term multipath users will have no problem with editing
multipath.conf and applying their own settings, and will most probably
have been doing that for years anyway [2]. Thus the upstream default
mostly matters for people who compile multipath locally [3], and for
(new) users of distributions that don't alter the upstream defaults.=A0

For these scenarios, I think that "smart" is the best choice.=A0"smart"
was meant to "do the right thing" for cases where the user doesn't want
to create configuration files. It's also useful for mass deployments.
IMO the boot delay is a small price to pay for getting the closest
approximation of a "right" setup immediately after activating
multipath. Those users who are annoyed by boot delays, caused by non-
blacklisted non-multipath devices with "smart", will consider their
needs and switch this to "yes" or "greedy". Even in mass deployments,
doing so with a tool like ansible isn't a big issue.

Anyway, Ben, the two of us should take a step back here. We are both
opinionated, based on the defaults our respective distributions have
been using for almost two decades.

This is why I asked for the "opinion of the user". I'd like to hear
which settings the practitioners prefer, why, and whether the
preferences differ between different configuration scenarios. I hope
someone is going to speak up. I suppose we'll choose either "yes" or
"smart", and I'm looking forward to hear what our users prefer. It's
not a religious matter to me.

Regards
Martin

[1] Personally, with "greedy" and a non-multipath root disk, I'd
recommend creating a blacklist entry, but it isn't strictly necessary
any more.
[2] In practice, one of the problems I see are overloaded
multipath.conf files that have grown over time and contain setting that
modern multipath-tools wouldn't need any more. But that's a different
issue.
[3] Does anyone do this these days?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

