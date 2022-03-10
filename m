Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79466C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 10 Mar 2022 04:06:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-15-MYH6vhM1PtK2XYAnnnGxWw-1; Wed, 09 Mar 2022 23:06:40 -0500
X-MC-Unique: MYH6vhM1PtK2XYAnnnGxWw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E9EFB101AA42;
	Thu, 10 Mar 2022 04:06:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 96191463EB4;
	Thu, 10 Mar 2022 04:06:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4CD981953574;
	Thu, 10 Mar 2022 04:06:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4E474195356D
 for <dm-devel@listman.corp.redhat.com>; Thu, 10 Mar 2022 04:06:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3BD0E40D282A; Thu, 10 Mar 2022 04:06:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3756D40D2826
 for <dm-devel@redhat.com>; Thu, 10 Mar 2022 04:06:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1F1CC802809
 for <dm-devel@redhat.com>; Thu, 10 Mar 2022 04:06:35 +0000 (UTC)
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com
 [209.85.215.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-496-hsYDi49lMNeuFGkj63s4dw-1; Wed, 09 Mar 2022 23:06:33 -0500
X-MC-Unique: hsYDi49lMNeuFGkj63s4dw-1
Received: by mail-pg1-f175.google.com with SMTP id t187so3699217pgb.1
 for <dm-devel@redhat.com>; Wed, 09 Mar 2022 20:06:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=n4d3sdtg+pC+efPptigqIpK+EMPNrP/21aNp3aHZHfI=;
 b=UEHp3vO4Dixgyb8nhD9FmuYU7IoZcqWW9+8OaFH+sbcKus2mDpfo8xd9eIgZMbZYdg
 6Kc08MG1KQtgpAuJbqCX2CcisknoF8ZOKYqZpcZOS2NOz99BF2bLlXoaZQVU9Qe88Jw2
 C45YgsjE76Tgj4LyYR2uSiG5dOFxVlB82eywZFwmHlEq20e8VZszWWz8YbztUG9OAn4D
 /7QSlKVwL3zraPdaC57LRnIDsje/V7GxJLoTite1j4GHMELLyYGm8TFNqT1jljBdzaeS
 UEVRVb1Gda4FU3lov+wKoyJql+C4yecMKa5W4/LsYMEs+l49V0FLWWzDFuTH67s0fepR
 9CrQ==
X-Gm-Message-State: AOAM530IobPZkLHUcLg2xONNVZhUslFTy14gnVSAK1HpIX1sYvZuKbsC
 8o1iQQjOUwHYX8IeiWJto3vEEw==
X-Google-Smtp-Source: ABdhPJyE0JVdHttDZ4avXV2jMFMqd/QgecH2nRf4iP9Tk6UbPqRGEjVQtOlX1AcMCBOfnEYiwQxioA==
X-Received: by 2002:a62:1881:0:b0:4e0:1b4c:36f8 with SMTP id
 123-20020a621881000000b004e01b4c36f8mr3117227pfy.26.1646885192218; 
 Wed, 09 Mar 2022 20:06:32 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
 by smtp.gmail.com with ESMTPSA id
 b5-20020a056a0002c500b004f6dbd217c9sm4686550pft.108.2022.03.09.20.06.31
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 09 Mar 2022 20:06:31 -0800 (PST)
Message-ID: <240bcfdf-a04f-069b-7574-a8a300d1d8f5@kernel.dk>
Date: Wed, 9 Mar 2022 21:06:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
To: Ming Lei <ming.lei@redhat.com>
References: <20220307185303.71201-1-snitzer@redhat.com>
 <20220307185303.71201-3-snitzer@redhat.com>
 <eac88ad5-3274-389b-9d18-9b6aa16fcb98@kernel.dk> <Yif/Or0s1rV87a5R@T590>
 <d4657e24-4cc7-7372-bafe-d6c9c8005c6b@kernel.dk> <Yil3wXO83U3zj5vj@T590>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Yil3wXO83U3zj5vj@T590>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v6 2/2] dm: support bio polling
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, hch@lst.de,
 Mike Snitzer <snitzer@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/9/22 9:00 PM, Ming Lei wrote:
> Looks improvement on 4k is small, is it caused by pcie bw limit?
> What is the IOPS when running the same t/io_uring on single optane
> directly?

Yes, see what you responded to higher up:

"which ends up being bw limited for me, because the devices aren't
linked gen4".

Some of them are, but the adapters are a bit janky and we often end up
with gen3 links and hence limited to ~3.2GB/sec per drive. But with the
bw limits even on gen4, you're roughly at about 1.5M IOPS per drive at
that point, so would expect lower percentage wise gains for 4k with
polling.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

