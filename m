Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88C57C0015E
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jul 2023 06:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688971641;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9+pSyN2FRqI29YCSGQHazIIy9nuSIQQV+pOMuku44NE=;
	b=Vtt5e7dhPSjEcC07j1298ozp32hnOzfPPr9YmlaWlJSvtAMJIx2CtY/nSXgt5Y/URscA6l
	B4yRi8n/46UpEu44PCXs2eL6IpZhm9p0f/Oq66QPplQ1pfArLhHFb7uj/HzoXulOLGktaj
	uBD9W3JOhCXpbNd6jfuWQKi6F68KIwk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-377-jGuwT0oJP1Oudz2YUjMOdQ-1; Mon, 10 Jul 2023 02:47:17 -0400
X-MC-Unique: jGuwT0oJP1Oudz2YUjMOdQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D47A788D543;
	Mon, 10 Jul 2023 06:47:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B94E1F66BB;
	Mon, 10 Jul 2023 06:47:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 53D0A19451D3;
	Mon, 10 Jul 2023 06:47:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BCE491946587
 for <dm-devel@listman.corp.redhat.com>; Fri, 23 Jun 2023 12:50:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AB4891121314; Fri, 23 Jun 2023 12:50:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A44CF1121315
 for <dm-devel@redhat.com>; Fri, 23 Jun 2023 12:50:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5058F29AA3B6
 for <dm-devel@redhat.com>; Fri, 23 Jun 2023 12:50:55 +0000 (UTC)
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com
 [209.85.210.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-564-dMRNUFctOBGJ_2FBrnIh_w-1; Fri, 23 Jun 2023 08:50:52 -0400
X-MC-Unique: dMRNUFctOBGJ_2FBrnIh_w-1
Received: by mail-pf1-f171.google.com with SMTP id
 d2e1a72fcca58-66c2d4e507aso73141b3a.1
 for <dm-devel@redhat.com>; Fri, 23 Jun 2023 05:50:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687524651; x=1690116651;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=3J6qedKH7rACUI+d8+QjoI1iru+7/a5M9lap7RdXq+s=;
 b=Hb+8gspps8qGhDfS51URMkTMXKP+1zX9VSUbiS1zQo0eW2Ptkc6A1HUAPXEMA2XU+f
 zoPl9RSqv4RT/IenMy8ET5ls3H6ho5CNiWg1VxydriVEbfIycGRUma54n6wDGggsd7ke
 3kYv/e+xdGp/sG700iRVt6M70f+PPsZgWrD7l6l/X2iuHCqXg80+IuON/+SpY7CPamtg
 nOFCOwZWE87no1tT8GZSfaMmv96HCPUCOjoAlg/EkQZKiiGKN0rRnsPUtDrVGy4SZ1PM
 C3pKlaSyXu5793B2w6z6X1kHvDf4o05Uau+RjNgZNpz5BplAOxkQ6AVn1FFT6oqWsUYS
 n7PA==
X-Gm-Message-State: AC+VfDzdm4PFjdXrDK0I5Xn+BpckB7z1euV2fhNktbMVsBjJu4nOtXLl
 fnuJmHFjA9dwpyTmLVyYMDp6eA==
X-Google-Smtp-Source: ACHHUZ6Fjrszr4MOiG7PTx+CVGVeY59XJZwzJifNOvY5NLzJaatECslqahuGwHQe8HJSyn0Dmf/QQQ==
X-Received: by 2002:a05:6a00:3186:b0:668:7fe6:c220 with SMTP id
 bj6-20020a056a00318600b006687fe6c220mr14325912pfb.3.1687524651198; 
 Fri, 23 Jun 2023 05:50:51 -0700 (PDT)
Received: from [10.4.168.167] ([139.177.225.254])
 by smtp.gmail.com with ESMTPSA id
 x21-20020aa79195000000b0063a04905379sm6063171pfa.137.2023.06.23.05.50.44
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 23 Jun 2023 05:50:50 -0700 (PDT)
Message-ID: <31d3f685-3017-25d8-5b0b-2795ed7049bc@bytedance.com>
Date: Fri, 23 Jun 2023 20:50:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
To: Vlastimil Babka <vbabka@suse.cz>, akpm@linux-foundation.org,
 david@fromorbit.com, tkhai@ya.ru, roman.gushchin@linux.dev,
 djwong@kernel.org, brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu
References: <20230622085335.77010-1-zhengqi.arch@bytedance.com>
 <20230622085335.77010-2-zhengqi.arch@bytedance.com>
 <b04a0191-fa27-f8dc-440c-ec363d9c0636@suse.cz>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <b04a0191-fa27-f8dc-440c-ec363d9c0636@suse.cz>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Mon, 10 Jul 2023 06:46:55 +0000
Subject: Re: [dm-devel] [External] Re: [PATCH 01/29] mm: shrinker: add
 shrinker::private_data field
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
Cc: linux-bcache@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, virtualization@lists.linux-foundation.org,
 linux-raid@vger.kernel.org, linux-mm@kvack.org, dm-devel@redhat.com,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: bytedance.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hi Vlastimil,

On 2023/6/22 22:47, Vlastimil Babka wrote:
> On 6/22/23 10:53, Qi Zheng wrote:
>> To prepare for the dynamic allocation of shrinker instances
>> embedded in other structures, add a private_data field to
>> struct shrinker, so that we can use shrinker::private_data
>> to record and get the original embedded structure.
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> I would fold this to 02/29, less churn.

OK, I will fold this to 02/29 in the v2.

Thanks,
Qi

> 
>> ---
>>   include/linux/shrinker.h | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
>> index 224293b2dd06..43e6fcabbf51 100644
>> --- a/include/linux/shrinker.h
>> +++ b/include/linux/shrinker.h
>> @@ -70,6 +70,8 @@ struct shrinker {
>>   	int seeks;	/* seeks to recreate an obj */
>>   	unsigned flags;
>>   
>> +	void *private_data;
>> +
>>   	/* These are for internal use */
>>   	struct list_head list;
>>   #ifdef CONFIG_MEMCG
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

