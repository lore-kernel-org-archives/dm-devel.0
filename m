Return-Path: <SRS0=byOr=FF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4810AC64E7A
	for <dm-devel@archiver.kernel.org>; Tue,  1 Dec 2020 11:25:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 511C9206E3
	for <dm-devel@archiver.kernel.org>; Tue,  1 Dec 2020 11:25:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 511C9206E3
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-W8-v5YUeNtqjSUnoaRlCLQ-1; Tue, 01 Dec 2020 06:25:07 -0500
X-MC-Unique: W8-v5YUeNtqjSUnoaRlCLQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E48C18030D5;
	Tue,  1 Dec 2020 11:25:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C64A360C0F;
	Tue,  1 Dec 2020 11:25:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 965924E58F;
	Tue,  1 Dec 2020 11:25:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B18boJH011217 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Dec 2020 03:37:51 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 820196FA4B; Tue,  1 Dec 2020 08:37:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7CE716FA42
	for <dm-devel@redhat.com>; Tue,  1 Dec 2020 08:37:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D54E811E76
	for <dm-devel@redhat.com>; Tue,  1 Dec 2020 08:37:48 +0000 (UTC)
Received: from relay3.sw.ru (relay.sw.ru [185.231.240.75]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-411-JkLpVL7tPoKBOF7TB7dS3Q-1;
	Tue, 01 Dec 2020 03:37:45 -0500
X-MC-Unique: JkLpVL7tPoKBOF7TB7dS3Q-1
Received: from [192.168.15.152] by relay3.sw.ru with esmtp (Exim 4.94)
	(envelope-from <ktkhai@virtuozzo.com>)
	id 1kk1AC-00BEXT-Cm; Tue, 01 Dec 2020 11:37:33 +0300
To: Mike Snitzer <snitzer@redhat.com>
References: <160633733483.339234.11951322983778059158.stgit@localhost.localdomain>
	<20201130173018.GA77957@lobo>
From: Kirill Tkhai <ktkhai@virtuozzo.com>
Message-ID: <0822692b-4d38-15a4-1f76-9f28b0beaafe@virtuozzo.com>
Date: Tue, 1 Dec 2020 11:37:40 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201130173018.GA77957@lobo>
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
X-Mailman-Approved-At: Tue, 01 Dec 2020 06:23:42 -0500
Cc: dm-devel@redhat.com, Bruce Johnston <bjohnsto@redhat.com>,
	John Dorminy <jdorminy@redhat.com>, agk@redhat.com
Subject: Re: [dm-devel] dm: Devices not having .iterate_devices may want to
 set max_io_len
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 30.11.2020 20:30, Mike Snitzer wrote:
> On Wed, Nov 25 2020 at  3:49pm -0500,
> Kirill Tkhai <ktkhai@virtuozzo.com> wrote:
> 
>> After commit 5091cdec56fa "dm: change max_io_len() to use
>> blk_max_size_offset()" my out-of-tree driver stopped to work.
>> The reason is that now ti->max_io_len from such target is ignored:
>> max_io_len() ignores ti->max_io_len, while
>> dm_calculate_queue_limits() never stacks ti->chunk_sectors into
>> ti_limits.chunk_sectors.
>>
>> Here I see two possible solutions, both are in dm_calculate_queue_limits():
>>
>> 1)Move ti_limits.chunk_sectors assignment down, so it will be made
>> right under combine_limits label. Thus, every time ti->max_io_len
>> will transform into chunk_sectors, even in case of device
>> has no .iterate_devices method;
>>
>> 2)Move io_hints call under the label (like it's made in this patch),
>> so one can set desired chunk_sectors there.
>>
>> First solution looks less clear, since in two drivers chunk_sectors
>> are assigned in io_hints (see unstripe_io_hints() and dmz_io_hints()),
>> and this rewrites, and we should not rewrite it.
>>
>> Second solution does not break anything since we change only
>> order with ->iterate_devices(device_area_is_invalid), while
>> device_area_is_invalid never touches chunk_sectors. So I choosed it.
>>
>> Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
>> ---
>>  drivers/md/dm-table.c |    8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
>> index 2073ee8d18f4..9994c767dc82 100644
>> --- a/drivers/md/dm-table.c
>> +++ b/drivers/md/dm-table.c
>> @@ -1453,10 +1453,6 @@ int dm_calculate_queue_limits(struct dm_table *table,
>>  		if (ti->max_io_len)
>>  			ti_limits.chunk_sectors = lcm_not_zero(ti->max_io_len,
>>  							       ti_limits.chunk_sectors);
>> -		/* Set I/O hints portion of queue limits */
>> -		if (ti->type->io_hints)
>> -			ti->type->io_hints(ti, &ti_limits);
>> -
>>  		/*
>>  		 * Check each device area is consistent with the target's
>>  		 * overall queue limits.
>> @@ -1466,6 +1462,10 @@ int dm_calculate_queue_limits(struct dm_table *table,
>>  			return -EINVAL;
>>  
>>  combine_limits:
>> +		/* Set I/O hints portion of queue limits */
>> +		if (ti->type->io_hints)
>> +			ti->type->io_hints(ti, &ti_limits);
>> +
>>  		/*
>>  		 * Merge this target's queue limits into the overall limits
>>  		 * for the table.
>>
>>
> 
> Sorry for the slow response, just got back from PTO today.
> 
> So while I appreciate that commit 5091cdec56fa caused your DM target to
> regress I don't think the proper solution is for your driver to take on
> setting chunk_sectors based on the ti->max_io_len you've established.
> 
> The use of chunk_sectors is an implementation detail.  One that every DM
> target that doesn't establish .iterate_devices should not need to take
> on worrying about.
> 
> Your above proposed patch changes DM core to _start_ to fix the
> regression you've reported but still requires your DM target to change
> too.  Does you DM target have one or more data device(s)?  If so you
> really should have it provide a .iterate_devices hook.  But that aside,

This is a virtual device, which never interact with data device, so there
is no .iterate_devices.

> here is the fix I'll be staging in linux-next shortly and that I'll be
> sending to Linus by the end of the week:
> 
> From: Mike Snitzer <snitzer@redhat.com>
> Date: Mon, 30 Nov 2020 10:57:43 -0500
> Subject: [PATCH] dm table: fix IO splitting
> 
> Commit 882ec4e609c1 ("dm table: stack 'chunk_sectors' limit to account
> for target-specific splitting") caused a regression for a couple
> reasons:
> 
> 1) Using lcm_not_zero() instead of min_not_zero() when stacking
>    chunk_sectors was a bug because chunk_sectors must reflect the most
>    limited of all devices in the IO stack.
> 2) DM targets that set max_io_len but that do _not_ provide an
>    .iterate_devices method no longer had there IO split properly.
> 
> dm_calculate_queue_limits() must establish the appropriate IO
> splitting limits early, without any dependency on iterating
> data_devices, otherwise IO will not be split as intended.
> 
> Fixes: 882ec4e609c1 ("dm table: stack 'chunk_sectors' limit to account for target-specific splitting")
> Cc: stable@vger.kernel.org
> Reported-by: John Dorminy <jdorminy@redhat.com>
> Reported-by: Bruce Johnston <bjohnsto@redhat.com>
> Reported-by: Kirill Tkhai <ktkhai@virtuozzo.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>

This works for me. Thanks, Mike.

You may add my Tested-by: Kirill Tkhai <ktkhai@virtuozzo.com>

> ---
>  drivers/md/dm-table.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 2073ee8d18f4..4e58f5c68ac0 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -18,7 +18,6 @@
>  #include <linux/mutex.h>
>  #include <linux/delay.h>
>  #include <linux/atomic.h>
> -#include <linux/lcm.h>
>  #include <linux/blk-mq.h>
>  #include <linux/mount.h>
>  #include <linux/dax.h>
> @@ -1431,6 +1430,10 @@ int dm_calculate_queue_limits(struct dm_table *table,
>  
>  		ti = dm_table_get_target(table, i);
>  
> +		/* Set appropriate limits if target-specific splitting is required */
> +		if (ti->max_io_len)
> +			ti_limits.chunk_sectors = ti->max_io_len;
> +
>  		if (!ti->type->iterate_devices)
>  			goto combine_limits;
>  
> @@ -1449,10 +1452,6 @@ int dm_calculate_queue_limits(struct dm_table *table,
>  			zone_sectors = ti_limits.chunk_sectors;
>  		}
>  
> -		/* Stack chunk_sectors if target-specific splitting is required */
> -		if (ti->max_io_len)
> -			ti_limits.chunk_sectors = lcm_not_zero(ti->max_io_len,
> -							       ti_limits.chunk_sectors);
>  		/* Set I/O hints portion of queue limits */
>  		if (ti->type->io_hints)
>  			ti->type->io_hints(ti, &ti_limits);
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

