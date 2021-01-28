Return-Path: <SRS0=tECb=HA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1367AC433DB
	for <dm-devel@archiver.kernel.org>; Fri, 29 Jan 2021 09:37:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3996D64E25
	for <dm-devel@archiver.kernel.org>; Fri, 29 Jan 2021 09:37:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3996D64E25
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-0rt_SqdmNleX0Xq-0Rh7Bw-1; Fri, 29 Jan 2021 04:37:02 -0500
X-MC-Unique: 0rt_SqdmNleX0Xq-0Rh7Bw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE15C18C8C04;
	Fri, 29 Jan 2021 09:36:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 620925D740;
	Fri, 29 Jan 2021 09:36:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 958AD1809C9F;
	Fri, 29 Jan 2021 09:36:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10SALvh2026379 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 28 Jan 2021 05:21:57 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B7D2B101B560; Thu, 28 Jan 2021 10:21:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B3BB1101F0A3
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 10:21:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 52D6E858281
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 10:21:54 +0000 (UTC)
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com
	[209.85.210.51]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-285-LZki4iDRMeGYbNZmasfDCg-1; Thu, 28 Jan 2021 05:21:50 -0500
X-MC-Unique: LZki4iDRMeGYbNZmasfDCg-1
Received: by mail-ot1-f51.google.com with SMTP id i20so4676794otl.7;
	Thu, 28 Jan 2021 02:21:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=HDfQ7EgSz4He6IVrUzqy89nGy356H19n/4Ap6Knawyw=;
	b=K3pQiqrppdagBIeDmhVOMeCc2Dfb07jFgDlUI6okog80VOuYGeSbb9mvmLub1gPv7T
	OY96ih1DBa3IBn2mbKP6qV4pm/rArT5QKbtJFVh39mR02bxtRKZdP2p7mjTjO556wm6m
	ltF+BeUoydzT/ai4uMj3loSZuEBLGe4ocDdLNAfKdpFZ+BMZaDMlLCAT0bznxs5HMqbj
	SkvRmJNmJegDhRfxuKaHkrUiEaExqwxMwfd6sgduamv5ZCe5Mdxmd5pbIIdKZcDM9BCr
	OckSNMfDjdb6mVLGPHvCI4MyaoqnI0T0RbIKFDJvJphtQ8q+ROws7GnSvGW6AFwlw1lC
	dbFg==
X-Gm-Message-State: AOAM531R20EOHeTJgaSYykOqqKQVrs0M4E8m7Zl3zjnlu2WiGodqjZSS
	ECnbofplNhKX27Idh3LoFZJebGWY/r4I87SDUmM=
X-Google-Smtp-Source: ABdhPJwJviHVEMHN6dwg9pHl9sFzPeOTWi/Tyw7MUMRzUkqGbWVHXybuLc31QSYFbmu849bxozre+7WWIBRJddZRpNc=
X-Received: by 2002:a05:6830:2313:: with SMTP id
	u19mr11117098ote.321.1611829309173; 
	Thu, 28 Jan 2021 02:21:49 -0800 (PST)
MIME-Version: 1.0
References: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
	<20210128071133.60335-30-chaitanya.kulkarni@wdc.com>
In-Reply-To: <20210128071133.60335-30-chaitanya.kulkarni@wdc.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Thu, 28 Jan 2021 11:21:36 +0100
Message-ID: <CAJZ5v0h01e4LgV0c5FxLorcc6iFW2LVzC=hJcd7LNAJ6D0E8jg@mail.gmail.com>
To: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
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
X-Mailman-Approved-At: Fri, 29 Jan 2021 04:33:25 -0500
Cc: shaggy@kernel.org, jfs-discussion@lists.sourceforge.net,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Mike Snitzer <snitzer@redhat.com>, Takashi Iwai <tiwai@suse.de>,
	djwong@kernel.org, linux-nvme <linux-nvme@lists.infradead.org>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	dm-devel@redhat.com, target-devel@vger.kernel.org,
	Pavel Machek <pavel@ucw.cz>, Alex Shi <alex.shi@linux.alibaba.com>,
	Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>,
	naohiro.aota@wdc.com, linux-nilfs@vger.kernel.org,
	Sagi Grimberg <sagi@grimberg.me>,
	"open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>,
	Mark Fasheh <mark@fasheh.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, osandov@fb.com,
	Eric Biggers <ebiggers@kernel.org>,
	xen-devel@lists.xenproject.org, ngupta@vflare.org,
	Len Brown <len.brown@intel.com>, Linux PM <linux-pm@vger.kernel.org>,
	Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
	Tejun Heo <tj@kernel.org>, linux-fscrypt@vger.kernel.org,
	Al Viro <viro@zeniv.linux.org.uk>, drbd-dev@tron.linbit.com,
	jaegeuk@kernel.org, Joel Becker <jlbec@evilplan.org>,
	konishi.ryusuke@gmail.com, Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>, damien.lemoal@wdc.com,
	Ted Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-xfs@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
	jefflexu@linux.alibaba.com, linux-fsdevel@vger.kernel.org,
	Lars Ellenberg <lars.ellenberg@linbit.com>, jth@kernel.org,
	asml.silence@gmail.com, ocfs2-devel@oss.oracle.com, roger.pau@citrix.com
Subject: Re: [dm-devel] [RFC PATCH 29/34] power/swap: use bio_new in
	hib_submit_io
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On Thu, Jan 28, 2021 at 8:21 AM Chaitanya Kulkarni
<chaitanya.kulkarni@wdc.com> wrote:
>

Please explain in the changelog why making this change is a good idea.

> Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> ---
>  kernel/power/swap.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/power/swap.c b/kernel/power/swap.c
> index c73f2e295167..e92e36c053a6 100644
> --- a/kernel/power/swap.c
> +++ b/kernel/power/swap.c
> @@ -271,13 +271,12 @@ static int hib_submit_io(int op, int op_flags, pgoff_t page_off, void *addr,
>                 struct hib_bio_batch *hb)
>  {
>         struct page *page = virt_to_page(addr);
> +       sector_t sect = page_off * (PAGE_SIZE >> 9);
>         struct bio *bio;
>         int error = 0;
>
> -       bio = bio_alloc(GFP_NOIO | __GFP_HIGH, 1);
> -       bio->bi_iter.bi_sector = page_off * (PAGE_SIZE >> 9);
> -       bio_set_dev(bio, hib_resume_bdev);
> -       bio_set_op_attrs(bio, op, op_flags);
> +       bio = bio_new(hib_resume_bdev, sect, op, op_flags, 1,
> +                     GFP_NOIO | __GFP_HIGH);
>
>         if (bio_add_page(bio, page, PAGE_SIZE, 0) < PAGE_SIZE) {
>                 pr_err("Adding page to bio failed at %llu\n",
> --
> 2.22.1
>

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

