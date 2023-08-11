Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2D3EC001B0
	for <dm-devel@archiver.kernel.org>; Fri, 11 Aug 2023 22:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691791880;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=f4VbK/2u0PjoROUUkE1zCZovCKWSHoqNopul6p1OMYc=;
	b=L6LCmQljfI1sa8GARXQDjMb2zu7qLsYUR2MQLAbeRPFNXnjS/5bgV4FiZPvY1IKsPUw303
	qRDWZ5PqdNplPWde7cGgb3h/cui0AfC9JI/NBje4Xb+G1jBriqqAsFBlZM5+wIlOWPkPz1
	JZUHfhXX+2Ty/Jqn0BNKGcM0Hvt5xmI=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-369-NLvBhBw7OOWyNKtgK4vp3g-1; Fri, 11 Aug 2023 18:11:17 -0400
X-MC-Unique: NLvBhBw7OOWyNKtgK4vp3g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A07C43801BEB;
	Fri, 11 Aug 2023 22:11:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8CE685CC9A;
	Fri, 11 Aug 2023 22:11:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 36F8C1946594;
	Fri, 11 Aug 2023 22:11:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5EC30194658F
 for <dm-devel@listman.corp.redhat.com>; Fri, 11 Aug 2023 22:11:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4745C63F66; Fri, 11 Aug 2023 22:11:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3F4C55CC9A
 for <dm-devel@redhat.com>; Fri, 11 Aug 2023 22:11:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1F99580CD85
 for <dm-devel@redhat.com>; Fri, 11 Aug 2023 22:11:13 +0000 (UTC)
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com
 [209.85.214.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-343-vwChxQenML6Ku5FxEEBocA-1; Fri, 11 Aug 2023 18:11:09 -0400
X-MC-Unique: vwChxQenML6Ku5FxEEBocA-1
Received: by mail-pl1-f171.google.com with SMTP id
 d9443c01a7336-1bbf8cb61aeso18223655ad.2; 
 Fri, 11 Aug 2023 15:11:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1691791868; x=1692396668;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=o52cWlwXR3N6/ms+y9tYy0bzSVEqexTODJML7eEO/+8=;
 b=VaRcDfeSKBG8naRAQDxrdLPwNgl8A9CHxv9FvUd7TrEJImyZMMr1YwWSPmV7abJdP+
 ekk/7s2v3xNAxAwv+Sk9BUo7G6IKfTwrm5Mt0KfW3N1+3IW180XdnWenyLmmEaDhlBcz
 8qMY0+LRzHgy+s3pIg0DWdLnwoMS63bxEwwQSYROQaEirApflNfmCbmQIiIcYchrZ+b0
 F700R7kZqj/mN7DX6wSLQOoyO9hxS0MJLA9dwwj+lSuztQitW19EKko7ICTLh32Q4dLe
 vLA58pwfHosZNyiM3Vkz7La8RQkMc9eYk1CIh8Iq5WhCsGi6c2mwhY/NHLsz3Z/0cBiH
 HsBA==
X-Gm-Message-State: AOJu0YwT/+zGzIzL1oUXgQm1E7sQO+UIGipFtDZIzlru1kexmVoZi7tG
 v93jUElP61sGIiOemvqJs3w=
X-Google-Smtp-Source: AGHT+IGO1cYq9ryCeUR18SdH4aYD4OVeMcVgDFSRF+fdG4TERHS/ZNVH28DIGQxUbVu84B1GJsMb2w==
X-Received: by 2002:a17:903:185:b0:1bc:2036:2219 with SMTP id
 z5-20020a170903018500b001bc20362219mr2795385plg.41.1691791868121; 
 Fri, 11 Aug 2023 15:11:08 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:cdd8:4c3:2f3c:adea?
 ([2620:15c:211:201:cdd8:4c3:2f3c:adea])
 by smtp.gmail.com with ESMTPSA id
 u9-20020a17090282c900b001bc53321392sm4413845plz.69.2023.08.11.15.11.06
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 11 Aug 2023 15:11:07 -0700 (PDT)
Message-ID: <57558d7b-4444-b709-60bf-5a061cd6c3e9@acm.org>
Date: Fri, 11 Aug 2023 15:11:05 -0700
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
 <CGME20230811105713epcas5p3b5323a0c553006e60671dde6c72fc4c6@epcas5p3.samsung.com>
 <20230811105300.15889-5-nj.shetty@samsung.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230811105300.15889-5-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v14 04/11] block: add emulation for copy
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
Cc: Vincent Fu <vincent.fu@samsung.com>, martin.petersen@oracle.com,
 linux-doc@vger.kernel.org, gost.dev@samsung.com,
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
> +	schedule_work(&emulation_io->emulation_work);

schedule_work() uses system_wq. This won't work for all users since 
there are no latency guarantees for system_wq.

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

