Return-Path: <SRS0=CL6l=HT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2637CC433E9
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:35:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A572064DA1
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:35:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A572064DA1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-572-AqD5EVDpOnu_AFLJqWdEFg-1; Wed, 17 Feb 2021 10:35:04 -0500
X-MC-Unique: AqD5EVDpOnu_AFLJqWdEFg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 92BC679EC2;
	Wed, 17 Feb 2021 15:34:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 42BB719C46;
	Wed, 17 Feb 2021 15:34:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0AE2057DFA;
	Wed, 17 Feb 2021 15:34:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1161d2cD022735 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 5 Feb 2021 20:39:03 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DEA092026D11; Sat,  6 Feb 2021 01:39:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D8C812026D48
	for <dm-devel@redhat.com>; Sat,  6 Feb 2021 01:38:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5F8EC800B29
	for <dm-devel@redhat.com>; Sat,  6 Feb 2021 01:38:59 +0000 (UTC)
Received: from out30-131.freemail.mail.aliyun.com
	(out30-131.freemail.mail.aliyun.com [115.124.30.131]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-225-fwulijlPNTKxVj01sBMiwA-1;
	Fri, 05 Feb 2021 20:38:54 -0500
X-MC-Unique: fwulijlPNTKxVj01sBMiwA-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R911e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04357;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=6; SR=0;
	TI=SMTPD_---0UNzidTa_1612575528
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UNzidTa_1612575528) by smtp.aliyun-inc.com(127.0.0.1);
	Sat, 06 Feb 2021 09:38:48 +0800
To: Mike Snitzer <snitzer@redhat.com>
References: <20210202033528.76166-1-jefflexu@linux.alibaba.com>
	<20210205183909.GA4722@redhat.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <8ec3ef1b-1818-bc0e-03f9-e7ec344a40c1@linux.alibaba.com>
Date: Sat, 6 Feb 2021 09:38:48 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210205183909.GA4722@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 17 Feb 2021 10:31:26 -0500
Cc: joseph.qi@linux.alibaba.com, msb@chromium.org, dm-devel@redhat.com,
	toshi.kani@hpe.com, mbroz@redhat.com
Subject: Re: [dm-devel] dm: fix iterate_device sanity check
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On 2/6/21 2:39 AM, Mike Snitzer wrote:
> On Mon, Feb 01 2021 at 10:35pm -0500,
> Jeffle Xu <jefflexu@linux.alibaba.com> wrote:
> 
>> According to the definition of dm_iterate_devices_fn:
>>  * This function must iterate through each section of device used by the
>>  * target until it encounters a non-zero return code, which it then returns.
>>  * Returns zero if no callout returned non-zero.
>>
>> For some target type (e.g., dm-stripe), one call of iterate_devices() may
>> iterate multiple underlying devices internally, in which case a non-zero
>> return code returned by iterate_devices_callout_fn will stop the iteration
>> in advance.
>>
>> Thus if we want to ensure that _all_ underlying devices support some kind of
>> attribute, the iteration structure like dm_table_supports_nowait() should be
>> used, while the input iterate_devices_callout_fn should handle the 'not
>> support' semantics. On the opposite, the iteration structure like
>> dm_table_any_device_attribute() should be used if _any_ underlying device
>> supporting this attibute is sufficient. In this case, the input
>> iterate_devices_callout_fn should handle the 'support' semantics.
>>
>> Fixes: 545ed20e6df6 ("dm: add infrastructure for DAX support")
>> Fixes: c3c4555edd10 ("dm table: clear add_random unless all devices have it set")
>> Fixes: 4693c9668fdc ("dm table: propagate non rotational flag")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> 
> Thanks for auditing and fixing this up.  It has been on my todo so
> you've really helped me out -- your changes look correct to me.
> 
> I've staged it for 5.12, the stable fix will likely need manual fixups
> depending on the stable tree... we'll just need to assist with
> backport(s) as needed.
> 

Thanks.

Actually, I have one v2 version patch, fixing more issues, and some
explanation comment included. Maybe I should send the v2?

-- 
Thanks,
Jeffle

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

