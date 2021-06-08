Return-Path: <SRS0=BzfN=LC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDA31C47082
	for <dm-devel@archiver.kernel.org>; Tue,  8 Jun 2021 16:25:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 57B9561249
	for <dm-devel@archiver.kernel.org>; Tue,  8 Jun 2021 16:25:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 57B9561249
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=acm.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-548-cx7vAWynP6yZwIgFlIsODw-1; Tue, 08 Jun 2021 12:25:02 -0400
X-MC-Unique: cx7vAWynP6yZwIgFlIsODw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DFB611034B21;
	Tue,  8 Jun 2021 16:24:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6628E5D6A1;
	Tue,  8 Jun 2021 16:24:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D728C18095C4;
	Tue,  8 Jun 2021 16:24:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 158GNhH4020327 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 8 Jun 2021 12:23:44 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D819B21EC5D8; Tue,  8 Jun 2021 16:23:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D3AB621EC5D5
	for <dm-devel@redhat.com>; Tue,  8 Jun 2021 16:23:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2CDC780D0E4
	for <dm-devel@redhat.com>; Tue,  8 Jun 2021 16:23:41 +0000 (UTC)
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com
	[209.85.215.171]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-377-i-NtMHghPhqxdowkGXVhRA-1; Tue, 08 Jun 2021 12:23:37 -0400
X-MC-Unique: i-NtMHghPhqxdowkGXVhRA-1
Received: by mail-pg1-f171.google.com with SMTP id e22so16902324pgv.10;
	Tue, 08 Jun 2021 09:23:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=qCqEbRr/ZPdmz8AchOJtyzKCBs+O43d8wPQ5fZZFjhk=;
	b=SORjg/VSw72iX+e/3wsYm1wiQe7GZ/2dJkA93hBu8qcYNIJY/oKfs4OpfmG7x+96HR
	ZvrN0/60Pb7qswEmskou4ROQ/FmQgMrwcAwm3YVPZzUx3UG+92u2w5626mnNYxWqiCCh
	pew/ivGn5FxyveLdFcMiyFCfrUNX/2op+vTzhZ3y576119/qgT/LEn09D1huFBmO2k1M
	yYqqToBdmbLMHy7HxQKh2py8SUfTq1UBONLyLltxgdoPnl8sa3q5j1T6lTeCDY5TqAaF
	avAfzZcS249IWxSIyT6H7Bs7kLi4+9C4h/Vaw4l+kpW9htw9o5q9G9PgteliOJcj/WYd
	poOw==
X-Gm-Message-State: AOAM533CnFycD1hhjUBFRZpiS3L4P6Yz0X7+9D5CxrxGxsGSQN39nEk7
	2vaAEx1to1it6aV4loyOcB+3o1qWBH0=
X-Google-Smtp-Source: ABdhPJw4bmfvWGcz16m0nccIT5A1wyVoaTqb2ljpnWRWjedCwkO8zIDp8El5QdjOUdkYia3UO1TSlw==
X-Received: by 2002:a65:5684:: with SMTP id v4mr22680238pgs.218.1623169415549; 
	Tue, 08 Jun 2021 09:23:35 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net.
	[73.241.217.19]) by smtp.gmail.com with ESMTPSA id
	p40sm4440358pfw.142.2021.06.08.09.23.33
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Tue, 08 Jun 2021 09:23:34 -0700 (PDT)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20210608160603.1535935-1-hch@lst.de>
	<20210608160603.1535935-3-hch@lst.de>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <9a073f63-65f6-6f3d-600d-e3900707fd06@acm.org>
Date: Tue, 8 Jun 2021 09:23:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210608160603.1535935-3-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Mike Snitzer <snitzer@redhat.com>, Geoff Levand <geoff@infradead.org>,
	linuxppc-dev@lists.ozlabs.org, linux-mips@vger.kernel.org,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Ilya Dryomov <idryomov@gmail.com>,
	Ira Weiny <ira.weiny@intel.com>, ceph-devel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 02/16] MIPS: don't include <linux/genhd.h> in
 <asm/mach-rc32434/rb.h>
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 6/8/21 9:05 AM, Christoph Hellwig wrote:
> There is no need to include genhd.h from a random arch header, and not
> doing so prevents the possibility for nasty include loops.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  arch/mips/include/asm/mach-rc32434/rb.h | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/mips/include/asm/mach-rc32434/rb.h b/arch/mips/include/asm/mach-rc32434/rb.h
> index d502673a4f6c..34d179ca020b 100644
> --- a/arch/mips/include/asm/mach-rc32434/rb.h
> +++ b/arch/mips/include/asm/mach-rc32434/rb.h
> @@ -7,8 +7,6 @@
>  #ifndef __ASM_RC32434_RB_H
>  #define __ASM_RC32434_RB_H
>  
> -#include <linux/genhd.h>
> -
>  #define REGBASE		0x18000000
>  #define IDT434_REG_BASE ((volatile void *) KSEG1ADDR(REGBASE))
>  #define UART0BASE	0x58000

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

