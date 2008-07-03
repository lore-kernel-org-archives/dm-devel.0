From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: problems getting ioband to work properly
Date: Thu, 03 Jul 2008 21:53:05 +0900 (JST)
Message-ID: <20080703.215305.112607122.ryov@valinux.co.jp>
References: <20080701121125.GA2898@develbox.linuxbox.cz>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080701121125.GA2898@develbox.linuxbox.cz>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, extmaillist@linuxbox.cz
Cc: nikola.ciprich@linuxbox.cz
List-Id: dm-devel.ids

Hi,

Thanks for being interested in dm-ioband.

> I'd like to try I/O shaping using ioband, but it doesn't seem to be working properly for some reason.
> I have one disc partition used as LVM PV, VG on top of it. I created two 1GB LVs for tests: iob1, iob2
> 
> Then I setup ioband using following commands:
> 
> echo 0 2097152 ioband /dev/mapper/vg-iob1 iob 0 0 none weight 0 :40 | dmsetup create ioband-iob1
> echo 0 2097152 ioband /dev/mapper/vg-iob2 iob 0 0 none weight 0 :10 | dmsetup create ioband-iob2
> 
> When I measure throughput using hdparm --direct -t on one of the ioband devices, i get ~61MBps.
> 
> If I measure it on both devices concurrently in loop, throughput settles on ~30MBps on every device, so it seems that it's divided equally.
> 
> What am I doing wrong?

Dm-ioband is designed not to limit the I/O bandwidths of disks unless
the I/O load is heavy so that you can use the full performance of
the disks, which can handle multiple I/O requests at the same time.

Dm-ioband starts controlling I/O bandwidth when the number of I/O
request exceeds a certain threshold, which can be changed with
dmsetup command.

    # sudo dmsetup message ioband-iob1 0 io_throttle 2

  Please see also the manual at:
     http://people.valinux.co.jp/~ryov/dm-ioband/manual/cmdref.html

If you do the following, you will see how the bandwidth control is working.

  1. run a total of eight dd programs for reading.

  #!/bin/bash
  for ((i = 0; i < 4; i++)); do
        dd if=/dev/mapper/ioband-iob1 of=/dev/null ibs=4k iflag=direct &
        dd if=/dev/mapper/ioband-iob2 of=/dev/null ibs=4k iflag=direct &
  done

  2. watch the iostat report at intervals of 5 seconds.

  # iostat -p dm-2 -p dm-3 5
  ...
  avg-cpu:  %user   %nice %system %iowait  %steal   %idle
             1.24    0.00   23.40   29.28    0.00   46.08

  Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
  dm-2           4647.33     37178.60         0.00     180688          0
  dm-3           1348.56     10788.48         0.00      52432          0

  avg-cpu:  %user   %nice %system %iowait  %steal   %idle
             0.73    0.00   23.11   26.11    0.00   50.05

  Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
  dm-2           5092.75     40742.03         0.00     196784          0
  dm-3           1019.25      8154.04         0.00      39384          0
  ...

Thanks,
Ryo Tsuruta
