From: Neil Brown <neilb@suse.de>
Subject: Re: =?iso-8859-2?Q?INFO:_task_md2=5Fresync:7950_blocked_for_more_than_120_seconds?=
Date: Wed, 21 May 2008 21:41:57 +1000
Message-ID: <18484.2693.62883.535755@notabene.brown>
References: <8a6b34b03e0524aa66c862534fee9b7a@www3.mail.volny.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from wylda@volny.cz on Sunday May 4
Sender: linux-raid-owner@vger.kernel.org
To: wylda@volny.cz
Cc: dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

On Sunday May 4, wylda@volny.cz wrote:
> Hello,
> 
> today i noticed in syslog some strange entries triggered by checkarray.
> I cannot judge if those are harmless messages or it means, that something
> bad is happening. So is it bad or just a bug?

Hi,
 your attachment was very large and so the original mail didn't go out
to the list but went to the moderator instead, and I ended up with it
(thanks Alasdair!).

The syslog contained lots of things like:

May  4 00:57:02 ss4000 mdadm: RebuildStarted event detected on md device /dev/md0
May  4 00:57:02 ss4000 kernel: md: delaying data-check of md1 until md2 has finished (they share one or more physical units)
May  4 00:57:02 ss4000 kernel: md: delaying data-check of md2 until md0 has finished (they share one or more physical units)
May  4 01:20:26 ss4000 kernel: INFO: task md1_resync:7949 blocked for more than 120 seconds.
May  4 01:20:26 ss4000 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
May  4 01:20:26 ss4000 kernel: md1_resync    D c02c01b8     0  7949      2
May  4 01:20:26 ss4000 kernel: [<c02bff50>] (schedule+0x0/0x2d4) from [<c0221ed0>] (md_do_sync+0x1dc/0x950)
May  4 01:20:26 ss4000 kernel: [<c0221cf4>] (md_do_sync+0x0/0x950) from [<c02237a0>] (md_thread+0x114/0x130)
May  4 01:20:26 ss4000 kernel: [<c022368c>] (md_thread+0x0/0x130) from [<c004ea7c>] (kthread+0x5c/0x94)
May  4 01:20:26 ss4000 kernel: [<c004ea20>] (kthread+0x0/0x94) from [<c003c3dc>] (do_exit+0x0/0x328)
May  4 01:20:26 ss4000 kernel:  r6:00000000 r5:00000000 r4:00000000
May  4 01:20:27 ss4000 kernel: no locks held by md1_resync/7949.
May  4 01:20:27 ss4000 kernel: INFO: task md2_resync:7950 blocked for more than 120 seconds.

suggesting that 'md1_resync' was blocked waiting for disk IO for 2 minutes
multiple times.

I have heard of another case of this happening when the md arrays were
built on top of dm logical volumes.

Could you please report exactly what kernel and distro you are using,
and describe your storage setup (what devices, what LVM, DM, MD, loop,
crypto, filesystem,.... is being used and how).

NeilBrown
