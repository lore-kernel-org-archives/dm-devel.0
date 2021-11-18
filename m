Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EB25C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 15:33:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 19B03613D3
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 15:33:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 19B03613D3
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-39-9zV_hiWiPJ68rMbUhmHsSw-1; Thu, 18 Nov 2021 10:33:01 -0500
X-MC-Unique: 9zV_hiWiPJ68rMbUhmHsSw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C918C100C668;
	Thu, 18 Nov 2021 15:32:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 98F335F4F4;
	Thu, 18 Nov 2021 15:32:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4023F4EA39;
	Thu, 18 Nov 2021 15:32:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AIFV85X022284 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Nov 2021 10:31:08 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 04E54404727D; Thu, 18 Nov 2021 15:31:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 008534047279
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 15:31:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DAAAD81B55E
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 15:31:07 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-455-jafGPGTZMcevh9LD2Db9DQ-1; Thu, 18 Nov 2021 10:31:06 -0500
X-MC-Unique: jafGPGTZMcevh9LD2Db9DQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E0E0E212FE;
	Thu, 18 Nov 2021 15:31:03 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 89CAB13D43;
	Thu, 18 Nov 2021 15:31:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id vt0rH7dxlmF/IQAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 18 Nov 2021 15:31:03 +0000
Message-ID: <8ed8fd1b0856e2f9c2043d600edfb7d0c09f365f.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, lixiaokeng
	<lixiaokeng@huawei.com>
Date: Thu, 18 Nov 2021 16:31:02 +0100
In-Reply-To: <20211118004716.GF19591@octiron.msp.redhat.com>
References: <78637f61-851d-cf9d-d308-9c22396d2071@huawei.com>
	<483a6cc1-10f1-a702-2e44-42ab7cb8e3cd@huawei.com>
	<20211118004716.GF19591@octiron.msp.redhat.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 2021-11-17 at 18:47 -0600, Benjamin Marzinski wrote:
> On Tue, Nov 16, 2021 at 10:00:53PM +0800, lixiaokeng wrote:
> > In _DEBUG_ mode, MALLOC/STRDUP/REALLOC and FREE will record
> > the memory usage. Match them.
> 
> This looks fine, but personally, I'd rather just have all the DEBUG
> memory code removed. If people want to check memory usage, there's
> always valgrind.

Ack. I'd rather see the MALLOC, FREE etc removed from the code.
I wouldn't want to add any more of them.

Good to see that you have similar feelings about this.

Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

