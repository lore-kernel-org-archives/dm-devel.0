Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2849C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 18 Apr 2022 12:50:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-270-ook6WCOGONuw2MZHul1hiQ-1; Mon, 18 Apr 2022 08:49:57 -0400
X-MC-Unique: ook6WCOGONuw2MZHul1hiQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3E59485A5BC;
	Mon, 18 Apr 2022 12:49:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7173E7BA70B;
	Mon, 18 Apr 2022 12:49:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0B2511947BBB;
	Mon, 18 Apr 2022 12:49:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E867D19451F1
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Apr 2022 12:49:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8011D215CDCD; Mon, 18 Apr 2022 12:49:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B4FF215CDCC
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 12:49:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7AB83833959
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 12:49:35 +0000 (UTC)
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com
 [209.85.215.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-394-9UGyYaYbMwuixaKB9bidfw-1; Mon, 18 Apr 2022 08:49:31 -0400
X-MC-Unique: 9UGyYaYbMwuixaKB9bidfw-1
Received: by mail-pg1-f180.google.com with SMTP id k14so18735271pga.0
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 05:49:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=CaiWu3nB+Cg/cttxtJ9pqGMb0TjM2GrMlztkyQNx6QY=;
 b=zhTdf/TgkZzGA3qMNQCvbwnY2dP8i6LLPVZqVs97X72CKU4Taiu3kD5t98Zi9R7mkB
 IDSJaJUyRUVe7Y2AlWEOolgd8cM0nHpsKYodl0PnANJy8p5C+OOSkHFdH/u2B0KFH/s9
 CMR1o7BOO+CpYI24ZfO3/nB7gdPpoiS9gXN7Ya8ACruIXDFTIPn9uScGfFMFRC65Shr5
 2MJZqNlOOYeodX8+RIU2TqC8RlpqEOIjJEDjlTkrhCXnWLO1LebBuoAUQkERM+fLS1Nk
 +5uYNg6gppQ5ZUs2qPNHVIGEvrvislqgHI9b6UHFDjsjE+r5vG17YXzVHcp093fAizII
 vFYw==
X-Gm-Message-State: AOAM531gsBBCNOQIhtK6GdxC1L7oYJqli8rVYI7C9kdbXXfiiSFepHu1
 CQLh0taeth9+1uocMl8L1Q5ouw==
X-Google-Smtp-Source: ABdhPJxaDcjpr8eUVvSBshPy7Q4ulw2fbWe1yb8COE1i01HHzQw3wiFLl5NK//6SO9XsDDPO6cWWvQ==
X-Received: by 2002:a05:6a00:1a49:b0:505:7ab3:e5c7 with SMTP id
 h9-20020a056a001a4900b005057ab3e5c7mr12259943pfv.62.1650286170578; 
 Mon, 18 Apr 2022 05:49:30 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
 by smtp.gmail.com with ESMTPSA id
 g15-20020a056a0023cf00b004e17e11cb17sm13348104pfc.111.2022.04.18.05.49.29
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 18 Apr 2022 05:49:30 -0700 (PDT)
Message-ID: <5af4e3d8-ce12-e4a7-0805-6f8cc2caa1b9@kernel.dk>
Date: Mon, 18 Apr 2022 06:49:28 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
To: Mike Snitzer <snitzer@kernel.org>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>
References: <20220418022733.56168-1-snitzer@kernel.org>
 <378611be-45ea-6085-7848-83380642c81a@opensource.wdc.com>
 <YlzYJS7gWBbEIaw6@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <YlzYJS7gWBbEIaw6@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [dm-5.19 PATCH 00/21] dm: changes staged for 5.19
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
Cc: dm-devel@redhat.com, hch@lst.de, ming.lei@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/17/22 9:16 PM, Mike Snitzer wrote:
> On Sun, Apr 17 2022 at 11:00P -0400,
> Damien Le Moal <damien.lemoal@opensource.wdc.com> wrote:
> 
>> On 4/18/22 11:27, Mike Snitzer wrote:
>>> Hi,
>>>
>>> This patchset reflects what I've staged in linux-dm.git's "dm-5.19"
>>> branch (also staged in "for-next" for linux-next):
>>> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-5.19
>>>
>>> It build's on jens/for-5.19/block branch (which is based on v5.18-rc3)
>>
>> Mike, thanks for posting. We will run this on zoned stuff to check.
> 
> OK, I appreciate it..
> 
>> Note that patches 13 to 20 are empty...
> 
> Not sure what's going on there... basically any patch that wasn't from
> me (so 1, 13-19) isn't showing up in patchwork or the dm-devel
> archive.

The patches I received look normal, fwiw.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

