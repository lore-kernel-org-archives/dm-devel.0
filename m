Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C470C001B0
	for <dm-devel@archiver.kernel.org>; Fri, 11 Aug 2023 21:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691790667;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=63fd811P15yKwUL+Lf8WXQodP8I2ynX46gDzSfOSkAM=;
	b=QpqupNdmwQBVTLCH2sgo3tYDCG/RLavNl1MjbZWSCqQ76ayMHOLSEeOEzEtLmv/yZZDLHK
	+9XQgg0IGCnbEDf55J2bmzG167V4ebndaaqRAR3sn4tngi9Tl6jj3rLnzDv9u2xLKC+NNi
	tlHcoQJYvDgAkkFjUSlPe5nf0lDEZFA=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-132-rqS2K47dOgaYYbwlU36cnQ-1; Fri, 11 Aug 2023 17:51:03 -0400
X-MC-Unique: rqS2K47dOgaYYbwlU36cnQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 26CA13C0F698;
	Fri, 11 Aug 2023 21:51:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AFEE6C15BAE;
	Fri, 11 Aug 2023 21:51:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5D1011946594;
	Fri, 11 Aug 2023 21:51:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B06C2194658F
 for <dm-devel@listman.corp.redhat.com>; Fri, 11 Aug 2023 21:50:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9BA9740C6F53; Fri, 11 Aug 2023 21:50:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9425940C6F4E
 for <dm-devel@redhat.com>; Fri, 11 Aug 2023 21:50:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 772E71C060DE
 for <dm-devel@redhat.com>; Fri, 11 Aug 2023 21:50:59 +0000 (UTC)
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com
 [209.85.214.178]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-166-sHewOHP4Mb-M21ZN4Ix11A-1; Fri, 11 Aug 2023 17:50:55 -0400
X-MC-Unique: sHewOHP4Mb-M21ZN4Ix11A-1
Received: by mail-pl1-f178.google.com with SMTP id
 d9443c01a7336-1bdc6867ec4so3320355ad.0; 
 Fri, 11 Aug 2023 14:50:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1691790654; x=1692395454;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=wrI+uxp3aYoFCrzZoU6uRvoRMnje8fjhUyPHKIqWtFA=;
 b=diy0bXzOcr0ugDs+um7YV+Joqa3Tnc988g3pbjsMdlLCNRhbbjYQFxxkDHwSnJfKLw
 An9Awe8BtnCD5misnZJDMnGneutUm+1BpTrqLJGg2MzyPZO0caaeq7HgHnNMGXrimpcl
 TtZZHNYFjG6k6dthSykhIS2wVAcS1kWUfeTCnldARWe484Zab2VSvZM1IlrOsraS2WRH
 PvzV/u3iRaLbiHcNNppgyHTrrUA4Bcuo5Iv2eW8uZiO2XPrG59Jy4EXFUIYQLDidYk8D
 Lo0eJjd7Wkr4kiRtJRY55OZK6d0fa073orDQaImLht71/6NuKU4QX1/8USnuVaFd7euI
 z6Rw==
X-Gm-Message-State: AOJu0YxKQ69pQJqAdW+0HNMDCWbfxQfjSibViSN774udmF9cQQW50Eee
 QRowwIzT9/LP0LXtEvHx4mE=
X-Google-Smtp-Source: AGHT+IF8U+lGorQ6rte8/N0gRF/coyHYDMaevJEd+XYzOy0jSGnPMMJg+8prLKGskrtcXvIzIdxvzA==
X-Received: by 2002:a17:902:ab5a:b0:1bd:bfc0:4627 with SMTP id
 ij26-20020a170902ab5a00b001bdbfc04627mr1837548plb.40.1691790654475; 
 Fri, 11 Aug 2023 14:50:54 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:cdd8:4c3:2f3c:adea?
 ([2620:15c:211:201:cdd8:4c3:2f3c:adea])
 by smtp.gmail.com with ESMTPSA id
 b1-20020a170902d30100b001b85bb5fd77sm4388437plc.119.2023.08.11.14.50.52
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 11 Aug 2023 14:50:54 -0700 (PDT)
Message-ID: <2cc56fb5-ddba-b6d0-f66b-aa8fffa42af0@acm.org>
Date: Fri, 11 Aug 2023 14:50:51 -0700
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
References: <CGME20230811105627epcas5p1aa1ef0e58bcd0fc05a072c8b40dcfb96@epcas5p1.samsung.com>
 <20230811105300.15889-1-nj.shetty@samsung.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230811105300.15889-1-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v14 00/11] Implement copy offload support
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
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, mcgrof@kernel.org, dlemoal@kernel.org,
 linux-fsdevel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: acm.org
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 8/11/23 03:52, Nitesh Shetty wrote:
> We achieve copy offload by sending 2 bio's with source and destination
> info and merge them to form a request. This request is sent to driver.
> So this design works only for request based storage drivers.

[ ... ]

> Overall series supports:
> ========================
> 	1. Driver
> 		- NVMe Copy command (single NS, TP 4065), including support
> 		in nvme-target (for block and file back end).
> 
> 	2. Block layer
> 		- Block-generic copy (REQ_OP_COPY_DST/SRC), operation with
>                    interface accommodating two block-devs
>                  - Merging copy requests in request layer
> 		- Emulation, for in-kernel user when offload is natively
>                  absent
> 		- dm-linear support (for cases not requiring split)
> 
> 	3. User-interface
> 		- copy_file_range

Is this sufficient? The combination of dm-crypt, dm-linear and the NVMe 
driver is very common. What is the plan for supporting dm-crypt? 
Shouldn't bio splitting be supported for dm-linear?

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

