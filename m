Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E95BFC433EF
	for <dm-devel@archiver.kernel.org>; Fri,  4 Feb 2022 07:51:48 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-uR5PkHoKPJWtAkAzzgd9Zw-1; Fri, 04 Feb 2022 02:51:44 -0500
X-MC-Unique: uR5PkHoKPJWtAkAzzgd9Zw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 28A418144E0;
	Fri,  4 Feb 2022 07:51:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ECFC45E49A;
	Fri,  4 Feb 2022 07:51:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2C1E91809CB8;
	Fri,  4 Feb 2022 07:51:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2147i5dV001295 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Feb 2022 02:44:06 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DC7B940885CA; Fri,  4 Feb 2022 07:44:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D85C540885BE
	for <dm-devel@redhat.com>; Fri,  4 Feb 2022 07:44:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F23585A5B9
	for <dm-devel@redhat.com>; Fri,  4 Feb 2022 07:44:05 +0000 (UTC)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com
	[209.85.218.54]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-186-EGJ6o6khP-2nVZuKBEzdkg-1; Fri, 04 Feb 2022 02:44:02 -0500
X-MC-Unique: EGJ6o6khP-2nVZuKBEzdkg-1
Received: by mail-ej1-f54.google.com with SMTP id d10so16731669eje.10;
	Thu, 03 Feb 2022 23:44:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
	:content-language:to:cc:references:from:in-reply-to
	:content-transfer-encoding;
	bh=I+eZ5r9Zo5doiib4NPJfnmz4nNAlQRvPDILFlHosWIo=;
	b=Cw5RWq6e/uthkaNJkGyBrFbrirW+rScqWl6m983GZaL6zpUBmjpspSzPDt7DJjOqFB
	5sfzN72N9G6D8C64QMUCS7rvd4K2yYGFPJkRp942fCtAJsy1I0MtyCprTVcG0ZLzt2ug
	l5ZrWIRELaada7866dhdYNwErDi7PQmxSYIIgy4lHl9wu6bhq4pjNuet79H1AR+lcTMt
	U7ygedhuX2jiHk87MctTATkcUhB6ZwO9g3DgVA6WBoajZHX1kMSntDLOJ7zyX8D5MOpg
	bsvci3j0OmkrjqyDYJ0UB8Dg7iolHPtdjeivnaszCGihK8Fwqv6no/lTeW2B+F2Bijl6
	4cSQ==
X-Gm-Message-State: AOAM530WKIkfSw5ZnGKaAFYdMNZf5H8Bs1nVVyPD9jhXGMIzLD66TN0T
	n55xhVqcOD2ooaMJZgul6G8=
X-Google-Smtp-Source: ABdhPJx1amdsi5+ctCgbOedLbQzMNVsDB7TAIXU/ONObuYY5mkNoRQvRdS4empd7YgKXCXePfLmhfQ==
X-Received: by 2002:a17:907:3f1a:: with SMTP id
	hq26mr1452818ejc.562.1643960640534; 
	Thu, 03 Feb 2022 23:44:00 -0800 (PST)
Received: from [192.168.2.27] (85-70-151-113.rcd.o2.cz. [85.70.151.113])
	by smtp.gmail.com with ESMTPSA id v23sm374545ejf.21.2022.02.03.23.43.59
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Thu, 03 Feb 2022 23:43:59 -0800 (PST)
Message-ID: <e033bbdf-5c07-8085-030d-a9954b321f08@gmail.com>
Date: Fri, 4 Feb 2022 08:43:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.5.1
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
	"Ivanov, Dmitry (HPC)" <dmitry.ivanov2@hpe.com>
References: <SJ0PR84MB18220278F9CA4C597E2467E8C2279@SJ0PR84MB1822.NAMPRD84.PROD.OUTLOOK.COM>
	<yq1tudfz49v.fsf@ca-mkp.ca.oracle.com>
From: Milan Broz <gmazyland@gmail.com>
In-Reply-To: <yq1tudfz49v.fsf@ca-mkp.ca.oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Damien Le Moal <damien.lemoal@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Dmitry Fomichev <dmitry.fomichev@wdc.com>,
	Mike Snitzer <snitzer@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>, "Lyashkov,
	Alexey" <alexey.lyashkov@hpe.com>
Subject: Re: [dm-devel] [PATCH 0/1] t10-pi bio split fix
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 04/02/2022 04:44, Martin K. Petersen wrote:
> 
> Dmitry,
> 
>> My only concern is dm_crypt target which operates on bip_iter directly
>> with the code copy-pasted from bio_integrity_advance:
>>
>> static int dm_crypt_integrity_io_alloc(struct dm_crypt_io *io, struct bio *bio)
>> {
>> 	struct bio_integrity_payload *bip;
>> 	unsigned int tag_len;
>> 	int ret;
>>
>> 	if (!bio_sectors(bio) || !io->cc->on_disk_tag_size)
>> 		return 0;
>>
>> 	bip = bio_integrity_alloc(bio, GFP_NOIO, 1);
>> 	if (IS_ERR(bip))
>> 		return PTR_ERR(bip);
>>
>> 	tag_len = io->cc->on_disk_tag_size * (bio_sectors(bio) >> io->cc->sector_shift);
>>
>> 	bip->bip_iter.bi_size = tag_len;
>> 	bip->bip_iter.bi_sector = io->cc->start + io->sector;
>>                 ^^^
>>
>> 	ret = bio_integrity_add_page(bio, virt_to_page(io->integrity_metadata),
>> 				     tag_len, offset_in_page(io->integrity_metadata));
>> ...
>> }
> 
> I copied Milan and Mike who are more familiar with the dm-drypt internals.

Hi,

What's the problem here you are trying to fix?
Even if I read linux-block posts, I do not understand the context...

Anyway, cc to Mikulas and dm-devel, as dm-integrity/dm-crypt is
the major user of bio_integrity here.

If you touch the code, please be sure you run cryptsetup testsuite
with the integrity tests.
(IOW integritysetup tests and LUKS2 with authenticated encryption
that uses dm-crypt over dm-integrity.)

All we need is that dm-integrity can process bio integrity data
directly. (I know some people do not like it, but this was
the most "elegant" solution here.)

Here dm-crypt uses the data for authenticated encryption (additional
auth tag in bio field), so because dm-crypt owns bio, integrity data
must be allocated in dm-crypt (stacked over dm-integrity).

Milan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

