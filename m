Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F47AC4332D
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:03:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2C8EB21D93
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:03:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2C8EB21D93
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=veeam.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-70-pFxzFb7uM2K69_NpvMFOqA-1; Mon, 04 Jan 2021 14:03:49 -0500
X-MC-Unique: pFxzFb7uM2K69_NpvMFOqA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D63DF184214E;
	Mon,  4 Jan 2021 19:03:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B6EAB5C8AA;
	Mon,  4 Jan 2021 19:03:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8BE7B50032;
	Mon,  4 Jan 2021 19:03:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BFFvRfi021724 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 15 Dec 2020 10:57:27 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0BBA42166B2D; Tue, 15 Dec 2020 15:57:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E90D52166B39
	for <dm-devel@redhat.com>; Tue, 15 Dec 2020 15:57:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C0708100FBE1
	for <dm-devel@redhat.com>; Tue, 15 Dec 2020 15:57:09 +0000 (UTC)
Received: from mx4.veeam.com (mx4.veeam.com [104.41.138.86]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-504-AunebN01OU2B5hL8W-k_Vw-1;
	Tue, 15 Dec 2020 10:57:03 -0500
X-MC-Unique: AunebN01OU2B5hL8W-k_Vw-1
Received: from mail.veeam.com (prgmbx01.amust.local [172.24.0.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx4.veeam.com (Postfix) with ESMTPS id E19C7B21B0;
	Tue, 15 Dec 2020 18:57:00 +0300 (MSK)
Received: from veeam.com (172.24.14.5) by prgmbx01.amust.local (172.24.0.171)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.721.2;
	Tue, 15 Dec 2020 16:56:59 +0100
Date: Tue, 15 Dec 2020 18:57:15 +0300
From: Sergei Shtepa <sergei.shtepa@veeam.com>
To: Bob Liu <bob.liu@oracle.com>
Message-ID: <20201215155715.GA2541@veeam.com>
References: <1607518911-30692-1-git-send-email-sergei.shtepa@veeam.com>
	<20201209135148.GA32720@redhat.com>
	<20201210145814.GA31521@veeam.com>
	<20201210163222.GB10239@redhat.com>
	<20201211163049.GC16168@redhat.com>
	<1ee7652e-b77f-6fa4-634c-ff6639037321@kernel.dk>
	<208edf35-ecdc-2d73-4c48-0424943a78c0@suse.de>
	<cdc3c792-17ac-de61-12ae-74691769fc3c@oracle.com>
MIME-Version: 1.0
In-Reply-To: <cdc3c792-17ac-de61-12ae-74691769fc3c@oracle.com>
X-Originating-IP: [172.24.14.5]
X-ClientProxiedBy: prgmbx01.amust.local (172.24.0.171) To prgmbx01.amust.local
	(172.24.0.171)
X-EsetResult: clean, is OK
X-EsetId: 37303A29C604D26A6D756B
X-Veeam-MMEX: True
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
X-Mailman-Approved-At: Mon, 04 Jan 2021 14:03:12 -0500
Cc: Jens Axboe <axboe@kernel.dk>, "steve@sk2.org" <steve@sk2.org>,
	Mike Snitzer <snitzer@redhat.com>,
	"johannes.thumshirn@wdc.com" <johannes.thumshirn@wdc.com>,
	Pavel Tide <Pavel.TIde@veeam.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"ming.lei@redhat.com" <ming.lei@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"hch@lst.de" <hch@lst.de>, "koct9i@gmail.com" <koct9i@gmail.com>
Subject: Re: [dm-devel] [PATCH 0/3] block: blk_interposer - Block Layer
	Interposer
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The 12/15/2020 09:51, Bob Liu wrote:
> Hi Folks,
> 
> On 12/12/20 12:56 AM, Hannes Reinecke wrote:
> > On 12/11/20 5:33 PM, Jens Axboe wrote:
> >> On 12/11/20 9:30 AM, Mike Snitzer wrote:
> >>> While I still think there needs to be a proper _upstream_ consumer of
> >>> blk_interposer as a condition of it going in.. I'll let others make the
> >>> call.
> >>
> >> That's an unequivocal rule.
> >>
> >>> As such, I'll defer to Jens, Christoph and others on whether your
> >>> minimalist blk_interposer hook is acceptable in the near-term.
> >>
> >> I don't think so, we don't do short term bandaids just to plan on
> >> ripping that out when the real functionality is there. IMHO, the dm
> >> approach is the way to go - it provides exactly the functionality that
> >> is needed in an appropriate way, instead of hacking some "interposer"
> >> into the core block layer.
> >>
> > Which is my plan, too.
> > 
> > I'll be working with the Veeam folks to present a joint patchset (including the DM bits) for the next round.
> > 
> 
> Besides the dm approach, do you think Veeam's original requirement is a good
> use case of "block/bpf: add eBPF based block layer IO filtering"?
> https://lwn.net/ml/bpf/20200812163305.545447-1-leah.rumancik@gmail.com/
> 
> Thanks,
> Bob

Hi Bob.
Thank you for your message.

I looked at your patch - it's interesting, but I have a few comments.

1.
#ifdef CONFIG_BPF_IO_FILTER
	struct bpf_prog_array __rcu *progs;
	struct mutex io_filter_lock;
#endif
For DM and blk-snap to work, it is necessary that there is always
the possibility of interception.

2.
We could get rid of the io_filter_lock lock if we do attach/detach while
the queue is stopped. And __rcu for *progs, can not use either.

3.
int io_filter_bpf_run(struct bio *bio)
{
	struct bpf_io_request io_req = {
		.sector_start = bio->bi_iter.bi_sector,
		.sector_cnt = bio_sectors(bio),
		.opf = bio->bi_opf,
	};
	return BPF_PROG_RUN_ARRAY_CHECK(bio->bi_disk->progs, &io_req, BPF_PROG_RUN);
}
Allows to get little information. It will not allow to work with the bios`s data.
blk_interposer allows to get full access to bio.
For use in the DM, we must also be able to add new bio's.

Summary:
For device-mapper purposes, bpf_io_filter is not suitable.
bpf_io_filter in this form is probably convenient to use for monitoring and
studying the block layer.
For the security task, I would suggest making a separate module and using
blk_interposer to intercept bio requests. This will give more flexible
functionality and better performance.

--
Sergei Shtepa
Veeam Software developer.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

