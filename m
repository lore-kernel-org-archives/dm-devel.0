Return-Path: <SRS0=qgW3=JQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60731C433B4
	for <dm-devel@archiver.kernel.org>; Mon, 19 Apr 2021 14:32:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DEEF861245
	for <dm-devel@archiver.kernel.org>; Mon, 19 Apr 2021 14:32:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DEEF861245
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-533-DstPio6mMOiiKs1gN8LPpA-1; Mon, 19 Apr 2021 10:32:05 -0400
X-MC-Unique: DstPio6mMOiiKs1gN8LPpA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 706706D246;
	Mon, 19 Apr 2021 14:31:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EA66E1893C;
	Mon, 19 Apr 2021 14:31:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BE7B95533F;
	Mon, 19 Apr 2021 14:31:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13JEVs9i002567 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 19 Apr 2021 10:31:54 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 0E4F020824D7; Mon, 19 Apr 2021 14:31:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0921F20824D4
	for <dm-devel@redhat.com>; Mon, 19 Apr 2021 14:31:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 42F59185A7A5
	for <dm-devel@redhat.com>; Mon, 19 Apr 2021 14:31:45 +0000 (UTC)
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com
	[209.85.128.53]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-550-kH2l1-0tMBC2x8lm1lLmng-1; Mon, 19 Apr 2021 10:31:42 -0400
X-MC-Unique: kH2l1-0tMBC2x8lm1lLmng-1
Received: by mail-wm1-f53.google.com with SMTP id
	o9-20020a1c41090000b029012c8dac9d47so11323069wma.1; 
	Mon, 19 Apr 2021 07:31:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=BukaGkqzntQMa+c7UOYXuyLPXisdJBi9+eUzsglGXps=;
	b=f65gz15vzwLlmb9i1nQuXjC54oWAoPV3hz/+BW8awI7NPoHQNIm+C//awMAv1pflp1
	ELQSpixUBFAnyi0ha9mpzQ5yda/0+k1rYza2EbhUW28S6A2GL+wMwbxWU+NitC1j8ARQ
	ifIKXYCkNKfXRGYwDyZKP8trI2ZLtQu9If9Iym8PmNrqLPsfMOEPRkSo/xMrEpyzWBXE
	uJNYULgeYzGjIJupy9Sd0F60w/EPy/fdBaNDthQz6hkRhVvRjq1vaiJHvW93/GVkkqAJ
	KAuviAvjQCQZ4Vr7mzFom/t+O+HrhxCh0pt0BhQLD3zQkt2RiPMhqrxiFcncN2e5RpCq
	vvQQ==
X-Gm-Message-State: AOAM532k30P+rK19+sH7fc7rWbIrZ2kzhuKlh7yUNx7QspcdE8WBig8D
	MQf6jj1pxMZcPzbO/4BAPuc=
X-Google-Smtp-Source: ABdhPJyXzJCtNjiK/RNOQVsENTX2/B34lzG8uvXlRcKqHCUuTavrzJjbLayUoY/kcz51nLnQH0BiPQ==
X-Received: by 2002:a05:600c:4ed1:: with SMTP id
	g17mr21963702wmq.67.1618842701452; 
	Mon, 19 Apr 2021 07:31:41 -0700 (PDT)
Received: from [192.168.2.27] (39.35.broadband4.iol.cz. [85.71.35.39])
	by smtp.gmail.com with ESMTPSA id
	x17sm19334170wmi.46.2021.04.19.07.31.39
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Mon, 19 Apr 2021 07:31:40 -0700 (PDT)
To: Mikulas Patocka <mpatocka@redhat.com>,
	Damien Le Moal <Damien.LeMoal@wdc.com>
References: <20210417023323.852530-1-damien.lemoal@wdc.com>
	<alpine.LRH.2.02.2104190840310.9677@file01.intranet.prod.int.rdu2.redhat.com>
	<BL0PR04MB65147D94E7E30C3E1063A282E7499@BL0PR04MB6514.namprd04.prod.outlook.com>
	<alpine.LRH.2.02.2104190951070.17565@file01.intranet.prod.int.rdu2.redhat.com>
From: Milan Broz <gmazyland@gmail.com>
Message-ID: <896ab66c-525a-749f-bf74-42299e028d77@gmail.com>
Date: Mon, 19 Apr 2021 16:31:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.2104190951070.17565@file01.intranet.prod.int.rdu2.redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Mike Snitzer <snitzer@redhat.com>,
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [PATCH v2 0/3] Fix dm-crypt zoned block device
	support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 19/04/2021 15:55, Mikulas Patocka wrote:
> 
> 
> On Mon, 19 Apr 2021, Damien Le Moal wrote:
> 
>>> I would say that it is incompatible with all dm targets - even the linear 
>>> target is changing the sector number and so it may redirect the write 
>>> outside of the range specified in dm-table and cause corruption.
>>
>> DM remapping of BIO sectors is zone compatible because target entries must be
>> zone aligned. In the case of zone append, the BIO sector always point to the
>> start sector of the target zone. DM sector remapping will remap that to another
>> zone start as all zones are the same size. No issue here. We extensively use
>> dm-linear for various test environment to reduce the size of the device tested
>> (to speed up tests). I am confident there are no problems there.
>>
>>> Instead of complicating device mapper with imperfect support, I would just 
>>> disable REQ_OP_ZONE_APPEND on device mapper at all.
>>
>> That was my initial approach, but for dm-crypt only since other targets that
>> support zoned devices are fine. However, this breaks zoned block device
>> requirement that zone append be supported so that users are presented with a
>> uniform interface for different devices. So while simple to do, disabling zone
>> append is far from ideal.
> 
> So, we could enable it for the linear target and disable for all other 
> targets?
> 
> I talked with Milan about it and he doesn't want to add more bloat to the 
> crypt target. I agree with him.

This is all fine even for dm-crypt IF the tweaking is unique for the sector position
(it can be something just derived from the sector offset in principle).

For FDE, we must never allow writing sectors to different positions with the same
tweak (IV) and key - there are real attacks based on this issue.

So zones can do any recalculation and reshuffling it wants if sector tweak
in dm-crypt is unique.
(Another solution would be to use different keys for different areas, but that
is not possible with dm-crypt or FDE in general, but fs encryption can do that.)

If you want dm-crypt to support zones properly, there is a need for emulation
of the real sector offset - because that is what IV expects now.

And I think such emulation should be in DM core, not in dm-crypt itself, because other
targets can need the same functionality (I guess that dm-integrity journal
has a problem with that already, Mikulas will know more).

For online reencryption we also use multiple targets in the table that dynamically moves
(linear combined with dm-crypt), so dm-crypt must support all commands as
dm-linear to make this work.

I hope I understand the problem correctly; all I want is to so avoid patching
the wrong place (dmcrypt crypto) because that problem will appear elsewhere later.
Also for security it would be nice to not add exceptions to encryption
code - it is always recipe for disaster.

Milan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

