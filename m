Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9785C433EF
	for <dm-devel@archiver.kernel.org>; Thu,  3 Feb 2022 22:50:17 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-301-uTOTz-UuMqWxPmIL8zT8cQ-1; Thu, 03 Feb 2022 17:50:15 -0500
X-MC-Unique: uTOTz-UuMqWxPmIL8zT8cQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7216F1853024;
	Thu,  3 Feb 2022 22:50:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 291EE794A9;
	Thu,  3 Feb 2022 22:50:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C1BE34CA93;
	Thu,  3 Feb 2022 22:50:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 213Mo3Qt021982 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Feb 2022 17:50:04 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D0038C01784; Thu,  3 Feb 2022 22:50:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CC5B4C15E74
	for <dm-devel@redhat.com>; Thu,  3 Feb 2022 22:50:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B12E6185A79C
	for <dm-devel@redhat.com>; Thu,  3 Feb 2022 22:50:03 +0000 (UTC)
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com
	[209.85.215.181]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-613-gOBy63WXOCOvMEhstD467Q-1; Thu, 03 Feb 2022 17:50:02 -0500
X-MC-Unique: gOBy63WXOCOvMEhstD467Q-1
Received: by mail-pg1-f181.google.com with SMTP id s16so3463742pgs.13;
	Thu, 03 Feb 2022 14:50:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
	:content-language:to:cc:references:from:in-reply-to
	:content-transfer-encoding;
	bh=gxtKotbKYVVDliBEkS/8NGZxxXzsaCF/Ghrn8g2asII=;
	b=iA3V6z2DWLeilh5h84B3HBlsei747I3CrTFmbbv1vBP9DMzw7DC0TjAXKShNu4TFms
	9NB6Cl9/16OZG3icDN1i1Tep1NqDOopsG0NynE4TvjdIC6N35EfMlCOnejRGVjnR7Uo5
	VBVrqWiDVpjVjd1NQl03VdVmEo42I3LPHuZLk6SFOaaGsxm71HMzRh9szJmv0jLrLS2T
	lMWsdUKn0HrJG5T3asdy7yngeQ7VXniHCn1FBaP9cfgxHlnAtNW6zJLlJDIS9cSNqi6N
	WaGDkuis5h5L242PvtYo/pu+Fgd0RmP97w89FR+g13XD1DzKuSJPBIxW6IQAoyChUNi0
	sExw==
X-Gm-Message-State: AOAM531NsLqjSc2q4MCrAsPidW7upAzYXb7O0kokUrxCI14AfWtHdla1
	9+tznUWwF3jP22jBC5ZyQKAcxIp+w/4=
X-Google-Smtp-Source: ABdhPJxbVDWLXFrYyts1WDQEZT5xMfsQOnoKDmtKT7LXmg2Sy357f0iLUMQzn3wbo7lsO987Ifcecw==
X-Received: by 2002:a63:91c3:: with SMTP id l186mr225003pge.558.1643928600285; 
	Thu, 03 Feb 2022 14:50:00 -0800 (PST)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net.
	[73.241.217.19])
	by smtp.gmail.com with ESMTPSA id h11sm48342pfe.214.2022.02.03.14.49.58
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Thu, 03 Feb 2022 14:49:59 -0800 (PST)
Message-ID: <a2ec9086-72d2-4a4e-c4fa-fe53bf5ba092@acm.org>
Date: Thu, 3 Feb 2022 14:49:57 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.5.0
To: Mikulas Patocka <mpatocka@redhat.com>
References: <f0e19ae4-b37a-e9a3-2be7-a5afb334a5c3@nvidia.com>
	<20220201102122.4okwj2gipjbvuyux@mpHalley-2>
	<alpine.LRH.2.02.2202011327350.22481@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.2202011331570.22481@file01.intranet.prod.int.rdu2.redhat.com>
	<efd2e976-4d2d-178e-890d-9bde1a89c47f@acm.org>
	<alpine.LRH.2.02.2202031310530.28604@file01.intranet.prod.int.rdu2.redhat.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <alpine.LRH.2.02.2202031310530.28604@file01.intranet.prod.int.rdu2.redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-loop: dm-devel@redhat.com
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [dm-devel] [RFC PATCH 1/3] block: add copy offload support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 2/3/22 10:50, Mikulas Patocka wrote:
> On Tue, 1 Feb 2022, Bart Van Assche wrote:
>> On 2/1/22 10:32, Mikulas Patocka wrote:
>>>    /**
>>> + * blk_queue_max_copy_sectors - set maximum copy offload sectors for the
>>> queue
>>> + * @q:  the request queue for the device
>>> + * @size:  the maximum copy offload sectors
>>> + */
>>> +void blk_queue_max_copy_sectors(struct request_queue *q, unsigned int size)
>>> +{
>>> +	q->limits.max_copy_sectors = size;
>>> +}
>>> +EXPORT_SYMBOL_GPL(blk_queue_max_copy_sectors);
>>
>> Please either change the unit of 'size' into bytes or change its type into
>> sector_t.
> 
> blk_queue_chunk_sectors, blk_queue_max_discard_sectors,
> blk_queue_max_write_same_sectors, blk_queue_max_write_zeroes_sectors,
> blk_queue_max_zone_append_sectors also have the unit of sectors and the
> argument is "unsigned int". Should blk_queue_max_copy_sectors be
> different?

As far as I know using the type sector_t for variables that represent a 
number of sectors is a widely followed convention:

$ git grep -w sector_t | wc -l
2575

I would appreciate it if that convention would be used consistently, 
even if that means modifying existing code.

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

