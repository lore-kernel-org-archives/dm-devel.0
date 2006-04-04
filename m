From: "Stefan Majer" <stefan@x-cellent.com>
Subject: [Fwd: Multipath, page allocation failure during bonnie++]
Date: Tue, 4 Apr 2006 08:40:42 +0200 (CEST)
Message-ID: <34881.212.34.68.21.1144132842.squirrel@extern.x-cellent.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,

im currently testing your multipath solution with the following setup:

HP DL585 with 4 DualCore Opterons, 8Gig RAM an 4 Qlogic FC Adapters,
connected to 2 IBM DS8100 Storages through two Broadcom Fabrics.
i Have 4 LUNS, 2 from each Storage Box. I build 2 SW-Raid=B4s with 2 LUNS
each to get host-based-mirroring. The SW-Raid is used as PV for LVM2.
Its a RH4 AS U3 kernel (2.6.9-34) with the device-mapper-multipath 0.45.

After doing some Stresstests with bonnie (4 parallel runs) i got the
following:

Mar 31 10:05:06 arenat11 kernel: bonnie++: page allocation failure.
order:0, mode:0x50
Mar 31 10:05:06 arenat11 kernel:
Mar 31 10:05:06 arenat11 kernel: Call
Trace:<ffffffff8015d06e>{__alloc_pages+846}
<ffffffff8015d105>{__get_free_pages+11}
Mar 31 10:05:06 arenat11 kernel:
<ffffffff801600e4>{kmem_getpages+36}
<ffffffff80160879>{cache_alloc_refill+609}
Mar 31 10:05:06 arenat11 kernel:
<ffffffff801605b7>{kmem_cache_alloc+90}
<ffffffffa00a146b>{:jbd:journal_start+132}
Mar 31 10:05:06 arenat11 kernel:
<ffffffffa00b6ae4>{:ext3:ext3_ordered_writepage+127}
Mar 31 10:05:06 arenat11 kernel:
<ffffffff801641bb>{shrink_zone+3095} <ffffffff8013f4b7>{del_timer+107}
Mar 31 10:05:06 arenat11 kernel:
<ffffffff8013f574>{del_singleshot_timer_sync+9}
<ffffffff80305528>{schedule_timeout+252
}
Mar 31 10:05:06 arenat11 kernel:
<ffffffff801647a5>{try_to_free_pages+303}
<ffffffff80134df2>{autoremove_wake_function+0
}
Mar 31 10:05:06 arenat11 kernel:
<ffffffff8015cf74>{__alloc_pages+596}
<ffffffff8015a6d8>{generic_file_buffered_write+29
5}
Mar 31 10:05:06 arenat11 kernel:
<ffffffffa00be568>{:ext3:__ext3_journal_stop+31}
<ffffffff8013bd7f>{current_fs_time+89}

Mar 31 10:05:06 arenat11 kernel:
<ffffffff8015af36>{__generic_file_aio_write_nolock+731}
Mar 31 10:05:06 arenat11 kernel:
<ffffffff8015b1d4>{generic_file_aio_write_nolock+32}
Mar 31 10:05:06 arenat11 kernel:
<ffffffff8015b29e>{generic_file_aio_write+126}
<ffffffffa00b4ee5>{:ext3:ext3_file_write
+22}
Mar 31 10:05:06 arenat11 kernel:
<ffffffff80177b65>{do_sync_write+173} <ffffffff80304a85>{thread_return+0}
Mar 31 10:05:06 arenat11 kernel:
<ffffffff80304add>{thread_return+88}
<ffffffff80134df2>{autoremove_wake_function+0}
Mar 31 10:05:06 arenat11 kernel:
<ffffffff80191570>{dnotify_parent+34} <ffffffff80177c60>{vfs_write+207}
Mar 31 10:05:06 arenat11 kernel:        <ffffffff80177d48>{sys_write+69}
<ffffffff801101c6>{system_call+126}
Mar 31 10:05:06 arenat11 kernel:
Mar 31 10:05:06 arenat11 kernel: Mem-info:
Mar 31 10:05:06 arenat11 kernel: Node 3 DMA per-cpu: empty
Mar 31 10:05:06 arenat11 kernel: Node 3 Normal per-cpu:
Mar 31 10:05:06 arenat11 kernel: cpu 0 hot: low 32, high 96, batch 16
Mar 31 10:05:06 arenat11 kernel: cpu 0 cold: low 0, high 32, batch 16
Mar 31 10:05:06 arenat11 kernel: cpu 1 hot: low 32, high 96, batch 16
Mar 31 10:05:06 arenat11 kernel: cpu 1 cold: low 0, high 32, batch 16
Mar 31 10:05:06 arenat11 kernel: cpu 2 hot: low 32, high 96, batch 16


This only happens if i use device-mapper-multipath for multipathing, it
does not if i use the LUNS without.

Any Ideas ?

I can run additional Test as you like, because this is a test environment=
.
I have two of those boxen, one with 128G of ram, all tests welcome.


Greetings from Munich

Stefan Majer
