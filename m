Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 280B4C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 30 Mar 2022 14:37:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-16-cKuAqFV4PhSuBJW1zTYmUg-1; Wed, 30 Mar 2022 10:37:51 -0400
X-MC-Unique: cKuAqFV4PhSuBJW1zTYmUg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 71148801E95;
	Wed, 30 Mar 2022 14:37:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1B7D12166B3F;
	Wed, 30 Mar 2022 14:37:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C14D019451F3;
	Wed, 30 Mar 2022 14:37:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8293B19466DF
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Mar 2022 14:37:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 53E801121314; Wed, 30 Mar 2022 14:37:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4FC08112131E
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 14:37:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2A20C8001EA
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 14:37:35 +0000 (UTC)
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com
 [209.85.166.46]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-540-kTslOUQQMwKhwbDxnDDV1w-1; Wed, 30 Mar 2022 10:37:33 -0400
X-MC-Unique: kTslOUQQMwKhwbDxnDDV1w-1
Received: by mail-io1-f46.google.com with SMTP id e22so24945163ioe.11
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 07:37:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=p1LjEXlqSlyorFbt9Hj6fJ3D33ukmQymP4McTXiwuvI=;
 b=wTjW8M0JotAzqMla7Ioc0rtWrcdao6n7Vo6V8xMRlfZY1qjuwTASALqXfF1X6NAP6t
 m9qz3rzgmxEK47k8lCXVsloRilZaIJ48BajZNMaZ8VWeKiOp2vFKA62rx9kLi608igwp
 poY3Xki7wBcp5miouIrr+1KJVmas4PGGdMGkic1jOAfGHdCr28DHbueldpGEynkYBIsK
 nIsRSpTlKZ3zcNuwnkfe7AG8ZXYhxh/KlpHoCTZ3x4bj8YHUCJLcYk6qACkKub1rc7UL
 zBHDxd7y1/qyvMQKBW4UOKu+rVaKuUwn/5NIS0CerVFHpQfUoWM1UjkS5BRCX9is4XwV
 D+rA==
X-Gm-Message-State: AOAM53126lfkUNWzgN6p9j2syOYWy2rv5sgpH1vylQgUuMkViuzoaKz0
 H9+oHx5C7LBxrfPouvNnNN/nMA==
X-Google-Smtp-Source: ABdhPJxWZjyhMiWtwRr2IJsCj1tDCDDyu4dISaBGduLCOvlTo7fi3P8RUag3/yt+zUT6N1KJCo0sFA==
X-Received: by 2002:a5d:9a0a:0:b0:648:c8a4:c86 with SMTP id
 s10-20020a5d9a0a000000b00648c8a40c86mr11682274iol.168.1648651052133; 
 Wed, 30 Mar 2022 07:37:32 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
 by smtp.gmail.com with ESMTPSA id
 k11-20020a926f0b000000b002c2756f7e90sm10089799ilc.17.2022.03.30.07.37.30
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 30 Mar 2022 07:37:31 -0700 (PDT)
Message-ID: <97a03884-9dcf-b1b3-a97c-506cec2f6d27@kernel.dk>
Date: Wed, 30 Mar 2022 08:37:28 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
To: Christoph Hellwig <hch@lst.de>
References: <20220308061551.737853-1-hch@lst.de> <20220330142941.GA3479@lst.de>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220330142941.GA3479@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] cleanup bio_kmalloc v2
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
Cc: linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
 Mike Snitzer <snitzer@redhat.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
 Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
 Song Liu <song@kernel.org>, dm-devel@redhat.com, target-devel@vger.kernel.org,
 David Sterba <dsterba@suse.com>, Phillip Lougher <phillip@squashfs.org.uk>,
 linux-btrfs@vger.kernel.org
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

On 3/30/22 8:29 AM, Christoph Hellwig wrote:
> I just noticed this didn't make it into the 5.18 queue.  Which is a
> bit sad as it leaves us with a rather inconsistent bio API in 5.18.

Let me take a look, we might still be able to make it...

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

