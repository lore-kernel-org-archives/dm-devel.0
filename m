Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 764CAC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 30 Nov 2021 11:22:08 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-byyPq41yPe-YW5uBLfAMKg-1; Tue, 30 Nov 2021 06:22:03 -0500
X-MC-Unique: byyPq41yPe-YW5uBLfAMKg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9BBE98749A5;
	Tue, 30 Nov 2021 11:21:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0466A6060F;
	Tue, 30 Nov 2021 11:21:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E91691809C89;
	Tue, 30 Nov 2021 11:21:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AUBLpUI005632 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 30 Nov 2021 06:21:51 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0B1BD492C3B; Tue, 30 Nov 2021 11:21:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 06E44492C38
	for <dm-devel@redhat.com>; Tue, 30 Nov 2021 11:21:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DFFE0801212
	for <dm-devel@redhat.com>; Tue, 30 Nov 2021 11:21:50 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-61-RNmLScFnNOe_qd0Jiq3pUQ-1; Tue, 30 Nov 2021 06:21:47 -0500
X-MC-Unique: RNmLScFnNOe_qd0Jiq3pUQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9C356212C5;
	Tue, 30 Nov 2021 11:21:45 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 628FE13C98;
	Tue, 30 Nov 2021 11:21:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id L6k+FkkJpmHnUQAAMHmgww
	(envelope-from <mwilck@suse.com>); Tue, 30 Nov 2021 11:21:45 +0000
Message-ID: <e56fcde94769fcdd44d0237b152407618be7f23e.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Tue, 30 Nov 2021 12:21:44 +0100
In-Reply-To: <20211130011759.GG19591@octiron.msp.redhat.com>
References: <20211118231338.22358-1-mwilck@suse.com>
	<20211118231338.22358-6-mwilck@suse.com>
	<20211130011759.GG19591@octiron.msp.redhat.com>
User-Agent: Evolution 3.42.1
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AUBLpUI005632
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 05/21] libmultipath (coverity): improve input
 checking in parse_vpd_pg83
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2021-11-29 at 19:17 -0600, Benjamin Marzinski wrote:
> On Fri, Nov 19, 2021 at 12:13:22AM +0100, mwilck@suse.com=A0wrote:
> > From: Martin Wilck <mwilck@suse.com>
> >=20
> > Check offsets and other obvious errors in the VPD83 data.
> >=20
> > The original reason to do this was to fix "tained scalar"
> > warnings from coverity. But this doesn't suffice for coverity
> > without using a constant boundary (WWID_SIZE) for "len" in
> > parse_vpd_pg80() and for "vpd_len" in parse_vpd_pg83(), even
> > though the computed boundaries are tighter than the constant
> > ones.
> >=20
>=20
> This looks fine, but I do wonder if we are being too strict.=A0 I'm not
> sure we should be failing, if sg_inq wouldn't fail.=A0 The goal of the
> fallback code is to get the WWID the udev would have gotten, and
> being
> lenient with scsi devices that don't quite follow the standard is
> usually the best policy. Thoughts?

If we encounter a broken VPD entry, IMO we can't continue reading
further entries, because if the entry is broken, we can't trust the
length value which is part of the entry. We may be reading total junk
if we follow it.

We might simply discard the broken entry, stop iterating over the
designators, see if we got a usable designator up to that point (i.e.,
previously), and if yes, use that entry, printing a big fat warning.=A0
That means we'd ultimately fail only if there was no usable designator
before the broken one.

Would you prefer that strategy?

Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

