Return-Path: <SRS0=vUAV=H3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8C91C433E6
	for <dm-devel@archiver.kernel.org>; Thu, 25 Feb 2021 09:27:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EDA5664EDC
	for <dm-devel@archiver.kernel.org>; Thu, 25 Feb 2021 09:27:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EDA5664EDC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-kPCfsQmcPseIjX0m1BFuzw-1; Thu, 25 Feb 2021 04:27:24 -0500
X-MC-Unique: kPCfsQmcPseIjX0m1BFuzw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4085E193578B;
	Thu, 25 Feb 2021 09:27:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 634EB60BF3;
	Thu, 25 Feb 2021 09:27:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 056C34EE83;
	Thu, 25 Feb 2021 09:27:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11O9QBV0015882 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 24 Feb 2021 04:26:11 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4ECDF2026D3A; Wed, 24 Feb 2021 09:26:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4796F2026D48
	for <dm-devel@redhat.com>; Wed, 24 Feb 2021 09:26:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C5ABC81F45B
	for <dm-devel@redhat.com>; Wed, 24 Feb 2021 09:26:06 +0000 (UTC)
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com
	[209.85.210.172]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-89--v0KteKzO1-SE-HWbUVAVQ-1; Wed, 24 Feb 2021 04:26:04 -0500
X-MC-Unique: -v0KteKzO1-SE-HWbUVAVQ-1
Received: by mail-pf1-f172.google.com with SMTP id 201so957518pfw.5
	for <dm-devel@redhat.com>; Wed, 24 Feb 2021 01:26:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=skeImN742nfG4E0VR51CuEJEgnI11NI7CM+fbkLvJHE=;
	b=Rk+FEaaEYuNAw/qkJcOcqNR836tegCa7gn3xHh3aJSBp4d/AJY+fmnvJBWKiZml1U0
	vOnhh+daSrRPpUIp9RX2xalxv/S9oRI5HgxuXpL3TNKTSEQONXXut9Wbp2ogZ7UUdIzm
	xAEpaxM0Z3TripgZJqpd5IW8PBMyXhVq4MdTseeDW+WpfDL/VBzutSN96En/hKpudwqU
	83+J1aJbDWvkOLDISySzyg2El/Q7fC4rlBFkwe2Vp6+DPHbaclVNy4ng1dvVPLzaw6Gn
	2A7MsTMrL2YpYjFcPadJTykFHeQG1lCXMFrjkP463IDOSOAVCDaRMuc8CMUJMltiq2bC
	YF2w==
X-Gm-Message-State: AOAM531rYfM6U9H2EhiSgMREsvFLhIyhyQvjgqLl5fpZ2gJFwPzCH2J5
	FVUpp1yrAzxpCfaoAOFiA9Tzrg==
X-Google-Smtp-Source: ABdhPJwNecl6jFwBFdxrR9hTadcRdwBZB3K+w0crjykXhBn8Jc1gVvlfJaQSqb4iF2lgIXJ/PgvMjw==
X-Received: by 2002:a65:5ac9:: with SMTP id d9mr27664900pgt.74.1614158761974; 
	Wed, 24 Feb 2021 01:26:01 -0800 (PST)
Received: from [0.0.0.0] ([62.217.45.26]) by smtp.gmail.com with ESMTPSA id
	g9sm1946042pfo.115.2021.02.24.01.25.54
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Wed, 24 Feb 2021 01:26:01 -0800 (PST)
To: Song Liu <song@kernel.org>, Paul Menzel <pmenzel@molgen.mpg.de>
References: <1613177399-22024-1-git-send-email-guoqing.jiang@cloud.ionos.com>
	<36a660ed-b995-839e-ac82-dc4ca25ccb8a@molgen.mpg.de>
	<CAPhsuW5s6fk3kua=9Z9o3VPCcN1wdUqXybXm9cp4arJW5+oBvQ@mail.gmail.com>
From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Message-ID: <9f28f6e2-e46a-bfed-09d8-2fec941ea881@cloud.ionos.com>
Date: Wed, 24 Feb 2021 10:25:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAPhsuW5s6fk3kua=9Z9o3VPCcN1wdUqXybXm9cp4arJW5+oBvQ@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 25 Feb 2021 04:27:13 -0500
Cc: Mike Snitzer <snitzer@redhat.com>, linux-raid <linux-raid@vger.kernel.org>,
	dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>,
	Donald Buczek <buczek@molgen.mpg.de>, it+raid@molgen.mpg.de
Subject: Re: [dm-devel] [PATCH V2] md: don't unregister sync_thread with
 reconfig_mutex held
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 2/24/21 10:09, Song Liu wrote:
> On Mon, Feb 15, 2021 at 3:08 AM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>>
>> [+cc Donald]
>>
>> Am 13.02.21 um 01:49 schrieb Guoqing Jiang:
>>> Unregister sync_thread doesn't need to hold reconfig_mutex since it
>>> doesn't reconfigure array.
>>>
>>> And it could cause deadlock problem for raid5 as follows:
>>>
>>> 1. process A tried to reap sync thread with reconfig_mutex held after echo
>>>      idle to sync_action.
>>> 2. raid5 sync thread was blocked if there were too many active stripes.
>>> 3. SB_CHANGE_PENDING was set (because of write IO comes from upper layer)
>>>      which causes the number of active stripes can't be decreased.
>>> 4. SB_CHANGE_PENDING can't be cleared since md_check_recovery was not able
>>>      to hold reconfig_mutex.
>>>
>>> More details in the link:
>>> https://lore.kernel.org/linux-raid/5ed54ffc-ce82-bf66-4eff-390cb23bc1ac@molgen.mpg.de/T/#t
>>>
>>> And add one parameter to md_reap_sync_thread since it could be called by
>>> dm-raid which doesn't hold reconfig_mutex.
>>>
>>> Reported-and-tested-by: Donald Buczek <buczek@molgen.mpg.de>
>>> Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
> 
> I don't really like this fix. But I haven't got a better (and not too
> complicated)
> alternative.
> 
>>> ---
>>> V2:
>>> 1. add one parameter to md_reap_sync_thread per Jack's suggestion.
>>>
>>>    drivers/md/dm-raid.c |  2 +-
>>>    drivers/md/md.c      | 14 +++++++++-----
>>>    drivers/md/md.h      |  2 +-
>>>    3 files changed, 11 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
>>> index cab12b2..0c4cbba 100644
>>> --- a/drivers/md/dm-raid.c
>>> +++ b/drivers/md/dm-raid.c
>>> @@ -3668,7 +3668,7 @@ static int raid_message(struct dm_target *ti, unsigned int argc, char **argv,
>>>        if (!strcasecmp(argv[0], "idle") || !strcasecmp(argv[0], "frozen")) {
>>>                if (mddev->sync_thread) {
>>>                        set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>>> -                     md_reap_sync_thread(mddev);
>>> +                     md_reap_sync_thread(mddev, false);
> 
> I think we can add mddev_lock() and mddev_unlock() here and then we don't
> need the extra parameter?
> 

I thought it too, but I would prefer get the input from DM people first.

@ Mike or Alasdair


Thanks,
Guoqing

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

