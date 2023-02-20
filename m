Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6FBDC636D6
	for <dm-devel@archiver.kernel.org>; Mon, 20 Feb 2023 22:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676931657;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=knRgXSmRsRpxc24jW7rpcl724eSBnXE/hjVclOelEGc=;
	b=OshKVeCeEK2uR6S5R11urqoEVGoDhhQfo0AQlaDGtC31gzyvbKHYDKNQ8q8hx2K6j1xuJE
	9etwDxls8L8mtqCre6bz0WJhCtulgdkXkOVIlW52VRaec+GduxYjEwzSPE9ynNoab42T0i
	D4dP1ChqTj+/5wrUGY8WceLJyh6OWK4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-674-NKHBhN6HOXm_obrDiGuCLA-1; Mon, 20 Feb 2023 17:20:54 -0500
X-MC-Unique: NKHBhN6HOXm_obrDiGuCLA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF0BE1C0519C;
	Mon, 20 Feb 2023 22:20:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 66F4AC15BAD;
	Mon, 20 Feb 2023 22:20:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 19BF21946587;
	Mon, 20 Feb 2023 22:20:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2CB161946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 20 Feb 2023 22:20:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 014442166B2A; Mon, 20 Feb 2023 22:20:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EEEF82166B29
 for <dm-devel@redhat.com>; Mon, 20 Feb 2023 22:20:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CF8C5882822
 for <dm-devel@redhat.com>; Mon, 20 Feb 2023 22:20:50 +0000 (UTC)
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com
 [209.85.160.174]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-37-kaOTxgSSPK6QFELlYMCicg-1; Mon, 20 Feb 2023 17:20:49 -0500
X-MC-Unique: kaOTxgSSPK6QFELlYMCicg-1
Received: by mail-qt1-f174.google.com with SMTP id fp16so2949497qtb.10
 for <dm-devel@redhat.com>; Mon, 20 Feb 2023 14:20:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=o/GkL4roSHCjRncSIk+Dw09K8EUHNxrM4m4i32VKjbs=;
 b=kkToJ4dQmCOSbc+hR5o/SwUDavVzHH02Ve7mFprq8zz91P+ahJysdDCaCW/JrpV63s
 2Cd4cXb6IMSKOH8ZqbnFZPTJ0w7iw71PNGdakuFcFN1H1tkBMNhIH7+jNvbKJEioUp93
 ulCQ4MltD48AN1RCldXU4OK2uJnCHyO2sUsc87uwZhyKNjLAI7eKFXYwZgxhZoUXBrs5
 vO1WyDghkn6SiuVYCm1ijWXM/Vw2j7lMdRMmgjWdrxtTM/sfAYNM+V3hq/ZYOpWsfe4r
 SA1iP552KmPg9F4DWCmYugpdktjYEXl5dyhapA8pzt3IkReDsZ+bm6Vbdkto+OUVQYoF
 nIJA==
X-Gm-Message-State: AO0yUKXxwfbxEYUxPbNCmL5GmwZDzkyw9S6ycYs+JBMUpnVT2t6pUzPi
 aL7xnwBD4o6ZTP81jDQW0KW3Ago=
X-Google-Smtp-Source: AK7set+evaFySCYbSrwieLb6flOyB5fBQlkRJ9eCz3NiKxnOc+WOsFmrkfzVrqv1kjmp1x00Glq8Uw==
X-Received: by 2002:a05:622a:1456:b0:3b9:c0e8:610c with SMTP id
 v22-20020a05622a145600b003b9c0e8610cmr4839450qtx.60.1676931648593; 
 Mon, 20 Feb 2023 14:20:48 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 b18-20020ac87fd2000000b003b80a69d353sm917343qtk.49.2023.02.20.14.20.47
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 20 Feb 2023 14:20:48 -0800 (PST)
Date: Mon, 20 Feb 2023 17:20:46 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <Y/PyPrY39QLTHtW4@redhat.com>
References: <Y/OueIbrfUBZRw5J@redhat.com>
MIME-Version: 1.0
In-Reply-To: <Y/OueIbrfUBZRw5J@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [git pull] device mapper changes for 6.3
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
Cc: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
 Sergey Shtylyov <s.shtylyov@omp.ru>, Pingfan Liu <piliu@redhat.com>,
 Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
 Heinz Mauelshagen <heinzm@redhat.com>,
 Thomas =?iso-8859-1?Q?Wei=DFschuh?= <linux@weissschuh.net>,
 Joe Thornber <ejt@redhat.com>, Nathan Huckleberry <nhuck@google.com>,
 linux-block@vger.kernel.org, Yu Zhe <yuzhe@nfschina.com>, dm-devel@redhat.com,
 XU pengfei <xupengfei@nfschina.com>,
 Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 Hou Tao <houtao1@huawei.com>, Mikulas Patocka <mpatocka@redhat.com>,
 Alasdair G Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Feb 20 2023 at 12:31P -0500,
Mike Snitzer <snitzer@kernel.org> wrote:

> Hi Linus,
> 
> The following changes since commit 4a6a7bc21d4726c5772e47525e6039852555b391:
> 
>   block: Default to use cgroup support for BFQ (2023-01-30 09:42:42 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.3/dm-changes
> 
> for you to fetch changes up to d695e44157c8da8d298295d1905428fb2495bc8b:
> 
>   dm: remove unnecessary (void*) conversion in event_callback() (2023-02-20 11:52:49 -0500)
> 
> Please pull, thanks.
> Mike

I should have mentioned: these DM changes are based on the "Block
updates for 6.3" from Jens.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

