Return-Path: <SRS0=vwJi=FQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3581EC4361B
	for <dm-devel@archiver.kernel.org>; Sat, 12 Dec 2020 16:19:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4968C22AAF
	for <dm-devel@archiver.kernel.org>; Sat, 12 Dec 2020 16:19:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4968C22AAF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24-gABAbFl5N7i0PyHvtXtxEA-1; Sat, 12 Dec 2020 11:19:47 -0500
X-MC-Unique: gABAbFl5N7i0PyHvtXtxEA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E98F8612AA;
	Sat, 12 Dec 2020 16:19:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CC7455D756;
	Sat, 12 Dec 2020 16:19:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A20274E58E;
	Sat, 12 Dec 2020 16:19:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BCGJfVm018008 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 12 Dec 2020 11:19:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6D1CB2166B2A; Sat, 12 Dec 2020 16:19:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 67CAF2166B29
	for <dm-devel@redhat.com>; Sat, 12 Dec 2020 16:19:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 02A128007DF
	for <dm-devel@redhat.com>; Sat, 12 Dec 2020 16:19:39 +0000 (UTC)
Received: from mail-pj1-f67.google.com (mail-pj1-f67.google.com
	[209.85.216.67]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-503-o3tJ1P3HMhyBb_DVxyJIPw-1; Sat, 12 Dec 2020 11:19:36 -0500
X-MC-Unique: o3tJ1P3HMhyBb_DVxyJIPw-1
Received: by mail-pj1-f67.google.com with SMTP id b5so4126339pjl.0
	for <dm-devel@redhat.com>; Sat, 12 Dec 2020 08:19:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=fNUq3Wc2zyF78i1TDeUWX/K7G8NedjGivLTs4+QSolE=;
	b=tnpSHnGEFvB1E+5zMCVVC0fJnVEuJRdBqcpdaubIcpV2rsq4E9g5VAI4Xd/0ltOAho
	h+n/MOqcDBwKU0YQ3H+v1DthOqnF3Wz9y9MI1/50Lb/N0jGgQFGYUeN1gU3vm0Pq20YS
	qSz9TgEtaZseX8NuuuQl9YAy0dEzEHUEXIZQYtQ8w5EOf4IKwKTUVSz4W7mybqn/Aulr
	8TI9NsG3vRqGdCQr+fUZFuDNqb2nBCLbeV0qOKOxNsgPb/2DoYKmDalNcMB0W36QHooI
	+95m3ds796KPvi5eq2iEjYP9Y5bW6llmyA+4U4VZ/MaOldLcnt+hwvqe+1A4ayvyqlBm
	AB4g==
X-Gm-Message-State: AOAM5312AqGji4tSv/Ln9h6+xEuKoiHRo3owiAQf6P9n8KGppFA6NeAm
	13IAeF5QPxHQOzf43kyDmLyZdK8fqvLK4Q==
X-Google-Smtp-Source: ABdhPJysddQ9smuBu62L9UTvcsZIdUYzHjtesiAECFxawtc2gj+hUqTQwGm7Bvo1X8/iYSvnI2ctTQ==
X-Received: by 2002:a17:90a:414d:: with SMTP id
	m13mr18174699pjg.229.1607789975168; 
	Sat, 12 Dec 2020 08:19:35 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
	by smtp.gmail.com with ESMTPSA id
	g30sm6701523pfr.152.2020.12.12.08.19.33
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Sat, 12 Dec 2020 08:19:34 -0800 (PST)
To: Mike Snitzer <snitzer@redhat.com>, Song Liu <songliubraving@fb.com>
References: <D6749568-4ED2-49A7-B0D3-F0969B934BF6@fb.com>
	<20201212144229.GB21863@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <2799b859-c451-c3f6-7753-fe08e35f4a7c@kernel.dk>
Date: Sat, 12 Dec 2020 09:19:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201212144229.GB21863@redhat.com>
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
Cc: linux-raid <linux-raid@vger.kernel.org>,
	Heinz Mauelshagen <heinzm@redhat.com>, Xiao Ni <xni@redhat.com>,
	dm-devel@redhat.com, Matthew Ruffell <matthew.ruffell@canonical.com>
Subject: Re: [dm-devel] [GIT PULL v3] md-fixes 20201212
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
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 12/12/20 7:42 AM, Mike Snitzer wrote:
> On Sat, Dec 12 2020 at  4:12am -0500,
> Song Liu <songliubraving@fb.com> wrote:
> 
>> Hi Jens, 
>>
>> Please consider pulling the following changes on top of tag
>> block-5.10-2020-12-05. This is to fix raid10 data corruption [1] in 5.10-rc7. 
>>
>> Tests run on this change: 
>>
>> 1. md raid10: tested discard on raid10 device works properly (zero mismatch_cnt).
>> 2. dm raid10: tested discard_granularity and discard_max_bytes was set properly. 
>>
>> Thanks,
>> Song
>>
>>
>> [1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1907262/
>>
>>
>> The following changes since commit 7e7986f9d3ba69a7375a41080a1f8c8012cb0923:
>>
>>   block: use gcd() to fix chunk_sectors limit stacking (2020-12-01 11:02:55 -0700)
>>
>> are available in the Git repository at:
>>
>>   ssh://git@gitolite.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes
>>
>> for you to fetch changes up to 0d5c7b890229f8a9bb4b588b34ffe70c62691143:
>>
>>   Revert "md: add md_submit_discard_bio() for submitting discard bio" (2020-12-12 00:51:41 -0800)
>>
>> ----------------------------------------------------------------
>> Song Liu (7):
>>       Revert "dm raid: remove unnecessary discard limits for raid10"
>>       Revert "dm raid: fix discard limits for raid1 and raid10"
>>       Revert "md/raid10: improve discard request for far layout"
>>       Revert "md/raid10: improve raid10 discard request"
>>       Revert "md/raid10: pull codes that wait for blocked dev into one function"
>>       Revert "md/raid10: extend r10bio devs to raid disks"
>>       Revert "md: add md_submit_discard_bio() for submitting discard bio"
>>
>>  drivers/md/dm-raid.c |   9 +++++
>>  drivers/md/md.c      |  20 ----------
>>  drivers/md/md.h      |   2 -
>>  drivers/md/raid0.c   |  14 ++++++-
>>  drivers/md/raid10.c  | 423 +++++++++++++++++++++++++++++------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
>>  drivers/md/raid10.h  |   1 -
>>  6 files changed, 78 insertions(+), 391 deletions(-)
>>
> 
> Jens already pulled 95% of these changes no? why are you sending a pull
> that ignores that fact?
> 
> And as I stated here:
> https://www.redhat.com/archives/dm-devel/2020-December/msg00253.html
> 
> I don't agree with reverting commit e0910c8e4f87bb9 ("dm raid: fix
> discard limits for raid1 and raid10").  Espeiclaly not like you've done,
> given it was marked for stable any follow-on fix/revert needs to be as
> well.
> 
> Simply changing 'struct mddev' chunk_sectors members from int to
> 'unsigned int' is the better way forward I think.

I agree, that'd be simpler. Mike, care to send a real patch for that
against block-5.10?

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

