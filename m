Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76297C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 29 Apr 2022 08:24:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-284-8UVJmGAUPsObOTAEGDJ_LQ-1; Fri, 29 Apr 2022 04:23:57 -0400
X-MC-Unique: 8UVJmGAUPsObOTAEGDJ_LQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7010F3C0FA81;
	Fri, 29 Apr 2022 08:23:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 59AC0C15D40;
	Fri, 29 Apr 2022 08:23:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C2ECD1947B83;
	Fri, 29 Apr 2022 08:23:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 03E781947046
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Apr 2022 08:19:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E357F407E1C1; Thu, 28 Apr 2022 08:19:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DE874407E1C0
 for <dm-devel@redhat.com>; Thu, 28 Apr 2022 08:19:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 861BE85A5A8
 for <dm-devel@redhat.com>; Thu, 28 Apr 2022 08:19:10 +0000 (UTC)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-43-tYv3AshvPJSn7ZRmuH_sFA-1; Thu, 28 Apr 2022 04:19:08 -0400
X-MC-Unique: tYv3AshvPJSn7ZRmuH_sFA-1
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
 by mailout4.samsung.com (KnoxPortal) with ESMTP id
 20220428081905epoutp049ef2becf382307874fd9c08597dac3fe~qAZM__cpG2858428584epoutp04h
 for <dm-devel@redhat.com>; Thu, 28 Apr 2022 08:19:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com
 20220428081905epoutp049ef2becf382307874fd9c08597dac3fe~qAZM__cpG2858428584epoutp04h
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
 epcas5p4.samsung.com (KnoxPortal) with ESMTP id
 20220428081904epcas5p47c8bcd22873ce6d18400433fc71cb400~qAZMpQ-GT1073810738epcas5p4n;
 Thu, 28 Apr 2022 08:19:04 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.175]) by
 epsnrtp1.localdomain (Postfix) with ESMTP id 4KppRn3tN5z4x9Q7; Thu, 28 Apr
 2022 08:19:01 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
 epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
 2A.07.09827.5FD4A626; Thu, 28 Apr 2022 17:19:01 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
 20220428080614epcas5p3491f94c681f10e405f2e32469014cb42~qAN-WXfd03164331643epcas5p33;
 Thu, 28 Apr 2022 08:06:14 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220428080614epsmtrp1646218e5d13d021f511c2694cde96f97~qAN-VdIg-2346223462epsmtrp1M;
 Thu, 28 Apr 2022 08:06:14 +0000 (GMT)
X-AuditID: b6c32a4a-b3bff70000002663-ef-626a4df5be25
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 83.6F.08853.6FA4A626; Thu, 28 Apr 2022 17:06:14 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220428080613epsmtip13d3d8cb3a0e30e5da0c0994a6f914284~qAN_HrEd02991929919epsmtip1i;
 Thu, 28 Apr 2022 08:06:13 +0000 (GMT)
Date: Thu, 28 Apr 2022 13:31:05 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Message-ID: <20220428080105.GH9558@test-zns>
MIME-Version: 1.0
In-Reply-To: <0d3b0a6b-825d-1b01-094a-911f81f5f354@opensource.wdc.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAJsWRmVeSWpSXmKPExsWy7bCmlu5X36wkg0/PmS1+nz3PbLH33WxW
 i723tC327D3JYnF51xw2i/nLnrJbdF/fwWax40kjowOHx85Zd9k9Ni+p99jZep/V4/2+q2we
 nzfJBbBGZdtkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXm
 AF2ipFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAw
 MgUqTMjOODfnPFPBJ9WKVc1zmBsY/8l2MXJySAiYSKz81cbcxcjFISSwm1Fi1cR7TBDOJ0aJ
 pzOusEE43xgl3l46wA7T0n1pFVTLXkaJfYuuQjnPGCX67r5nAaliEVCV6J84hbGLkYODTUBb
 4vR/DpCwiICpxNueVhaQemaBM4wS7e93gU0VFvCRWH5iGiOIzSugIzHx8Tt2CFtQ4uTMJywg
 czgF3CRW/dMFCYsKKEsc2HYc7FQJgVYOiTuda9kgrnOR2NHdzAJhC0u8Or4F6mopiZf9bVB2
 ucT2tgVQzS2MEl2nTkE12Etc3POXCcRmFsiQ6J/wFapBVmLqqXVQcT6J3t9PmCDivBI75sHY
 yhJr1i+AOkJS4tr3RijbQ2Le3icskBC6xSSxpuEx2wRG+VlInpuFZB+ErSOxYPcntllATzML
 SEss/8cBYWpKrN+lv4CRdRWjZGpBcW56arFpgVFeajk8ypPzczcxgpOqltcOxocPPugdYmTi
 YDzEKMHBrCTC+2V3RpIQb0piZVVqUX58UWlOavEhRlNgZE1klhJNzgem9bySeEMTSwMTMzMz
 E0tjM0Mlcd7T6RsShQTSE0tSs1NTC1KLYPqYODilGphE3I1qJd5rMrdsDKionCfM8n+O8WT2
 BOUf7nMKbre3TNtefC85ISLO5Kyn6BOmBFmrwL+/wzKTl0VZFeUk9csUPj12oTTIfrPa7eyT
 vJWsV9lPXBN1yrh1iOW1So7jvtTjHnOcLp3U4p5WNiWeVzWaO0v/aoFpzMFJMtOW8y/M2hdX
 OCfN0fn8KqZZ4s6FZ+TvXH4nEbvi16ktPvtv2x8NjbAOMFQ4rRneZWHaIeI+a7XZtCPZ/zbf
 npe+xfldruZPnu/sNlN+rZx77dWiI4XBT3gjvD/+nRzc4f+qUeHpzdaSHWahi7xL/zrHrNiU
 U9XuG1q+qGzSfmOmneqrD7xac+fPMUOWmbFTOq1XBimxFGckGmoxFxUnAgAMLRIEMwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsWy7bCSnO43r6wkg8WnNC1+nz3PbLH33WxW
 i723tC327D3JYnF51xw2i/nLnrJbdF/fwWax40kjowOHx85Zd9k9Ni+p99jZep/V4/2+q2we
 nzfJBbBGcdmkpOZklqUW6dslcGX07T7DWLBJueLcvhaWBsbr0l2MnBwSAiYS3ZdWMXcxcnEI
 CexmlLi39xgLREJSYtnfI8wQtrDEyn/P2SGKnjBKLLx1DqyIRUBVon/iFMYuRg4ONgFtidP/
 OUDCIgKmEm97WllA6pkFzjBKtL/fxQ6SEBbwkVh+YhojiM0roCMx8fE7qKG3mCQWP97EBpEQ
 lDg58wnYAmYBLYkb/14ygSxgFpCWWP6PA8TkFHCTWPVPF6RCVEBZ4sC240wTGAVnIWmehaR5
 FkLzAkbmVYySqQXFuem5xYYFhnmp5XrFibnFpXnpesn5uZsYwZGgpbmDcfuqD3qHGJk4GA8x
 SnAwK4nwftmdkSTEm5JYWZValB9fVJqTWnyIUZqDRUmc90LXyXghgfTEktTs1NSC1CKYLBMH
 p1QDU2aJhIDZ37KSa3Oud/X/VX85J/+55Neit+E/7fgzxHzWa1wwuzxDNHjHhWTXWSc/22mu
 T94Tpv2tgO+n3LYbZ/I7GDV5/4u3/9doeR3w2khqsaE/4xX5qgZNw8eMog9DquwnTXVr8j6j
 +y/qQH3kwyMyYisPZIjVlis/DDLO+bPTXbh2pbP1JF83Y5G3GY5OLO27z+3x2qf0g8XV/PqF
 M82Wp7ZmOjpsEVdZOONgFvP3ZOOHP1isVdUKfv3UqNjQWzt7451tzx8tE3rTnsl0Larmkc6C
 pCNlXd/lqhjn7fvnk5PtMLlrn0+nRM2mxpXXklMZzln5TU/+wvlvQaBWxt+QK2uerth15t0n
 v9ZQJZbijERDLeai4kQAbdFbu/MCAAA=
X-CMS-MailID: 20220428080614epcas5p3491f94c681f10e405f2e32469014cb42
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220426101921epcas5p341707619b5e836490284a42c92762083
References: <20220426101241.30100-1-nj.shetty@samsung.com>
 <CGME20220426101921epcas5p341707619b5e836490284a42c92762083@epcas5p3.samsung.com>
 <20220426101241.30100-3-nj.shetty@samsung.com>
 <7d1fdd1e-c854-4744-8bec-7d222fb9be76@opensource.wdc.com>
 <20220427151535.GC9558@test-zns>
 <0d3b0a6b-825d-1b01-094a-911f81f5f354@opensource.wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mailman-Approved-At: Fri, 29 Apr 2022 08:23:40 +0000
Subject: Re: [dm-devel] [PATCH v4 02/10] block: Add copy offload support
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
Cc: linux-scsi@vger.kernel.org, nitheshshetty@gmail.com,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 linux-fsdevel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed;
 boundary="----s9reHD3dvq.Swzu4OgS99nNlXP7CLa0djtt04wdzZepsPVyA=_1ceb3_"

------s9reHD3dvq.Swzu4OgS99nNlXP7CLa0djtt04wdzZepsPVyA=_1ceb3_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Thu, Apr 28, 2022 at 07:04:13AM +0900, Damien Le Moal wrote:
> On 4/28/22 00:15, Nitesh Shetty wrote:
> > On Wed, Apr 27, 2022 at 11:45:26AM +0900, Damien Le Moal wrote:
> >> On 4/26/22 19:12, Nitesh Shetty wrote:
> >>> Introduce blkdev_issue_copy which supports source and destination bdevs,
> >>> and an array of (source, destination and copy length) tuples.
> >>> Introduce REQ_COPY copy offload operation flag. Create a read-write
> >>> bio pair with a token as payload and submitted to the device in order.
> >>> Read request populates token with source specific information which
> >>> is then passed with write request.
> >>> This design is courtesy Mikulas Patocka's token based copy
> >>>
> >>> Larger copy will be divided, based on max_copy_sectors,
> >>> max_copy_range_sector limits.
> >>>
> >>> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> >>> Signed-off-by: Arnav Dawn <arnav.dawn@samsung.com>
> >>> ---
> >>>  block/blk-lib.c           | 232 ++++++++++++++++++++++++++++++++++++++
> >>>  block/blk.h               |   2 +
> >>>  include/linux/blk_types.h |  21 ++++
> >>>  include/linux/blkdev.h    |   2 +
> >>>  include/uapi/linux/fs.h   |  14 +++
> >>>  5 files changed, 271 insertions(+)
> >>>
> >>> diff --git a/block/blk-lib.c b/block/blk-lib.c
> >>> index 09b7e1200c0f..ba9da2d2f429 100644
> >>> --- a/block/blk-lib.c
> >>> +++ b/block/blk-lib.c
> >>> @@ -117,6 +117,238 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
> >>>  }
> >>>  EXPORT_SYMBOL(blkdev_issue_discard);
> >>>  
> >>> +/*
> >>> + * Wait on and process all in-flight BIOs.  This must only be called once
> >>> + * all bios have been issued so that the refcount can only decrease.
> >>> + * This just waits for all bios to make it through bio_copy_end_io. IO
> >>> + * errors are propagated through cio->io_error.
> >>> + */
> >>> +static int cio_await_completion(struct cio *cio)
> >>> +{
> >>> +	int ret = 0;
> >>> +	unsigned long flags;
> >>> +
> >>> +	spin_lock_irqsave(&cio->lock, flags);
> >>> +	if (cio->refcount) {
> >>> +		cio->waiter = current;
> >>> +		__set_current_state(TASK_UNINTERRUPTIBLE);
> >>> +		spin_unlock_irqrestore(&cio->lock, flags);
> >>> +		blk_io_schedule();
> >>> +		/* wake up sets us TASK_RUNNING */
> >>> +		spin_lock_irqsave(&cio->lock, flags);
> >>> +		cio->waiter = NULL;
> >>> +		ret = cio->io_err;
> >>> +	}
> >>> +	spin_unlock_irqrestore(&cio->lock, flags);
> >>> +	kvfree(cio);
> >>
> >> cio is allocated with kzalloc() == kmalloc(). So why the kvfree() here ?
> >>
> > 
> > acked.
> > 
> >>> +
> >>> +	return ret;
> >>> +}
> >>> +
> >>> +static void bio_copy_end_io(struct bio *bio)
> >>> +{
> >>> +	struct copy_ctx *ctx = bio->bi_private;
> >>> +	struct cio *cio = ctx->cio;
> >>> +	sector_t clen;
> >>> +	int ri = ctx->range_idx;
> >>> +	unsigned long flags;
> >>> +	bool wake = false;
> >>> +
> >>> +	if (bio->bi_status) {
> >>> +		cio->io_err = bio->bi_status;
> >>> +		clen = (bio->bi_iter.bi_sector << SECTOR_SHIFT) - ctx->start_sec;
> >>> +		cio->rlist[ri].comp_len = min_t(sector_t, clen, cio->rlist[ri].comp_len);
> >>
> >> long line.
> > 
> > Is it because line is more than 80 character, I thought limit is 100 now, so
> > went with longer lines ?
> 
> When it is easy to wrap the lines without readability loss, please do to
> keep things under 80 char per line.
> 
>

acked

> >>> +{
> >>> +	struct request_queue *src_q = bdev_get_queue(src_bdev);
> >>> +	struct request_queue *dest_q = bdev_get_queue(dest_bdev);
> >>> +	int ret = -EINVAL;
> >>> +
> >>> +	if (!src_q || !dest_q)
> >>> +		return -ENXIO;
> >>> +
> >>> +	if (!nr)
> >>> +		return -EINVAL;
> >>> +
> >>> +	if (nr >= MAX_COPY_NR_RANGE)
> >>> +		return -EINVAL;
> >>
> >> Where do you check the number of ranges against what the device can do ?
> >>
> > 
> > The present implementation submits only one range at a time. This was done to 
> > make copy offload generic, so that other types of copy implementation such as
> > XCOPY should be able to use same infrastructure. Downside at present being
> > NVMe copy offload is not optimal.
> 
> If you issue one range at a time without checking the number of ranges,
> what is the point of the nr ranges queue limit ? The user can submit a
> copy ioctl request exceeding it. Please use that limit and enforce it or
> remove it entirely.
> 

Sure, will remove this limit in next version.

--
Thank you
Nitesh Shetty


------s9reHD3dvq.Swzu4OgS99nNlXP7CLa0djtt04wdzZepsPVyA=_1ceb3_
Content-Type: text/plain; charset="utf-8"


------s9reHD3dvq.Swzu4OgS99nNlXP7CLa0djtt04wdzZepsPVyA=_1ceb3_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

------s9reHD3dvq.Swzu4OgS99nNlXP7CLa0djtt04wdzZepsPVyA=_1ceb3_--

