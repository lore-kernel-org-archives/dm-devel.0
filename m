Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D72B9C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 15 Dec 2021 07:35:17 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-314-0muKAw7UNCS56taOZ4Zlow-1; Wed, 15 Dec 2021 02:35:13 -0500
X-MC-Unique: 0muKAw7UNCS56taOZ4Zlow-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C33B1006AA0;
	Wed, 15 Dec 2021 07:35:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7500970D5F;
	Wed, 15 Dec 2021 07:35:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 389F04BB7C;
	Wed, 15 Dec 2021 07:35:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BF7XGpO011060 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 15 Dec 2021 02:33:16 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 927881121333; Wed, 15 Dec 2021 07:33:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8DD4F1121331
	for <dm-devel@redhat.com>; Wed, 15 Dec 2021 07:33:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 954E8802E5E
	for <dm-devel@redhat.com>; Wed, 15 Dec 2021 07:33:13 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-481-EMFFLx0pOJu9e2J-zGzI8A-1; Wed, 15 Dec 2021 02:33:11 -0500
X-MC-Unique: EMFFLx0pOJu9e2J-zGzI8A-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A881F1F3CA;
	Wed, 15 Dec 2021 07:33:09 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 61A0713A9F;
	Wed, 15 Dec 2021 07:33:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id UuI3FTWauWELHwAAMHmgww
	(envelope-from <mwilck@suse.com>); Wed, 15 Dec 2021 07:33:09 +0000
Message-ID: <00f998ccfd2ee9893b27e4eb536fa26c59608e8b.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed, 15 Dec 2021 08:33:08 +0100
In-Reply-To: <20211214232526.GB19591@octiron.msp.redhat.com>
References: <20211118225840.19810-1-mwilck@suse.com>
	<20211118225840.19810-4-mwilck@suse.com>
	<20211124204118.GP19591@octiron.msp.redhat.com>
	<52ddff9a6d2b1813d1269a008eb92ee522c3d6ad.camel@suse.com>
	<20211129192729.GD19591@octiron.msp.redhat.com>
	<d9260ceb655395864041a5037bac5aab6f722cf0.camel@suse.com>
	<20211130165251.GK19591@octiron.msp.redhat.com>
	<c6893070dd0d70420104ed071f7f45a365bd7faf.camel@suse.com>
	<1e0efe64215f399ca2f248590b48b4ec5024d8ed.camel@suse.com>
	<20211214232526.GB19591@octiron.msp.redhat.com>
User-Agent: Evolution 3.42.2
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1BF7XGpO011060
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com,
	Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [dm-devel] [PATCH v2 03/48] libmultipath: add optional wakeup
 functionality to lock.c
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2021-12-14 at 17:25 -0600, Benjamin Marzinski wrote:
> On Wed, Dec 01, 2021 at 01:06:45PM +0100, Martin Wilck wrote:
> > On Tue, 2021-11-30 at 21:28 +0100, Martin Wilck wrote:
> > >=20
> > > Perhaps we'll encounter another use case for it, or we find a
> > > flaw in
> > > my reasoning above. I wouldn't remove the digit.
> >=20
> > And here's the flaw: While my argument above is valid for ld.so,
> > it's
> > not for package management tools like rpm. Here on openSUSE, we got
> > rpm
> > Requires like "libmultipath.so.0(LIBMULTIPATH_13.0.0)(64bit)". As
> > distributors, we prefer incompatibilities to be detected at
> > installation time rather than at runtime. So, we do need the minor
> > version bumps.
>=20
> So where does this leave us. Are we bumping versions once per merge
> to
> Christophe's offical branch, and if distributions put out multiple
> releases between these, they are responsible for any version bumps
> that
> they need.=A0 Or are we bumping versions once per patchset if needed?

I just wanted to say that my previous argument that addition or removal
of symbols can be ignored was wrong, and that we should keep the
treatment of minor versions as originally designed. I am fine with us
not touching the .version files while we work on new patch sets, and
leaving it to the person perparing a PR for Christope (likely myself)
to fix it up when a patch series is finished. In practice, it'll
probably result in just a major version bump per submission to
Christophe, but that isn't cast in stone (if we submit a smaller set of
patches, it might be just a minor bump, or none at all).

Distros are free to modify the last digit as they please.

Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

