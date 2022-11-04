Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4095C433FE
	for <dm-devel@archiver.kernel.org>; Fri,  4 Nov 2022 02:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667529718;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=O/334K7K5mNDo0QcaESGXfAZ92Xgk7EfOUThpu0Tzis=;
	b=VXsQtyZbi+BR1TGngTalrcOX4NCItnxebG1uMWqUu7K+FPaiwqzUpSgXCvJG1lAH9+AV7x
	dbSJFqsZ9T2VW/9QD8wjbAbRzQVyIQu53Og7UoRYhfPRx3TNoLiZbBrRJSXESmEXktUTS2
	NiwwwwwEeY25smnoIwK4gonr0J9+538=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-Keo3fpbxOEesGkNxLQiLNg-1; Thu, 03 Nov 2022 22:41:55 -0400
X-MC-Unique: Keo3fpbxOEesGkNxLQiLNg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9896D29AB41E;
	Fri,  4 Nov 2022 02:41:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 838A0492B21;
	Fri,  4 Nov 2022 02:41:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4CD9A1946597;
	Fri,  4 Nov 2022 02:41:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 48E801946594
 for <dm-devel@listman.corp.redhat.com>; Fri,  4 Nov 2022 02:41:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B91351402BDD; Fri,  4 Nov 2022 02:41:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B1FCB1400070
 for <dm-devel@redhat.com>; Fri,  4 Nov 2022 02:41:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C9FFF1C05AE1
 for <dm-devel@redhat.com>; Fri,  4 Nov 2022 02:41:42 +0000 (UTC)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-594-PTzFPHdSOY2XffC4_UHiZw-1; Thu,
 03 Nov 2022 22:41:31 -0400
X-MC-Unique: PTzFPHdSOY2XffC4_UHiZw-1
To: Mikulas Patocka <mpatocka@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
References: <alpine.LRH.2.21.2211021214390.25745@file01.intranet.prod.int.rdu2.redhat.com>
 <78646e88-2457-81e1-e3e7-cf66b67ba923@linux.dev>
 <alpine.LRH.2.21.2211030851090.10884@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.21.2211031018030.18305@file01.intranet.prod.int.rdu2.redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <5dd07779-5c09-4c75-6e34-392e4c05c3c8@linux.dev>
Date: Fri, 4 Nov 2022 10:41:18 +0800
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.21.2211031018030.18305@file01.intranet.prod.int.rdu2.redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] A crash caused by the commit
 0dd84b319352bb8ba64752d4e45396d8b13e6018
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
Cc: linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-15"; Format="flowed"



On 11/3/22 11:20 PM, Mikulas Patocka wrote:
>
> On Thu, 3 Nov 2022, Mikulas Patocka wrote:
>
>>> BTW, is the mempool_free from endio -> dec_count -> complete_io?
>>> And io which caused the crash is from dm_io -> async_io / sync_io
>>>  =A0-> dispatch_io, seems dm-raid1 can call it instead of dm-raid, so I
>>> suppose the io is for mirror image.
>>>
>>> Thanks,
>>> Guoqing
>> I presume that the bug is caused by destruction of a bio set while bio
>> from that set was in progress. When the bio finishes and an attempt is
>> made to free the bio, a crash happens when the code tries to free the bi=
o
>> into a destroyed mempool.
>>
>> I can do more testing to validate this theory.
>>
>> Mikulas
> When I disable tail-call optimizations with "-fno-optimize-sibling-calls"=
,
> I get this stacktrace:

Just curious, is the option used for compile kernel or lvm? BTW, this=20
trace is
different from previous one, and it is more understandable to me, thanks.

> [  200.105367] Call Trace:
> [  200.105611]  <TASK>
> [  200.105825]  dump_stack_lvl+0x33/0x42
> [  200.106196]  dump_stack+0xc/0xd
> [  200.106516]  mempool_free.cold+0x22/0x32
> [  200.106921]  bio_free+0x49/0x60
> [  200.107239]  bio_put+0x95/0x100
> [  200.107567]  super_written+0x4f/0x120 [md_mod]
> [  200.108020]  bio_endio+0xe8/0x100
> [  200.108359]  __dm_io_complete+0x1e9/0x300 [dm_mod]
> [  200.108847]  clone_endio+0xf4/0x1c0 [dm_mod]
> [  200.109288]  bio_endio+0xe8/0x100
> [  200.109621]  __dm_io_complete+0x1e9/0x300 [dm_mod]
> [  200.110102]  clone_endio+0xf4/0x1c0 [dm_mod]

Assume the above from this chain.

clone_endio -> dm_io_dec_pending -> __dm_io_dec_pending -> dm_io_complete
-> __dm_io_complete -> bio_endio

> [  200.110543]  bio_endio+0xe8/0x100
> [  200.110877]  brd_submit_bio+0xf8/0x123 [brd]
> [  200.111310]  __submit_bio+0x7a/0x120
> [  200.111670]  submit_bio_noacct_nocheck+0xb6/0x2a0
> [  200.112138]  submit_bio_noacct+0x12e/0x3e0
> [  200.112551]  dm_submit_bio_remap+0x46/0xa0 [dm_mod]
> [  200.113036]  flush_expired_bios+0x28/0x2f [dm_delay]

Was flush_expired_bios triggered by the path?

__dm_destroy or __dm_suspend -> suspend_targets -> delay_presuspend
-> del_timer_sync(&dc->delay_timer) -> handle_delayed_timer

> [  200.113536]  process_one_work+0x1b4/0x320
> [  200.113943]  worker_thread+0x45/0x3e0
> [  200.114319]  ? rescuer_thread+0x380/0x380
> [  200.114714]  kthread+0xc2/0x100
> [  200.115035]  ? kthread_complete_and_exit+0x20/0x20
> [  200.115517]  ret_from_fork+0x1f/0x30
> [  200.115874]  </TASK>
>
> The function super_written is obviously buggy, because it first wakes up =
a
> process and then calls bio_put(bio) - so the woken-up process is racing
> with bio_put(bio) and the result is that we attempt to free a bio into a
> destroyed bio set.

Does it mean the woken-up process destroyed the bio set?

The io for super write is allocated from sync_set, and the bio set is=20
mostly destroyed
in md_free_disk or md_stop, I assume md_stop is more relevant here as it=20
is called
by dm-raid.

So I guess the problem is, raid_dtr is called while in flight (or=20
expired) bio still not
completed, maybe lvm issues cmd to call dm_table_destroy and dm was in the
progress of suspend or destroy. Just my $0.02.

> When I fix super_written, there are no longer any crashes. I'm posting a
> patch in the next email.

IIRC, the code existed for a long time, I'd suggest try with mdadm test=20
suite first
with the change. Cc Neil too.

Thanks,
Guoqing

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

