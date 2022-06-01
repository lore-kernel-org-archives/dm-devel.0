Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FC6AC433F5
	for <dm-devel@archiver.kernel.org>; Wed,  1 Jun 2022 03:27:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-261-UnmkOTNjORi4QmZRQ4bsfQ-1; Tue, 31 May 2022 23:27:48 -0400
X-MC-Unique: UnmkOTNjORi4QmZRQ4bsfQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09D2380159B;
	Wed,  1 Jun 2022 03:27:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 384B11121314;
	Wed,  1 Jun 2022 03:27:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 12662194706E;
	Wed,  1 Jun 2022 03:27:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 99984194706A
 for <dm-devel@listman.corp.redhat.com>; Wed,  1 Jun 2022 03:27:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5D55C82882; Wed,  1 Jun 2022 03:27:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 58DEF10725
 for <dm-devel@redhat.com>; Wed,  1 Jun 2022 03:27:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 38D6F1C08987
 for <dm-devel@redhat.com>; Wed,  1 Jun 2022 03:27:43 +0000 (UTC)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com
 [209.85.167.41]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-292-Ibj1CzSGNiK6cZ1lj4aPVQ-1; Tue, 31 May 2022 23:27:40 -0400
X-MC-Unique: Ibj1CzSGNiK6cZ1lj4aPVQ-1
Received: by mail-lf1-f41.google.com with SMTP id l13so606940lfp.11
 for <dm-devel@redhat.com>; Tue, 31 May 2022 20:27:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=uWE/tlnw2tByHU+mXjZ+jRPcFVoufodKiFqk051MZR4=;
 b=AlU4LTp2SkN+hEcVMgjEknLVoq6ZISMqNwjFYVVsLG/8kCYohxF+f04FYyo7GQkgF3
 p6EvR2qWg0vyp2dv1y4p71oF11Y0Hlo3xPC6eeW/iTVZHUykUjyDfzqQN3Ib3zVizPc4
 nGwzWtXYDH3w9RXdzY3r3WTKYKsZPw6qVvndIs1OOEYok7YSFAgGjQCDHIG4Y7evNY/2
 CfuJEEvRay4M0FgS9j+uu/VucZZyxnAvKfIeGfIFey6JvGpHajkyiB4IJnHzSODKW0I/
 LC93Lc/7T0dvvTcet6f41ab0pKltUVmJ7XdlI+45VGp6+l9DDjejbrrQ4d7EGL7wOgCl
 tnfQ==
X-Gm-Message-State: AOAM532R4PB9IyqiC38vIO1ghx74vlZ9Y5UTI9vPttFOxzyy0bA6YbFY
 i8OW1RSx1LtrGNu9sgoga6qzIudGpwKR2lEz
X-Google-Smtp-Source: ABdhPJzatB2O7qy43HFTOdYED0i4F4fVJ+N4n+yDhea/CLDLvvZGS6wSvGM56t/eojTX01SEBIOfJg==
X-Received: by 2002:a5d:6d09:0:b0:20f:bef8:665b with SMTP id
 e9-20020a5d6d09000000b0020fbef8665bmr45911540wrq.548.1654054048882; 
 Tue, 31 May 2022 20:27:28 -0700 (PDT)
Received: from [10.188.163.71] (cust-east-parth2-46-193-73-98.wb.wifirst.net.
 [46.193.73.98]) by smtp.gmail.com with ESMTPSA id
 r12-20020a05600c2c4c00b0039750c29cf7sm473034wmg.40.2022.05.31.20.27.27
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 31 May 2022 20:27:28 -0700 (PDT)
Message-ID: <434b4857-12fd-feb7-7e3e-466831a3f36b@kernel.dk>
Date: Tue, 31 May 2022 21:27:27 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
To: Mike Snitzer <snitzer@redhat.com>
References: <YpK7m+14A+pZKs5k@casper.infradead.org>
 <2523e5b0-d89c-552e-40a6-6d414418749d@kernel.dk>
 <YpZlOCMept7wFjOw@redhat.com>
 <6995e822-79a0-ca17-9c32-6089d14b5be5@kernel.dk>
 <YpZxVH7DRUkrbWUa@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <YpZxVH7DRUkrbWUa@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] bioset_exit poison from dm_destroy
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, david@fromorbit.com,
 Matthew Wilcox <willy@infradead.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 5/31/22 1:49 PM, Mike Snitzer wrote:
> On Tue, May 31 2022 at  3:00P -0400,
> Jens Axboe <axboe@kernel.dk> wrote:
> 
>> On 5/31/22 12:58 PM, Mike Snitzer wrote:
>>> On Sun, May 29 2022 at  8:46P -0400,
>>> Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>>> On 5/28/22 6:17 PM, Matthew Wilcox wrote:
>>>>> Not quite sure whose bug this is.  Current Linus head running xfstests
>>>>> against ext4 (probably not ext4's fault?)
>>>>>
>>>>> 01818 generic/250	run fstests generic/250 at 2022-05-28 23:48:09
>>>>> 01818 EXT4-fs (dm-0): mounted filesystem with ordered data mode. Quota mode: none.
>>>>> 01818 EXT4-fs (dm-0): unmounting filesystem.
>>>>> 01818 EXT4-fs (dm-0): mounted filesystem with ordered data mode. Quota mode: none.
>>>>> 01818 EXT4-fs (dm-0): unmounting filesystem.
>>>>> 01818 EXT4-fs (dm-0): mounted filesystem with ordered data mode. Quota mode: none.
>>>>> 01818 Buffer I/O error on dev dm-0, logical block 3670000, async page read
>>>>> 01818 EXT4-fs (dm-0): unmounting filesystem.
>>>>> 01818 EXT4-fs (dm-0): mounted filesystem with ordered data mode. Quota mode: none.
>>>>> 01818 EXT4-fs (dm-0): unmounting filesystem.
>>>>> 01818 general protection fault, probably for non-canonical address 0xdead000000000122: 0000 [#1] PREEMPT SMP NOPTI
>>>>> 01818 CPU: 0 PID: 1579117 Comm: dmsetup Kdump: loaded Not tainted 5.18.0-11049-g1dec3d7fd0c3-dirty #262
>>>>> 01818 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
>>>>> 01818 RIP: 0010:__cpuhp_state_remove_instance+0xf0/0x1b0
>>>>> 01818 Code: a0 f8 d7 81 42 3b 1c 28 7f d9 4c 89 e1 31 d2 89 de 89 7d dc e8 01 fd ff ff 8b 7d dc eb c5 49 8b 04 24 49 8b 54 24 08 48 85 c0 <48> 89 02 74 04 48 89 50 08 48 b8 00 01 00 00 00 00 ad de 48 c7 c7
>>>>> 01818 RSP: 0018:ffff888101fcfc60 EFLAGS: 00010286
>>>>> 01818 RAX: dead000000000100 RBX: 0000000000000017 RCX: 0000000000000000
>>>>> 01818 RDX: dead000000000122 RSI: ffff8881233b0ae8 RDI: ffffffff81e3b080
>>>>> 01818 RBP: ffff888101fcfc88 R08: 0000000000000008 R09: 0000000000000003
>>>>> 01818 R10: 0000000000000000 R11: 00000000002dc6c0 R12: ffff8881233b0ae8
>>>>> 01818 R13: 0000000000000000 R14: ffffffff81e38f58 R15: ffff88817b5a3c00
>>>>> 01818 FS:  00007ff56daec280(0000) GS:ffff888275800000(0000) knlGS:0000000000000000
>>>>> 01818 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>>> 01818 CR2: 00005591ad94f198 CR3: 000000017b5a0004 CR4: 0000000000770eb0
>>>>> 01818 PKRU: 55555554
>>>>> 01818 Call Trace:
>>>>> 01818  <TASK>
>>>>> 01818  ? kfree+0x66/0x250
>>>>> 01818  bioset_exit+0x32/0x210
>>>>> 01818  cleanup_mapped_device+0x34/0xf0
>>>>> 01818  __dm_destroy+0x149/0x1f0
>>>>> 01818  ? table_clear+0xc0/0xc0
>>>>> 01818  dm_destroy+0xe/0x10
>>>>> 01818  dev_remove+0xd9/0x120
>>>>> 01818  ctl_ioctl+0x1cb/0x420
>>>>> 01818  dm_ctl_ioctl+0x9/0x10
>>>>> 01818  __x64_sys_ioctl+0x89/0xb0
>>>>> 01818  do_syscall_64+0x35/0x80
>>>>> 01818  entry_SYSCALL_64_after_hwframe+0x46/0xb0
>>>>> 01818 RIP: 0033:0x7ff56de3b397
>>>>> 01818 Code: 3c 1c e8 1c ff ff ff 85 c0 79 87 49 c7 c4 ff ff ff ff 5b 5d 4c 89 e0 41 5c c3 66 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d a9 da 0d 00 f7 d8 64 89 01 48
>>>>> 01818 RSP: 002b:00007ffe55367ef8 EFLAGS: 00000206 ORIG_RAX: 0000000000000010
>>>>> 01818 RAX: ffffffffffffffda RBX: 00007ff56df31a8e RCX: 00007ff56de3b397
>>>>> 01818 RDX: 000055daad7cab30 RSI: 00000000c138fd04 RDI: 0000000000000003
>>>>> 01818 RBP: 00007ffe55367fb0 R08: 00007ff56df81558 R09: 00007ffe55367d60
>>>>> 01818 R10: 00007ff56df808a2 R11: 0000000000000206 R12: 00007ff56df808a2
>>>>> 01818 R13: 00007ff56df808a2 R14: 00007ff56df808a2 R15: 00007ff56df808a2
>>>>> 01818  </TASK>
>>>>> 01818 Modules linked in: crct10dif_generic crct10dif_common [last unloaded: crc_t10dif]
>>>>
>>>> I suspect dm is calling bioset_exit() multiple times? Which it probably
>>>> should not.
>>>>
>>>> The reset of bioset_exit() is resilient against this, so might be best
>>>> to include bio_alloc_cache_destroy() in that.
>>>>
>>>>
>>>> diff --git a/block/bio.c b/block/bio.c
>>>> index a3893d80dccc..be3937b84e68 100644
>>>> --- a/block/bio.c
>>>> +++ b/block/bio.c
>>>> @@ -722,6 +722,7 @@ static void bio_alloc_cache_destroy(struct bio_set *bs)
>>>>  		bio_alloc_cache_prune(cache, -1U);
>>>>  	}
>>>>  	free_percpu(bs->cache);
>>>> +	bs->cache = NULL;
>>>>  }
>>>>  
>>>>  /**
>>>
>>> Yes, we need the above to fix the crash.  Does it also make sense to
>>> add this?
>>>
>>> diff --git a/include/linux/bio.h b/include/linux/bio.h
>>> index 49eff01fb829..f410c78e9c0c 100644
>>> --- a/include/linux/bio.h
>>> +++ b/include/linux/bio.h
>>> @@ -681,7 +681,7 @@ struct bio_set {
>>>
>>>  static inline bool bioset_initialized(struct bio_set *bs)
>>>  {
>>> -	return bs->bio_slab != NULL;
>>> +	return (bs->bio_slab != NULL || bs->cache != NULL);
>>>  }
>>
>> Should not be possible to have valid bs->cache without bs->bio_slab?
> 
> Not quite following your question, but I sprinkled this extra check in
> purely because DM core uses bioset_initialized() to verify that the
> bioset is _not_ yet initialized.
> 
> But it really doesn't make sense to consider the bioset _fully_
> initialized if bs->bio_slab is NULL but bs->cache is NOT...

Honestly, I'd be way happier getting rid of bioset_initialized()!

> Anyway, really don't need this change but we do need your earlier
> patch to reset bs->cache to NULL.

Certainly, that patch will be going upstream in a day or two.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

