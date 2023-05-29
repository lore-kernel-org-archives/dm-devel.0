Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE6F9C7EE2F
	for <dm-devel@archiver.kernel.org>; Tue, 30 May 2023 20:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685480089;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=QkijMHinjcs4Ijp8UEMjLJnuEfUx7wyW60FCsQp4yG4=;
	b=GOA9cdTXUmcR4wZvCEB07/Hcmgz/zBE7hJmOB4jLaq33txo3K6AtyOrKHWk5Ce6o6+GWxj
	13RCJj+gM4UbOxh7kCHx/stI2gQbqogvqBBAwG/ibUda20DXkvgn6cXhOy0kKhB1GIEnq1
	UJdMZCBHkiiCE63bk50HvqHLF5rKUxo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-122-Ow_S88eNO-mO28e3xHw6oQ-1; Tue, 30 May 2023 16:54:48 -0400
X-MC-Unique: Ow_S88eNO-mO28e3xHw6oQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DABC33C11C78;
	Tue, 30 May 2023 20:54:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C25D8400DFF;
	Tue, 30 May 2023 20:54:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4F58B194F26E;
	Tue, 30 May 2023 20:54:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D2868194658C
 for <dm-devel@listman.corp.redhat.com>; Mon, 29 May 2023 16:36:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B6308420A8; Mon, 29 May 2023 16:36:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AE24335443
 for <dm-devel@redhat.com>; Mon, 29 May 2023 16:36:28 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9243F3806729
 for <dm-devel@redhat.com>; Mon, 29 May 2023 16:36:28 +0000 (UTC)
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com
 [209.85.128.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-450-kZ9EtWj8OjmprUgd_6dOkQ-1; Mon, 29 May 2023 12:36:25 -0400
X-MC-Unique: kZ9EtWj8OjmprUgd_6dOkQ-1
Received: by mail-yw1-f169.google.com with SMTP id
 00721157ae682-565e6beb7aaso26298947b3.2; 
 Mon, 29 May 2023 09:36:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685378184; x=1687970184;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=XGlmlfpGRhYW8HjfyI5EG9tKXwTbZGzHl2Gw/X6ax14=;
 b=VdKP/FkQWFCCQibrw9MI1VTsxbXXkbS/fix7YUNWTOl37Mkw45pT+mz+CgPMsRDObx
 pswAS01cReTDpu34RH3X9XjGZE/vCxBmY23m6AHERB4rm5BVWsLoqS1oT+jtIi5gOjjn
 p3AHm45kBn2FMCq7SyT+X+pnsSiBcfi94Mm8xHzXxSFnp1BeFXrarfMZ+tV+EQsQNoCM
 wdvxKJfVsLa0D1VlpeMBsYhREwSHJYTuUHD59Ih/oAvs6PcHN5GK0Tk9X5OPutJaYiGM
 5NLFmG3iYLkztN0i9LkHCcASlMd/GkkToqY3+xgIjCnjg5N5B0sx1szYNdE83lJltA8M
 o/tA==
X-Gm-Message-State: AC+VfDwwKl1xlreAShU/KfP+IPy1unxI6f6jNXLFRa1h45uvqAqoXmfD
 HaCpZ+iVedFbbXrfMS7AUCiFC5LjF/DLm52bIHejBfRCZCAL91bY
X-Google-Smtp-Source: ACHHUZ7InCRLGF330bSJ+LMuRh4g/NfzTfd2m8OEywQty5+b+eU+JLZRKLHh0ktsR3qbMPwu4QSHwqAz7Ha/ifAXWSw=
X-Received: by 2002:a0d:d88b:0:b0:565:bb04:53fa with SMTP id
 a133-20020a0dd88b000000b00565bb0453famr11663162ywe.10.1685378184319; Mon, 29
 May 2023 09:36:24 -0700 (PDT)
MIME-Version: 1.0
References: <20230522104146.2856-1-nj.shetty@samsung.com>
 <CGME20230522104536epcas5p23dd8108dd267ec588e5c36e8f9eb9fe8@epcas5p2.samsung.com>
 <20230522104146.2856-3-nj.shetty@samsung.com>
 <20230524154049.GD11607@frogsfrogsfrogs>
In-Reply-To: <20230524154049.GD11607@frogsfrogsfrogs>
From: Nitesh Shetty <nitheshshetty@gmail.com>
Date: Mon, 29 May 2023 22:06:13 +0530
Message-ID: <CAOSviJ2-=U+Y2vFOq6=8n=uHqXgoud3=7gaH7H7sw2jiPXtNPA@mail.gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Tue, 30 May 2023 20:54:23 +0000
Subject: Re: [dm-devel] [PATCH v11 2/9] block: Add copy offload support
 infrastructure
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
Cc: linux-nvme@lists.infradead.org, James.Bottomley@hansenpartnership.com,
 linux-mm@kvack.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>,
 Alasdair Kergon <agk@redhat.com>, Sagi Grimberg <sagi@grimberg.me>,
 linux-scsi@vger.kernel.org, gost.dev@samsung.com,
 James Smart <james.smart@broadcom.com>,
 "Matthew Wilcox \(Oracle\)" <willy@infradead.org>,
 Nitesh Shetty <nj.shetty@samsung.com>, Chaitanya Kulkarni <kch@nvidia.com>,
 anuj20.g@samsung.com, Mike Snitzer <snitzer@kernel.org>, ming.lei@redhat.com,
 linux-block@vger.kernel.org, dlemoal@kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>, Keith Busch <kbusch@kernel.org>,
 bvanassche@acm.org, Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <brauner@kernel.org>, joshi.k@samsung.com,
 martin.petersen@oracle.com, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> > +/*
> > + * @bdev_in: source block device
> > + * @pos_in:  source offset
> > + * @bdev_out:        destination block device
> > + * @pos_out: destination offset
> > + * @len:     length in bytes to be copied
> > + * @endio:   endio function to be called on completion of copy operation,
> > + *           for synchronous operation this should be NULL
> > + * @private: endio function will be called with this private data, should be
> > + *           NULL, if operation is synchronous in nature
> > + * @gfp_mask:   memory allocation flags (for bio_alloc)
> > + *
> > + * Returns the length of bytes copied or error if encountered
> > + *
> > + * Description:
> > + *   Copy source offset from source block device to destination block
> > + *   device. Max total length of copy is limited to MAX_COPY_TOTAL_LENGTH
> > + */
> > +int blkdev_issue_copy(struct block_device *bdev_in, loff_t pos_in,
>
> I'd have thought you'd return ssize_t here.  If the two block devices
> are loopmounted xfs files, we can certainly reflink "copy" more than 2GB
> at a time.
>
> --D
>

Sure we will add this to make API future proof, but at present we do have
a limit for copy. COPY_MAX_BYTES(=128MB) at present. This limit is based
on our internal testing, we have plans to increase/remove with this
limit in future phases.

Thank you,
Nitesh Shetty

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

