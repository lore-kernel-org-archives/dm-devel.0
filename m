Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65E7AEB64DC
	for <dm-devel@archiver.kernel.org>; Fri, 21 Jul 2023 14:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689948055;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=YMGC0g5rdTGsDF7vUBvvLpbEQZNfuuz71vMoz47X7Ec=;
	b=D/TqkVGj6tvcNVhMZSx9wm4QeNh4/RE0gCycrGaWdcGoEuWdXcc1PkvLVICyI0VPjKjLPp
	dBHDlDdI3bYp14loCqLNAlIwHGL+1A31UgnLjfmfChdCRK7BpN+OXs9fA0LawlKJwnmt5X
	CGvpWp8uF8lY3pVHsroG3WwmkG48t9Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-590-f4j04jmMMXa7R_f6o6hHzA-1; Fri, 21 Jul 2023 10:00:52 -0400
X-MC-Unique: f4j04jmMMXa7R_f6o6hHzA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9D427936D26;
	Fri, 21 Jul 2023 14:00:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3DC42492C13;
	Fri, 21 Jul 2023 14:00:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0289F1946A43;
	Fri, 21 Jul 2023 14:00:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0B3A01946586
 for <dm-devel@listman.corp.redhat.com>; Fri, 21 Jul 2023 14:00:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8F312C5796B; Fri, 21 Jul 2023 14:00:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E2B9C5796A
 for <dm-devel@redhat.com>; Fri, 21 Jul 2023 14:00:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 64087892245
 for <dm-devel@redhat.com>; Fri, 21 Jul 2023 14:00:47 +0000 (UTC)
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com
 [209.85.166.44]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-613-25DDEsXtPLSkRLI9rOO0uw-1; Fri, 21 Jul 2023 10:00:45 -0400
X-MC-Unique: 25DDEsXtPLSkRLI9rOO0uw-1
Received: by mail-io1-f44.google.com with SMTP id
 ca18e2360f4ac-760dff4b701so28477139f.0
 for <dm-devel@redhat.com>; Fri, 21 Jul 2023 07:00:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1689948044; x=1690552844;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=yowB+SDYz3WsGB5u3KbSB7coFl3FEU+ho0O0+py0Ukc=;
 b=L7fxWjgNK1s3nD/+aBi9JCQspNjaNhAuOhMTdja33wNteaCTunaFQTT2yUYcvzSKAr
 E5hREfPAXbEExkQyPzbL5OA6Iai5+hyQ0X3bmFGgU7yrfwXY8tYb5AZLocVvBdOs2F9U
 3KY9Y1A8LmLR8Ta9H2f054ouwkhETqrR1YCry5SqHr/hUzmJM5owcbVlh49pzSmcNJuT
 bNn0Lso7bbY+n2VNbDV0ZORRWizGGSa6f6PXYmYOG4MfpAgucPQuJhuzNSAqY9EitXvO
 c4Ai3zfk6XF6YSF+UK72J1X483LutJ02UQCi1Etv9DFkh4HHJge80ygqh7Xh6X8W/146
 9+tA==
X-Gm-Message-State: ABy/qLbqzKFRuSoURPHMhVOPmxD7q46IPHrP8XGIStbrxkiNpJhLc7dm
 y8FVDx0iXqgPqFPtRNo1w+sBUA==
X-Google-Smtp-Source: APBJJlHMT+rxz7f5suX2hWoG4yc3KEkLf1UJ5Q0KxS+wamMFFlkkxKHrGWKDrLBg9z5MlQwuTgUyMQ==
X-Received: by 2002:a6b:b789:0:b0:787:1926:54ed with SMTP id
 h131-20020a6bb789000000b00787192654edmr1799444iof.1.1689948044181; 
 Fri, 21 Jul 2023 07:00:44 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2]) by smtp.gmail.com with ESMTPSA id
 b10-20020a5ea70a000000b0078337cd3b3csm1065191iod.54.2023.07.21.07.00.43
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 21 Jul 2023 07:00:43 -0700 (PDT)
Message-ID: <6f0b9cbb-6752-6dd8-c184-10798533dfed@kernel.dk>
Date: Fri, 21 Jul 2023 08:00:42 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
To: Mikulas Patocka <mpatocka@redhat.com>
References: <9933f5df-dd43-3447-dce3-f513368578@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <9933f5df-dd43-3447-dce3-f513368578@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v2 0/3] brd discard patches
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
Cc: linux-block@vger.kernel.org, Chaitanya Kulkarni <chaitanyak@nvidia.com>,
 Christoph Hellwig <hch@infradead.org>, Li Nan <linan666@huaweicloud.com>,
 dm-devel@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.dk
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/21/23 7:48?AM, Mikulas Patocka wrote:
> This is a new version of the brd discard patches.

Can you please:

1) Ensure that your postings thread properly, it's all separate emails
   and the patches don't nest under the cover letter parent.

2) Include a changelog. What changed since v1?

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

