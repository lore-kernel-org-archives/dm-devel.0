Return-Path: <SRS0=zjfM=LD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8CFDC47095
	for <dm-devel@archiver.kernel.org>; Wed,  9 Jun 2021 09:33:35 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 60DEC6128A
	for <dm-devel@archiver.kernel.org>; Wed,  9 Jun 2021 09:33:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 60DEC6128A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-vYXTLHmOOeOrv3xuTwLFpg-1; Wed, 09 Jun 2021 05:33:33 -0400
X-MC-Unique: vYXTLHmOOeOrv3xuTwLFpg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E990910C1ADC;
	Wed,  9 Jun 2021 09:33:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D7DA45B826;
	Wed,  9 Jun 2021 09:33:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D92114A717;
	Wed,  9 Jun 2021 09:33:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1599XLoX029619 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 9 Jun 2021 05:33:21 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 5CA09112D402; Wed,  9 Jun 2021 09:33:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5598E112D19E
	for <dm-devel@redhat.com>; Wed,  9 Jun 2021 09:33:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 165BA919824
	for <dm-devel@redhat.com>; Wed,  9 Jun 2021 09:33:18 +0000 (UTC)
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com
	[209.85.166.182]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-304-djMkeODwORag7E5-ObkZ_Q-1; Wed, 09 Jun 2021 05:33:16 -0400
X-MC-Unique: djMkeODwORag7E5-ObkZ_Q-1
Received: by mail-il1-f182.google.com with SMTP id b14so24269226ilq.7;
	Wed, 09 Jun 2021 02:33:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=mhMcjERsi3wx3J0HCHYpS+goiMXBDBgg8cMNxlYjvGA=;
	b=t5yURxLG9oB9BeMbOrZwY91HkzDLrcfEb0suWZ/k1bSPElDfqq8q75JucYXUdx1JwC
	sPmIS1xanhpHkH0auGMP2+gG7+zYcW99k6n+VXKOcEEMLtceujAzolS2ErAPJ3rFpvQ4
	Ym5Dicl0ZxqfCoWLL+/2Sr9tJN3bSbYTkY0UygaGz8qPIa9dn3Xs86+0e0Si6zWemR2A
	IK25KQNat+smJFRX/A+gObtzqSrtLjDsKsILPChdxj3GfPCg9u9Oq2IiyBNPgqEVV3Z4
	d35k8XIlvOFaSRiS/cZoh5F/ZcvSKgk1bqDxcA1F2Ja9d8kmY+01Ws3OrgpmMya24flj
	Op0w==
X-Gm-Message-State: AOAM531zmiopIEr7DbTvpos+mM+dp965sKxxV1/djFTKga8dXcReXkn5
	RTdRJ9HVZRD9880vJ/F62kRm3ufNBeQlKlXm1wuzNqJp22Y/eA==
X-Google-Smtp-Source: ABdhPJwAXk5XLhiYZ2SCv5KKecZJLPTCdFzz10ao0FJv/DCA2fGlPOpnYQTjWTA/Q177jVl11ZJJ3bM2RHXJ7omJZKU=
X-Received: by 2002:a6b:287:: with SMTP id 129mr18520979ioc.182.1623231195095; 
	Wed, 09 Jun 2021 02:33:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210608160603.1535935-1-hch@lst.de>
	<20210608160603.1535935-5-hch@lst.de>
In-Reply-To: <20210608160603.1535935-5-hch@lst.de>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Wed, 9 Jun 2021 11:33:13 +0200
Message-ID: <CAOi1vP8Xe1ZqE8fe=8KcU00xDjRrvaRONAC_TYYctsE1dns0Og@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Mike Snitzer <snitzer@redhat.com>, Geoff Levand <geoff@infradead.org>,
	linuxppc-dev@lists.ozlabs.org, linux-mips@vger.kernel.org,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-block <linux-block@vger.kernel.org>, dm-devel@redhat.com,
	Ceph Development <ceph-devel@vger.kernel.org>,
	Ira Weiny <ira.weiny@intel.com>
Subject: Re: [dm-devel] [PATCH 04/16] bvec: add a bvec_kmap_local helper
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jun 8, 2021 at 6:06 PM Christoph Hellwig <hch@lst.de> wrote:
>
> Add a helper to call kmap_local_page on a bvec.  There is no need for
> an unmap helper given that kunmap_local accept any address in the mapped
> page.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/linux/bvec.h | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/include/linux/bvec.h b/include/linux/bvec.h
> index 883faf5f1523..d64d6c0ceb77 100644
> --- a/include/linux/bvec.h
> +++ b/include/linux/bvec.h
> @@ -7,6 +7,7 @@
>  #ifndef __LINUX_BVEC_H
>  #define __LINUX_BVEC_H
>
> +#include <linux/highmem.h>
>  #include <linux/bug.h>
>  #include <linux/errno.h>
>  #include <linux/limits.h>
> @@ -183,4 +184,9 @@ static inline void bvec_advance(const struct bio_vec *bvec,
>         }
>  }
>
> +static inline void *bvec_kmap_local(struct bio_vec *bvec)
> +{
> +       return kmap_local_page(bvec->bv_page) + bvec->bv_offset;
> +}
> +
>  #endif /* __LINUX_BVEC_H */

Might be useful to add the second sentence of the commit message as
a comment for bvec_kmap_local().  It could be expanded to mention the
single-page bvec caveat too.

Thanks,

                Ilya

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

