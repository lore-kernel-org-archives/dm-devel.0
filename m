Return-Path: <SRS0=KxaR=D6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DF03C388F9
	for <dm-devel@archiver.kernel.org>; Fri, 23 Oct 2020 15:12:13 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 83A83208B6
	for <dm-devel@archiver.kernel.org>; Fri, 23 Oct 2020 15:12:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NPvqpdJ6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 83A83208B6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1603465931;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ePO6J1rF3ApDlegnpm3EYHxSIdzpbSo48e/I1hupUCM=;
	b=NPvqpdJ61rj2VHt+tqdj9/e3OtHIUu5bwPBsO33/R8lL3BV4wgh48EEYkEVDGFNMjwES81
	247/f6ZYe4b22WpnUWSpOxsCAUeYW+XRWPYUB3JhTXwlHuAr+Ma+e2PeIILJ2cKLkhdlrb
	GHRNNG6EURgCDdbruWL8VDnjKuKhR1w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-pGHZ9kQiNauZt_4na9wZoA-1; Fri, 23 Oct 2020 11:12:08 -0400
X-MC-Unique: pGHZ9kQiNauZt_4na9wZoA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C5BB83DC22;
	Fri, 23 Oct 2020 15:12:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 310CE5B4AC;
	Fri, 23 Oct 2020 15:12:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D5A2E18199F6;
	Fri, 23 Oct 2020 15:11:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09NFBu3t013015 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 23 Oct 2020 11:11:56 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C15BC5D9E2; Fri, 23 Oct 2020 15:11:56 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 48C855D9D5;
	Fri, 23 Oct 2020 15:11:53 +0000 (UTC)
Date: Fri, 23 Oct 2020 11:11:52 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Message-ID: <20201023151152.GA21936@redhat.com>
References: <20201015150504.1319098-1-mic@digikod.net>
	<20201015165229.GA5513@redhat.com>
	<022e949e-00c4-d98a-b536-1c5f9e05c09c@digikod.net>
	<b7ba2ff9-5f5f-8c1e-dfaa-33da56d3d8de@digikod.net>
	<b7ccaa01-0398-f108-a70d-c67753d9fa6d@gmail.com>
	<55389f91-60a5-05db-b3e1-8f24aa356893@digikod.net>
	<54e98aa6-0e52-1147-b9ce-a640e2317b00@digikod.net>
MIME-Version: 1.0
In-Reply-To: <54e98aa6-0e52-1147-b9ce-a640e2317b00@digikod.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: Deven Bowers <deven.desai@linux.microsoft.com>,
	linux-kernel@vger.kernel.org,
	Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>,
	Milan Broz <gmazyland@gmail.com>, dm-devel@redhat.com,
	linux-integrity@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Alasdair Kergon <agk@redhat.com>,
	Jaskaran Khurana <jaskarankhurana@linux.microsoft.com>
Subject: Re: [dm-devel] [PATCH v2] dm verity: Add support for signature
 verification with 2nd keyring
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

On Fri, Oct 23 2020 at  6:20am -0400,
Micka=EBl Sala=FCn <mic@digikod.net> wrote:

> It seems that there is no more question. Mike, Alasdair, could you
> please consider to merge this into the tree?
>=20
> On 16/10/2020 14:19, Micka=EBl Sala=FCn wrote:
> >=20
> > On 16/10/2020 13:08, Milan Broz wrote:
> >> On 16/10/2020 10:49, Micka=EBl Sala=FCn wrote:
> >>> On 16/10/2020 10:29, Micka=EBl Sala=FCn wrote:
> >>>>
> >>>> On 15/10/2020 18:52, Mike Snitzer wrote:
> >>>>> Can you please explain why you've decided to make this a Kconfig CO=
NFIG
> >>>>> knob?=A0 Why not either add: a dm-verity table argument? A dm-verit=
y
> >>>>> kernel module parameter? or both (to allow a particular default but
> >>>>> then
> >>>>> per-device override)?
> >>>>
> >>>> The purpose of signed dm-verity images is to authenticate files, or =
said
> >>>> in another way, to enable the kernel to trust disk images in a flexi=
ble
> >>>> way (i.e. thanks to certificate's chain of trust). Being able to upd=
ate
> >>>> such chain at run time requires to use the second trusted keyring. T=
his
> >>>> keyring automatically includes the certificate authorities from the
> >>>> builtin trusted keyring, which are required to dynamically populate =
the
> >>>> secondary trusted keyring with certificates signed by an already tru=
sted
> >>>> authority. The roots of trust must then be included at build time in=
 the
> >>>> builtin trusted keyring.
> >>>>
> >>>> To be meaningful, using dm-verity signatures implies to have a
> >>>> restricted user space, i.e. even the root user has limited power ove=
r
> >>>> the kernel and the rest of the system. Blindly trusting data provide=
d by
> >>>> user space (e.g. dm-verity table argument, kernel module parameter)
> >>>> defeat the purpose of (mandatory) authenticated images.
> >>>>
> >>>>>
> >>>>> Otherwise, _all_ DM verity devices will be configured to use second=
ary
> >>>>> keyring fallback.=A0 Is that really desirable?
> >>>>
> >>>> That is already the current state (on purpose).
> >>>
> >>> I meant that when DM_VERITY_VERIFY_ROOTHASH_SIG is set, dm-verity
> >>> signature becomes mandatory. This new configuration
> >>> DM_VERITY_VERIFY_ROOTHASH_SIG_SECONDARY_KEYRING extend this trust to =
the
> >>> secondary trusted keyring, which contains certificates signed (direct=
ly
> >>> or indirectly) by CA from the builtin trusted keyring.
> >>>
> >>> So yes, this new (optional) configuration *extends* the source of tru=
st
> >>> for all dm-verity devices, and yes, it is desirable. I think it shoul=
d
> >>> have been this way from the beginning (as for other authentication
> >>> mechanisms) but it wasn't necessary at that time.
> >>
> >> Well, I understand why you need a config option here.
> >> And using the secondary keyring actually makes much more sense to me t=
han
> >> the original approach.
> >>
> >> But please do not forget that dm-verity is sometimes used in different
> >> contexts where such strict in-kernel certificate trust is unnecessary.
> >> With your configure options set, you deliberately remove the possibili=
ty
> >> to configure such devices.
> > It doesn't make sense to set DM_VERITY_VERIFY_ROOTHASH_SIG in generic
> > distro because such policy is configured at build time in the kernel
> > with hardcoded CAs. If the new option is not set then nothing change. I
> > don't see why it could be an issue for use cases we previously defined
> > (with DM_VERITY_VERIFY_ROOTHASH_SIG).
> >=20
> >> I understand that it is needed for "trusted" systems, but we should be
> >> clear
> >> in the documentation.
> >> Maybe also add note to
> >> /Documentation/admin-guide/device-mapper/verity.rst ?
> >> We already mention DM_VERITY_VERIFY_ROOTHASH_SIG there.
> >=20
> > The current documentation remains true.
> > DM_VERITY_VERIFY_ROOTHASH_SIG_SECONDARY_KEYRING depends on
> > DM_VERITY_VERIFY_ROOTHASH_SIG.

Yes, while true that doesn't change the fact that documenting
DM_VERITY_VERIFY_ROOTHASH_SIG_SECONDARY_KEYRING is useful to potential
consumers of baseline DM_VERITY_VERIFY_ROOTHASH_SIG.

Please update Documentation and post v3, I'll get it merged for 5.11.

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

