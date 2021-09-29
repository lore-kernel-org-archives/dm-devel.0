Return-Path: <SRS0=53Ra=OT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3417DC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 29 Sep 2021 06:52:21 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 88F3A613A9
	for <dm-devel@archiver.kernel.org>; Wed, 29 Sep 2021 06:52:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 88F3A613A9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-MUPRvFkOMrewx_m6F_3H8g-1; Wed, 29 Sep 2021 02:52:18 -0400
X-MC-Unique: MUPRvFkOMrewx_m6F_3H8g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B471C100C626;
	Wed, 29 Sep 2021 06:52:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A4855FC23;
	Wed, 29 Sep 2021 06:52:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0FC8C1800B9C;
	Wed, 29 Sep 2021 06:52:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18T6qBFO021910 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 29 Sep 2021 02:52:11 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1C3C21003355; Wed, 29 Sep 2021 06:52:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 18109100708F
	for <dm-devel@redhat.com>; Wed, 29 Sep 2021 06:52:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E3BB080B913
	for <dm-devel@redhat.com>; Wed, 29 Sep 2021 06:52:07 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-325-o8SOlf-mMHK0_U4WB9s2LQ-1;
	Wed, 29 Sep 2021 02:52:05 -0400
X-MC-Unique: o8SOlf-mMHK0_U4WB9s2LQ-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id E4F6567357; Wed, 29 Sep 2021 08:52:02 +0200 (CEST)
Date: Wed, 29 Sep 2021 08:52:02 +0200
From: Christoph Hellwig <hch@lst.de>
To: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Message-ID: <20210929065202.GA31534@lst.de>
References: <68dde454-965a-0c44-374a-a0ca277150ee@linux.vnet.ibm.com>
	<20210901133618.GA16687@lst.de>
	<86f8e47b-84ca-4cc3-5d5b-f5f11c1d4d1a@linux.vnet.ibm.com>
MIME-Version: 1.0
In-Reply-To: <86f8e47b-84ca-4cc3-5d5b-f5f11c1d4d1a@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, sachinp <sachinp@linux.vnet.ibm.com>, jack@suse.cz,
	linux-scsi <linux-scsi@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>, dm-devel@redhat.com,
	linux-next <linux-next@vger.kernel.org>, dougmill@us.ibm.com,
	Brian King <brking@linux.vnet.ibm.com>,
	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [next-20210827][ppc][multipathd] INFO: task hung in
 dm_table_add_target
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Sep 28, 2021 at 03:53:47PM +0530, Abdul Haleem wrote:
>
> On 9/1/21 7:06 PM, Christoph Hellwig wrote:
>> On Wed, Sep 01, 2021 at 04:47:26PM +0530, Abdul Haleem wrote:
>>> Greeting's
>>>
>>> multiple task hung while adding the vfc disk back to the multipath on my
>>> powerpc box running linux-next kernel
>> Can you retry to reproduce this with lockdep enabled to see if there
>> is anything interesting holding this lock?
>
> LOCKDEP was earlier enabled by default
>
> # cat .config | grep LOCKDEP
> CONFIG_LOCKDEP_SUPPORT=y
>
> BTW, Recreated again on 5.15.0-rc2 mainline kernel and attaching the logs

It seems the reinstate is blocking on the close which is blocking on
flushing dirty data.  In other words it looks like the link blocking
looks like the symptom and not the cause.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

