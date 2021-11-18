Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DC29C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 15:47:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3CFBD613D3
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 15:47:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3CFBD613D3
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-44-RwHoyxwvMkeAi618FtdBxA-1; Thu, 18 Nov 2021 10:47:34 -0500
X-MC-Unique: RwHoyxwvMkeAi618FtdBxA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 093FD1851725;
	Thu, 18 Nov 2021 15:47:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B5F115E279;
	Thu, 18 Nov 2021 15:47:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F2ABF4EA2A;
	Thu, 18 Nov 2021 15:47:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AIFgeHi023059 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Nov 2021 10:42:40 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A43702026D46; Thu, 18 Nov 2021 15:42:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A02062026D60
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 15:42:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8941818A045E
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 15:35:16 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-351-uxUliy23MweaUvmPtTYoLQ-1; Thu, 18 Nov 2021 10:35:13 -0500
X-MC-Unique: uxUliy23MweaUvmPtTYoLQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B9C931FD29;
	Thu, 18 Nov 2021 15:35:11 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5FAFC13D43;
	Thu, 18 Nov 2021 15:35:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id bXMQFa9ylmFiIwAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 18 Nov 2021 15:35:11 +0000
Message-ID: <c12a8f41b41d213bd6e7cb1196e63f22cb3afab1.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: lixiaokeng <lixiaokeng@huawei.com>, Benjamin Marzinski
	<bmarzins@redhat.com>
Date: Thu, 18 Nov 2021 16:35:10 +0100
In-Reply-To: <38da7635-d5cb-3d14-2358-e06dbd7fce24@huawei.com>
References: <78637f61-851d-cf9d-d308-9c22396d2071@huawei.com>
	<483a6cc1-10f1-a702-2e44-42ab7cb8e3cd@huawei.com>
	<20211118004716.GF19591@octiron.msp.redhat.com>
	<38da7635-d5cb-3d14-2358-e06dbd7fce24@huawei.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AIFgeHi023059
X-loop: dm-devel@redhat.com
Cc: dm-devel, list <dm-devel@redhat.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>,
	linfeilong <linfeilong@huawei.com>
Subject: Re: [dm-devel] [PATCH 4/5] Match FREE and MALLOC/STRDUP/REALLOC
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

On Thu, 2021-11-18 at 10:46 +0800, lixiaokeng wrote:
>=20
>=20
> On 2021/11/18 8:47, Benjamin Marzinski wrote:
> > On Tue, Nov 16, 2021 at 10:00:53PM +0800, lixiaokeng wrote:
> > > In _DEBUG_ mode, MALLOC/STRDUP/REALLOC and FREE will record
> > > the memory usage. Match them.
> >=20
> > This looks fine, but personally, I'd rather just have all the DEBUG
> > memory code removed. If people want to check memory usage, there's
> > always valgrind.
> >=20
> > -Ben
> >=20
> > >=20
>=20
> If MALLOC/STRDUP/REALLOC and FREE is unnecessary, I'll remove this
> patch
> in this series and make a patch remove them latter. What is Martin's
> opinion?

As you saw, I agree with Ben. If you want to make a major contribution,
prepare a patch that gets rid of all those. :-)=A0

Just note that MALLOC() is really calloc().=20

The only one that that's useful in non-debug mode is FREE(), because it
sets the pointer to NULL, avoiding double-free. Therefore a patch
replacing FREE() with free() would need to assess where that's
necessary (basically always if the data structure that holds the
pointer lives on after the free() call).

Regards
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

