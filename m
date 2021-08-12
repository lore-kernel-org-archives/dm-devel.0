Return-Path: <SRS0=gpIH=ND=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7783C4338F
	for <dm-devel@archiver.kernel.org>; Thu, 12 Aug 2021 07:23:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2ED886104F
	for <dm-devel@archiver.kernel.org>; Thu, 12 Aug 2021 07:23:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2ED886104F
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-510-Jtak66EPMmu0UTnGPQlKJQ-1; Thu, 12 Aug 2021 03:23:19 -0400
X-MC-Unique: Jtak66EPMmu0UTnGPQlKJQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F131108292C;
	Thu, 12 Aug 2021 07:23:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 365AE60C04;
	Thu, 12 Aug 2021 07:23:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9621C4BB7C;
	Thu, 12 Aug 2021 07:23:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17C7JExn026397 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 12 Aug 2021 03:19:14 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 89CE72015D0B; Thu, 12 Aug 2021 07:19:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 84067202868F
	for <dm-devel@redhat.com>; Thu, 12 Aug 2021 07:19:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D6208CA94F
	for <dm-devel@redhat.com>; Thu, 12 Aug 2021 07:19:11 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-452-t6RG-LEcNJ-f_bmuLTSPYw-1; Thu, 12 Aug 2021 03:19:07 -0400
X-MC-Unique: t6RG-LEcNJ-f_bmuLTSPYw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C9F56221CF;
	Thu, 12 Aug 2021 07:19:05 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8F88F1345F;
	Thu, 12 Aug 2021 07:19:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id LaPvIGnLFGG5GAAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 12 Aug 2021 07:19:05 +0000
Message-ID: <4e5798a3cd0244e617dab4590d8698b73f9ae7e9.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Bart Van Assche <bvanassche@acm.org>, Benjamin Marzinski
	<bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Thu, 12 Aug 2021 09:19:04 +0200
In-Reply-To: <942d3693-959a-556d-35b8-d2bf7c4e55e4@acm.org>
References: <20210811154150.24714-1-mwilck@suse.com>
	<20210811154150.24714-3-mwilck@suse.com>
	<942d3693-959a-556d-35b8-d2bf7c4e55e4@acm.org>
User-Agent: Evolution 3.40.3
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 17C7JExn026397
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2 2/9] libmultipath: strbuf: simple api for
 growing string buffers
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

Hello Bart,

On Mi, 2021-08-11 at 09:08 -0700, Bart Van Assche wrote:
> On 8/11/21 8:41 AM, mwilck@suse.com=A0wrote:
> > Add an API for string buffers that grow in size as text is added.
> > This API will be useful in several places of the multipath-tools
> > code
> > base. Add unit tests for these helpers, too.
>=20
> Has it been considered to switch to C++ and use std::string and/or=20
> std::ostringstream instead of implementing a string library in C?
>=20

no, not at this time. It's an interesting long-term perspective, but
for the time being, I think we can quite well stick with C.

Regards,
Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

