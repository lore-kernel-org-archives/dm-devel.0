Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 163DBC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 29 Nov 2021 17:00:31 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-75-s81JI9H2OLaeenIqVfb2VA-1; Mon, 29 Nov 2021 12:00:27 -0500
X-MC-Unique: s81JI9H2OLaeenIqVfb2VA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71469192D785;
	Mon, 29 Nov 2021 17:00:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 41D905D6BA;
	Mon, 29 Nov 2021 17:00:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0EB914BB7C;
	Mon, 29 Nov 2021 17:00:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ATH0JUb019732 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 29 Nov 2021 12:00:19 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0723A2026D7F; Mon, 29 Nov 2021 17:00:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 034342026D69
	for <dm-devel@redhat.com>; Mon, 29 Nov 2021 17:00:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C009D106655B
	for <dm-devel@redhat.com>; Mon, 29 Nov 2021 17:00:13 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-152-FUcWPxMSOo2D0gZSXtQMig-1; Mon, 29 Nov 2021 12:00:10 -0500
X-MC-Unique: FUcWPxMSOo2D0gZSXtQMig-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9BFFF1FD56;
	Mon, 29 Nov 2021 17:00:08 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5843A13B7D;
	Mon, 29 Nov 2021 17:00:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id V8mCExgHpWHFUAAAMHmgww
	(envelope-from <mwilck@suse.com>); Mon, 29 Nov 2021 17:00:08 +0000
Message-ID: <416482c0d6a6563314126bdf019df97fa516163e.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 29 Nov 2021 18:00:07 +0100
In-Reply-To: <20211129161904.GA19591@octiron.msp.redhat.com>
References: <20211118225840.19810-1-mwilck@suse.com>
	<20211118225840.19810-30-mwilck@suse.com>
	<20211125003859.GT19591@octiron.msp.redhat.com>
	<d0d0a5bbcd78083550f0df6c17463f133ca9021e.camel@suse.com>
	<20211129161904.GA19591@octiron.msp.redhat.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ATH0JUb019732
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com,
	Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [dm-devel] [PATCH v2 29/48] multipathd: uxlsnr: merge
 uxsock_trigger() into state machine
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
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2021-11-29 at 10:19 -0600, Benjamin Marzinski wrote:
> On Fri, Nov 26, 2021 at 03:34:59PM +0100, Martin Wilck wrote:
> >=20
> > I'm going to fix that, but I assume you're aware that our code is
> > far
> > from being consistent in this respect. This holds also for other
> > patches in this series. Do you want me to re-format all of them?
>=20
> Huh? I mean that the line doesn't start with a tab, but instead has 8
> spaces.=A0 A quick grep through the source code in your queue branch
> only
> turns that up in some of the files in the tests directory and in
> files
> we've just imported
>=20
> # grep -l "^=A0=A0=A0=A0=A0=A0=A0 " `find ./ -name "*.[ch]"`
> ./libmultipath/nvme/nvme-ioctl.c
> ./tests/pgpolicy.c
> ./tests/util.c
> ./tests/directio.c
> ./tests/mpathvalid.c
> ./tests/dmevents.c
> ./third-party/valgrind/drd.h
> ./third-party/valgrind/valgrind.h

Right. It must be some change in the way emacs handles indentation,
then. I'm not aware that I'm doing anything different than before.
Unfortunately, there are still some space-indented lines in my v3
submission.

I'll prepare a v4, and try to figure out what changed in my
environment. Sorry.

Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

