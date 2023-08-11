Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7799AC001B0
	for <dm-devel@archiver.kernel.org>; Fri, 11 Aug 2023 21:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691789173;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=h/tiJl+AEHCzg1Dbi15ba9vi/N8c45WdMxEdsfsW30o=;
	b=PemaC1PjWqP4W95m5Gtl8MWoUHmXDt6tqXhcarcTd/MJho5cBbfvlkWdChECpNPYMQzd/8
	qNHTPUP0L2nH+SsqSB6Yq420uZ04DmksoNcUZ9BYh+JTWZ31fyH2meoCwarCGNExaeE+BD
	SAMJDK6zOBkFInOyczFrsynVDBtRtHE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-TgwlL1DXPjW1WhKB1Wl76g-1; Fri, 11 Aug 2023 17:26:10 -0400
X-MC-Unique: TgwlL1DXPjW1WhKB1Wl76g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A2B108DC665;
	Fri, 11 Aug 2023 21:26:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2CA6E140E96D;
	Fri, 11 Aug 2023 21:26:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CB45B1946594;
	Fri, 11 Aug 2023 21:26:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 13CDC194658F
 for <dm-devel@listman.corp.redhat.com>; Fri, 11 Aug 2023 21:26:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E46DA1121315; Fri, 11 Aug 2023 21:26:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DD2F01121314
 for <dm-devel@redhat.com>; Fri, 11 Aug 2023 21:26:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C00348015AA
 for <dm-devel@redhat.com>; Fri, 11 Aug 2023 21:26:04 +0000 (UTC)
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com
 [209.85.210.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-GZHzdCRLPOm0JqgtLYRAmw-1; Fri, 11 Aug 2023 17:26:02 -0400
X-MC-Unique: GZHzdCRLPOm0JqgtLYRAmw-1
Received: by mail-pf1-f171.google.com with SMTP id
 d2e1a72fcca58-686f8614ce5so2212393b3a.3; 
 Fri, 11 Aug 2023 14:26:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1691789161; x=1692393961;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=jkael3S2pdg/VfM2aJEaWso36Tz2Khr7pAvSvEHl94s=;
 b=F5HD8Pi/rPGdc1YC2CnSnxylv8C1Qy3h3n++5l38dEy91q39jYyhitYfNar5Jy85Cu
 TJuRzcHmCIc1+o73MWyiOecvHR9HV29aHEtjw0dT5375dfmqXz0f3hWo92HeJNHObtFH
 9k3BqOlE4xW3+OGuu2jeAZkCsHSWhvTesm+/gs4Mw8de4XdflgILynIQ/V7wFR4QYmbS
 5B8NOyzpeN1lXmREljyl1LCRVFeddk1IraZvwMeqooFk5swo1oG280JJNJJmhb36TL8Q
 s7/M/JzEThLBvdRuOUUfyvigdCe4a+GTFc6uji7htYpNgqFobtdBPH9X9FzP4KiKzLxc
 hs4Q==
X-Gm-Message-State: AOJu0YyjxgWp0bBrqRPDBD/BT5nHZ8vaB9x0LY/gtTtRKQEncLtAlxly
 jEQa7Ttza5t7ohdJE6gc1xE=
X-Google-Smtp-Source: AGHT+IGvgfv1o9rzwDcunf/qZS4YYopLpr1rFa2hIc4fQs8fXgSIMEA6km+8Z6cMKCMBJqWea0/OGQ==
X-Received: by 2002:a17:90a:bd95:b0:26b:ab3:493a with SMTP id
 z21-20020a17090abd9500b0026b0ab3493amr2567330pjr.16.1691789161399; 
 Fri, 11 Aug 2023 14:26:01 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:cdd8:4c3:2f3c:adea?
 ([2620:15c:211:201:cdd8:4c3:2f3c:adea])
 by smtp.gmail.com with ESMTPSA id
 e10-20020a170902b78a00b001bd41b70b60sm4386849pls.45.2023.08.11.14.25.59
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 11 Aug 2023 14:26:00 -0700 (PDT)
Message-ID: <3b1da341-1c7f-e28f-d6aa-cecb83188f34@acm.org>
Date: Fri, 11 Aug 2023 14:25:58 -0700
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
 <CGME20230811105648epcas5p3ae8b8f6ed341e2aa253e8b4de8920a4d@epcas5p3.samsung.com>
 <20230811105300.15889-3-nj.shetty@samsung.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230811105300.15889-3-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v14 02/11] Add infrastructure for copy
 offload in block and request layer.
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: acm.org
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 8/11/23 03:52, Nitesh Shetty wrote:
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 0bad62cca3d0..de0ad7a0d571 100644
> +static inline bool op_is_copy(blk_opf_t op)
> +{
> +	return ((op & REQ_OP_MASK) == REQ_OP_COPY_SRC ||
> +		(op & REQ_OP_MASK) == REQ_OP_COPY_DST);
> +}
> +

The above function should be moved into include/linux/blk-mq.h below the
definition of req_op() such that it can use req_op() instead of 
open-coding it.

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

