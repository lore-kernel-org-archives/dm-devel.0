Return-Path: <SRS0=PruR=NO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B28BC4338F
	for <dm-devel@archiver.kernel.org>; Mon, 23 Aug 2021 06:42:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BB3DA6103D
	for <dm-devel@archiver.kernel.org>; Mon, 23 Aug 2021 06:42:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BB3DA6103D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-0H3RjrtLNUG5j6eYKJY0_Q-1; Mon, 23 Aug 2021 02:40:34 -0400
X-MC-Unique: 0H3RjrtLNUG5j6eYKJY0_Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1F1401008072;
	Mon, 23 Aug 2021 06:40:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 02B512CD33;
	Mon, 23 Aug 2021 06:40:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C8F02181A1D3;
	Mon, 23 Aug 2021 06:40:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17KAdl8J000929 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 20 Aug 2021 06:39:47 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 343C910BFD7D; Fri, 20 Aug 2021 10:39:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2FC8210BFD7E
	for <dm-devel@redhat.com>; Fri, 20 Aug 2021 10:39:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 12026800883
	for <dm-devel@redhat.com>; Fri, 20 Aug 2021 10:39:44 +0000 (UTC)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com
	[209.85.128.48]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-347-YZIHmzT4PJWN-Sma6aaMGA-1; Fri, 20 Aug 2021 06:39:42 -0400
X-MC-Unique: YZIHmzT4PJWN-Sma6aaMGA-1
Received: by mail-wm1-f48.google.com with SMTP id
	v20-20020a1cf714000000b002e71f4d2026so1107816wmh.1; 
	Fri, 20 Aug 2021 03:39:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=2l4f87jQ5BCVnW/LtVQs/ujfdv1Edqo9vK1XTZNmj64=;
	b=C3LtH4HBLBPv97DcuGGHaVxGJekUE31DDZTSfHV79ZZuLgVauJHAfAj8yufFhex9UI
	XTDLt0iMoQnLkj2fCbPJ48WFnSD7EjV3RBYQubGzBhkVSQcGmCu/TD0CQNaas0FpUaLQ
	o+8UfcMYuy18+pxv3IArYzw3VrcglY+0K3tO2S7eDkJesfkl279ldZUCR0txgum4M7Iz
	jegLNRwSDlNP0dbUzDQqx9Arg63G9S/405ExyBx++LoaihYaQShfeNuwr3ivA9/GLoSY
	btwhd8K+6XeAisFuZhG0uzxfsNFjEYBNNkwnLbtD0nK/JeeYC23Eze84Pd9Xti7UfeJr
	5Fig==
X-Gm-Message-State: AOAM533bfZGrJU8VpwhjXfmTCTFHQIYveTmSQWBxrLADce3SFRSCs7KF
	L9kcxd6jH+9L3/GUviZbFuyfXTZoqvDvCZA/Ros=
X-Google-Smtp-Source: ABdhPJwvvbvC7oT0EDMBScqPKbmq4ABDQwLkxNDJHv+ZwVgPws6KmaaRL0F7/tnmz8XSY+QaosFzbLsSI9/h7hXg+gc=
X-Received: by 2002:a05:600c:1c08:: with SMTP id
	j8mr3147766wms.138.1629455980524; 
	Fri, 20 Aug 2021 03:39:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210817101423.12367-1-selvakuma.s1@samsung.com>
	<CGME20210817101758epcas5p1ec353b3838d64654e69488229256d9eb@epcas5p1.samsung.com>
	<20210817101423.12367-4-selvakuma.s1@samsung.com>
	<ad3561b9-775d-dd4d-0d92-6343440b1f8f@acm.org>
In-Reply-To: <ad3561b9-775d-dd4d-0d92-6343440b1f8f@acm.org>
From: Kanchan Joshi <joshiiitr@gmail.com>
Date: Fri, 20 Aug 2021 16:09:14 +0530
Message-ID: <CA+1E3rK2ULVajQRkNTZJdwKoqBeGvkfoVYNF=WyK6Net85YkhA@mail.gmail.com>
To: Bart Van Assche <bvanassche@acm.org>
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
X-Mailman-Approved-At: Mon, 23 Aug 2021 02:39:55 -0400
Cc: Mike Snitzer <snitzer@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	djwong@kernel.org, linux-nvme@lists.infradead.org,
	dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>,
	agk@redhat.com, linux-scsi@vger.kernel.org,
	nitheshshetty@gmail.com, Matthew Wilcox <willy@infradead.org>,
	Nitesh Shetty <nj.shetty@samsung.com>, kch@kernel.org,
	SelvaKumar S <selvakuma.s1@samsung.com>,
	Selva Jove <selvajove@gmail.com>, linux-block@vger.kernel.org,
	mpatocka@redhat.com, Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Damien Le Moal <damien.lemoal@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Bart, Mikulas

On Tue, Aug 17, 2021 at 10:44 PM Bart Van Assche <bvanassche@acm.org> wrote:
>
> On 8/17/21 3:14 AM, SelvaKumar S wrote:
> > Introduce REQ_OP_COPY, a no-merge copy offload operation. Create
> > bio with control information as payload and submit to the device.
> > Larger copy operation may be divided if necessary by looking at device
> > limits. REQ_OP_COPY(19) is a write op and takes zone_write_lock when
> > submitted to zoned device.
> > Native copy offload is not supported for stacked devices.
>
> Using a single operation for copy-offloading instead of separate
> operations for reading and writing is fundamentally incompatible with
> the device mapper. I think we need a copy-offloading implementation that
> is compatible with the device mapper.
>

While each read/write command is for a single contiguous range of
device, with simple-copy we get to operate on multiple discontiguous
ranges, with a single command.
That seemed like a good opportunity to reduce control-plane traffic
(compared to read/write operations) as well.

With a separate read-and-write bio approach, each source-range will
spawn at least one read, one write and eventually one SCC command. And
it only gets worse as there could be many such discontiguous ranges (for
GC use-case at least) coming from user-space in a single payload.
Overall sequence will be
- Receive a payload from user-space
- Disassemble into many read-write pair bios at block-layer
- Assemble those (somehow) in NVMe to reduce simple-copy commands
- Send commands to device

We thought payload could be a good way to reduce the
disassembly/assembly work and traffic between block-layer to nvme.
How do you see this tradeoff?  What seems necessary for device-mapper
usecase, appears to be a cost when device-mapper isn't used.
Especially for SCC (since copy is within single ns), device-mappers
may not be too compelling anyway.

Must device-mapper support be a requirement for the initial support atop SCC?
Or do you think it will still be a progress if we finalize the
user-space interface to cover all that is foreseeable.And for
device-mapper compatible transport between block-layer and NVMe - we
do it in the later stage when NVMe too comes up with better copy
capabilities?


-- 
Joshi

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

