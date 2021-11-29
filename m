Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E21F7C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 29 Nov 2021 20:57:05 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-457-YIVtkohaOnieeAJ0I8fO0w-1; Mon, 29 Nov 2021 15:57:01 -0500
X-MC-Unique: YIVtkohaOnieeAJ0I8fO0w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6715801B27;
	Mon, 29 Nov 2021 20:56:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A372C5D9C0;
	Mon, 29 Nov 2021 20:56:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 015531809C89;
	Mon, 29 Nov 2021 20:56:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ATKqtZh006906 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 29 Nov 2021 15:52:56 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B656E401E45; Mon, 29 Nov 2021 20:52:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B274A401E22
	for <dm-devel@redhat.com>; Mon, 29 Nov 2021 20:52:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 97BF98007B1
	for <dm-devel@redhat.com>; Mon, 29 Nov 2021 20:52:55 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-217-etYND9Z0NzOPG98avdylIw-1; Mon, 29 Nov 2021 15:52:51 -0500
X-MC-Unique: etYND9Z0NzOPG98avdylIw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8DDBB1FD2F;
	Mon, 29 Nov 2021 20:52:50 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4A0B413BEC;
	Mon, 29 Nov 2021 20:52:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id fJPFD6I9pWGcLQAAMHmgww
	(envelope-from <mwilck@suse.com>); Mon, 29 Nov 2021 20:52:50 +0000
Message-ID: <d9260ceb655395864041a5037bac5aab6f722cf0.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 29 Nov 2021 21:52:49 +0100
In-Reply-To: <20211129192729.GD19591@octiron.msp.redhat.com>
References: <20211118225840.19810-1-mwilck@suse.com>
	<20211118225840.19810-4-mwilck@suse.com>
	<20211124204118.GP19591@octiron.msp.redhat.com>
	<52ddff9a6d2b1813d1269a008eb92ee522c3d6ad.camel@suse.com>
	<20211129192729.GD19591@octiron.msp.redhat.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ATKqtZh006906
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2021-11-29 at 13:27 -0600, Benjamin Marzinski wrote:
> On Wed, Nov 24, 2021 at 10:20:53PM +0100, Martin Wilck wrote:
> > On Wed, 2021-11-24 at 14:41 -0600, Benjamin Marzinski wrote:
> > > On Thu, Nov 18, 2021 at 11:57:55PM +0100, mwilck@suse.com=A0wrote:
> > > > From: Martin Wilck <mwilck@suse.com>
> > > >=20
> > > > Have struct mutex_lock take an optional wakeup function.
> > > > unlock() is renamed to __unlock() in order to prevent it from
> > > > being called by mistake.
> > > >=20
> > > > This changes offsets in "struct vectors", requiring a major
> > > > libmultipath version bump. While the strucure is already
> > > > changed,
> > > > in order to avoid this in the future, move the lock to the end
> > > > of "struct vectors".
> > > >=20
> > > > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > >=20
> > > In libmultipath.version, I would have said that set_wakeup_fn was
> > > added
> > > in 10.0.0, instead of 9.2.0, which is a version that never
> > > actually
> > > existed, but I don't think that's going to cause any problems so,
> > >=20
> > > Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> >=20
> > We should consider whether we want bump the version numbers only
> > when
> > we submit to Christophe, or maybe once per major patch series that
> > touches the ABI. This is something that I could=20
>=20
> I suppose that we could just bump the version the first time after a
> push to Christophe that an ABI change is made, and then just make all
> the symbol changes under that version until Christophe makes another
> release. If the first change only caused a minor version bump, and a
> later change needed a major bump we could have two version bumps in a
> release, but I don't think we're getting any benefit from making
> more.
> But once per patchset works fine for me too.

I agree. Also, I realize that we've bumped the library version too
often in the past. If we add a function, we don't need to bump. Because
a program that needs the added function will require e.g.
foo@LIBMULTIPATH_10.0.0, and this will fail for a library that doesn't
export foo (which is what we want). Likewise for function deletion - a
program that calls the deleted function will fail to link with the
updated library. OTOH, programs that use this version of the ABI
*without* using the functions which are added or removed are unaffected
by the addition / removal.

The only case in which the ABI version must be bumped is when we have
changed functions or data structures.

Furthermore, I believe now that the habit (which I introduced) to list
added functions at the end of the .version files, with comments
indicating when they were added, is useless. We should rather keep the
.version file ordered alphabetically.

Regards
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

