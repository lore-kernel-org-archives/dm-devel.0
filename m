Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6D2DC001B0
	for <dm-devel@archiver.kernel.org>; Fri, 11 Aug 2023 22:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691791583;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=sUG4MRRQjeP/vuuSJmJpf8anE1jZN4OulDqbjBHOpPs=;
	b=Fn1806thr0z/Vjd0zr2obbtPZRmQw4EvUEfnybpiv2Eu/i56UYMgBQxeGCCGYY3488wjwK
	FR1OnDG9itUKLWM3UkTNWnl4dozoAE3yQyo9y1jqyJlGYNb8g/LAtoc9wtq+RE31XgbdEC
	a6mMNksfzH6KQbB4w/Z1kbBHCrw0qQg=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-691-fTUd4XZaNqK0w_lgS9R7rg-1; Fri, 11 Aug 2023 18:06:19 -0400
X-MC-Unique: fTUd4XZaNqK0w_lgS9R7rg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 387D21C068F8;
	Fri, 11 Aug 2023 22:06:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D969C2166B27;
	Fri, 11 Aug 2023 22:06:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8D5E31946594;
	Fri, 11 Aug 2023 22:06:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 96D45194658F
 for <dm-devel@listman.corp.redhat.com>; Fri, 11 Aug 2023 22:06:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D90BE2166B27; Fri, 11 Aug 2023 22:06:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D07D62166B25
 for <dm-devel@redhat.com>; Fri, 11 Aug 2023 22:06:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B2E3E185A78B
 for <dm-devel@redhat.com>; Fri, 11 Aug 2023 22:06:15 +0000 (UTC)
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com
 [209.85.214.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-137-5g92ykMQMuuZJ54RLhnkIg-1; Fri, 11 Aug 2023 18:06:12 -0400
X-MC-Unique: 5g92ykMQMuuZJ54RLhnkIg-1
Received: by mail-pl1-f173.google.com with SMTP id
 d9443c01a7336-1bdb7b0c8afso7337815ad.3; 
 Fri, 11 Aug 2023 15:06:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1691791571; x=1692396371;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=hCulArU7T/2N0cjtt9v/Sb6kpK5zL9r3ISOsLR/eGqQ=;
 b=XvifGKjf/SR8l+DoGMpo3+8JsyAzis5jzjLXWShHfIsGx8bfBY2820wK6mOMgrHQOe
 /fVXPFNjjiT8snsE58jl4i9bIAomKWvcyOrePtfuqbqdB9Y7cWy4yDBIYOuMB5q72nmy
 jREcQMRSloHFHa2i3RZ8+FiIY/9XPAGKIYHBFzoWpY1YvwSr44O2dzQXBD8cH4awEB3y
 vih9dquaypE6KbmEdkdnDgSmtOh5p9xX96KBUwb15KCRMdcMf1U3uo7uDtLzl+Zxo6Pp
 OQ+15rb/wtZfXbW6zv8LHFStmrc7XzRvJBHm52U7+fjXeo5sLvrZ6Tx1XaBolKVi6+8e
 Yq3Q==
X-Gm-Message-State: AOJu0YwEsmQiJZsWGoYGfglitUQTerQZs8PCmUu7pCnj1HuhQ9JLKhzu
 Q0HhA7s+Z255XpPWJghrb77Zqb4SLbI=
X-Google-Smtp-Source: AGHT+IGRDCvq8p2vjG6TVx2gDv6+cL2iFQ4Ue2nk9VRR38rhHkVlR+1xjT53rq6hRwjwXypPBI3lmA==
X-Received: by 2002:a17:903:244d:b0:1b8:5ab2:49a4 with SMTP id
 l13-20020a170903244d00b001b85ab249a4mr3374277pls.53.1691791571131; 
 Fri, 11 Aug 2023 15:06:11 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:cdd8:4c3:2f3c:adea?
 ([2620:15c:211:201:cdd8:4c3:2f3c:adea])
 by smtp.gmail.com with ESMTPSA id
 c11-20020a170903234b00b001a183ade911sm4424160plh.56.2023.08.11.15.06.09
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 11 Aug 2023 15:06:10 -0700 (PDT)
Message-ID: <2e263977-0ee7-ae78-5a8a-2a67df43df76@acm.org>
Date: Fri, 11 Aug 2023 15:06:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
To: Nitesh Shetty <nj.shetty@samsung.com>, Jens Axboe <axboe@kernel.dk>,
 Jonathan Corbet <corbet@lwn.net>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
References: <20230811105300.15889-1-nj.shetty@samsung.com>
 <CGME20230811105659epcas5p1982eeaeb580c4cb9b23a29270945be08@epcas5p1.samsung.com>
 <20230811105300.15889-4-nj.shetty@samsung.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230811105300.15889-4-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v14 03/11] block: add copy offload support
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
Cc: martin.petersen@oracle.com, linux-doc@vger.kernel.org, gost.dev@samsung.com,
 Anuj Gupta <anuj20.g@samsung.com>, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, mcgrof@kernel.org,
 dlemoal@kernel.org, linux-fsdevel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: acm.org
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 8/11/23 03:52, Nitesh Shetty wrote:
> +		if (rem != chunk)
> +			atomic_inc(&cio->refcount);

This code will be easier to read if the above if-test is left out
and if the following code is added below the for-loop:

	if (atomic_dec_and_test(&cio->refcount))
		blkdev_copy_endio(cio);

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

