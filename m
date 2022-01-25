Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FAD0C2BA4C
	for <dm-devel@archiver.kernel.org>; Wed, 26 Jan 2022 04:41:12 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-482-VcA7xCniO5C1rVuVtLCS9w-1; Tue, 25 Jan 2022 23:41:07 -0500
X-MC-Unique: VcA7xCniO5C1rVuVtLCS9w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 48B451006AA0;
	Wed, 26 Jan 2022 04:41:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F1C8104FF;
	Wed, 26 Jan 2022 04:41:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2EF911809CB8;
	Wed, 26 Jan 2022 04:40:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20P88K7e028998 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 25 Jan 2022 03:08:20 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0C78A2166B4D; Tue, 25 Jan 2022 08:08:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 078C92166B46
	for <dm-devel@redhat.com>; Tue, 25 Jan 2022 08:08:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D5F580B717
	for <dm-devel@redhat.com>; Tue, 25 Jan 2022 08:08:13 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-569-HZbkwHkzM-6n3r4hXYIR-w-1; Tue, 25 Jan 2022 03:08:10 -0500
X-MC-Unique: HZbkwHkzM-6n3r4hXYIR-w-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id B658FB8172B
	for <dm-devel@redhat.com>; Tue, 25 Jan 2022 08:00:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA86C340EB
	for <dm-devel@redhat.com>; Tue, 25 Jan 2022 08:00:56 +0000 (UTC)
Received: by mail-yb1-f173.google.com with SMTP id g81so59165967ybg.10
	for <dm-devel@redhat.com>; Tue, 25 Jan 2022 00:00:56 -0800 (PST)
X-Gm-Message-State: AOAM532APaMo3/MwETlb8p9/a8IdnXhoPqQqbu++QjhG4E6MKWiQx/kv
	xgD92CATHpPevsVSHOEULHEgKCmKS8gy7O1kB1w=
X-Google-Smtp-Source: ABdhPJzE0ChTuzHVQV+U/wv6ARwukapx8IFQmD8hO10Utrm5YQG3XSGHnX1S3Gu/DHqdZz0HjBdopf5B3i+qfwg6+kU=
X-Received: by 2002:a25:bc0e:: with SMTP id i14mr28436551ybh.670.1643097655496;
	Tue, 25 Jan 2022 00:00:55 -0800 (PST)
MIME-Version: 1.0
References: <747C2684-B570-473E-9146-E8AB53102236@filmlight.ltd.uk>
	<20220123180058.372f72ce@gecko.fritz.box>
	<70008df6-ef90-6e8d-8a57-9b30077508e7@molgen.mpg.de>
	<C5CCA1CE-E120-4BCB-925E-981DBA7A29F4@filmlight.ltd.uk>
In-Reply-To: <C5CCA1CE-E120-4BCB-925E-981DBA7A29F4@filmlight.ltd.uk>
From: Song Liu <song@kernel.org>
Date: Tue, 25 Jan 2022 00:00:44 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6wc2iPfzb+9DZ130RqNWfOmxJpkA59x58WN1s18Uuahg@mail.gmail.com>
Message-ID: <CAPhsuW6wc2iPfzb+9DZ130RqNWfOmxJpkA59x58WN1s18Uuahg@mail.gmail.com>
To: Roger Willcocks <roger@filmlight.ltd.uk>
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
X-Mailman-Approved-At: Tue, 25 Jan 2022 23:35:56 -0500
Cc: linux-raid <linux-raid@vger.kernel.org>,
	Paul Menzel <pmenzel@molgen.mpg.de>, dm-devel@redhat.com,
	Lukas Straub <lukasstraub2@web.de>
Subject: Re: [dm-devel] Raid0 performance regression
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Jan 24, 2022 at 8:49 AM Roger Willcocks <roger@filmlight.ltd.uk> wrote:
>
>
>
> > On 23 Jan 2022, at 21:34, Paul Menzel <pmenzel@molgen.mpg.de> wrote:
> >
> > Dear Roger,
> >
> >
> > Am 23.01.22 um 19:00 schrieb Lukas Straub:
> >> CC'ing Song Liu (md-raid maintainer) and linux-raid mailing list.
> >> On Fri, 21 Jan 2022 16:38:03 +0000 Roger Willcocks wrote:
> >
> >>> we noticed a thirty percent drop in performance on one of our raid
> >>> arrays when switching from CentOS 6.5 to 8.4; it uses raid0-like
> >
> > For those outside the CentOS universe, what Linux kernel versions are those?
> >
>
> 2.6.32 (and backported changes) and 4.18.0 (sim.)
>
> >>> striping to balance (by time) access to a pair of hardware raid-6
> >>> arrays. The underlying issue is also present in the native raid0
> >>> driver so herewith the gory details; I'd appreciate your thoughts.
> >>>
> >>> --
> >>>
> >>> blkdev_direct_IO() calls submit_bio() which calls an outermost
> >>> generic_make_request() (aka submit_bio_noacct()).
> >>>
> >>> md_make_request() calls blk_queue_split() which cuts an incoming
> >>> request into two parts with the first no larger than get_max_io_size()
> >>> bytes (which in the case of raid0, is the chunk size):
> >>>
> >>>   R -> AB
> >>>   blk_queue_split() gives the second part 'B' to generic_make_request()
> >>> to worry about later and returns the first part 'A'.
> >>>
> >>> md_make_request() then passes 'A' to a more specific request handler,
> >>> In this case raid0_make_request().
> >>>
> >>> raid0_make_request() cuts its incoming request into two parts at the
> >>> next chunk boundary:
> >>>
> >>> A -> ab
> >>>
> >>> it then fixes up the device (chooses a physical device) for 'a', and
> >>> gives both parts, separately, to generic make request()
> >>>
> >>> This is where things go awry, because 'b' is still targetted to the
> >>> original device (same as 'B'), but 'B' was queued before 'b'. So we
> >>> end up with:
> >>>
> >>>   R -> Bab
> >>>
> >>> The outermost generic_make_request() then cuts 'B' at
> >>> get_max_io_size(), and the process repeats. Ascii art follows:
> >>>
> >>>
> >>>     /---------------------------------------------------/   incoming rq
> >>>
> >>>     /--------/--------/--------/--------/--------/------/   max_io_size
> >>>       |--------|--------|--------|--------|--------|--------|--------| chunks
> >>>
> >>> |...=====|---=====|---=====|---=====|---=====|---=====|--......| rq out
> >>>       a    b  c     d  e     f  g     h  i     j  k     l
> >>>
> >>> Actual submission order for two-disk raid0: 'aeilhd' and 'cgkjfb'
> >>>
> >>> --
> >>>
> >>> There are several potential fixes -
> >>>
> >>> simplest is to set raid0 blk_queue_max_hw_sectors() to UINT_MAX
> >>> instead of chunk_size, so that raid0_make_request() receives the
> >>> entire transfer length and cuts it up at chunk boundaries;
> >>>
> >>> neatest is for raid0_make_request() to recognise that 'b' doesn't
> >>> cross a chunk boundary so it can be sent directly to the physical
> >>> device;
> >>>
> >>> and correct is for blk_queue_split to requeue 'A' before 'B'.
> >>>
> >>> --
> >>>
> >>> There's also a second issue - with large raid0 chunk size (256K), the
> >>> segments submitted to the physical device are at least 128K and
> >>> trigger the early unplug code in blk_mq_make_request(), so the
> >>> requests are never merged. There are legitimate reasons for a large
> >>> chunk size so this seems unhelpful.
> >>>
> >>> --
> >>>
> >>> As I said, I'd appreciate your thoughts.
> >
> > Thank you for the report and the analysis.
> >
> > Is the second issue also a regression? If not, I suggest to split it into a separate thread.
> >
>
> Yes this is also a regression, both issues above have to be addressed to recover the
> original performance.
>
> Specifically, an md raid0 array with 256K chunk size interleaving two x 12-disk raid6
> devices (Adaptec 3154 controller, 50MB files stored contiguously on disk, four threads)
> can achieve a sequential read rate of 3800 MB/sec with the (very) old 6.5 kernel; this
> falls to 2500 MB/sec with the relatively newer kernel.
>
> This change to raid0.c:
>
> -               blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
> +              blk_queue_max_hw_sectors(mddev->queue, UINT_MAX);

I guess this is OK.

>
> improves things somewhat, the sub-chunk requests are now submitted in order but we
> still only get 2800 MB/sec because no merging takes place; the controller struggles to
> keep up with the large number of sub-chunk transfers. This additional change to
> blk-mq.c:
>
> -               if (request_count >= BLK_MAX_REQUEST_COUNT || (last &&
> +               if (request_count >= BLK_MAX_REQUEST_COUNT || (false && last &&
>                     blk_rq_bytes(last) >= BLK_PLUG_FLUSH_SIZE)) {
>                         blk_flush_plug_list(plug, false);

We recently did some optimization for BLK_MAX_REQUEST_COUNT ([1] and some
follow up). We can probably do something similar for BLK_PLUG_FLUSH_SIZE.

Thanks,
Song

[1] https://lore.kernel.org/all/20210907230338.227903-1-songliubraving@fb.com/

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

