Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AD9DC433EF
	for <dm-devel@archiver.kernel.org>; Mon,  7 Mar 2022 02:25:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-35-Hnvci3X9PeaCrDyXYufMkg-1; Sun, 06 Mar 2022 21:25:23 -0500
X-MC-Unique: Hnvci3X9PeaCrDyXYufMkg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2264C185A7A4;
	Mon,  7 Mar 2022 02:25:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 100FA2166B2D;
	Mon,  7 Mar 2022 02:25:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 96252194E107;
	Mon,  7 Mar 2022 02:25:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B801A194E021
 for <dm-devel@listman.corp.redhat.com>; Mon,  7 Mar 2022 02:25:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 55F501121321; Mon,  7 Mar 2022 02:25:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 51064112131E
 for <dm-devel@redhat.com>; Mon,  7 Mar 2022 02:25:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5EE481C05ABA
 for <dm-devel@redhat.com>; Mon,  7 Mar 2022 02:25:16 +0000 (UTC)
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com
 [209.85.214.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-594-68qwjNywPUCVY581pTvnXA-1; Sun, 06 Mar 2022 21:25:14 -0500
X-MC-Unique: 68qwjNywPUCVY581pTvnXA-1
Received: by mail-pl1-f176.google.com with SMTP id e13so12514859plh.3
 for <dm-devel@redhat.com>; Sun, 06 Mar 2022 18:25:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=hmPhMTI7t3TVVpPhw5nNW52OuQD8LGJ91mhG7z/hh1o=;
 b=tpir9496kfg71mKOKxUflzgpIWpDJJqTMBxrQOxTVGmmF3otcS/9/68YXR5plSTX7K
 u2b7Dd2OuJOgwZrP6eIsOHtTf3mj2nrYjXOB+hz75OCczDmS6+avOyzaHT+f5bDVGBI7
 YqwpAGUIlzAyo+Xk5EXoTRrmr3H5rGbAvJ2L9hSheg8+7GFUYDEPbdRC+n6tDIdzzF8Q
 sUnC+Rp/CL5QVGmYawaGsk3YhcmZpTFbf/mJjELGVNJQqxHXlKtwV6p33ftcmBJDV1mB
 F3kVcjMuN+kBHgoBGE6xuXkxOr43KNqDEO6bw4/5GkZYLSnmuIlxPM49n0eMwmdZzgzk
 1WjQ==
X-Gm-Message-State: AOAM530NZhucStcXYpPEkjJS3pSkE8AtkQz+iyXkegIL5WalLU9Cxd6b
 EmYvDGrFb2RjtQ64hpZnvLUWNQ==
X-Google-Smtp-Source: ABdhPJygOhhaNp5HmmASiVr9p7LuiTuRC0JsENfLW4mS+UdTHuYZwnoYl5YbttBI/tzkKOCfCvb1yA==
X-Received: by 2002:a17:902:b589:b0:14f:3f88:15e2 with SMTP id
 a9-20020a170902b58900b0014f3f8815e2mr9958915pls.171.1646619913733; 
 Sun, 06 Mar 2022 18:25:13 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
 by smtp.gmail.com with ESMTPSA id
 d11-20020a056a00198b00b004dfc6b023b2sm13100022pfl.41.2022.03.06.18.25.12
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sun, 06 Mar 2022 18:25:13 -0800 (PST)
Message-ID: <89612542-0040-65bd-23bc-5bf8cac71f61@kernel.dk>
Date: Sun, 6 Mar 2022 19:25:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
To: Ming Lei <ming.lei@redhat.com>
References: <20220305020804.54010-1-snitzer@redhat.com>
 <20220305020804.54010-3-snitzer@redhat.com> <20220306092937.GC22883@lst.de>
 <2ced53d5-d87b-95db-a612-6896f73ce895@kernel.dk> <YiVr4rna9DG0Oyng@T590>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <YiVr4rna9DG0Oyng@T590>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v5 2/2] dm: support bio polling
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
 Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/6/22 7:20 PM, Ming Lei wrote:
> On Sun, Mar 06, 2022 at 06:48:15PM -0700, Jens Axboe wrote:
>> On 3/6/22 2:29 AM, Christoph Hellwig wrote:
>>>> +/*
>>>> + * Reuse ->bi_end_io as hlist head for storing all dm_io instances
>>>> + * associated with this bio, and this bio's bi_end_io has to be
>>>> + * stored in one of 'dm_io' instance first.
>>>> + */
>>>> +static inline struct hlist_head *dm_get_bio_hlist_head(struct bio *bio)
>>>> +{
>>>> +	WARN_ON_ONCE(!(bio->bi_opf & REQ_DM_POLL_LIST));
>>>> +
>>>> +	return (struct hlist_head *)&bio->bi_end_io;
>>>> +}
>>>
>>> So this reuse is what I really hated.  I still think we should be able
>>> to find space in the bio by creatively shifting fields around to just
>>> add the hlist there directly, which would remove the need for this
>>> override and more importantly the quite cumbersome saving and restoring
>>> of the end_io handler.
>>
>> If it's possible, then that would be preferable. But I don't think
>> that's going to be easy to do...
> 
> I agree, now basically there isn't gap inside bio, so either adding one
> new field or reusing one existed field...

There'd no amount of re-arranging that'll free up 8 bytes, that's just
not happening. I'm not a huge fan of growing struct bio for that, and
the oddity here is mostly (to me) that ->bi_end_io is the one overlayed.
That would usually belong to the owner of the bio.

Maybe some commenting would help? Is bi_next available at this point?

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

