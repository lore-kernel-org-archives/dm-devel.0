Return-Path: <SRS0=0/yZ=PI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0386CC433FE
	for <dm-devel@archiver.kernel.org>; Wed, 20 Oct 2021 18:49:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 65F6F610D0
	for <dm-devel@archiver.kernel.org>; Wed, 20 Oct 2021 18:49:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 65F6F610D0
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-k-BXc09sO02-qGxRx4KlAA-1; Wed, 20 Oct 2021 14:49:46 -0400
X-MC-Unique: k-BXc09sO02-qGxRx4KlAA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 526451800D41;
	Wed, 20 Oct 2021 18:49:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6CF971816A;
	Wed, 20 Oct 2021 18:49:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0D4514A703;
	Wed, 20 Oct 2021 18:49:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19KIilI2031381 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 20 Oct 2021 14:44:47 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 37D7D40CFD11; Wed, 20 Oct 2021 18:44:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 32D6640CFD01
	for <dm-devel@redhat.com>; Wed, 20 Oct 2021 18:44:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1995380158D
	for <dm-devel@redhat.com>; Wed, 20 Oct 2021 18:44:47 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-450-EcsAqhTAOPO4Xu9SebhVHw-1; Wed, 20 Oct 2021 14:44:45 -0400
X-MC-Unique: EcsAqhTAOPO4Xu9SebhVHw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F0AEC1FD4B;
	Wed, 20 Oct 2021 18:44:43 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BBECA13BF1;
	Wed, 20 Oct 2021 18:44:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id LHNDK5tjcGH/BgAAMHmgww
	(envelope-from <mwilck@suse.com>); Wed, 20 Oct 2021 18:44:43 +0000
Message-ID: <d300f40640858a6c38d37285da2ffc381ce689c3.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: "berthiaume, wayne" <Wayne.Berthiaume@dell.com>, Xose Vazquez Perez
	<xose.vazquez@gmail.com>
Date: Wed, 20 Oct 2021 20:44:43 +0200
In-Reply-To: <BY3PR19MB48522AA6EFF15AC8608253ECE2AA9@BY3PR19MB4852.namprd19.prod.outlook.com>
References: <20210928173121.18081-1-xose.vazquez@gmail.com>
	<BY3PR19MB48522AA6EFF15AC8608253ECE2AA9@BY3PR19MB4852.namprd19.prod.outlook.com>
User-Agent: Evolution 3.42.0
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 19KIilI2031381
X-loop: dm-devel@redhat.com
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH] multipath-tools: make EMC/Invista config
 work with alua and multibus
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

Wayne,

On Thu, 2021-09-30 at 14:32 +0000, berthiaume, wayne wrote:
> Hi Xose.
>=20
> =A0=A0=A0=A0=A0=A0=A0=A0OPM is no longer supported in the Dell VPLEX prod=
uct. If we
> at Dell had wished to change the default device stanzas for any of
> our products they would have been done when the product and/or
> feature is released. Please remove this patch as well. It is not
> needed.

thanks for the feedback, and thanks for paying attention.=A0
The patch will be removed. The one for SYMMETRIX, likewise.


Regards
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

