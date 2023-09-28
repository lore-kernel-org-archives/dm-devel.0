Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31444E732F4
	for <dm-devel@archiver.kernel.org>; Thu, 28 Sep 2023 16:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695920372;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=afNbKQ8mDmW8nbODC3I7ZF2magtD6ZbD3vqAroa9qd0=;
	b=P4e0NSA9c7fUKXdgoeCkN1vmQuVEFVfqPv7izPBjDEpNBVfxNb0HaP8aHsN6kLz6mfwIDk
	s1qNqc3loTiPqcQg4OmtigDcRivzxXfLwUNBRAUb5fTVK3SuAs0noYOcW4VSqlBF1Bal4N
	v9TxlunrjTtmsc098R0oNu+5X4l6A7E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-642-PITy_n-kOBS9tnfE2RcHdw-1; Thu, 28 Sep 2023 12:59:28 -0400
X-MC-Unique: PITy_n-kOBS9tnfE2RcHdw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2668918312E9;
	Thu, 28 Sep 2023 16:59:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F0CA814171CE;
	Thu, 28 Sep 2023 16:59:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AF0D21946594;
	Thu, 28 Sep 2023 16:59:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 850F71946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Sep 2023 16:57:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4D650215670B; Thu, 28 Sep 2023 16:57:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 45D6B2156702
 for <dm-devel@redhat.com>; Thu, 28 Sep 2023 16:57:28 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2513B101A550
 for <dm-devel@redhat.com>; Thu, 28 Sep 2023 16:57:28 +0000 (UTC)
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-399-N6CEU4dBMBqlw_NTMW2z6A-1; Thu, 28 Sep 2023 12:57:27 -0400
X-MC-Unique: N6CEU4dBMBqlw_NTMW2z6A-1
Received: by mail-wr1-f70.google.com with SMTP id
 ffacd0b85a97d-31fd48da316so10153427f8f.3
 for <dm-devel@redhat.com>; Thu, 28 Sep 2023 09:57:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1695920245; x=1696525045;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=00QmXapohq3DPZCRHS2BR5NmKgg5YovRM/bSgGyBQuc=;
 b=VieEJxJjbl2M9fLbGMXKe8/YOWSuzUnVauNoX7DEH5h4bWlROSOWrwT1gEEUTuuWLD
 71TjMvQcwTk1INfpxHKaZGHeZ7MOrablIXrsaV63+9AZb3Q++w9Tp7JvzgipjCPNPbba
 XuJnEwyewIxTF+coWPEniZ/59AxNIvBxu1rosXELe8oLHqGD+nc7XJ7iAGnCzYmq23DL
 ku3qiVqCGSlS+IoLRWvJ3ekPzhsSa6I2NUFh/YcjENKKYVtvlEwao93tWPo41GVUBDo7
 fnrqIqcTnw8x1I5RIONCYkGqdc63m2jOpRVFfpWm4VbzLvuBsUSUd3/PQ0s8g3qg/NLs
 8OCw==
X-Gm-Message-State: AOJu0YyI4NyXYvd+MkiimheA2Ks9X7sh6VoxhLQHGCGYscq8qTJmkdvs
 sE5122RXCjKT1U/VeP9BHlPLrcrl8mAwvH+QMwTVoL/01i7Tu4w9lj4Np+9IWp4HGNZeRKY6Lcv
 7ajPKzPlMfnpnA0vqnqrNEmc=
X-Received: by 2002:a5d:5b17:0:b0:31f:a4fa:130a with SMTP id
 bx23-20020a5d5b17000000b0031fa4fa130amr2000430wrb.14.1695920245450; 
 Thu, 28 Sep 2023 09:57:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFdPFunf1e46tcllomSWe7BexIz1+NPtzsrILM3MPcQJWSlQc934AuWtqt00GJ12IWls8lktg==
X-Received: by 2002:a5d:5b17:0:b0:31f:a4fa:130a with SMTP id
 bx23-20020a5d5b17000000b0031fa4fa130amr2000414wrb.14.1695920245057; 
 Thu, 28 Sep 2023 09:57:25 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89?
 ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
 by smtp.googlemail.com with ESMTPSA id
 g25-20020a50d0d9000000b005361a6da384sm1474069edf.19.2023.09.28.09.57.18
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 28 Sep 2023 09:57:24 -0700 (PDT)
Message-ID: <b3ed3da7-ffa3-0d35-34c1-27b159af43bb@redhat.com>
Date: Thu, 28 Sep 2023 18:57:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
To: Mikulas Patocka <mpatocka@redhat.com>
References: <20230315113133.11326-1-kirill.shutemov@linux.intel.com>
 <3c25ec6f-cd33-9445-a76f-6ec2c30755f5@redhat.com>
 <86e7f97a-ac6b-873d-93b2-1121a464989a@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <86e7f97a-ac6b-873d-93b2-1121a464989a@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH 00/10] Fix confusion around MAX_ORDER
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
Cc: linux-arch@vger.kernel.org, quic_jhugo@quicinc.com,
 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, dm <dm-devel@redhat.com>,
 Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@suse.cz>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 9/28/23 09:50, Mikulas Patocka wrote:
>>> Fix the bugs and then change the definition of MAX_ORDER to be
>>> inclusive: the range of orders user can ask from buddy allocator is
>>> 0..MAX_ORDER now.
> I think that exclusive MAX_ORDER is more intuitive in the C language -
> i.e. if you write "for (i = 0; i < MAX_ORDER; i++)", you are supposed to
> loop over all allowed values. If you declare an array "void
> *array[MAX_ORDER];" you are supposed to hold a value for each allowed
> order.
> 
> Pascal has for loops and array dimensions with inclusive ranges - and it
> is more prone to off-by-one errors.

I agree it's somewhat confusing either way but the ship has sailed, the 
patch has been included in Linux for several months.

Paolo

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

