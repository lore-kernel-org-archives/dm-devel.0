Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33D45C001B0
	for <dm-devel@archiver.kernel.org>; Fri, 11 Aug 2023 21:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691791130;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=dd6RjzSvKx5xIrgLky2l9q13nX1PZP6Stn8l0HvfopM=;
	b=NN27fdpyYzI2n672+uWklcUaGiKg/cRdzBwUFLOoSuCiDT/YJ0/se6LV80bRQUeDkjHfXZ
	+rsXOvcD/RrlPYJ8gFnj3pU3aEH/bGc/fSxf8oHtD5xnwCf5f+EmxFXHtw9TuOGq53B0ig
	GIbIoECTV2NGvqWANuwigo7xsk0ts8E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-300-gRJq0g81MN6qp0dppXJY2g-1; Fri, 11 Aug 2023 17:58:46 -0400
X-MC-Unique: gRJq0g81MN6qp0dppXJY2g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 07B5D857A84;
	Fri, 11 Aug 2023 21:58:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E7C4363F66;
	Fri, 11 Aug 2023 21:58:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8C55B1946594;
	Fri, 11 Aug 2023 21:58:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 88B83194658F
 for <dm-devel@listman.corp.redhat.com>; Fri, 11 Aug 2023 21:58:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 555D7401E63; Fri, 11 Aug 2023 21:58:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4CCC1492C13
 for <dm-devel@redhat.com>; Fri, 11 Aug 2023 21:58:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 319708007A4
 for <dm-devel@redhat.com>; Fri, 11 Aug 2023 21:58:43 +0000 (UTC)
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com
 [209.85.214.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-464-_M3jE99RMry65cUnBfEH_w-1; Fri, 11 Aug 2023 17:58:40 -0400
X-MC-Unique: _M3jE99RMry65cUnBfEH_w-1
Received: by mail-pl1-f169.google.com with SMTP id
 d9443c01a7336-1bdc510e981so4035915ad.2; 
 Fri, 11 Aug 2023 14:58:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1691791119; x=1692395919;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=L6HRkLM0SkoQZVLyx2qLkyNekZfBcDgxJqKY8rpzcgg=;
 b=NEUrd15dhHy/eRVXdnVpZrh5uPyhGf6TbsnqaMzO1oQvfzEOG4upto9W/lcP7pA4JE
 UOL0pUeJgcol8cBAk74n53Dd+m9w2XL0miB+lh9ymjW8w6xUG/i9+99dZK/4O1XKzQyq
 NiDLi02KL3hlGRK8bIXBgL/TXxeqv38HHREM8dLCU/9WzmThz/ud7rS9HnUvi9Ma6/Ma
 b8hoYNNwVpjtm/KoFetcEgLvzJefr1vTV7gRbBmQ+vRPeXbiBjgRxCg548TE5K7Y6KoZ
 J7RfxpQLiY2uk4VpvkSE/Kve5RJDw6qMR1Q9rGf/nIzENgMdoiX2k1KYumsz2ww74Di4
 hjmQ==
X-Gm-Message-State: AOJu0YzM7xKinhesZNFj7wjua4i2wbVLNvPJC1rWqnvGdj9ZxJsA9aoN
 DlDKJF9QkS3zED/Lkv5IhvI=
X-Google-Smtp-Source: AGHT+IGwHdIE3Y5YV9a/4Hh9MIcPpfsNQVJE3AlI+jbV6QV1hWBOlM8CNMnC6D2YYbg22mOHJHHRnA==
X-Received: by 2002:a17:902:b907:b0:1b9:de3e:7a59 with SMTP id
 bf7-20020a170902b90700b001b9de3e7a59mr2960940plb.10.1691791119094; 
 Fri, 11 Aug 2023 14:58:39 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:cdd8:4c3:2f3c:adea?
 ([2620:15c:211:201:cdd8:4c3:2f3c:adea])
 by smtp.gmail.com with ESMTPSA id
 l13-20020a170902d34d00b001bda42a216bsm4135429plk.100.2023.08.11.14.58.37
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 11 Aug 2023 14:58:38 -0700 (PDT)
Message-ID: <355bb623-9cd9-fe33-106e-1f091c09fb32@acm.org>
Date: Fri, 11 Aug 2023 14:58:36 -0700
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: acm.org
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 8/11/23 03:52, Nitesh Shetty wrote:
> We expect caller to take a plug and send bio with source information,
> followed by bio with destination information.
> Once the src bio arrives we form a request and wait for destination
> bio. Upon arrival of destination we merge these two bio's and send
> corresponding request down to device driver.

Is the above description up-to-date? In the cover letter there is a 
different description of how copy offloading works.

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

