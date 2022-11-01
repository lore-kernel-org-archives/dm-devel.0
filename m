Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 322F2FA373D
	for <dm-devel@archiver.kernel.org>; Tue,  1 Nov 2022 10:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667299780;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ItP5AC3CZS8cdBVD2v+jF8XizRdnGSYljgvAUrMr3fw=;
	b=Yah3f7e8ttKYighoxCpUOmLBnhSh8xfk4KOCW1uBlJcQVFWcVF6lMzLjVmvLjsUK6mtHRr
	0sRzmFeLTPy9aDG5mazq7NSU2AiVoqSZjHcQXafBWAFUWY9O825pj6UxBP4pAYOKOUpFMr
	HUr8caL2ZE4wFqCyfez8OCtBYMe/gFY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-fADpJZlBPyqlxYlGh_WqIA-1; Tue, 01 Nov 2022 06:49:37 -0400
X-MC-Unique: fADpJZlBPyqlxYlGh_WqIA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CB9CD3804505;
	Tue,  1 Nov 2022 10:49:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AA301140EBF3;
	Tue,  1 Nov 2022 10:49:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 76EB319465B3;
	Tue,  1 Nov 2022 10:49:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3C1D51946594
 for <dm-devel@listman.corp.redhat.com>; Tue,  1 Nov 2022 10:49:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1753E492B13; Tue,  1 Nov 2022 10:49:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0FE3A492B0B
 for <dm-devel@redhat.com>; Tue,  1 Nov 2022 10:49:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE00F858F13
 for <dm-devel@redhat.com>; Tue,  1 Nov 2022 10:49:33 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-QVJf8hpMO2S3l3E4V5WtDQ-1; Tue, 01 Nov 2022 06:49:32 -0400
X-MC-Unique: QVJf8hpMO2S3l3E4V5WtDQ-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id 041D868AA6; Tue,  1 Nov 2022 11:49:27 +0100 (CET)
Date: Tue, 1 Nov 2022 11:49:27 +0100
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <20221101104927.GA13823@lst.de>
References: <20221030153120.1045101-1-hch@lst.de>
 <20221030153120.1045101-8-hch@lst.de>
 <fd409996-e5e1-d7af-b31d-87db943eaa25@huaweicloud.com>
MIME-Version: 1.0
In-Reply-To: <fd409996-e5e1-d7af-b31d-87db943eaa25@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH 7/7] block: store the holder kobject in
 bd_holder_disk
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 "yukuai \(C\)" <yukuai3@huawei.com>, Christoph Hellwig <hch@lst.de>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Oct 31, 2022 at 09:52:04AM +0800, Yu Kuai wrote:
>>     	INIT_LIST_HEAD(&holder->list);
>> -	holder->bdev = bdev;
>>   	holder->refcnt = 1;
>> +	holder->holder_dir = kobject_get(bdev->bd_holder_dir);
>
> I wonder is this safe here, if kobject reference is 0 here and
> bd_holder_dir is about to be freed. Here in kobject_get, kref_get() will
> warn about uaf, and kobject_get will return a address that is about to
> be freed.

But how could the reference be 0 here?  The driver that calls
bd_link_disk_holder must have the block device open and thus hold a
reference to it.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

