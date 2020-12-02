Return-Path: <SRS0=/aYG=FG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A24A6C71155
	for <dm-devel@archiver.kernel.org>; Wed,  2 Dec 2020 09:55:32 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D28492222A
	for <dm-devel@archiver.kernel.org>; Wed,  2 Dec 2020 09:55:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D28492222A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-82-ql7Vlr-NPxuu08bd6RWlhw-1; Wed, 02 Dec 2020 04:55:28 -0500
X-MC-Unique: ql7Vlr-NPxuu08bd6RWlhw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A02B7192D794;
	Wed,  2 Dec 2020 09:55:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 80A0D19C47;
	Wed,  2 Dec 2020 09:55:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5363F1809CA1;
	Wed,  2 Dec 2020 09:55:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B244c5n003232 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Dec 2020 23:04:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 409B62166B2B; Wed,  2 Dec 2020 04:04:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C08C2166B29
	for <dm-devel@redhat.com>; Wed,  2 Dec 2020 04:04:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C3CA2103B807
	for <dm-devel@redhat.com>; Wed,  2 Dec 2020 04:04:35 +0000 (UTC)
Received: from out30-56.freemail.mail.aliyun.com
	(out30-56.freemail.mail.aliyun.com [115.124.30.56]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-172-h_q5a3tFP2KCcFec_SKlEw-1;
	Tue, 01 Dec 2020 23:04:31 -0500
X-MC-Unique: h_q5a3tFP2KCcFec_SKlEw-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R941e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04426;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
	TI=SMTPD_---0UHHR.5w_1606881864
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UHHR.5w_1606881864) by smtp.aliyun-inc.com(127.0.0.1);
	Wed, 02 Dec 2020 12:04:24 +0800
From: JeffleXu <jefflexu@linux.alibaba.com>
To: snitzer@redhat.com
References: <20201130113339.42817-1-jefflexu@linux.alibaba.com>
Message-ID: <38922bfe-4d52-af4d-f6f0-9d452b257ba1@linux.alibaba.com>
Date: Wed, 2 Dec 2020 12:04:24 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201130113339.42817-1-jefflexu@linux.alibaba.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 02 Dec 2020 04:55:04 -0500
Cc: joseph.qi@linux.alibaba.com, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] dm crypt: export sysfs of kcryptd workqueue
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Mike,

What about this patch?

On 11/30/20 7:33 PM, Jeffle Xu wrote:
> It should be helpful to export sysfs of "kcryptd" workqueue in some
> cases, such as setting specific CPU affinity of the workqueue.
> 
> Besides, also tweak the name format a little. The slash inside a
> directory name will be translate into exclamation mark, such as
> /sys/devices/virtual/workqueue/'kcryptd!253:0'.
> 
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> ---
>  drivers/md/dm-crypt.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 392337f16ecf..6b4c1f674239 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -3166,11 +3166,12 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  	}
>  
>  	if (test_bit(DM_CRYPT_SAME_CPU, &cc->flags))
> -		cc->crypt_queue = alloc_workqueue("kcryptd/%s", WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM,
> +		cc->crypt_queue = alloc_workqueue("kcryptd-%s", WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM,
>  						  1, devname);
>  	else
> -		cc->crypt_queue = alloc_workqueue("kcryptd/%s",
> -						  WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM | WQ_UNBOUND,
> +		cc->crypt_queue = alloc_workqueue("kcryptd-%s",
> +						  WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM |
> +						  WQ_UNBOUND | WQ_SYSFS,
>  						  num_online_cpus(), devname);
>  	if (!cc->crypt_queue) {
>  		ti->error = "Couldn't create kcryptd queue";
> 

-- 
Thanks,
Jeffle

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

