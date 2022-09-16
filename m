Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A656C54EE9
	for <dm-devel@archiver.kernel.org>; Fri, 16 Sep 2022 06:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663311420;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=KOVlFlxSLaWddybZnNNO9LizoKAwuAXtf0xWN7y8L78=;
	b=iagGi80qI+YMKfv4EKL194ZHlyH39UxJfuWvMHHWzPY5fJHQzQf4SMhFzru763Or2AKGwB
	yGYzhHO3bYufBHbtcPrcL8EL+oxrfkeTtdS62taGSx4eN0VvCr2GCTDetW+QrvhbgfXQ1/
	8UsA8+9wpVJrWbiE7vxOhjHl5e5M4To=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-435-FpDzgwDmPne9hSf9FowvpA-1; Fri, 16 Sep 2022 02:56:59 -0400
X-MC-Unique: FpDzgwDmPne9hSf9FowvpA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 37A0A85A5B6;
	Fri, 16 Sep 2022 06:56:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 36601C15BA4;
	Fri, 16 Sep 2022 06:56:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 130281946587;
	Fri, 16 Sep 2022 06:56:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 32A371946586
 for <dm-devel@listman.corp.redhat.com>; Fri, 16 Sep 2022 06:56:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 10C51140E93D; Fri, 16 Sep 2022 06:56:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0495D140EBF5
 for <dm-devel@redhat.com>; Fri, 16 Sep 2022 06:56:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E0897800B30
 for <dm-devel@redhat.com>; Fri, 16 Sep 2022 06:56:53 +0000 (UTC)
Received: from mail1.bemta34.messagelabs.com (mail1.bemta34.messagelabs.com
 [195.245.231.2]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-275-3feAEoBjOHulTr01tQsfVA-1; Fri, 16 Sep 2022 02:56:50 -0400
X-MC-Unique: 3feAEoBjOHulTr01tQsfVA-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleJIrShJLcpLzFFi42Kxs+FI1NWXU0k
 2OPTYymL9qWPMFnvfzWa1OPvrKotF28avjBYPF2xmt1jbn+7A5rFrVyO7x6ZVnWwe7/ddZQtg
 jmLNzEvKr0hgzfi2ZgVbwVf2ipYz+5gbGJvYuxi5OIQEtjBKrFm/lQXCWc4ksXPhbqjMNkaJz
 hOzGbsYOTl4BewkOr6dYAKxWQRUJSbP+M4GEReUODnzCQuILSqQJHF1w11WEJtNwFFi3qyNYD
 XCArYSi763gsVFBJwl+pZOZgJZwCzwnFHi5qvLYM3MAhYSi98cZIew5SW2v53DDGJLCChKtC3
 5xw5hV0g0Tj/EBGGrSVw9t4l5AqPALCR3zEIyahaSUQsYmVcxWiUVZaZnlOQmZuboGhoY6Boa
 muoaW+paGOklVukm6qWW6panFpfoArnlxXqpxcV6xZW5yTkpenmpJZsYgdGQUqwetIPx24qfe
 ocYJTmYlER5H5srJwvxJeWnVGYkFmfEF5XmpBYfYpTh4FCS4LUSV0kWEixKTU+tSMvMAUYmTF
 qCg0dJhNdRBCjNW1yQmFucmQ6ROsVozHF+5/69zBxrGw7sZRZiycvPS5US53WVAioVACnNKM2
 DGwRLGJcYZaWEeRkZGBiEeApSi3IzS1DlXzGKczAqCfPOlwSawpOZVwK37xXQKUxAp/AaKIOc
 UpKIkJJqYJpYnPx9UbZa01U/kym1DG65focu3mUu3nc7a/OKrIrkX6cvbaj2PJkec9XG8vSzO
 09aMpvXGl7PYMqcfXxbkdLP5f+47/I0mj3xZjabr9/Hdlhx3oe/9pzVojfDvOefXORjfmXvbP
 EPcZUHHrKIi4beWtf8N5Z1qtY8s/l9c1cYbn7BfVlo788baRN/PfOyz9iyWDiratWzdSHW1zZ
 bbV4nPXfr622ihzp0OYq36kXXqB18PKGy3f2BkI1r7D4J5RLXwtmK3x+t3jrVQdz0lHhZcnQ0
 s0v4pLVaC74ZBYjw3W36t/yTlGFxwqMZgYd6JRrPJ9nrmO76F5Lzc8Wrw3Xu31uvvA5sbvia6
 t9/sF2JpTgj0VCLuag4EQBGQ7EOkwMAAA==
X-Env-Sender: yangx.jy@fujitsu.com
X-Msg-Ref: server-3.tower-571.messagelabs.com!1663311407!21683!1
X-Originating-IP: [62.60.8.97]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.87.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 19234 invoked from network); 16 Sep 2022 06:56:47 -0000
Received: from unknown (HELO n03ukasimr01.n03.fujitsu.local) (62.60.8.97)
 by server-3.tower-571.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384
 encrypted SMTP; 16 Sep 2022 06:56:47 -0000
Received: from n03ukasimr01.n03.fujitsu.local (localhost [127.0.0.1])
 by n03ukasimr01.n03.fujitsu.local (Postfix) with ESMTP id 9653D100191;
 Fri, 16 Sep 2022 07:56:47 +0100 (BST)
Received: from R01UKEXCASM121.r01.fujitsu.local (R01UKEXCASM121
 [10.183.43.173])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by n03ukasimr01.n03.fujitsu.local (Postfix) with ESMTPS id 8A08010018D;
 Fri, 16 Sep 2022 07:56:47 +0100 (BST)
Received: from [10.167.215.54] (10.167.215.54) by
 R01UKEXCASM121.r01.fujitsu.local (10.183.43.173) with Microsoft SMTP Server
 (TLS) id 15.0.1497.32; Fri, 16 Sep 2022 07:56:43 +0100
Message-ID: <e0cce6af-fd55-a582-194e-7f8a3aced6b0@fujitsu.com>
Date: Fri, 16 Sep 2022 14:56:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
From: =?UTF-8?B?WWFuZywgWGlhby/mnagg5pmT?= <yangx.jy@fujitsu.com>
To: <zwisler@kernel.org>, <toshi.kani@hpe.com>, <jmoyer@redhat.com>
X-Originating-IP: [10.167.215.54]
X-ClientProxiedBy: G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) To
 R01UKEXCASM121.r01.fujitsu.local (10.183.43.173)
X-Virus-Scanned: ClamAV using ClamSMTP
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] Question about which types of dm need to support DAX
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
Cc: snitzer@redhat.com, Shiyang
 Ruan <ruansy.fnst@fujitsu.com>, "y-goto@fujitsu.com" <y-goto@fujitsu.com>,
 dm-devel@redhat.com,
 =?UTF-8?B?R3UsIEppbnhpYW5nL+mhviA=?= =?UTF-8?B?6YeR6aaZ?= <gujx@fujitsu.com>,
 agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hi Ross, Toshi, Jeff and others

After reading the kernel patches[1][2][3] about dm, I think only three 
types(linear, stripe and log-writes) of dm can support DAX now, right?

[1] 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=98d82f48f1983ceef5c8d2f6c87bfee2918790ee
[2] 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=beec25b4573bc310f5a12cf33207b20ecc30945c
[3] 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=84b22f8378cf493524043a0a8dd567c58c64546f

In addition, I also saw that Jeff has added a check[4] for the DAX 
support of dm in xfstests.

[4] 
https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/commit/?id=fc7b3903894a6213c765d64df91847f4460336a2

I wonder why only three types of dm need to support DAX? Is there any 
reason/history and use case?

Is it necessary to make other types (for example, thin-pool) support 
DAX? If necessary, is there any use case for other types?

Best Regards,
Xiao Yang

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

