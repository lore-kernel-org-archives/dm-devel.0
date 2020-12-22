Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8963FC433E0
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:04:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 169B12068D
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:04:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 169B12068D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-448-DqK3FP7hMEanVl_aobN5tw-1; Mon, 04 Jan 2021 14:03:58 -0500
X-MC-Unique: DqK3FP7hMEanVl_aobN5tw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 285EE107AD28;
	Mon,  4 Jan 2021 19:03:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0ACC46F924;
	Mon,  4 Jan 2021 19:03:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D78A35003A;
	Mon,  4 Jan 2021 19:03:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BMKVki1028883 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 22 Dec 2020 15:31:46 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 67A57110F0AE; Tue, 22 Dec 2020 20:31:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 63D1F110F0AD
	for <dm-devel@redhat.com>; Tue, 22 Dec 2020 20:31:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E878F101A53F
	for <dm-devel@redhat.com>; Tue, 22 Dec 2020 20:31:43 +0000 (UTC)
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com
	[209.85.216.47]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-175-8wVG6qM7Mma8WVzlpFJUng-1; Tue, 22 Dec 2020 15:31:41 -0500
X-MC-Unique: 8wVG6qM7Mma8WVzlpFJUng-1
Received: by mail-pj1-f47.google.com with SMTP id b5so1976731pjl.0
	for <dm-devel@redhat.com>; Tue, 22 Dec 2020 12:31:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
	:mime-version:content-transfer-encoding;
	bh=K3t0gQbM6vz2TJwWgefdmZ2h7DY9X/bWdXKHVBct5Bo=;
	b=s5FJCDTQQIynmV1BIjjKVQ5JSJaB9NxBXZqE0CWIBc+YWRCOdMnyB3pZJiHcDlXWxR
	hKSttixZ+s+/qliB1D1xCzoS4PZlLKhik9rIbpukGanHpmoljEi5CC6yYDJNxIBydZvU
	FdwmRxQPiEuIBIdA6Duqqiyp+37cpjAFln6oG0wdwr+F/Uy+HY5MFrih9o9U6f+4hT8z
	mHQ7EFDrxHWh66LTn/5VOt3b/RgWNgUgcg6ukgfXBCfwAdImqNzfz7xbafiRmbzdQFhV
	AmZI7j09GQHNpVWY/aG0rDOmnsi6e1hnoE6UQXw/Z954Pccmau0CgbUsiuRbFqSym/R0
	MnKQ==
X-Gm-Message-State: AOAM533YhLG3P6OMTyGXi6oQPmo7FxxQc4MCBoOi+/DLcvCWDX4uCLlL
	4sTqITiNxuSaoLGOGhMoWSVwbQ==
X-Google-Smtp-Source: ABdhPJxmDWHlPtP4ZhkG5oNkIvaR9bXeCaw5WhU7AWPPpJheCeEpfLo0O3inkKuWstj+VTyDNxvnQw==
X-Received: by 2002:a17:90a:e005:: with SMTP id
	u5mr23339455pjy.64.1608669100205; 
	Tue, 22 Dec 2020 12:31:40 -0800 (PST)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net.
	[76.210.143.223]) by smtp.gmail.com with ESMTPSA id
	w27sm17486740pfq.104.2020.12.22.12.31.39
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 22 Dec 2020 12:31:39 -0800 (PST)
Date: Tue, 22 Dec 2020 12:31:39 -0800 (PST)
X-Google-Original-Date: Tue, 22 Dec 2020 12:31:37 PST (-0800)
In-Reply-To: <20201222133246.GA5099@infradead.org>
From: Palmer Dabbelt <palmer@dabbelt.com>
To: Christoph Hellwig <hch@infradead.org>
Message-ID: <mhng-843a42fb-63aa-4626-a60d-6e4d28a7bb73@palmerdabbelt-glaptop>
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
Cc: linux-raid@vger.kernel.org, bvanassche@acm.org, snitzer@redhat.com,
	corbet@lwn.net, shuah@kernel.org, linux-doc@vger.kernel.org,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On Tue, 22 Dec 2020 05:32:46 PST (-0800), Christoph Hellwig wrote:
> On Mon, Dec 14, 2020 at 07:00:57PM -0800, Palmer Dabbelt wrote:
>> I haven't gotten a whole lot of feedback, so I'm inclined to at least have some
>> reasonable performance numbers before bothering with a v2.
>
> FYI, my other main worry beside duplicating nbd is that device mapper
> really is a stacked interface that sits on top of other block device.
> Turning this into something else that just pipes data to userspace
> seems very strange.

Agreed.  It certainly doesn't fit the DM model.  We'd considered doing a non-DM
version of this (maybe "ubd"), but decided to stick with dm-user because we
didn't want to duplicate all the device creation stuff that DM provides.  A
simple version of that wouldn't be that hard to do, but the DM version has a
lot of features and we get that all for free.  We essentially decided to run
with DM until it gets in the way, and the only sticking point we ended up with
was that REQUEUE stuff (though not sure how that would show up with a bare
block device) and that scheduler question.

I'm going to stick with DM for now, unless it gets in the way, to avoid coming
up with a device creation scheme myself.  In the long term it's probably best
to have this be a standalone thing, but I don't want to dump a bunch of time
into putting that stuff together only to find that this isn't interesting
enough from a performance perspective to stick around.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

