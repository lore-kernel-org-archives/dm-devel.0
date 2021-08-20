Return-Path: <SRS0=PruR=NO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DD37C4338F
	for <dm-devel@archiver.kernel.org>; Mon, 23 Aug 2021 06:40:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2F0156127B
	for <dm-devel@archiver.kernel.org>; Mon, 23 Aug 2021 06:40:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2F0156127B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-kC17T5fKN7yjNoEi0idARg-1; Mon, 23 Aug 2021 02:40:33 -0400
X-MC-Unique: kC17T5fKN7yjNoEi0idARg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 17E3D1082933;
	Mon, 23 Aug 2021 06:40:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EA74F6A905;
	Mon, 23 Aug 2021 06:40:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BC28E4A700;
	Mon, 23 Aug 2021 06:40:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17KBBoN6002988 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 20 Aug 2021 07:11:50 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 382F120B6640; Fri, 20 Aug 2021 11:11:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 33C4A20B6637
	for <dm-devel@redhat.com>; Fri, 20 Aug 2021 11:11:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AC0D58011AF
	for <dm-devel@redhat.com>; Fri, 20 Aug 2021 11:11:46 +0000 (UTC)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com
	[209.85.221.47]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-589-UNcef0NdNC2JZaTojpXMYQ-1; Fri, 20 Aug 2021 07:11:42 -0400
X-MC-Unique: UNcef0NdNC2JZaTojpXMYQ-1
Received: by mail-wr1-f47.google.com with SMTP id q11so13703426wrr.9;
	Fri, 20 Aug 2021 04:11:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=XTV41ORucx8ryF7oB1eYwysBWiCN8gKMFeTRn1Zj7AM=;
	b=ce6c4qd/KSu2gOp2pP4LCa38DdxT4jZrQa7NnNPjDvYYA2oOQX4JfcwyxwkhWCvn8U
	LE9v0WqZ/7yqxj1zGDyj8Mgr71ssCKfoCAM5zcOrSezPgmBekkEZpnhi3rcLnfI+Xc0z
	9RsvyG2zjsexxgmutIDH7X7k7ep/moEHb+wZqvlq7Lw5zZrgznzWs94DnDAIvAg0m5YE
	YbXL4g3ReF+7AUdmmARKoRMVGzBdGFNvYBYZsIC9bOGqmFQmGI0EI2pAJ63XFgwrhi+F
	EXRauPCNAjzCotv8YsoCYtfAYD+pBNybPjwtr0MxdBLSOFi5cPip+AxHUTYe8iivXqGX
	V5Vg==
X-Gm-Message-State: AOAM533FHaoDANtMst9lB3o+hXF1Jck7VYFbzn+jT/2NM4rfqFFAMyj8
	bJXBeOsw/gTKKXQ/+tUc9HK93g3CJz0xjh3DjDc=
X-Google-Smtp-Source: ABdhPJyHLBn4cAqZhoblha8bwzOCJdvxUWt4EpC0AJmYcZ2sxKZSuvBjXl3YiZg/qrMlyWLl4b6/2Ts3GXLe812W024=
X-Received: by 2002:a5d:6991:: with SMTP id g17mr9619476wru.253.1629457901314; 
	Fri, 20 Aug 2021 04:11:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210817101423.12367-1-selvakuma.s1@samsung.com>
	<CGME20210817101758epcas5p1ec353b3838d64654e69488229256d9eb@epcas5p1.samsung.com>
	<20210817101423.12367-4-selvakuma.s1@samsung.com>
	<yq1sfz6loh9.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1sfz6loh9.fsf@ca-mkp.ca.oracle.com>
From: Kanchan Joshi <joshiiitr@gmail.com>
Date: Fri, 20 Aug 2021 16:41:15 +0530
Message-ID: <CA+1E3rKmS6LSPDb9C8S7Ap-b40TB9dfogC-PYm7ehLeBTn+Ukw@mail.gmail.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 23 Aug 2021 02:39:55 -0400
Cc: snitzer@redhat.com, djwong@kernel.org, linux-nvme@lists.infradead.org,
	dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>,
	agk@redhat.com, bvanassche@acm.org, linux-scsi@vger.kernel.org,
	nitheshshetty@gmail.com, Matthew Wilcox <willy@infradead.org>,
	Nitesh Shetty <nj.shetty@samsung.com>, kch@kernel.org,
	SelvaKumar S <selvakuma.s1@samsung.com>,
	Selva Jove <selvajove@gmail.com>, linux-block@vger.kernel.org,
	mpatocka@redhat.com, Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Damien Le Moal <damien.lemoal@wdc.com>,
	KANCHAN JOSHI <joshi.k@samsung.com>, linux-api@vger.kernel.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-fsdevel@vger.kernel.org, Javier Gonzalez <javier.gonz@samsung.com>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [dm-devel] [PATCH 3/7] block: copy offload support
	infrastructure
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Aug 19, 2021 at 12:05 AM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> > Native copy offload is not supported for stacked devices.
>
> One of the main reasons that the historic attempts at supporting copy
> offload did not get merged was that the ubiquitous deployment scenario,
> stacked block devices, was not handled well.
>
> Pitfalls surrounding stacking has been brought up several times in
> response to your series. It is critically important that both kernel
> plumbing and user-facing interfaces are defined in a way that works for
> the most common use cases. This includes copying between block devices
> and handling block device stacking. Stacking being one of the most
> fundamental operating principles of the Linux block layer!
>
> Proposing a brand new interface that out of the gate is incompatible
> with both stacking and the copy offload capability widely implemented in
> shipping hardware makes little sense. While NVMe currently only supports
> copy operations inside a single namespace, it is surely only a matter of
> time before that restriction is lifted.
>
> Changing existing interfaces is painful, especially when these are
> exposed to userland. We obviously can't predict every field or feature
> that may be needed in the future. But we should at the very least build
> the infrastructure around what already exists. And that's where the
> proposed design falls short...
>
Certainly, on user-space interface. We've got few cracks to be filled
there, missing the future viability.
But on stacking, can that be additive. Could you please take a look at
the other response (comment from Bart) for the trade-offs.


-- 
Joshi

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

