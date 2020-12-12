Return-Path: <SRS0=vwJi=FQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F6F9C4361B
	for <dm-devel@archiver.kernel.org>; Sat, 12 Dec 2020 17:35:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C7DF92064A
	for <dm-devel@archiver.kernel.org>; Sat, 12 Dec 2020 17:35:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C7DF92064A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-433-bhFMBu_7OjKpW-WzBOcwsg-1; Sat, 12 Dec 2020 12:35:06 -0500
X-MC-Unique: bhFMBu_7OjKpW-WzBOcwsg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0646B180A089;
	Sat, 12 Dec 2020 17:35:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 70E3E60BFA;
	Sat, 12 Dec 2020 17:35:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 36EA9180954D;
	Sat, 12 Dec 2020 17:34:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BCHYbQZ025260 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 12 Dec 2020 12:34:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E4C26100BFCE; Sat, 12 Dec 2020 17:34:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DFF6A1018E60
	for <dm-devel@redhat.com>; Sat, 12 Dec 2020 17:34:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 875F4858280
	for <dm-devel@redhat.com>; Sat, 12 Dec 2020 17:34:34 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-509-tv6FYfu7Opmi-Ys4an5Z4A-1;
	Sat, 12 Dec 2020 12:34:31 -0500
X-MC-Unique: tv6FYfu7Opmi-Ys4an5Z4A-1
Received: from [192.168.86.31] (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 02E6920B717A;
	Sat, 12 Dec 2020 09:34:28 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 02E6920B717A
To: Tyler Hicks <tyhicks@linux.microsoft.com>
References: <20201211235807.30815-1-tusharsu@linux.microsoft.com>
	<20201211235807.30815-5-tusharsu@linux.microsoft.com>
	<20201212002500.GF4951@sequoia>
	<7e137e37-c195-1d16-05ef-56c2645fcc84@linux.microsoft.com>
	<20201212144741.GH4951@sequoia>
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <157daf28-9b59-bb3a-9b14-17d5aa0a9943@linux.microsoft.com>
Date: Sat, 12 Dec 2020 09:34:28 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201212144741.GH4951@sequoia>
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
Cc: sashal@kernel.org, paul@paul-moore.com, snitzer@redhat.com,
	selinux@vger.kernel.org, stephen.smalley.work@gmail.com,
	jmorris@namei.org, zohar@linux.ibm.com,
	linux-kernel@vger.kernel.org, nramas@linux.microsoft.com,
	linux-security-module@vger.kernel.org, casey@schaufler-ca.com,
	linux-integrity@vger.kernel.org, dm-devel@redhat.com,
	gmazyland@gmail.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v8 4/8] IMA: add policy rule to measure
	critical data
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"


>>>> +	case CRITICAL_DATA:
>>>> +		if (!rule->data_source)
>>>> +			return true;
>>>> +
>>>> +		opt_list = rule->data_source;
>>>> +		break;
>>>
>>> I guess this case should unconditionally return true in this patch and
>>> then the include this additional logic in the next patch.
>>>
>>> Sorry, I missed these on my last review.
>>>
>> No worries.
>>
>> As I mentioned above, I kept it purposefully in this patch since
>> my impression was rule->data_source is not part of the user facing
>> policy.
>>
>> But I can simply return true here as you suggested, and move the logic to
>> the next patch.
> 
> I understand the thinking that it isn't harmful in this patch but I
> think it is a bit cleaner to introduce the data_source policy language
> element and all of its backend support in the same patch. Please move it
> to the next patch. Thanks!
> 
> Tyler
> 
Will do.
Thanks a lot Tyler for a detailed review. Appreciate it.

~Tushar



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

