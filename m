Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B739C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 11 Apr 2022 06:19:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-ZRKTT4eFP2iItci9QSrymA-1; Mon, 11 Apr 2022 02:19:32 -0400
X-MC-Unique: ZRKTT4eFP2iItci9QSrymA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E5B7885A5BE;
	Mon, 11 Apr 2022 06:19:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D1485432022;
	Mon, 11 Apr 2022 06:19:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 75098193F50F;
	Mon, 11 Apr 2022 06:19:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 48C611949763
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Apr 2022 17:28:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 299BE2027EB4; Wed,  6 Apr 2022 17:28:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2560C2026614
 for <dm-devel@redhat.com>; Wed,  6 Apr 2022 17:28:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C6A438008A8
 for <dm-devel@redhat.com>; Wed,  6 Apr 2022 17:28:32 +0000 (UTC)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com
 [209.85.167.53]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-164-sx-QHAscOmW0tlvyZ46h4A-1; Wed, 06 Apr 2022 13:28:30 -0400
X-MC-Unique: sx-QHAscOmW0tlvyZ46h4A-1
Received: by mail-lf1-f53.google.com with SMTP id y32so5295905lfa.6;
 Wed, 06 Apr 2022 10:28:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=WJLYFFwKJzu0AzBejzceyC93Fh4AhvIk3A/MNZXzKIU=;
 b=lauQf50QRqgGzSTUPbal207oEU2VY0BTsSXqvEq9HByfGGESDMtuzrfWU8zK7chAAx
 lx084Ydi1WMXDS/KZ1oUuiL7/6Itz+1MUh0EIzle6Pe1JCIq1r5BU9W30vh8h6U9ovFe
 nPNkDn4hjbne3Ikm/zDo5dwh+gjAFoe4zR6JZ5rCV9ohgMN+nSsbzmaOIDMgnLPpHA19
 t/mX4hr6G41t92nF3qn+dvtnBQS+tMsLeCuqyDUpCNzp2pCISMcX+Vog/SLnkxMro8/W
 wRzGxoxN1eeA7bN1ts63CMDtVRvshuu1r9EDIYv7hdMdykQ2LdBEXssQgrU2cjhu24EA
 yHug==
X-Gm-Message-State: AOAM531C9mab1nqOh3HydwW7+xux9sV+pdWuHDfw8+rf7twowm4ii45u
 O43rHjYGWVcTnXLEulVRKsT1/wqGyMli6PXOhQ4=
X-Google-Smtp-Source: ABdhPJxvT7YhfWN8QbCVz4oydCsKwT/zbXQ5089WXaSZlqzdjbFflulVc086iBmKtewP4KtbC66vp+jW8qrWjcRFTmg=
X-Received: by 2002:ac2:5f4d:0:b0:43e:da3e:4529 with SMTP id
 13-20020ac25f4d000000b0043eda3e4529mr6768924lfz.627.1649266108188; Wed, 06
 Apr 2022 10:28:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-24-hch@lst.de>
In-Reply-To: <20220406060516.409838-24-hch@lst.de>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Thu, 7 Apr 2022 02:28:15 +0900
Message-ID: <CAKFNMokGOma3pvHdEsnsjuKgW+jpYX9zx8fWwJWyeKuCpKz-YQ@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Mailman-Approved-At: Mon, 11 Apr 2022 06:19:21 +0000
Subject: Re: [dm-devel] [PATCH 23/27] block: add a bdev_max_discard_sectors
 helper
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
Cc: jfs-discussion@lists.sourceforge.net, linux-nvme@lists.infradead.org,
 virtualization@lists.linux-foundation.org, Linux MM <linux-mm@kvack.org>,
 device-mapper development <dm-devel@redhat.com>, target-devel@vger.kernel.org,
 linux-mtd@lists.infradead.org, drbd-dev@lists.linbit.com,
 linux-s390@vger.kernel.org, linux-nilfs <linux-nilfs@vger.kernel.org>,
 Andreas Gruenbacher <agruenba@redhat.com>, linux-scsi@vger.kernel.org,
 cluster-devel@redhat.com, xen-devel@lists.xenproject.org,
 linux-ext4@vger.kernel.org, linux-um@lists.infradead.org, nbd@other.debian.org,
 linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
 ceph-devel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
 ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
 ntfs3@lists.linux.dev, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Apr 6, 2022 at 11:05 PM Christoph Hellwig <hch@lst.de> wrote:
>
> Add a helper to query the number of sectors support per each discard bio
> based on the block device and use this helper to stop various places from
> poking into the request_queue to see if discard is supported and if so how
> much.  This mirrors what is done e.g. for write zeroes as well.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
...
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index 16e775bcf4a7c..7d510e4231713 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -829,9 +829,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
>  }
>
>  /*
> - * Check if the underlying struct block_device request_queue supports
> - * the QUEUE_FLAG_DISCARD bit for UNMAP/WRITE_SAME in SCSI + TRIM
> - * in ATA and we need to set TPE=1

> + * Check if the underlying struct block_device request_queue supports disard.
>   */

Here was a typo:

 s/disard/discard/

On Thu, Apr 7, 2022 at 12:19 AM Andreas Gruenbacher <agruenba@redhat.com> wrote:
> If I'm misreading things, could you please document that
> bdev_max_discard_sectors() != 0 implies that discard is supported?

I got the same impression.   Checking the discard support with
bdev_max_discard_sectors() != 0 seems a bit unclear than before.

Thanks,
Ryusuke Konishi

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

