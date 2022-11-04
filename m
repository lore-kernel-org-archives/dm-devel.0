Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72ADCC433FE
	for <dm-devel@archiver.kernel.org>; Fri,  4 Nov 2022 13:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667569261;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=DiB2Hr3wPKIxyygAOCCX7NihUtd0rLIjzlKW3cg+Uns=;
	b=Coi6yiIFUDy+v+7G9STrO9k3v2gNb8vKtibk3BvZ/M7pGcbHOkzhryv4hhTlZ2Mg5+aFfW
	kcUJs8fhz9oQ9C7Cd1iipxmiTLZ40bHucl+K74XhgTdo6Hw4OhfasE0V434XbNVTBuS5QL
	5xgOjAVLHfp82D9n4AdXreU18h9/uvs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-Lin6MVGKP2yOHj5QotghLg-1; Fri, 04 Nov 2022 09:41:00 -0400
X-MC-Unique: Lin6MVGKP2yOHj5QotghLg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EB8C52815202;
	Fri,  4 Nov 2022 13:40:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9BDAC140EBF5;
	Fri,  4 Nov 2022 13:40:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6D6AD1946587;
	Fri,  4 Nov 2022 13:40:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 26BBB1946586
 for <dm-devel@listman.corp.redhat.com>; Fri,  4 Nov 2022 13:40:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 169094B400F; Fri,  4 Nov 2022 13:40:55 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F2B464B4016;
 Fri,  4 Nov 2022 13:40:54 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 2A4Desr6002893; Fri, 4 Nov 2022 09:40:54 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 2A4Desg2002889; Fri, 4 Nov 2022 09:40:54 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Fri, 4 Nov 2022 09:40:54 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Guoqing Jiang <guoqing.jiang@linux.dev>
In-Reply-To: <5dd07779-5c09-4c75-6e34-392e4c05c3c8@linux.dev>
Message-ID: <alpine.LRH.2.21.2211040909470.19553@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.21.2211021214390.25745@file01.intranet.prod.int.rdu2.redhat.com>
 <78646e88-2457-81e1-e3e7-cf66b67ba923@linux.dev>
 <alpine.LRH.2.21.2211030851090.10884@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.21.2211031018030.18305@file01.intranet.prod.int.rdu2.redhat.com>
 <5dd07779-5c09-4c75-6e34-392e4c05c3c8@linux.dev>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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
Cc: linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Zdenek Kabelac <zkabelac@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed;
 BOUNDARY="185206533-1296177131-1667568533=:19553"
Content-ID: <alpine.LRH.2.21.2211040938110.19553@file01.intranet.prod.int.rdu2.redhat.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
--185206533-1296177131-1667568533=:19553
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LRH.2.21.2211040938111.19553@file01.intranet.prod.int.rdu2.redhat.com>



On Fri, 4 Nov 2022, Guoqing Jiang wrote:

> 
> 
> On 11/3/22 11:20 PM, Mikulas Patocka wrote:
> > 
> > On Thu, 3 Nov 2022, Mikulas Patocka wrote:
> > 
> > > > BTW, is the mempool_free from endio -> dec_count -> complete_io?
> > > > And io which caused the crash is from dm_io -> async_io / sync_io
> > > >   -> dispatch_io, seems dm-raid1 can call it instead of dm-raid, so I
> > > > suppose the io is for mirror image.
> > > > 
> > > > Thanks,
> > > > Guoqing
> > > I presume that the bug is caused by destruction of a bio set while bio
> > > from that set was in progress. When the bio finishes and an attempt is
> > > made to free the bio, a crash happens when the code tries to free the bio
> > > into a destroyed mempool.
> > > 
> > > I can do more testing to validate this theory.
> > > 
> > > Mikulas
> > When I disable tail-call optimizations with "-fno-optimize-sibling-calls",
> > I get this stacktrace:
> 
> Just curious, is the option used for compile kernel or lvm?

I used it to compile the kernel. I set
export KCFLAGS="-march=barcelona -fno-optimize-sibling-calls"
and recompiled the kernel.

> BTW, this trace is different from previous one, and it is more 
> understandable to me, thanks.
> 
> > [  200.105367] Call Trace:
> > [  200.105611]  <TASK>
> > [  200.105825]  dump_stack_lvl+0x33/0x42
> > [  200.106196]  dump_stack+0xc/0xd
> > [  200.106516]  mempool_free.cold+0x22/0x32
> > [  200.106921]  bio_free+0x49/0x60
> > [  200.107239]  bio_put+0x95/0x100
> > [  200.107567]  super_written+0x4f/0x120 [md_mod]
> > [  200.108020]  bio_endio+0xe8/0x100
> > [  200.108359]  __dm_io_complete+0x1e9/0x300 [dm_mod]
> > [  200.108847]  clone_endio+0xf4/0x1c0 [dm_mod]
> > [  200.109288]  bio_endio+0xe8/0x100
> > [  200.109621]  __dm_io_complete+0x1e9/0x300 [dm_mod]
> > [  200.110102]  clone_endio+0xf4/0x1c0 [dm_mod]
> 
> Assume the above from this chain.
> 
> clone_endio -> dm_io_dec_pending -> __dm_io_dec_pending -> dm_io_complete
> -> __dm_io_complete -> bio_endio
> 
> > [  200.110543]  bio_endio+0xe8/0x100
> > [  200.110877]  brd_submit_bio+0xf8/0x123 [brd]
> > [  200.111310]  __submit_bio+0x7a/0x120
> > [  200.111670]  submit_bio_noacct_nocheck+0xb6/0x2a0
> > [  200.112138]  submit_bio_noacct+0x12e/0x3e0
> > [  200.112551]  dm_submit_bio_remap+0x46/0xa0 [dm_mod]
> > [  200.113036]  flush_expired_bios+0x28/0x2f [dm_delay]
> 
> Was flush_expired_bios triggered by the path?
> 
> __dm_destroy or __dm_suspend -> suspend_targets -> delay_presuspend
> -> del_timer_sync(&dc->delay_timer) -> handle_delayed_timer

No - del_timer_sync doesn't call handle_delayed_timer.

The timer was set by "mod_timer(&dc->delay_timer, expires);". When the 
time expires, it calls handle_delayed_timer. handle_delayed_timer calls 
"queue_work(dc->kdelayd_wq, &dc->flush_expired_bios);" - this submits a 
work item that calls "flush_expired_bios" and triggers this stacktrace.

> > [  200.113536]  process_one_work+0x1b4/0x320
> > [  200.113943]  worker_thread+0x45/0x3e0
> > [  200.114319]  ? rescuer_thread+0x380/0x380
> > [  200.114714]  kthread+0xc2/0x100
> > [  200.115035]  ? kthread_complete_and_exit+0x20/0x20
> > [  200.115517]  ret_from_fork+0x1f/0x30
> > [  200.115874]  </TASK>
> > 
> > The function super_written is obviously buggy, because it first wakes up a
> > process and then calls bio_put(bio) - so the woken-up process is racing
> > with bio_put(bio) and the result is that we attempt to free a bio into a
> > destroyed bio set.
> 
> Does it mean the woken-up process destroyed the bio set?

Yes.

> The io for super write is allocated from sync_set, and the bio set is 
> mostly destroyed in md_free_disk or md_stop, I assume md_stop is more 
> relevant here as it is called by dm-raid.

Yes.

> So I guess the problem is, raid_dtr is called while in flight (or 
> expired) bio still not completed,

When device mapper calls raid_dtr, there are no external bios in progress 
(this is guaranteed by dm design). However, the bio that writes the 
superblock is still in progress and it races with the md_stop. I am not an 
expert in md, so I don't know if this is OK or not.

> maybe lvm issues cmd to call dm_table_destroy and dm was in the progress 
> of suspend or destroy. Just my $0.02.
> 
> > When I fix super_written, there are no longer any crashes. I'm posting a
> > patch in the next email.
> 
> IIRC, the code existed for a long time, I'd suggest try with mdadm test 
> suite first with the change. Cc Neil too.

I get an error when attempting to run the testsuite:
[debian:/usr/src/git/mdadm]# ./test
Testing on linux-6.1.0-rc3 kernel
/usr/src/git/mdadm/tests/00createnames... FAILED - see 
/var/tmp/00createnames.log and /var/tmp/fail00createnames.log for details

[debian:/usr/src/git/mdadm]# cat /var/tmp/00createnames.log
+ . /usr/src/git/mdadm/tests/00createnames
++ set -x -e
++ _create /dev/md/name
++ local DEVNAME=/dev/md/name
++ local NAME=
++ [[ -z '' ]]
++ mdadm -CR /dev/md/name -l0 -n 1 /dev/loop0 --force
++ rm -f /var/tmp/stderr
++ case $* in
++ case $* in
++ for args in $*
++ [[ -CR =~ /dev/ ]]
++ for args in $*
++ [[ /dev/md/name =~ /dev/ ]]
++ [[ /dev/md/name =~ md ]]
++ for args in $*
++ [[ -l0 =~ /dev/ ]]
++ for args in $*
++ [[ -n =~ /dev/ ]]
++ for args in $*
++ [[ 1 =~ /dev/ ]]
++ for args in $*
++ [[ /dev/loop0 =~ /dev/ ]]
++ [[ /dev/loop0 =~ md ]]
++ /usr/src/git/mdadm/mdadm --zero /dev/loop0
mdadm: Unrecognised md component device - /dev/loop0
++ for args in $*
++ [[ --force =~ /dev/ ]]
++ /usr/src/git/mdadm/mdadm --quiet -CR /dev/md/name -l0 -n 1 /dev/loop0 
--force --auto=yes
++ rv=1
++ case $* in
++ cat /var/tmp/stderr
mdadm: unexpected failure opening /dev/md127
++ return 1
++ [[ 1 != \0 ]]
++ echo 'Cannot create device.'
Cannot create device.
++ exit 1
mdadm: unexpected failure opening /dev/md127

[debian:/usr/src/git/mdadm]# cat /var/tmp/fail00createnames.log
## debian.vm: saving dmesg.
## debian.vm: saving proc mdstat.
Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
unused devices: <none>
## debian.vm: no array assembled!
## debian.vm: saving dmesg.
## debian.vm: saving proc mdstat.
Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
unused devices: <none>
## debian.vm: no array assembled!
## debian.vm: saving dmesg.
## debian.vm: saving proc mdstat.
Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
unused devices: <none>
## debian.vm: no array assembled!
## debian.vm: saving dmesg.
## debian.vm: saving proc mdstat.
Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
unused devices: <none>
## debian.vm: no array assembled!

> Thanks,
> Guoqing

Mikulas
--185206533-1296177131-1667568533=:19553
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--185206533-1296177131-1667568533=:19553--

