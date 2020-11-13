Return-Path: <SRS0=awJs=ET=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36BB5C55ABD
	for <dm-devel@archiver.kernel.org>; Fri, 13 Nov 2020 08:02:55 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 739C020857
	for <dm-devel@archiver.kernel.org>; Fri, 13 Nov 2020 08:02:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 739C020857
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-i36lc8M7OlCLSeCwZ7tbDA-1; Fri, 13 Nov 2020 03:02:51 -0500
X-MC-Unique: i36lc8M7OlCLSeCwZ7tbDA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 803AD809DFA;
	Fri, 13 Nov 2020 08:02:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 609A55577D;
	Fri, 13 Nov 2020 08:02:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 358F158111;
	Fri, 13 Nov 2020 08:02:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AD2CKcW001964 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 12 Nov 2020 21:12:20 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 32EA5F11F3; Fri, 13 Nov 2020 02:12:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2DA7410F024
	for <dm-devel@redhat.com>; Fri, 13 Nov 2020 02:12:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D375A1021F88
	for <dm-devel@redhat.com>; Fri, 13 Nov 2020 02:12:16 +0000 (UTC)
Received: from out30-43.freemail.mail.aliyun.com
	(out30-43.freemail.mail.aliyun.com [115.124.30.43]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-4-XXxNgH9KNomtruyCL6lwvA-1;
	Thu, 12 Nov 2020 21:12:14 -0500
X-MC-Unique: XXxNgH9KNomtruyCL6lwvA-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R691e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e01424;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=4; SR=0;
	TI=SMTPD_---0UF8jmCY_1605233529
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UF8jmCY_1605233529) by smtp.aliyun-inc.com(127.0.0.1);
	Fri, 13 Nov 2020 10:12:09 +0800
From: JeffleXu <jefflexu@linux.alibaba.com>
To: snitzer@redhat.com
References: <20201110065558.22694-1-jefflexu@linux.alibaba.com>
	<20201113020551.55716-1-jefflexu@linux.alibaba.com>
Message-ID: <36d70710-6c8b-0206-6f60-6a3cea5fa3f1@linux.alibaba.com>
Date: Fri, 13 Nov 2020 10:12:09 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
	Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201113020551.55716-1-jefflexu@linux.alibaba.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 13 Nov 2020 03:02:15 -0500
Cc: joseph.qi@linux.alibaba.com, dm-devel@redhat.com, koct9i@gmail.com
Subject: Re: [dm-devel] [PATCH v2] dm: add support for DM_TARGET_NOWAIT for
 various targets
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hi Mike,

I just tweaks the commit message in this v2 patch to make the purpose 
clearer,

while keep the code unstained.


Thanks,

Jeffle


On 11/13/20 10:05 AM, Jeffle Xu wrote:
> commit 021a24460dc2 ("block: add QUEUE_FLAG_NOWAIT") adds a new queue
> flag QUEUE_FLAG_NOWAIT to advertise if the bdev supports handling of
> REQ_NOWAIT or not. DM core supports this in commit 6abc49468eea ("dm:
> add support for REQ_NOWAIT and enable it for linear target"), in which
> only dm-linear is enabled.
>
> This patch also enables several dm-linear likely dm targets, the mapping
> algorithm of which is just simple remapping.
>
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> ---
>   drivers/md/dm-stripe.c   | 2 +-
>   drivers/md/dm-switch.c   | 1 +
>   drivers/md/dm-unstripe.c | 1 +
>   drivers/md/dm-zero.c     | 1 +
>   4 files changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
> index 151d022b032d..df359d33cda8 100644
> --- a/drivers/md/dm-stripe.c
> +++ b/drivers/md/dm-stripe.c
> @@ -496,7 +496,7 @@ static void stripe_io_hints(struct dm_target *ti,
>   static struct target_type stripe_target = {
>   	.name   = "striped",
>   	.version = {1, 6, 0},
> -	.features = DM_TARGET_PASSES_INTEGRITY,
> +	.features = DM_TARGET_PASSES_INTEGRITY | DM_TARGET_NOWAIT,
>   	.module = THIS_MODULE,
>   	.ctr    = stripe_ctr,
>   	.dtr    = stripe_dtr,
> diff --git a/drivers/md/dm-switch.c b/drivers/md/dm-switch.c
> index bff4c7fa1cd2..262e2b0fd975 100644
> --- a/drivers/md/dm-switch.c
> +++ b/drivers/md/dm-switch.c
> @@ -550,6 +550,7 @@ static int switch_iterate_devices(struct dm_target *ti,
>   static struct target_type switch_target = {
>   	.name = "switch",
>   	.version = {1, 1, 0},
> +	.features = DM_TARGET_NOWAIT,
>   	.module = THIS_MODULE,
>   	.ctr = switch_ctr,
>   	.dtr = switch_dtr,
> diff --git a/drivers/md/dm-unstripe.c b/drivers/md/dm-unstripe.c
> index e673dacf6418..7357c1bd5863 100644
> --- a/drivers/md/dm-unstripe.c
> +++ b/drivers/md/dm-unstripe.c
> @@ -178,6 +178,7 @@ static void unstripe_io_hints(struct dm_target *ti,
>   static struct target_type unstripe_target = {
>   	.name = "unstriped",
>   	.version = {1, 1, 0},
> +	.features = DM_TARGET_NOWAIT,
>   	.module = THIS_MODULE,
>   	.ctr = unstripe_ctr,
>   	.dtr = unstripe_dtr,
> diff --git a/drivers/md/dm-zero.c b/drivers/md/dm-zero.c
> index b65ca8dcfbdc..faa1dbffc8b4 100644
> --- a/drivers/md/dm-zero.c
> +++ b/drivers/md/dm-zero.c
> @@ -59,6 +59,7 @@ static int zero_map(struct dm_target *ti, struct bio *bio)
>   static struct target_type zero_target = {
>   	.name   = "zero",
>   	.version = {1, 1, 0},
> +	.features = DM_TARGET_NOWAIT,
>   	.module = THIS_MODULE,
>   	.ctr    = zero_ctr,
>   	.map    = zero_map,

-- 
Thanks,
Jeffle

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

