Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BC1EC77B75
	for <dm-devel@archiver.kernel.org>; Tue, 18 Apr 2023 22:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681857838;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=p4Ygfa7vS212NA2D0kBL3AaOy2EX78rmCIqkswoSSDM=;
	b=ZQEgpzN9IbLuFrK76ObuYRE47MXTlx92KzEXV/qHFcpASkMFZpWAu7q6W570xrBHhhXv7f
	0nHho52DV9uADdO+yeG9bjcfEXeItvGOyWYPgEHiwwGQAD4CiNKtRMQOBOul4yioCQS8II
	7dWCrlAc8qF3BfEdjmSFN98o3JekNjQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-221-Ak_ePqtAPXqSO10C3F0YEQ-1; Tue, 18 Apr 2023 18:43:57 -0400
X-MC-Unique: Ak_ePqtAPXqSO10C3F0YEQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 36D7F3C0C88B;
	Tue, 18 Apr 2023 22:43:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B85062958;
	Tue, 18 Apr 2023 22:43:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 83D591946594;
	Tue, 18 Apr 2023 22:43:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 09139194658F
 for <dm-devel@listman.corp.redhat.com>; Tue, 18 Apr 2023 22:43:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A83682166B29; Tue, 18 Apr 2023 22:43:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A06212166B26
 for <dm-devel@redhat.com>; Tue, 18 Apr 2023 22:43:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8240A887400
 for <dm-devel@redhat.com>; Tue, 18 Apr 2023 22:43:52 +0000 (UTC)
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com
 [209.85.214.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-_w58Sc-YO9ibCZ2da-dmPQ-1; Tue, 18 Apr 2023 18:43:50 -0400
X-MC-Unique: _w58Sc-YO9ibCZ2da-dmPQ-1
Received: by mail-pl1-f171.google.com with SMTP id
 d9443c01a7336-1a6c5acf6ccso11453975ad.3; 
 Tue, 18 Apr 2023 15:43:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1681857829; x=1684449829;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=GRd1Pn/ei3QfwgTQ2bN6W/oJfrlsBAZasHc6v7hkSkA=;
 b=hJ9xQc6kxGn2KnzXfBl0Ztq3mXOj5eHqHEiD4ztnsNGTOw0Y056nzkZlxRVkAD1C75
 E6rhjcOlQQuBU/Sju5NogHbFXOdlWJzoHGLHNBcLCdRZaIlB4jcjsyxuiAG3r+2xpeCX
 v21LkaftvNYH9PRLKf9lMMZRBHmlKcd7rTdmThGQPXiI9STICS3QfkKjhpH3MMzOdB07
 xgDazcz87JOJUuXKo0rdUocsQArZW7EnLsgPpjaN/qowNT1PxcGFXdLCx8osuTrCv1JN
 kM2vhNgVmGdnuRtQAySZg4uXx6KRbv29JPi+M3TUe6UcqSE25iytM80ZqJSQl0Xq5Q98
 F/TA==
X-Gm-Message-State: AAQBX9chIKmVPsgaM5OABNuQUHxz1z1bneKverbefNqf/h2niHVXuTss
 zuvF4EMDLDCn2PGgqa15q/U=
X-Google-Smtp-Source: AKy350bwRPit77QBRyCkurpbLJcKpUzou5Ygm5yswkmtHRjJpN/wCGE3gl3bGCRqpWafsB3KLZ6hBA==
X-Received: by 2002:a17:903:32c1:b0:1a1:b656:2149 with SMTP id
 i1-20020a17090332c100b001a1b6562149mr4070484plr.50.1681857828891; 
 Tue, 18 Apr 2023 15:43:48 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:5d9b:263d:206c:895a?
 ([2620:15c:211:201:5d9b:263d:206c:895a])
 by smtp.gmail.com with ESMTPSA id
 k5-20020a170902e90500b001a64a335e42sm10127547pld.160.2023.04.18.15.43.47
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 18 Apr 2023 15:43:48 -0700 (PDT)
Message-ID: <b74cc3d8-bfde-8375-3b19-24ea13eb1196@acm.org>
Date: Tue, 18 Apr 2023 15:43:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
To: Sarthak Kukreti <sarthakkukreti@chromium.org>, dm-devel@redhat.com,
 linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20230414000219.92640-1-sarthakkukreti@chromium.org>
 <20230418221207.244685-1-sarthakkukreti@chromium.org>
 <20230418221207.244685-2-sarthakkukreti@chromium.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230418221207.244685-2-sarthakkukreti@chromium.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v4 1/4] block: Introduce provisioning
 primitives
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
Cc: Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>,
 "Michael S. Tsirkin" <mst@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>,
 Jason Wang <jasowang@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, Christoph Hellwig <hch@infradead.org>,
 Andreas Dilger <adilger.kernel@dilger.ca>, Daniil Lunev <dlunev@google.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, Brian Foster <bfoster@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: acm.org
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 4/18/23 15:12, Sarthak Kukreti wrote:
>   	/* Fail if we don't recognize the flags. */
> -	if (mode & ~BLKDEV_FALLOC_FL_SUPPORTED)
> +	if (mode != 0 && mode & ~BLKDEV_FALLOC_FL_SUPPORTED)
>   		return -EOPNOTSUPP;

Is this change necessary? Doesn't (mode & ~BLKDEV_FALLOC_FL_SUPPORTED) 
!= 0 imply that mode != 0?

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

