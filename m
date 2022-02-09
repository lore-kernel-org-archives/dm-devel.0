Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6D10C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  9 Feb 2022 14:07:55 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-463-68OoA-eGOlWJg-kKzcP7Ig-1; Wed, 09 Feb 2022 09:07:52 -0500
X-MC-Unique: 68OoA-eGOlWJg-kKzcP7Ig-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3042583DCA2;
	Wed,  9 Feb 2022 14:07:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D37A7D728;
	Wed,  9 Feb 2022 14:07:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E0A384BB7B;
	Wed,  9 Feb 2022 14:07:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 219E4tNk026098 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 9 Feb 2022 09:04:56 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DBA6EC07F5D; Wed,  9 Feb 2022 14:04:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D8432C080AE
	for <dm-devel@redhat.com>; Wed,  9 Feb 2022 14:04:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C45AF10726A2
	for <dm-devel@redhat.com>; Wed,  9 Feb 2022 14:04:55 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-107-3vRfwWO_MGmi5axTJTtvwg-1; Wed, 09 Feb 2022 09:04:53 -0500
X-MC-Unique: 3vRfwWO_MGmi5axTJTtvwg-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id 35FB767373; Wed,  9 Feb 2022 15:04:49 +0100 (CET)
Date: Wed, 9 Feb 2022 15:04:48 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jinpu Wang <jinpu.wang@ionos.com>
Message-ID: <20220209140448.GA20765@lst.de>
References: <20220209082828.2629273-1-hch@lst.de>
	<20220209082828.2629273-4-hch@lst.de>
	<CAMGffE=GMYNsw+mDt1h-BDh3JXkdrP9v2AUF7z0xE7jkumM+RQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAMGffE=GMYNsw+mDt1h-BDh3JXkdrP9v2AUF7z0xE7jkumM+RQ@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, manoj@linux.ibm.com, linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com, philipp.reisner@linbit.com,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	target-devel@vger.kernel.org, haris.iqbal@ionos.com,
	ukrishn@linux.ibm.com, lars.ellenberg@linbit.com,
	drbd-dev@lists.linbit.com, Christoph Hellwig <hch@lst.de>,
	mrochs@linux.ibm.com
Subject: Re: [dm-devel] [PATCH 3/7] rnbd: drop WRITE_SAME support
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Feb 09, 2022 at 11:16:13AM +0100, Jinpu Wang wrote:
> Hi Christoph,
> 
> 
> On Wed, Feb 9, 2022 at 9:28 AM Christoph Hellwig <hch@lst.de> wrote:
> >
> > REQ_OP_WRITE_SAME was only ever submitted by the legacy Linux zeroing
> > code, which has switched to use REQ_OP_WRITE_ZEROES long before rnbd was
> > even merged.
> 
> Do you think if it makes sense to instead of removing
> REQ_OP_WRITE_SAME, simply convert it to REQ_OP_WRITE_ZEROES?

Well, they have different semantics, so you can't just "convert" it.
But it might make sense to add REQ_OP_WRITE_ZEROES.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

