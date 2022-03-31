Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 188FCC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 31 Mar 2022 21:22:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-377-y0uF9OD8Pcy0z6YLJny7PQ-1; Thu, 31 Mar 2022 17:22:29 -0400
X-MC-Unique: y0uF9OD8Pcy0z6YLJny7PQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2FF68185A7A4;
	Thu, 31 Mar 2022 21:22:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 82C241121314;
	Thu, 31 Mar 2022 21:22:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1D6041947BBB;
	Thu, 31 Mar 2022 21:22:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B058719451F3
 for <dm-devel@listman.corp.redhat.com>; Thu, 31 Mar 2022 21:22:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 92569400E11D; Thu, 31 Mar 2022 21:22:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E0A7400E42D
 for <dm-devel@redhat.com>; Thu, 31 Mar 2022 21:22:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 76A4A1010360
 for <dm-devel@redhat.com>; Thu, 31 Mar 2022 21:22:23 +0000 (UTC)
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com
 [209.85.215.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-l-j-613pMP6IlqrfRwLb9w-1; Thu, 31 Mar 2022 17:22:18 -0400
X-MC-Unique: l-j-613pMP6IlqrfRwLb9w-1
Received: by mail-pg1-f176.google.com with SMTP id k14so819776pga.0
 for <dm-devel@redhat.com>; Thu, 31 Mar 2022 14:22:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=x3SePf6cYyzJ/sV6xHzMCnP/4ErKQDoUNlfoUc3FU/o=;
 b=GWuFww6ZpuM/mUfpvhjHVlgjobgOeD1038n6+1ck32FTZkk87dKwp3Xfk3UyvHr0RX
 XLlLQlvnDhFbQTyIRKlIfXSMxm4WSap1AUJjy8a7JdYms/E32tHLnhxGbPVydwqrdc9V
 C3CrQ9mvrrI2UizhDSvpfJol/y+JBVNrIAR+BWW6e9qzkI7LTI3ojs0nQ6LOM5msxKkx
 qxDES4jLTPJZa/acWHSeRDpBLcnKuacKpnZn2uSbRne/sfu1h6HB4f+3F4bzUCTF0yrE
 JOXnRtEwc16LxeV8DBS+3yEfmY9seMIizZeoQ84b/HtdmBzHiGuNOkFaY4Q384J/bN6x
 u6Gw==
X-Gm-Message-State: AOAM5301/GN3utRLCgm/t0h5cYY42Hy3CmXDuKJKvQKFFw0yBwxHv/+n
 Q34Ma6TiH4MCSJGR9Y4QP6GucZM8oT2CDQ94
X-Google-Smtp-Source: ABdhPJwYnU9r41ORdf19G02EFb5yhsyLJV8xzLTtxC7Sx8NiXMpF/1DkwJ2vuON7bztWgA+FZZylpQ==
X-Received: by 2002:a05:6a00:328f:b0:4fa:95b5:e1ff with SMTP id
 ck15-20020a056a00328f00b004fa95b5e1ffmr7412958pfb.60.1648761737704; 
 Thu, 31 Mar 2022 14:22:17 -0700 (PDT)
Received: from ?IPV6:2600:380:772e:9a93:98d9:fd90:ab06:5943?
 ([2600:380:772e:9a93:98d9:fd90:ab06:5943])
 by smtp.gmail.com with ESMTPSA id
 j7-20020a056a00130700b004b9f7cd94a4sm410220pfu.56.2022.03.31.14.22.15
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 31 Mar 2022 14:22:17 -0700 (PDT)
Message-ID: <1eb268c5-3420-0263-3f0c-7d3982f8f512@kernel.dk>
Date: Thu, 31 Mar 2022 15:22:14 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
To: Marek Szyprowski <m.szyprowski@samsung.com>, Christoph Hellwig <hch@lst.de>
References: <20220308061551.737853-1-hch@lst.de>
 <20220308061551.737853-5-hch@lst.de>
 <CGME20220331211804eucas1p28da21f2dfd57aa490abffb8f87417f42@eucas1p2.samsung.com>
 <6696cc6a-3e3f-035e-5b8c-05ea361383f3@samsung.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6696cc6a-3e3f-035e-5b8c-05ea361383f3@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH 4/5] block: turn bio_kmalloc into a simple
 kmalloc wrapper
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/31/22 3:18 PM, Marek Szyprowski wrote:
> Hi Christoph,
> 
> On 08.03.2022 07:15, Christoph Hellwig wrote:
>> Remove the magic autofree semantics and require the callers to explicitly
>> call bio_init to initialize the bio.
>>
>> This allows bio_free to catch accidental bio_put calls on bio_init()ed
>> bios as well.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> This patch, which landed in today's next-20220331 as commit 57c47b42f454 
> ("block: turn bio_kmalloc into a simple kmalloc wrapper"), breaks badly 
> all my test systems, which use squashfs initrd:

The series has been reverted on the block side, so next linux-next should
be fine again. We'll try again for 5.19.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

