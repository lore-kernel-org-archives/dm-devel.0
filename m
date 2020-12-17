Return-Path: <SRS0=NZHG=FV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8868BC4361B
	for <dm-devel@archiver.kernel.org>; Thu, 17 Dec 2020 23:47:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7B3C122511
	for <dm-devel@archiver.kernel.org>; Thu, 17 Dec 2020 23:47:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7B3C122511
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=matrixstorm.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-553-ikNrXOFoPsmF773VfipxoA-1; Thu, 17 Dec 2020 18:46:57 -0500
X-MC-Unique: ikNrXOFoPsmF773VfipxoA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 519AD1005504;
	Thu, 17 Dec 2020 23:46:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C144866A16;
	Thu, 17 Dec 2020 23:46:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 076074BB7B;
	Thu, 17 Dec 2020 23:46:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BHNhUAg014440 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 17 Dec 2020 18:43:31 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 93DA92026D35; Thu, 17 Dec 2020 23:43:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8EBE32026D48
	for <dm-devel@redhat.com>; Thu, 17 Dec 2020 23:43:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ED7AD811E76
	for <dm-devel@redhat.com>; Thu, 17 Dec 2020 23:43:26 +0000 (UTC)
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de
	[85.215.255.22]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-124-4wLYDuV_Mi2FZJxX3FZCcA-1; Thu, 17 Dec 2020 18:43:23 -0500
X-MC-Unique: 4wLYDuV_Mi2FZJxX3FZCcA-1
X-RZG-AUTH: ":P3gBZUipdd99EFhDYOISZA2ym5zGOgAd5ykVVQQWw7fG5QErre8LbX52SwnSyIMB1hwG6B8omT6f"
X-RZG-CLASS-ID: mo00
Received: from [172.24.6.159] by smtp.strato.de (RZmta 47.9.2 DYNA|AUTH)
	with ESMTPSA id h07c8dwBHNeG43B
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
	Fri, 18 Dec 2020 00:40:16 +0100 (CET)
From: "S. Baerwolf" <stephan@matrixstorm.com>
To: dm-devel@redhat.com
References: <alpine.LRH.2.02.2009241225310.22728@file01.intranet.prod.int.rdu2.redhat.com>
	<CAMeeMh87GLea=7_4qGuPhMj0WKnB-596HzkKQDafLirHiBpSzQ@mail.gmail.com>
	<20200924170047.GB14650@redhat.com>
	<CAMeeMh-KfeEFAZE9v_UiDx_TELg3twKg6Ayvbbaf=NwYJ-8Csg@mail.gmail.com>
	<CAMeeMh-6kdN_73qc3uH_UVqbWyo07nWR8yhypVcboyXry-2N9A@mail.gmail.com>
X-Mozilla-News-Host: news://infosun2.rus.uni-stuttgart.de
Message-ID: <f1c2c572-48c7-f94c-6fc4-c8967e9b97c8@matrixstorm.com>
Date: Fri, 18 Dec 2020 00:40:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <CAMeeMh-6kdN_73qc3uH_UVqbWyo07nWR8yhypVcboyXry-2N9A@mail.gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>, John Dorminy <jdorminy@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: [dm-devel] dm-raid: stack limits instead of overwriting them.
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
Content-Type: multipart/mixed; boundary="------------1439CA659FE57919E55904E1"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------1439CA659FE57919E55904E1
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi

I just saw your posts right now. (After posting my text "[PATCH] dm-raid: set discard_granularity non-zero if possible" yesterday)

How about iterating over all meta-devices corresponding to the raid1? Having mixed technology devices (TRIM and nonTRIM) I assume discard should be switched off? So using lcm_with_zero would be more suitable?

BR Stephan


On 24.09.20 18:56, John Dorminy wrote:

> On Thu, Sep 24, 2020 at 1:24 PM John Dorminy <jdorminy@redhat.com> wrote:
>>
>> I am impressed at how much I read wrong...
>>
>> On Thu, Sep 24, 2020 at 1:00 PM Mike Snitzer <snitzer@redhat.com> wrote:
>>>
>>> On Thu, Sep 24 2020 at 12:45pm -0400,
>>> John Dorminy <jdorminy@redhat.com> wrote:
>>>
>>>> I don't understand how this works...
>>>>
>>>> Can chunk_size_bytes be 0? If not, how is discard_granularity being set to 0?
>>>
>>> Yeah, I had same question.. see the reply I just sent in this thread:
>>> https://www.redhat.com/archives/dm-devel/2020-September/msg00568.html
>>>
>>>> I think also limits is local to the ti in question here, initialized
>>>> by blk_set_stacking_limits() via dm-table.c, and therefore has only
>>>> default values and not anything to do with the underlying queue. So
>>>> setting discard_granularity=max(discard_granularity, chunk_size_bytes)
>>>> doesn't seem like it should be working, unless I'm not understanding
>>>> what it's there for...
>>>
>>> You're reading the dm-table.c limits stacking wrong. Of course DM stack
>>> up the underlying device(s) limits ;)
>>
>> Yep, I failed to read iterate_devices...
>>
>>>
>>>>
>>>> And shouldn't melding in the target's desired io_hints into the
>>>> existing queue limits be happening in blk_stack_limits() instead?
>>>> (Also, it does lcm_not_zero() for stacking granularity, instead of
>>>> max()...)
>>>>
>>>
>>> DM core does do that, the .io_hints hook in the DM target is reserved
>>> for when the target has additional constraints that blk_stack_limits()
>>> didn't/couldn't factor in.
>> Yes, I had erroneously thought the limit-stacking was after getting
>> the targets' individual limits, not before.
>>
>>>
>>> And blk_stack_limts() does use max() for discard_granularity.
>> ... I'm just terrible at reading this morning.
>>
>> Thanks for pointing out all the things I misread!
>
> Actually, though, I don't understand why it should be max instead of
> lcm_not_zero(). If the raid's chunk size is 1024 sectors, say, and
> you're constructing it on something that has discard_granularity 812
> sectors, say, blkdev_issue_discard will be generating 1024 sector IOs
> which will work poorly when passed down to the 812-sector-granularity
> underlying device. While, if lcm(812,1024) were used, lcm(812,1024)
> sector IOs would be compatible with both the chunk size and underlying
> device's granularity, perhaps? Maybe I'm missing something, but I read
> the doc and code an extra time around this time ;)
>
>>
>>>
>>> Mike
>>>
>>>>
>>>> On Thu, Sep 24, 2020 at 12:29 PM Mikulas Patocka <mpatocka@redhat.com> wrote:
>>>>>
>>>>> This patch fixes a warning WARN_ON_ONCE(!q->limits.discard_granularity).
>>>>> The reason is that the function raid_io_hints overwrote
>>>>> limits->discard_granularity with zero. We need to properly stack the
>>>>> limits instead of overwriting them.
>>>>>
>>>>> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>>>>> Cc: stable@vger.kernel.org
>>>>>
>>>>> ---
>>>>> drivers/md/dm-raid.c | 4 ++--
>>>>> 1 file changed, 2 insertions(+), 2 deletions(-)
>>>>>
>>>>> Index: linux-2.6/drivers/md/dm-raid.c
>>>>> ===================================================================
>>>>> --- linux-2.6.orig/drivers/md/dm-raid.c 2020-09-24 18:16:45.000000000 +0200
>>>>> +++ linux-2.6/drivers/md/dm-raid.c 2020-09-24 18:16:45.000000000 +0200
>>>>> @@ -3734,8 +3734,8 @@ static void raid_io_hints(struct dm_targ
>>>>> * RAID0/4/5/6 don't and process large discard bios properly.
>>>>> */
>>>>> if (rs_is_raid1(rs) || rs_is_raid10(rs)) {
>>>>> - limits->discard_granularity = chunk_size_bytes;
>>>>> - limits->max_discard_sectors = rs->md.chunk_sectors;
>>>>> + limits->discard_granularity = max(limits->discard_granularity, chunk_size_bytes);
>>>>> + limits->max_discard_sectors = min_not_zero(limits->max_discard_sectors, (unsigned)rs->md.chunk_sectors);
>>>>> }
>>>>> }
>>>>>
>>>>>
>>>>> --
>>>>> dm-devel mailing list
>>>>> dm-devel@redhat.com
>>>>> https://www.redhat.com/mailman/listinfo/dm-devel
>>>>>
>>>>
>>>
>



--------------1439CA659FE57919E55904E1
Content-Type: text/x-patch; charset=UTF-8;
	name="0001-dm-raid-set-discard_granularity-non-zero-if-possible.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0001-dm-raid-set-discard_granularity-non-zero-if-possible.pa";
	filename*1="tch"

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 8d2b835d7a10..4c769fd93ced 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3734,8 +3734,36 @@ static void raid_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	 * RAID0/4/5/6 don't and process large discard bios properly.
 	 */
 	if (rs_is_raid1(rs) || rs_is_raid10(rs)) {
-		limits->discard_granularity = chunk_size_bytes;
-		limits->max_discard_sectors = rs->md.chunk_sectors;
+        /* HACK */
+        if (chunk_size_bytes==0) {
+            unsigned int i, chunk_sectors=(UINT_MAX >>  SECTOR_SHIFT);
+            struct request_queue *q = NULL;
+
+            DMINFO("chunk_size is 0 for raid1 - preventing issue with TRIM");
+
+            for (i=0;i<rs->raid_disks;i++) {
+                q=bdev_get_queue(rs->dev[i].meta_dev->bdev);
+                if (chunk_sectors >  q->limits.max_discard_sectors) {
+                    chunk_sectors = q->limits.max_discard_sectors;
+                }
+                if (chunk_size_bytes < q->limits.discard_granularity) {
+                    chunk_size_bytes = q->limits.discard_granularity;
+                }
+
+                /* lcm(x,y,...,0) = 0 */
+                if (q->limits.discard_granularity == 0) {
+                    chunk_size_bytes = 0;
+                    break;
+                }
+            }
+
+            limits->discard_granularity = chunk_size_bytes;
+            limits->max_discard_sectors = chunk_sectors;
+        /* end of HACK (but not of if) */
+        } else {
+            limits->discard_granularity = chunk_size_bytes;
+            limits->max_discard_sectors = rs->md.chunk_sectors;
+        }
 	}
 }
 


--------------1439CA659FE57919E55904E1
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
--------------1439CA659FE57919E55904E1--

