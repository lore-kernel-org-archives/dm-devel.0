Return-Path: <SRS0=bIvj=O3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A902CC433F5
	for <dm-devel@archiver.kernel.org>; Thu,  7 Oct 2021 08:00:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 27E3061029
	for <dm-devel@archiver.kernel.org>; Thu,  7 Oct 2021 08:00:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 27E3061029
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-WF1Zoc8jOmeIeVh4tthN-A-1; Thu, 07 Oct 2021 04:00:47 -0400
X-MC-Unique: WF1Zoc8jOmeIeVh4tthN-A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E27E51023F4F;
	Thu,  7 Oct 2021 08:00:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C22255F4FE;
	Thu,  7 Oct 2021 08:00:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 52E964EA2A;
	Thu,  7 Oct 2021 08:00:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 196KtjZb024027 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 6 Oct 2021 16:55:45 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 783642166B26; Wed,  6 Oct 2021 20:55:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 729DC2166B3F
	for <dm-devel@redhat.com>; Wed,  6 Oct 2021 20:55:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 940838007B1
	for <dm-devel@redhat.com>; Wed,  6 Oct 2021 20:55:42 +0000 (UTC)
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com
	[209.85.167.182]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-357-iOT09z_LMtGlb_3s4JEWnw-1; Wed, 06 Oct 2021 16:55:39 -0400
X-MC-Unique: iOT09z_LMtGlb_3s4JEWnw-1
Received: by mail-oi1-f182.google.com with SMTP id w206so5904386oiw.4
	for <dm-devel@redhat.com>; Wed, 06 Oct 2021 13:55:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=JvTa2lKBoI8pDHEiWBkxH9Br7TgFSzn7gNvMea8puyE=;
	b=J19GWzk6xmmd+fjPPtZlFNHQXliV7p0Pps8TOHzMXG6TaIIXz/2F7BEHz1+Ab5aloQ
	CA31jSYTOkHCjqymGWd6y2s4XhnEUxBW4hDjRlsJ+4f9oKSjnOJPLxLbYTnLpDS/AO0Q
	/chj2XcGzTtEbH7Sj+hyP2US9NchjKIkpHEGD6hxdivtv9Klmv8LyKEHK1P8akZly4qi
	yM6IWVLDOHPovczJI9AUhBLNtj6/URpLzQJVLg8UW/GsSKzJU9cE5Hx7xJfAkcu8BxSJ
	BAu0Ic2owTmOmcI/iGl7Anrsvsl8vJRl0sZjRMBmPVLhnbOalngsLtQXQ8SK8b3v45F2
	SZyA==
X-Gm-Message-State: AOAM531XQWfgd1tzEtBFe2EDcRyaEX7/F6FG2e1eF6dx5DlVrK8S2wuz
	3FPcMSvf0IQF6ZFD9QY4EDoQLSfseAmPjA==
X-Google-Smtp-Source: ABdhPJzkTmkeqt1d1IgAw8uqylMn+U2CKvyQpd1md95wOPaS5qvtKnrya6+H/PaGK2fiqa20u55PRA==
X-Received: by 2002:aca:dbc2:: with SMTP id s185mr305618oig.141.1633553738147; 
	Wed, 06 Oct 2021 13:55:38 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net.
	[24.9.64.241])
	by smtp.gmail.com with ESMTPSA id l1sm3351258oop.28.2021.10.06.13.55.37
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Wed, 06 Oct 2021 13:55:37 -0700 (PDT)
To: Mike Snitzer <snitzer@redhat.com>
References: <20211004200641.378496-1-skhan@linuxfoundation.org>
	<YV4IecLg56NpzkYx@redhat.com>
From: Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <f1eebe07-492e-3152-8070-ea622d36bd33@linuxfoundation.org>
Date: Wed, 6 Oct 2021 14:55:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YV4IecLg56NpzkYx@redhat.com>
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
X-Mailman-Approved-At: Thu, 07 Oct 2021 03:43:07 -0400
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, agk@redhat.com,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [dm-devel] dm: change dm_get_target_type() to check for module
	load error
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
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 10/6/21 2:35 PM, Mike Snitzer wrote:
> On Mon, Oct 04 2021 at  4:06P -0400,
> Shuah Khan <skhan@linuxfoundation.org> wrote:
> 
>> dm_get_target_type() doesn't check error return from request_module().
>> Change to check for error and return NULL instead of trying to get
>> target type again which would fail.
>>
>> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
>> ---
>>   drivers/md/dm-target.c | 11 ++++++++---
>>   1 file changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
>> index 64dd0b34fcf4..0789e9f91d3a 100644
>> --- a/drivers/md/dm-target.c
>> +++ b/drivers/md/dm-target.c
>> @@ -41,17 +41,22 @@ static struct target_type *get_target_type(const char *name)
>>   	return tt;
>>   }
>>   
>> -static void load_module(const char *name)
>> +static int load_module(const char *name)
>>   {
>> -	request_module("dm-%s", name);
>> +	return request_module("dm-%s", name);
>>   }
>>   
>>   struct target_type *dm_get_target_type(const char *name)
>>   {
>>   	struct target_type *tt = get_target_type(name);
>> +	int ret;
>>   
>>   	if (!tt) {
>> -		load_module(name);
>> +		ret = load_module(name);
>> +		if (ret < 0) {
>> +			pr_err("Module %s load failed %d\n", name, ret);
>> +			return NULL;
>> +		}
>>   		tt = get_target_type(name);
>>   	}
>>   
>> -- 
>> 2.30.2
>>
> 
> While I appreciate your intent, the reality is that multiple targets
> may be made available in a given module.  And so loading one dm module
> may bring in access to N targets.  There isn't a rigid 1:1 mapping of
> target modules to names.  And there may not even be a loadable module
> that has the name dm-${name} -- but that doesn't mean the target_type
> won;t have been loaded into DM for it to access.
> 

Thanks for the explanation.

-- Shuah

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

