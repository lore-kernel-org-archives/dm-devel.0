Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40E38C433DB
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:04:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AE6412068D
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:04:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE6412068D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-AKCDroK2M4-y0MJ4WlVIGA-1; Mon, 04 Jan 2021 14:03:58 -0500
X-MC-Unique: AKCDroK2M4-y0MJ4WlVIGA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 23BC8801ADD;
	Mon,  4 Jan 2021 19:03:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 03E9D1001281;
	Mon,  4 Jan 2021 19:03:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C901550038;
	Mon,  4 Jan 2021 19:03:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BMKcaP1030528 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 22 Dec 2020 15:38:36 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 35757110F0B3; Tue, 22 Dec 2020 20:38:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 31BA0110F0AE
	for <dm-devel@redhat.com>; Tue, 22 Dec 2020 20:38:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D0B1B800157
	for <dm-devel@redhat.com>; Tue, 22 Dec 2020 20:38:33 +0000 (UTC)
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com
	[209.85.216.48]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-487-o1A4d1R7PAC4anpGV7O7gg-1; Tue, 22 Dec 2020 15:38:30 -0500
X-MC-Unique: o1A4d1R7PAC4anpGV7O7gg-1
Received: by mail-pj1-f48.google.com with SMTP id hk16so1974693pjb.4
	for <dm-devel@redhat.com>; Tue, 22 Dec 2020 12:38:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
	:mime-version:content-transfer-encoding;
	bh=w7wUorTulI1SLGLyUAtcsZM5JvELPWd2Jp06S7SjCVY=;
	b=E/7LFneAHqJEFlf3hVMH9vWtapUPxFqhjYhLmWOoEPcNz8WzyLJDPh0y2zTmuxgbmc
	/85CmDN/hrg4tvPKNMUsJTf1RS5hQ4GbnQRMO69n/wSKvZCuoNqpvSZhVERb4YQekL+s
	VQc7iVrw7YtrIfGhULIn15keXYcw2ibYMw651XfxrsaFLxml2/dSCQ7FRtYM14lA47jU
	WqlaYvY/qQ8vkhtgK0UgLGICPGkP6Wvo1rxtUD0tym+Fw9GQTxrbSO/tLRSRp4bloCC9
	6PUQm/qSzQBpVFTBOjpJgcWSzR0Q+ABUQ1PzPlxyWRCbs2jXYkrHsD+jq0bStghEMe8C
	iv0Q==
X-Gm-Message-State: AOAM5333ffjEH/MeelOteJs7FMIsaCYIE+CY0/LWH5Kn4UN1EqZ76fU+
	esFuUZiwt/uzg6nuAXyWl0XPAQ==
X-Google-Smtp-Source: ABdhPJyrUEeQS+6tCykxcXi4wBUYC0ygmbARaXIsYIp63WsLg3f/qvwDb9rwYmvpLbj3fuqqf4mwnw==
X-Received: by 2002:a17:90a:301:: with SMTP id
	1mr23852780pje.195.1608669509537; 
	Tue, 22 Dec 2020 12:38:29 -0800 (PST)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net.
	[76.210.143.223]) by smtp.gmail.com with ESMTPSA id
	g30sm21624684pfr.152.2020.12.22.12.38.28
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 22 Dec 2020 12:38:28 -0800 (PST)
Date: Tue, 22 Dec 2020 12:38:28 -0800 (PST)
X-Google-Original-Date: Tue, 22 Dec 2020 12:38:26 PST (-0800)
In-Reply-To: <20201222143616.GB12885@redhat.com>
From: Palmer Dabbelt <palmer@dabbelt.com>
To: snitzer@redhat.com
Message-ID: <mhng-26d96d8e-77aa-415b-a8ee-518a0e91b6ef@palmerdabbelt-glaptop>
Mime-Version: 1.0 (MHng)
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
X-Mailman-Approved-At: Mon, 04 Jan 2021 14:03:12 -0500
Cc: linux-raid@vger.kernel.org, bvanassche@acm.org, corbet@lwn.net,
	shuah@kernel.org, linux-doc@vger.kernel.org,
	josef@toxicpanda.com, linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>, song@kernel.org,
	dm-devel@redhat.com, michael.christie@oracle.com,
	linux-kselftest@vger.kernel.org, kernel-team@android.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v1 0/5] dm: dm-user: New target that proxies
	BIOs to userspace
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On Tue, 22 Dec 2020 06:36:16 PST (-0800), snitzer@redhat.com wrote:
> On Tue, Dec 22 2020 at  8:32am -0500,
> Christoph Hellwig <hch@infradead.org> wrote:
>
>> On Mon, Dec 14, 2020 at 07:00:57PM -0800, Palmer Dabbelt wrote:
>> > I haven't gotten a whole lot of feedback, so I'm inclined to at least have some
>> > reasonable performance numbers before bothering with a v2.
>>
>> FYI, my other main worry beside duplicating nbd is that device mapper
>> really is a stacked interface that sits on top of other block device.
>> Turning this into something else that just pipes data to userspace
>> seems very strange.
>
> I agree.  Only way I'd be interested is if it somehow tackled enabling
> much more efficient IO.  Earlier discussion in this thread mentioned
> that zero-copy and low overhead wasn't a priority (because it is hard,
> etc).  But the hard work has already been done with io_uring.  If
> dm-user had a prereq of leaning heavily on io_uring and also enabled IO
> polling for bio-based then there may be a win to supporting it.
>
> But unless lower latency (or some other more significant win) is made
> possible I just don't care to prop up an unnatural DM bolt-on.

I don't remember if I mentioned this in the thread, but it was definately in
the Plumbers talk, but I'd had the general idea bouncing around that it would
be possible to write a high-performance version of this using an interface
similar to the one provided here while relying on io_uring for the
high-performance userspace.  That definately won't work with exactly the
current interface, but my hope was to avoid writing my own high-performance
ring buffer.  My worry was that it'll be too tricky to map this all to
zero-copy, and I guess I forgot about it.

Now that you bring it up, it certainly seems worth taking a shot at.  We'd
essentially have the best of both worlds: userspace implementations that want
to be simple could just use read()/write(), while those that want to be higher
performance could have their implicit ring buffer.

I'm currently trying to put together a benchmarking setup that is of sufficient
fidelity that I would believe the numbers, which is really why I don't have any
performance numbers yet (no sense posting numbers I would shoot down :)).  I'll
try to remember to take a shot at an io_uring based userspace (probably with
some dm-user interface modifications) to see how it feels.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

