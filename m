Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97747C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 24 Jan 2022 06:26:00 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-Y0pOh3ukNPWEAJRAgEMWXQ-1; Mon, 24 Jan 2022 01:25:55 -0500
X-MC-Unique: Y0pOh3ukNPWEAJRAgEMWXQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3AEAD83DD21;
	Mon, 24 Jan 2022 06:25:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B30B55F77;
	Mon, 24 Jan 2022 06:25:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 110604CA9B;
	Mon, 24 Jan 2022 06:25:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20NLdELY002329 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 23 Jan 2022 16:39:16 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9C99B40CFD11; Sun, 23 Jan 2022 21:39:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 98AD840CFD0B
	for <dm-devel@redhat.com>; Sun, 23 Jan 2022 21:39:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 801D480B711
	for <dm-devel@redhat.com>; Sun, 23 Jan 2022 21:39:14 +0000 (UTC)
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-592-NdXAIx15PLOE4WoWWLb9tg-1; Sun, 23 Jan 2022 16:39:12 -0500
X-MC-Unique: NdXAIx15PLOE4WoWWLb9tg-1
Received: from [192.168.0.2] (ip5f5aeacb.dynamic.kabel-deutschland.de
	[95.90.234.203])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest
	SHA256) (No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id D07E361E6478B;
	Sun, 23 Jan 2022 22:34:03 +0100 (CET)
Message-ID: <70008df6-ef90-6e8d-8a57-9b30077508e7@molgen.mpg.de>
Date: Sun, 23 Jan 2022 22:34:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.5.0
To: Roger Willcocks <roger@filmlight.ltd.uk>
References: <747C2684-B570-473E-9146-E8AB53102236@filmlight.ltd.uk>
	<20220123180058.372f72ce@gecko.fritz.box>
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20220123180058.372f72ce@gecko.fritz.box>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 24 Jan 2022 01:25:45 -0500
Cc: linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Dear Roger,


Am 23.01.22 um 19:00 schrieb Lukas Straub:
> CC'ing Song Liu (md-raid maintainer) and linux-raid mailing list.
> 
> On Fri, 21 Jan 2022 16:38:03 +0000 Roger Willcocks wrote:

>> we noticed a thirty percent drop in performance on one of our raid
>> arrays when switching from CentOS 6.5 to 8.4; it uses raid0-like

For those outside the CentOS universe, what Linux kernel versions are those?

>> striping to balance (by time) access to a pair of hardware raid-6
>> arrays. The underlying issue is also present in the native raid0
>> driver so herewith the gory details; I'd appreciate your thoughts.
>>
>> --
>>
>> blkdev_direct_IO() calls submit_bio() which calls an outermost
>> generic_make_request() (aka submit_bio_noacct()).
>>
>> md_make_request() calls blk_queue_split() which cuts an incoming
>> request into two parts with the first no larger than get_max_io_size()
>> bytes (which in the case of raid0, is the chunk size):
>>
>>    R -> AB
>>    
>> blk_queue_split() gives the second part 'B' to generic_make_request()
>> to worry about later and returns the first part 'A'.
>>
>> md_make_request() then passes 'A' to a more specific request handler,
>> In this case raid0_make_request().
>>
>> raid0_make_request() cuts its incoming request into two parts at the
>> next chunk boundary:
>>
>> A -> ab
>>
>> it then fixes up the device (chooses a physical device) for 'a', and
>> gives both parts, separately, to generic make request()
>>
>> This is where things go awry, because 'b' is still targetted to the
>> original device (same as 'B'), but 'B' was queued before 'b'. So we
>> end up with:
>>
>>    R -> Bab
>>
>> The outermost generic_make_request() then cuts 'B' at
>> get_max_io_size(), and the process repeats. Ascii art follows:
>>
>>
>>      /---------------------------------------------------/   incoming rq
>>
>>      /--------/--------/--------/--------/--------/------/   max_io_size
>>        
>> |--------|--------|--------|--------|--------|--------|--------| chunks
>>
>> |...=====|---=====|---=====|---=====|---=====|---=====|--......| rq out
>>        a    b  c     d  e     f  g     h  i     j  k     l
>>
>> Actual submission order for two-disk raid0: 'aeilhd' and 'cgkjfb'
>>
>> --
>>
>> There are several potential fixes -
>>
>> simplest is to set raid0 blk_queue_max_hw_sectors() to UINT_MAX
>> instead of chunk_size, so that raid0_make_request() receives the
>> entire transfer length and cuts it up at chunk boundaries;
>>
>> neatest is for raid0_make_request() to recognise that 'b' doesn't
>> cross a chunk boundary so it can be sent directly to the physical
>> device;
>>
>> and correct is for blk_queue_split to requeue 'A' before 'B'.
>>
>> --
>>
>> There's also a second issue - with large raid0 chunk size (256K), the
>> segments submitted to the physical device are at least 128K and
>> trigger the early unplug code in blk_mq_make_request(), so the
>> requests are never merged. There are legitimate reasons for a large
>> chunk size so this seems unhelpful.
>>
>> --
>>
>> As I said, I'd appreciate your thoughts.

Thank you for the report and the analysis.

Is the second issue also a regression? If not, I suggest to split it 
into a separate thread.


Kind regards,

Paul

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

