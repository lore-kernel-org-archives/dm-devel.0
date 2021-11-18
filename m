Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B3DDC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 15:37:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D0CDC6138D
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 15:37:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D0CDC6138D
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-248-uGQOqflNNXCgd_-LCfMq3A-1; Thu, 18 Nov 2021 10:37:00 -0500
X-MC-Unique: uGQOqflNNXCgd_-LCfMq3A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7275719253CD;
	Thu, 18 Nov 2021 15:36:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 51BC160C05;
	Thu, 18 Nov 2021 15:36:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F13F5180BAD1;
	Thu, 18 Nov 2021 15:36:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AIFapYO022726 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Nov 2021 10:36:51 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8B4A9112131B; Thu, 18 Nov 2021 15:36:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 862681121315
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 15:36:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2DA6A181E085
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 15:36:46 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-190-TKM35PNkNPKSvYgZR70BYg-1; Thu, 18 Nov 2021 10:36:44 -0500
X-MC-Unique: TKM35PNkNPKSvYgZR70BYg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E179A1FD38;
	Thu, 18 Nov 2021 15:36:42 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8E9FC13D48;
	Thu, 18 Nov 2021 15:36:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id 2ryKIApzlmEAJAAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 18 Nov 2021 15:36:42 +0000
Message-ID: <f416a25130ecc8834ea3946bbb58151a5ccab26c.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: lixiaokeng <lixiaokeng@huawei.com>, Christophe Varoqui
	<christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel mailing list <dm-devel@redhat.com>
Date: Thu, 18 Nov 2021 16:36:41 +0100
In-Reply-To: <adf675e0-1ed6-f395-e428-548fe145ea64@huawei.com>
References: <78637f61-851d-cf9d-d308-9c22396d2071@huawei.com>
	<adf675e0-1ed6-f395-e428-548fe145ea64@huawei.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AIFapYO022726
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: Re: [dm-devel] [PATCH 5/5] add prflag to path
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2021-11-16 at 22:01 +0800, lixiaokeng wrote:
> The update_map will frequently be called and there will be
> unnecessary checks of reseravtion. We add prflag to path
> to avoid this.
>=20
> The pp->state changes from others to up or ghost, the
> mpath_pr_event_handle should be called. The
> mpath_pr_event_handle in ev_add_path may not be called,
> so set pp->prkey PRKEY_NO when path is removed.
>=20
> Fix: 4db4fa
> Signed-off-by: Lixiaokeng <lixiaokeng>
> ---
> =A0libmpathpersist/mpath_persist.c |=A0 2 +-
> =A0libmultipath/structs.c=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> =A0libmultipath/structs.h=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 12 ++++++++++++
> =A0multipathd/cli_handlers.c=A0=A0=A0=A0=A0=A0 | 15 ++++++++++-----
> =A0multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 5 +++=
--
> =A05 files changed, 27 insertions(+), 8 deletions(-)
>=20
> diff --git a/libmpathpersist/mpath_persist.c
> b/libmpathpersist/mpath_persist.c
> index 803a2a28..f88a2e89 100644
> --- a/libmpathpersist/mpath_persist.c
> +++ b/libmpathpersist/mpath_persist.c
>=20
> +/*
> + * PRFLAG_NO for path, it means reservation should be checked.
> + * PRFLAG_NO for multipath, it means mpp has no prkey.
> + * PRFLAG_OK for path, it means reservation has been checked.
> + * PRFLAG_OK for multipath, it means mpp has prkey.
> + */

Please don't use the same enum with different meanings in different
context.

Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

