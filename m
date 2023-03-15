Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBF3FC6FD1D
	for <dm-devel@archiver.kernel.org>; Wed, 15 Mar 2023 15:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678893956;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=VO5X4KnwEuGWylGSfOVvWxQhVQJoODXPyLBs7lmxfmA=;
	b=XlEipsf0Bvs0wspk5x7XiHIxgF8txkZ7szG42jlwb26LY+1gL/kVUghlRVDHhvC3zuQkmu
	pCqX6xGygD/NFLyaSyzX6clN8LEkLP3rBfGUR852Ms+Lq3kV5OftYUSAbUoYqhK9Sn+PVI
	1jtm/2WNQpIoRMTY5hmkZ0J2QbAOb94=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-529-fDRTuxKtM_yv_-3LRLLgSA-1; Wed, 15 Mar 2023 11:25:55 -0400
X-MC-Unique: fDRTuxKtM_yv_-3LRLLgSA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E686E80B246;
	Wed, 15 Mar 2023 15:25:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 92A92400F4F;
	Wed, 15 Mar 2023 15:25:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5AF2B1946A40;
	Wed, 15 Mar 2023 15:25:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 78E5A1946597
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Mar 2023 15:25:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 36BB5492B03; Wed, 15 Mar 2023 15:25:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F508492B00
 for <dm-devel@redhat.com>; Wed, 15 Mar 2023 15:25:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0A97E857FBB
 for <dm-devel@redhat.com>; Wed, 15 Mar 2023 15:25:43 +0000 (UTC)
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com
 [209.85.166.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-FUUmZvlJMGKPs51iLgHlmw-1; Wed, 15 Mar 2023 11:25:41 -0400
X-MC-Unique: FUUmZvlJMGKPs51iLgHlmw-1
Received: by mail-il1-f180.google.com with SMTP id bp11so5132039ilb.3
 for <dm-devel@redhat.com>; Wed, 15 Mar 2023 08:25:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1678893940;
 h=content-transfer-encoding:mime-version:date:message-id:subject
 :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=311tmwoPi+X9O5T0jkqGhTRpiGHy+F0ctJn+X1ijaso=;
 b=nK6Cr7pXX4oWyK6HXAVJIzHwONeIJcf52NfeRkiIWfsbMAOMQE35Xd8y6i7pu8ORws
 zdcmMzEXv6TPNxVBBveK+GQpaGanPBaV0FRElYw1R/S6VQkWas9HcuyYG1OJjIMXnDUm
 dhUAlDgy+n5YuG9Uw46CUPMnKX1d/W8X4lWYMyU/D05+5VzqQtRJ734uXdhh7rx9owC0
 Sm/Igd5hd+TUV7y3XGJiWhx5CgnPJ8J8vaY8JwUSBUsTtJQPZ/Unowz0+LOAhJ/N/vkX
 MlpmOuKgGxYOeLhS1zyLtpzfg11lydH5Q8A/H6/DgAS6eMnNVsK7wgujTzwVloXi5TP1
 63Zg==
X-Gm-Message-State: AO0yUKWHhjxUV1ga7PrA/is9x2RCjI028PHagN9LSagLT5WaEkpUPNcw
 Dh9WKjJ70GjHj+0+UgbJa6yWfA==
X-Google-Smtp-Source: AK7set+GXeS45AV6ZCOSt9EJghEpaRhu4keAdlUsc5MciV2dt1MDmCOkfh6V8QLE789iJhm5iwmeYQ==
X-Received: by 2002:a92:d704:0:b0:317:943c:2280 with SMTP id
 m4-20020a92d704000000b00317943c2280mr10003193iln.0.1678893940152; 
 Wed, 15 Mar 2023 08:25:40 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2]) by smtp.gmail.com with ESMTPSA id
 h11-20020a02b60b000000b003e80d0843e4sm1713415jam.78.2023.03.15.08.25.39
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 15 Mar 2023 08:25:39 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com, 
 kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, guz.fnst@cn.fujitsu.com, 
 Yu Kuai <yukuai1@huaweicloud.com>
In-Reply-To: <20230223091226.1135678-1-yukuai1@huaweicloud.com>
References: <20230223091226.1135678-1-yukuai1@huaweicloud.com>
Message-Id: <167889393912.42717.4228399799157411797.b4-ty@kernel.dk>
Date: Wed, 15 Mar 2023 09:25:39 -0600
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH -next RFC] block: count 'ios' and 'sectors'
 when io is done for bio-based device
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
Cc: yi.zhang@huawei.com, yangerkun@huawei.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 yukuai3@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


On Thu, 23 Feb 2023 17:12:26 +0800, Yu Kuai wrote:
> While using iostat for raid, I observed very strange 'await'
> occasionally, and turns out it's due to that 'ios' and 'sectors' is
> counted in bdev_start_io_acct(), while 'nsecs' is counted in
> bdev_end_io_acct(). I'm not sure why they are ccounted like that
> but I think this behaviour is obviously wrong because user will get
> wrong disk stats.
> 
> [...]

Applied, thanks!

[1/1] block: count 'ios' and 'sectors' when io is done for bio-based device
      commit: 5f27571382ca42daa3e3d40d1b252bf18c2b61d2

Best regards,
-- 
Jens Axboe



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

