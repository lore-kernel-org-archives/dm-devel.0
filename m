Return-Path: <SRS0=tlLk=MT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C91F3C432BE
	for <dm-devel@archiver.kernel.org>; Tue, 27 Jul 2021 20:38:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 202F460F9D
	for <dm-devel@archiver.kernel.org>; Tue, 27 Jul 2021 20:38:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 202F460F9D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-NwTJ4KwwOLy76Qfs0fu__w-1; Tue, 27 Jul 2021 16:38:33 -0400
X-MC-Unique: NwTJ4KwwOLy76Qfs0fu__w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 82C38100CA88;
	Tue, 27 Jul 2021 20:38:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4ACA018432;
	Tue, 27 Jul 2021 20:38:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1F45E4BB7C;
	Tue, 27 Jul 2021 20:38:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16RKcQ5u009807 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 27 Jul 2021 16:38:26 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E6652E7792; Tue, 27 Jul 2021 20:38:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DEA95E7785
	for <dm-devel@redhat.com>; Tue, 27 Jul 2021 20:38:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C39C280D2A3
	for <dm-devel@redhat.com>; Tue, 27 Jul 2021 20:38:21 +0000 (UTC)
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com
	[209.85.221.49]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-380-CpayxekfMKObwwsWOW_w5Q-1; Tue, 27 Jul 2021 16:38:19 -0400
X-MC-Unique: CpayxekfMKObwwsWOW_w5Q-1
Received: by mail-wr1-f49.google.com with SMTP id l18so8986282wrv.5;
	Tue, 27 Jul 2021 13:38:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=KPMi5h0wG6VmN+T30wtj1G7lchgByCQoOqYqjiw39eI=;
	b=YHLPggg3hevDc0xeFTRLIv21zYBrbl2DucjZRgRSC22rXTjrnGOlINTsOQi1ylZUXh
	rjFv9Drharo94OFztkUWJZiP3eGokW5OyBUqbnKnLm+mHOtt+xdtHHfnY5vRdfmJQLiQ
	oE5PmlmmH83BImSy0DgIYJTqcTddXk9UVBCWqNXbzNJjkdCOatML+CQOpve4sm4Vf4Pk
	567ltDAVYaMHUICN/IJU9RvOdng2lMwDILx4XXm243y0fl69GcD3kPeIfOrWy9f1ENrF
	7SbnRRdT1NxgzozLWY2HKc1hKFOq3gwA3cM2CPCLe+X5GrpNOLvDTIGhd4UkAAjnf19D
	sDTQ==
X-Gm-Message-State: AOAM533Zn8ouAb5sllLd7oYkbhbJdgkB3noJeVPo9G+sJ3r7v6SRcSTM
	921M7fC54FHvRZzMN4jmN18MzBrceNc=
X-Google-Smtp-Source: ABdhPJzULrhZk2lqdInoI6Mjx/u3ve6ShCM8qkTZhLAl61553LahecpEUl5/CyDMOvLjoxzh+TxJhA==
X-Received: by 2002:a5d:64c2:: with SMTP id f2mr26218030wri.374.1627418298225; 
	Tue, 27 Jul 2021 13:38:18 -0700 (PDT)
Received: from [192.168.2.27] (39.35.broadband4.iol.cz. [85.71.35.39])
	by smtp.gmail.com with ESMTPSA id d67sm4223406wmd.9.2021.07.27.13.38.16
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Tue, 27 Jul 2021 13:38:17 -0700 (PDT)
To: Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>
References: <20210725055458.29008-1-hch@lst.de> <YQAtNkd8T1w/cSLc@redhat.com>
	<20210727160226.GA17989@lst.de> <YQAxyjrGJpl7UkNG@redhat.com>
From: Milan Broz <gmazyland@gmail.com>
Message-ID: <9c719e1d-f8da-f1f3-57a9-3802aa1312d4@gmail.com>
Date: Tue, 27 Jul 2021 22:38:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YQAxyjrGJpl7UkNG@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com
Subject: Re: [dm-devel] use regular gendisk registration in device mapper
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 27/07/2021 18:18, Mike Snitzer wrote:
> On Tue, Jul 27 2021 at 12:02P -0400,
> Christoph Hellwig <hch@lst.de> wrote:
> 
>> On Tue, Jul 27, 2021 at 11:58:46AM -0400, Mike Snitzer wrote:
>>>> This did not make a different to my testing
>>>> using dmsetup and the lvm2 tools.
>>>
>>> I'll try these changes running through the lvm2 testsuite.
>>
>> Btw, is ther documentation on how to run it somewhere?  I noticed
>> tests, old-tests and unit-tests directories, but no obvious way
>> to run them.
> 
> I haven't tracked how it has changed in a while, but I always run:
> make check_local
> 
> (but to do that you first need to ./configure how your distro does
> it... so that all targets are enabled, etc. Then: make).
> 
> Will revisit this shortly and let you know if my process needed to
> change at all due to lvm2 changes.

BTW it would be also nice to run cryptsetup testsuite as root - we do a lot
of DM operations there (and we depend on sysfs on some places).

You can just run configure, make and then make check.

Thanks,
Milan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

