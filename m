Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94E6BC19F28
	for <dm-devel@archiver.kernel.org>; Wed,  3 Aug 2022 17:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659547443;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0D4gWhX76c6RsoImOfiV3RjhmgWxBlc+2ckbwsLeCKI=;
	b=Iy+U1asXVrU7E4LCTAgQz0PqtEaWoR7wJZfJ+XSWK0s3adMpQpOmVprA9lZn66/GvjSlLy
	BdGwz5GlS6Kmg20syJ8qvBkc+RkWT5rNtslXwhQipbULpKLkW1TwUq+fJwCDxN7vB1cYxg
	FncbD3/qZDY5MUydoP6IDWk0hKndiFI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-261-mV82OCaQM9CilbV_OxIzGw-1; Wed, 03 Aug 2022 13:24:02 -0400
X-MC-Unique: mV82OCaQM9CilbV_OxIzGw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 00767101A54E;
	Wed,  3 Aug 2022 17:24:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E15721410F38;
	Wed,  3 Aug 2022 17:23:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 84A411946A5C;
	Wed,  3 Aug 2022 17:23:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D56771946A5C
 for <dm-devel@listman.corp.redhat.com>; Wed,  3 Aug 2022 17:23:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C3C80400DEF8; Wed,  3 Aug 2022 17:23:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C01FC400EA85
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 17:23:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A73A83C22886
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 17:23:57 +0000 (UTC)
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com
 [209.85.215.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-ThcBiMboPiurJkaru1tA0Q-1; Wed, 03 Aug 2022 13:23:48 -0400
X-MC-Unique: ThcBiMboPiurJkaru1tA0Q-1
Received: by mail-pg1-f170.google.com with SMTP id 12so15727768pga.1;
 Wed, 03 Aug 2022 10:23:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc;
 bh=0/8nr848GRaOG+Fxstqzc9TigPNxYkNf2h7q9hGBHq8=;
 b=d8jBds7vSpD6Kt2LIUPathAkvPN8fe0aeQqEdZIr4u7q4ZGFy+E0+EoI7eTRh9I+Ht
 55IIAzp6K8TxiQikZp0BMPkQgeNKaVqpFLDZMuPUCYGMG5fKni+xz8W7wCFdE678ttZI
 YxBhoQN6BCn4lf3vJFPwPZv85ArjJ7yiZAHAzpf8mk9jC2EYI+YazOTUX3KJkKEglmAn
 +tuu5Cqyy/fO1fVKH5yPwPUz6Nnv2f/GqQj0Zj/yvCEHtIkdYsy1TVXr60jIIidVZU7t
 DeUDAPaysPoP6oC8w0eDylpDV7cH9yxpqsqDZO4nZ8GOp5o7prGDn1TyywelTAe3L0pJ
 zccQ==
X-Gm-Message-State: AJIora/eSYu4xl4UwxTScHaJ9T+Cor8aY0d3b42pss6NiGB0ZB5/6kA/
 LhE2Ot71Frmzcpnq1x2gGdo=
X-Google-Smtp-Source: AGRyM1vgZohnjas8fupQWk0TGJ1ujqQbQ0c9VjCzhrzKOA3JUzR8cBuYkbzDzRvd/ngCVEXerrSzcQ==
X-Received: by 2002:a63:4f52:0:b0:41a:3744:d952 with SMTP id
 p18-20020a634f52000000b0041a3744d952mr21509471pgl.186.1659547427197; 
 Wed, 03 Aug 2022 10:23:47 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:db71:edb7:462a:44af?
 ([2620:15c:211:201:db71:edb7:462a:44af])
 by smtp.gmail.com with ESMTPSA id
 c25-20020aa79539000000b0052dfe83e19csm3180967pfp.16.2022.08.03.10.23.44
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 03 Aug 2022 10:23:46 -0700 (PDT)
Message-ID: <4b6f14a1-2a96-da20-d56c-032a87dee7d2@acm.org>
Date: Wed, 3 Aug 2022 10:23:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Pankaj Raghav <p.raghav@samsung.com>, Johannes.Thumshirn@wdc.com,
 snitzer@kernel.org, axboe@kernel.dk, damien.lemoal@opensource.wdc.com,
 agk@redhat.com, hch@lst.de
References: <20220803094801.177490-1-p.raghav@samsung.com>
 <CGME20220803094812eucas1p271cea804453d9dd379b919067fe5b154@eucas1p2.samsung.com>
 <20220803094801.177490-10-p.raghav@samsung.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220803094801.177490-10-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v9 09/13] dm-zone: use generic helpers to
 calculate offset from zone start
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
Cc: pankydev8@gmail.com, gost.dev@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, jaegeuk@kernel.org, matias.bjorling@wdc.com,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 8/3/22 02:47, Pankaj Raghav wrote:
> -		if ((clone->bi_iter.bi_sector & (zsectors - 1)) != zwp_offset)
> +		if ((bdev_offset_from_zone_start(md->disk->part0,
> +						 clone->bi_iter.bi_sector)) != zwp_offset)

If this patch series needs to be reposted, please leave out the 
superfluous parentheses from the above statement.

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

