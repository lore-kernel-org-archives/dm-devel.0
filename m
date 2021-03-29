Return-Path: <SRS0=Y5I9=I3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDDFDC433DB
	for <dm-devel@archiver.kernel.org>; Mon, 29 Mar 2021 18:25:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3C89D6193A
	for <dm-devel@archiver.kernel.org>; Mon, 29 Mar 2021 18:25:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3C89D6193A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1617042300;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3l4s9DKsCfjt9j4XHJpvd0SxVW9/AABfC/cYq+bXQNo=;
	b=hwY4AFFcg5WX+jHmuER4XKGmvDpQxYXMVYqGrm4XxqshLUBinf7WGG6dLgKKAOoBBRM03M
	VTeD8bqF19XryUJi+enwwlwsobmwJGjaMB6F0MyXB0h4OBiBs9VS1uE/80Rt5q2Y3Lic2I
	9pyvl9HrYq9h9qI+sBzpMJmcF/SWVkk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-9L4iOr64MzCE6X23Hg5ozg-1; Mon, 29 Mar 2021 14:24:57 -0400
X-MC-Unique: 9L4iOr64MzCE6X23Hg5ozg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F8B09CDAD;
	Mon, 29 Mar 2021 18:24:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6E4FC5D6AB;
	Mon, 29 Mar 2021 18:24:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 12E0E1809C82;
	Mon, 29 Mar 2021 18:24:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12TIKdY7002046 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 29 Mar 2021 14:20:39 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 916A039A66; Mon, 29 Mar 2021 18:20:39 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0EF5769CBF;
	Mon, 29 Mar 2021 18:20:35 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 12TIKYds003460; 
	Mon, 29 Mar 2021 13:20:34 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 12TIKXLh003459;
	Mon, 29 Mar 2021 13:20:33 -0500
Date: Mon, 29 Mar 2021 13:20:33 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20210329182033.GJ15006@octiron.msp.redhat.com>
References: <1616719966-10221-1-git-send-email-bmarzins@redhat.com>
	<1616719966-10221-3-git-send-email-bmarzins@redhat.com>
	<1088f960e04492a26530385040b2485b3691c94e.camel@suse.com>
	<20210327021853.GI15006@octiron.msp.redhat.com>
	<31162621ac38601976bfa51db92989471fd4c23e.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <31162621ac38601976bfa51db92989471fd4c23e.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
	Hannes Reinecke <hare@suse.com>
Subject: Re: [dm-devel] [PATCH 2/4] libmultipath: fix priorities in
	parse_vpd_pg83
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 29, 2021 at 08:44:46AM +0000, Martin Wilck wrote:
> On Fri, 2021-03-26 at 21:18 -0500, Benjamin Marzinski wrote:
> > On Fri, Mar 26, 2021 at 05:12:36PM +0000, Martin Wilck wrote:
> > > On Thu, 2021-03-25 at 19:52 -0500, Benjamin Marzinski wrote:
> > > > The priorities for the EUI-64 (0x02) and NAME (0x08) scsi
> > > > identifiers
> > > > in
> > > > parse_vpd_pg83() don't match their priorities in 55-scsi-
> > > > sg3_id.rules.
> > > > Switch them so that they match.
> > >=20
> > > I think we should rather change the udev rules file, to be
> > > consistent
> > > with what the kernel does:
> > >=20
> > > https://elixir.bootlin.com/linux/latest/A/ident/designator_prio
> >=20
> > If we were going with the kernel as a standard, we should also change
> > scsi_id, since it doesn't match that the kernel either (or the
> > priority
> > ordering in 55-scsi-sg3_id.rules for that matter).=A0 The bigger issue
> > here is that distributions would need to make special plans to take
> > this
> > change, because user's devices would change uuids, which could cause
> > problems on existing systems. It will definitely do so on systems
> > using
> > multipath. Devices will suddenly change wwids, which will rename
> > them.
>=20
> True. (Although this would happen only to devices that provide both
> type 8 (SCSI name string) _and_ either type 3 (NAA) or type 2 (EUI-64)
> designators. I'm not sure how many of those exist)
>=20
> I wish we'd been consistent in the first place...
>=20
> The preference for type 8 in the kernel dates back to Hannes' patch
> from 2015: 9983bed3907c ("scsi: Add scsi_vpd_lun_id()"). It makes sense
> in general: while the specs don't explicitly mandate preferences, SPC-4
> lists the designators in what seems to be a "increasing priority"
> order, and the "name string" format is listed last. Also, "name string"
> has the same or even stricter formal requirements than the other types,
> while allowing iSCSI name strings besides NAA and EUI-64 identifiers.
>=20
> > The whole reason why Red Hat installs 55-scsi-sg3_id.rules as
> > 61-scsi-sg3_id.rules is beause we didn't initally include it, and we
> > don't want go changing people's device UUIDs, so is has to go after
> > 60-persistent-storage.rules, which sets ID_SERIAL if it's not already
> > set.
> >=20
> > On the other hand, it's obviously safe to make our fallback method of
> > getting wwids return the same wwids as the primary method does.=A0
>=20
> Ack.
>=20
> > Since
> > recheck_wwids relies on both methods giving the same wwid, I would
> > argue
> > that it's a bug that they don't. If we don't add this fix, then we
> > should add back the code that disables recheck_wwids if multipathd
> > doesn't see that both methods return the same wwid at least once, so
> > we
> > know that we can rely on parse_vpd_pg83.
>=20
> I was hoping that we could eventually settle on the kernel's priority
> list. By doing so, we could perhaps some day actually rely on the
> kernel's "wwid" attribute rather than logic of the udev rules (IOW:
> change the udev rules to simply use "wwid"). I believe being able to do
> so would also be in the interest of SID, am I wrong?

You're right. I would love to get away from the arbitrariness of the
udev rules for picking the WWID, and SID would definitely benefit from
a standard, non-udev way of getting the WWID.
=20
> For now, I suppose you're right - it's more important to retain
> backward compatibility. So, I'm going to ACK your patch. But we should
> try to figure out an exit strategy for this, if possible without adding
> yet another configuration option for device detection in multipath-
> tools.
>
> As a first step, we could change the udev rules to set a device
> property based on the kernel's "wwid" sysfs attribute. For now, that
> property would just be yet one more ID attribute. We could make the
> rest of the udev rule logic depend on a conditional which distributions
> could control. I.e. "modern" setups would _only_ use the "wwid"
> attribute and not set ID_SERIAL any more. Distros with major interest
> in backward compatibilty can keep ID_SERIAL as long as they see fit.
>=20
> multipathd could figure out the system configuration from the (non)
> availability of certain properties, and use an appropriate fallback
> logic for either case.

That seems like reasonable first step, although one that won't help SID,
since it can't rely on getting the wwid from udev.  This actually brings
up a different point I have. Is your main objection to adding more
config options that it is complicating the code, or confusing the users?

Because multipath wouldn't need to add any configuration options to be
easily usable with SID (the current workaround, setting uid_attribute to
"", is pretty non-obvious to users) if it could just check if sid was
running, and key off that.  However this adds even more code complexity
than simply checking a config option. I don't know how you would feel
about accepting a patch that does this, when SID is production ready.
=20
> >=20
> > Speaking of which, I was planning on doing more work to make our
> > fallback method of returning wwids work more like 55-scsi-
> > sg3_id.rules
> > and 60-persistent-storage.rules. For instance, both of those will
> > fall
> > back to using page 0x80, if setting ID_SERIAL from page 0x83 fails.
>=20
> Yes, that'd be a good thing.
>=20
> I think I've made my point that I'd like to achieve consistent behavior
> between kernel, udev, and multipathd some day. We should have a plan,
> and should make sure the kernel people are on the same boat as us.
> I think I'll write to linux-scsi to discuss how we can best proceed.
>=20
> Best regards,
> Martin
>=20
> >=20
> > -Ben
> >=20
> > >=20
> > > Regards
> > > Martin
> > >=20
> > >=20
> > >=20
> > > >=20
> > > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > > ---
> > > > =A0libmultipath/discovery.c | 16 ++++++++--------
> > > > =A01 file changed, 8 insertions(+), 8 deletions(-)
> > > >=20
> > > > diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> > > > index 5727f7a6..f8044141 100644
> > > > --- a/libmultipath/discovery.c
> > > > +++ b/libmultipath/discovery.c
> > > > @@ -1152,19 +1152,19 @@ parse_vpd_pg83(const unsigned char *in,
> > > > size_t
> > > > in_len,
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0vpd =3D d;
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0}
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0break;
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0case 0x8:
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0/* SCSI Name: Prio 4 */
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0if (memcmp(d + 4, "eui.", 4) &&
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 memcmp(d + 4, "naa.", 4) &&
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 memcmp(d + 4, "iqn.", 4))
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0case 0x2:
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0/* EUI-64: Prio 4 */
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0if (prio < 4) {
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0prio =3D 4;
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0vpd =3D d;
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0}
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0break;
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0case 0x2:
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0/* EUI-64: Prio 3 */
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0case 0x8:
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0/* SCSI Name: Prio 3 */
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0if (memcmp(d + 4, "eui.", 4) &&
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 memcmp(d + 4, "naa.", 4) &&
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 memcmp(d + 4, "iqn.", 4))
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0if (prio < 3) {
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0prio =3D 3;
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0vpd =3D d;
> > >=20
> > > --=20
> > > Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
> > > SUSE Software Solutions Germany GmbH
> > > HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer
> > >=20
> >=20
>=20
> --=20
> Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
> SUSE Software Solutions Germany GmbH
> HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer
>=20

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

