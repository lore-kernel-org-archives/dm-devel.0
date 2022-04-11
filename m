Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECED5C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 11 Apr 2022 07:43:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-539-wVg2JHEqNAS8gQWOYtjWXA-1; Mon, 11 Apr 2022 03:43:12 -0400
X-MC-Unique: wVg2JHEqNAS8gQWOYtjWXA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 02E301C068C5;
	Mon, 11 Apr 2022 07:43:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 94572145B97F;
	Mon, 11 Apr 2022 07:43:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 65FBA19451F2;
	Mon, 11 Apr 2022 07:43:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0863D19466DF
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Apr 2022 07:43:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E78EFC44AEC; Mon, 11 Apr 2022 07:43:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E36E5C44AF6
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 07:43:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E14FF811E7A
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 07:43:07 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-KmICZjcDOnaXy_VaNCFu7A-2; Mon, 11 Apr 2022 03:43:06 -0400
X-MC-Unique: KmICZjcDOnaXy_VaNCFu7A-2
X-IronPort-AV: E=Sophos;i="5.90,251,1643644800"; d="scan'208";a="202463036"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 11 Apr 2022 15:43:01 +0800
IronPort-SDR: 5CO1SDn15rC1zU1Nl5Bm+tMsnwYNX1bOZt8yaaMGDuSUfM0lARu9EUnVR/E54WwjBDsOHA7ayb
 bje8oVSr3HLue2b+00s9xNiVodfIZ0RsJ/+SYjoGFIddmHAKZF+i8h3v7tJPeSQ0wLeha7udC5
 GckXLn54oel+SMF06F/PIntz9q/XxOxsPUmxOTUcZPpyoruVjXw5xGgltW9Kx6H+A079UU/znT
 ipeVwiW/kcnxdsNIgqFIrcUkDM5hcFe20xIiZcDC55aPSfXGLY1aAF5VNHpodQLUkSY08XMpMO
 lMZ9KTlVhuWRHhBBEYXtZ3dS
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 11 Apr 2022 00:14:21 -0700
IronPort-SDR: dh1iztLVqbQNDk2gJvxid486ALj721cpdLky8CZ9i4ItSbmqRQw+wcIhJlO9ueKSCgFGGOfpgk
 AlyXZoPhExNAgHwu4w3NxI7cDhUWWyQax0bS5AGI50dUtPUIYe6MIrGLRn9zZYb3EePOZ+QGGw
 bMmpGbFfY4DjVRq6ycD5UAxzWaIFrp0kYkg5gDWPfA9NBeST/RlNGaNGTjTDrZPDFmSkhad3bb
 UgYCbAHJtcjEql0LLji0ZIgr8uFA6CYLEk5KxEn0n2lL23Wh3Tapt+7i0Wttg/xc5fWxJekTd1
 jOY=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 11 Apr 2022 00:43:03 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KcLS71F5Qz1SVnx
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 00:43:03 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id Fi9TJOebsuJA for <dm-devel@redhat.com>;
 Mon, 11 Apr 2022 00:43:02 -0700 (PDT)
Received: from [10.225.163.9] (unknown [10.225.163.9])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KcLS52pG9z1Rvlx;
 Mon, 11 Apr 2022 00:43:01 -0700 (PDT)
Message-ID: <54279bbe-6e8b-2c0a-90fc-825b89863b3f@opensource.wdc.com>
Date: Mon, 11 Apr 2022 16:42:59 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
To: Ming Lei <ming.lei@redhat.com>
References: <20220408171254.935171-1-ming.lei@redhat.com>
 <20220408171254.935171-2-ming.lei@redhat.com>
 <8b9078c2-7884-a5b5-5aa9-ad284b4068ef@opensource.wdc.com>
 <YlN4BC2qbGODxbVz@T590>
 <95d8a8ed-27f8-0d88-a543-16910dca83e3@opensource.wdc.com>
 <YlN+plgvwZQdPBGj@T590>
 <7ccf1709-8aec-18c3-1d09-fe03b4a57017@opensource.wdc.com>
 <6b617a59-1591-8323-9de8-b39247eb328f@opensource.wdc.com>
 <YlPZ7vSZGMZBaRDv@T590>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <YlPZ7vSZGMZBaRDv@T590>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH 1/3] dm: don't grab target io reference in
 dm_zone_map_bio
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
Cc: dm-devel@redhat.com, Damien Le Moal <damien.lemoal@wdc.com>,
 Mike Snitzer <snitzer@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/11/22 16:34, Ming Lei wrote:
> On Mon, Apr 11, 2022 at 11:55:14AM +0900, Damien Le Moal wrote:
>> On 4/11/22 11:19, Damien Le Moal wrote:
>>> On 4/11/22 10:04, Ming Lei wrote:
>>>> On Mon, Apr 11, 2022 at 09:50:57AM +0900, Damien Le Moal wrote:
>>>>> On 4/11/22 09:36, Ming Lei wrote:
>>>>>> On Mon, Apr 11, 2022 at 09:18:56AM +0900, Damien Le Moal wrote:
>>>>>>> On 4/9/22 02:12, Ming Lei wrote:
>>>>>>>> dm_zone_map_bio() is only called from __map_bio in which the io's
>>>>>>>> reference is grabbed already, and the reference won't be released
>>>>>>>> until the bio is submitted, so no necessary to do it dm_zone_map_bio
>>>>>>>> any more.
>>>>>>>
>>>>>>> I do not think that this patch is correct. Removing the extra reference on
>>>>>>> the io can lead to problems if the io is completed in the target
>>>>>>> ->map(ti, clone) call or before dm_zone_map_bio_end() is called for the
>>>>>>> DM_MAPIO_SUBMITTED or DM_MAPIO_REMAPPED cases. dm_zone_map_bio_end() needs
>>>>>>
>>>>>> __map_bio():
>>>>>> 	...
>>>>>> 	dm_io_inc_pending(io);
>>>>>> 	...
>>>>>> 	dm_zone_map_bio(tio);
>>>>>> 	...
>>>>>
>>>>> dm-crypt (for instance) may terminate the clone bio immediately in its
>>>>> ->map() function context, resulting in the bio_endio()clone) ->
>>>>> clone_endio() -> dm_io_dec_pending() call chain.
>>>>>
>>>>> With that, the io is gone and dm_zone_map_bio_end() will not have a valid
>>>>> reference on the orig bio.
>>>>
>>>> Any target can complete io during ->map. Here looks nothing is special with
>>>> dm-crypt or dm-zone, why does only dm zone need extra reference?
>>>>
>>>> The reference counter is initialized as 1 in init_clone_info(), dm_io_inc_pending()
>>>> in __map_bio() increases it to 2, so after the above call chain you mentioned is done,
>>>> the counter becomes 1. The original bio can't be completed until dm_io_dec_pending()
>>>> in dm_split_and_process_bio() is called.
>>>>
>>>> Or maybe I miss any extra requirement from dm-zone?
>>>
>>> Something is wrong... With and without your patch, when I setup a dm-crypt
>>> target on top of a zoned nullblk device, I get:
>>>
>>> [  292.596454] device-mapper: uevent: version 1.0.3
>>> [  292.602746] device-mapper: ioctl: 4.46.0-ioctl (2022-02-22)
>>> initialised: dm-devel@redhat.com
>>> [  292.732217] general protection fault, probably for non-canonical
>>> address 0xdffffc0000000002: 0000 [#1] PREEMPT SMP KASAN PTI
>>> [  292.743724] KASAN: null-ptr-deref in range
>>> [0x0000000000000010-0x0000000000000017]
>>> [  292.751409] CPU: 0 PID: 4259 Comm: systemd-udevd Not tainted
>>> 5.18.0-rc2+ #1458
>>> [  292.758746] Hardware name: Supermicro Super Server/X11DPL-i, BIOS 3.3
>>> 02/21/2020
>>> [  292.766250] RIP: 0010:dm_zone_map_bio+0x146/0x1740 [dm_mod]
>>> [  292.771938] Code: 00 00 4d 8b 65 10 48 8d 43 28 48 89 44 24 10 49 8d 44
>>> 24 10 48 89 c2 48 89 44 24 18 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03
>>> <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e 78 0e 00 00 45 8b 7c 24 10 41
>>> [  292.790946] RSP: 0018:ffff8883cd847218 EFLAGS: 00010202
>>> [  292.796260] RAX: dffffc0000000000 RBX: ffff8885c5bcdce8 RCX:
>>> 1ffff11034470027
>>> [  292.803496] RDX: 0000000000000002 RSI: 0000000000000008 RDI:
>>> ffff8885c5bcdc60
>>> [  292.810732] RBP: 1ffff11079b08e4f R08: ffff8881a23801d8 R09:
>>> ffff8881a238013f
>>> [  292.817970] R10: ffff88821c594040 R11: 0000000000000001 R12:
>>> 0000000000000000
>>> [  292.825206] R13: ffff8885c5bcdc50 R14: ffff8881a2380000 R15:
>>> ffff8885c5bcdd08
>>> [  292.832442] FS:  00007fe169b06b40(0000) GS:ffff88880fc00000(0000)
>>> knlGS:0000000000000000
>>> [  292.840646] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [  292.846481] CR2: 00007ffd80a57a38 CR3: 00000004b91b0006 CR4:
>>> 00000000007706f0
>>> [  292.853722] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>>> 0000000000000000
>>> [  292.860957] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
>>> 0000000000000400
>>> [  292.868194] PKRU: 55555554
>>> [  292.870949] Call Trace:
>>> [  292.873446]  <TASK>
>>> [  292.875593]  ? lock_is_held_type+0xd7/0x130
>>> [  292.879860]  ? dm_set_zones_restrictions+0x8f0/0x8f0 [dm_mod]
>>> [  292.885718]  ? __module_address.part.0+0x25/0x300
>>> [  292.890509]  ? is_module_address+0x43/0x70
>>> [  292.894674]  ? static_obj+0x8a/0xc0
>>> [  292.898233]  __map_bio+0x352/0x740 [dm_mod]
>>> [  292.902512]  dm_submit_bio+0x72f/0x17a0 [dm_mod]
>>> [  292.907222]  ? find_held_lock+0x2c/0x110
>>> [  292.911217]  ? __send_empty_flush+0x2b0/0x2b0 [dm_mod]
>>> [  292.916459]  ? lock_release+0x3b2/0x6f0
>>> [  292.920368]  ? lock_downgrade+0x6d0/0x6d0
>>> [  292.924458]  ? lock_is_held_type+0xd7/0x130
>>> [  292.928714]  __submit_bio+0x12a/0x1f0
>>> [  292.932450]  submit_bio_noacct_nocheck+0x324/0x840
>>> [  292.937324]  ? should_fail_request+0x70/0x70
>>> [  292.941670]  ? rcu_read_lock_sched_held+0x3f/0x70
>>> [  292.946458]  ? submit_bio_noacct+0xfa4/0x1530
>>> [  292.950888]  ? lock_is_held_type+0xd7/0x130
>>> [  292.957813]  mpage_readahead+0x32e/0x4b0
>>> [  292.964470]  ? do_mpage_readpage+0x17c0/0x17c0
>>> [  292.971661]  ? blkdev_write_begin+0x20/0x20
>>> [  292.978567]  ? lock_release+0x3b2/0x6f0
>>> [  292.985073]  ? folio_add_lru+0x217/0x3f0
>>> [  292.991620]  ? lock_downgrade+0x6d0/0x6d0
>>> [  292.998237]  read_pages+0x18c/0x990
>>> [  293.004308]  ? memcg_list_lru_alloc+0x810/0x810
>>> [  293.011404]  ? folio_add_lru+0x238/0x3f0
>>> [  293.017805]  ? file_ra_state_init+0xd0/0xd0
>>> [  293.024395]  ? policy_node+0xbb/0x140
>>> [  293.030416]  page_cache_ra_unbounded+0x258/0x410
>>> [  293.037376]  force_page_cache_ra+0x281/0x400
>>> [  293.043944]  filemap_get_pages+0x25e/0x1290
>>> [  293.050342]  ? __lock_acquire+0x1603/0x6180
>>> [  293.056654]  ? filemap_add_folio+0x140/0x140
>>> [  293.063002]  ? lock_is_held_type+0xd7/0x130
>>> [  293.069236]  filemap_read+0x29e/0x910
>>> [  293.074927]  ? filemap_get_pages+0x1290/0x1290
>>> [  293.081378]  ? __lock_acquire+0x1603/0x6180
>>> [  293.087558]  blkdev_read_iter+0x20c/0x640
>>> [  293.093529]  ? cp_new_stat+0x47a/0x590
>>> [  293.099190]  ? cp_old_stat+0x470/0x470
>>> [  293.104795]  new_sync_read+0x2e4/0x520
>>> [  293.110362]  ? __x64_sys_lseek+0x1d0/0x1d0
>>> [  293.116269]  ? lock_acquire+0x1b2/0x4d0
>>> [  293.121928]  ? find_held_lock+0x2c/0x110
>>> [  293.127648]  vfs_read+0x312/0x430
>>> [  293.132755]  ksys_read+0xf3/0x1d0
>>> [  293.137863]  ? __x64_sys_pwrite64+0x1f0/0x1f0
>>> [  293.144032]  do_syscall_64+0x35/0x80
>>> [  293.149391]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>>>
>>> The crash is at: drivers/md/dm-zone.c:499, which is
>>> dm_need_zone_wp_tracking() called from dm_zone_map_bio(). The orig_bio
>>> pointer is invalid. Weird. Investigating.
>>>
>>> Also checking why our weekly test runs did not catch this.
>>
>> This fixes the issue:
>>
>> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
>> index 3c5fad7c4ee6..3dd6735450c5 100644
>> --- a/drivers/md/dm.c
>> +++ b/drivers/md/dm.c
>> @@ -581,7 +581,7 @@ static struct dm_io *alloc_io(struct mapped_device
>> *md, struct bio *bio)
>>         io->status = 0;
>>         atomic_set(&io->io_count, 1);
>>         this_cpu_inc(*md->pending_io);
>> -       io->orig_bio = NULL;
>> +       io->orig_bio = bio;
>>         io->md = md;
>>         io->map_task = current;
>>         spin_lock_init(&io->lock);
>>
>> Otherwise, the dm-zone.c code sees a NULL orig_bio.
>> However, this change may be messing up the bio accounting. Need to check that.
> 
> Looks it is one recent regression since:
> 
> commit 0fbb4d93b38b ("dm: add dm_submit_bio_remap interface")

Yep, saw that. Problem is, I really do not understand that change setting
io->orig_bio *after* __map_bio() is called. It seems that the accounting
is done on each fragment of the orig_bio instead of once for the entire
BIO... So my "fix" above seems wrong. Apart from passing along orig_bio as
an argument to  __map_bio() from __split_and_process_bio(), I do not think
my change is correct. Thoughts ?

-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

