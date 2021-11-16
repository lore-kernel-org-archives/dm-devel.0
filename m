Return-Path: <SRS0=rSqa=QD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9BD3C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 16 Nov 2021 21:35:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 52ED861502
	for <dm-devel@archiver.kernel.org>; Tue, 16 Nov 2021 21:35:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 52ED861502
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-383-ydOGDVcNMeCmdPuM689ThQ-1; Tue, 16 Nov 2021 16:35:45 -0500
X-MC-Unique: ydOGDVcNMeCmdPuM689ThQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85F5FE744;
	Tue, 16 Nov 2021 21:35:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 86B3699CC;
	Tue, 16 Nov 2021 21:35:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E5F0F1819AC1;
	Tue, 16 Nov 2021 21:35:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AGLY9xq012556 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 16 Nov 2021 16:34:09 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id AEE8C2026D65; Tue, 16 Nov 2021 21:34:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AA02C2026D5D
	for <dm-devel@redhat.com>; Tue, 16 Nov 2021 21:34:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B7A6A85A5A8
	for <dm-devel@redhat.com>; Tue, 16 Nov 2021 21:34:06 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-542-Bcx1Yb-2Nlm5LNjWr6JxZQ-1; Tue, 16 Nov 2021 16:34:05 -0500
X-MC-Unique: Bcx1Yb-2Nlm5LNjWr6JxZQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 911671FD37;
	Tue, 16 Nov 2021 21:34:03 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5CBC113C62;
	Tue, 16 Nov 2021 21:34:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id utVUFMsjlGHxHAAAMHmgww
	(envelope-from <mwilck@suse.com>); Tue, 16 Nov 2021 21:34:03 +0000
Message-ID: <0143a4a6360115591679c5830a3606bf5d01ef14.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski
	<bmarzins@redhat.com>
Date: Tue, 16 Nov 2021 22:34:02 +0100
In-Reply-To: <20211115202201.755-2-mwilck@suse.com>
References: <20211115202201.755-1-mwilck@suse.com>
	<20211115202201.755-2-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AGLY9xq012556
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 2/3] kpartx: use opened loop device
	immediately
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2021-11-15 at 21:22 +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
>=20
> The code in find_unused_loop_device() goes through circles to
> get an unused device, but it takes no care not to race with a
> different
> process opening the same loop device. Use the once-opened
> loop device for setup immediately instead of closing and re-opening
> it.
>=20
> While at it, simplify the code somewhat.
>=20
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
> =A0kpartx/kpartx.c |=A0 4 +--
> =A0kpartx/lopart.c | 72 +++++++++++++++++++----------------------------
> --
> =A0kpartx/lopart.h |=A0 3 +--
> =A03 files changed, 29 insertions(+), 50 deletions(-)
>=20
> diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
> index 7bc6454..3c49999 100644
> --- a/kpartx/kpartx.c
> +++ b/kpartx/kpartx.c
> =A0
> @@ -266,11 +250,9 @@ int set_loop(const char *device, const char
> *file, int offset, int *loopro)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0
> -=A0=A0=A0=A0=A0=A0=A0if ((fd =3D open (device, mode)) < 0) {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0close(ffd);
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0perror (device);
> +=A0=A0=A0=A0=A0=A0=A0*device =3D find_unused_loop_device(mode, &fd);
> +=A0=A0=A0=A0=A0=A0=A0if (!*device)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;

This leaks the file descriptor ffd. I'll re-post.

Regards
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

