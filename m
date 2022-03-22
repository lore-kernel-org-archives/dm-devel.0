Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7A25C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 22 Mar 2022 11:19:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-304-FFcTHNC9NSeVeEwdGyswtA-1; Tue, 22 Mar 2022 07:19:02 -0400
X-MC-Unique: FFcTHNC9NSeVeEwdGyswtA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 48BF9185A7A4;
	Tue, 22 Mar 2022 11:19:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B978B2166B2D;
	Tue, 22 Mar 2022 11:18:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4AC7B1949762;
	Tue, 22 Mar 2022 11:18:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2E92E1947BBC
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 11:18:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F0BE94B8D4D; Tue, 22 Mar 2022 11:18:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ED384401E88
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 11:18:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D7A40811E75
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 11:18:55 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-502-tRRyeSbhMxWKGA_koVyAVA-1; Tue, 22 Mar 2022 07:18:51 -0400
X-MC-Unique: tRRyeSbhMxWKGA_koVyAVA-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id 5189868AFE; Tue, 22 Mar 2022 12:18:48 +0100 (CET)
Date: Tue, 22 Mar 2022 12:18:48 +0100
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.garry@huawei.com>
Message-ID: <20220322111848.GA29270@lst.de>
References: <1647945585-197349-1-git-send-email-john.garry@huawei.com>
 <1647945585-197349-2-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
In-Reply-To: <1647945585-197349-2-git-send-email-john.garry@huawei.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH 01/11] blk-mq: Add blk_mq_init_queue_ops()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: axboe@kernel.dk, bvanassche@acm.org, martin.petersen@oracle.com,
 chenxiang66@hisilicon.com, damien.lemoal@opensource.wdc.com,
 linux-kernel@vger.kernel.org, hch@lst.de, linux-block@vger.kernel.org,
 linux-ide@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org,
 ming.lei@redhat.com, jejb@linux.ibm.com, beanhuo@micron.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Mar 22, 2022 at 06:39:35PM +0800, John Garry wrote:
> Add an API to allocate a request queue which accepts a custom set of
> blk_mq_ops for that request queue.
> 
> The reason which we may want custom ops is for queuing requests which we
> don't want to go through the normal queuing path.

Eww.  I really do not think we should do separate ops per queue, as that
is going to get us into a deep mess eventually.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

