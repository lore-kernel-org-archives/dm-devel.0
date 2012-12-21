From: Greg Stark <stark@mit.edu>
Subject: Re: How to force a snapshot status to valid when I know
 very well it's valid?
Date: Fri, 21 Dec 2012 22:54:21 +0000
Message-ID: <CAM-w4HPxTMGQd76C_Dqt56vQ1WFA7KrG4o3fbQWU1x5y=XHm5Q@mail.gmail.com>
References: <CAM-w4HM0-Cov_KtRE410etrh+v795tsPX1UM9WkV-o4MXaQBAQ@mail.gmail.com>
	<CAEcBt+UtiFrBw778r85JfZi7FegEgO6nXxkyoAUPRGXnvFXhmQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAEcBt+UtiFrBw778r85JfZi7FegEgO6nXxkyoAUPRGXnvFXhmQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

> See
> https://fedoraproject.org/wiki/LiveOS_image#Overlay_recovery

THANK YOU. That was enormously helpful and saved my bacon big time.
The lvm snapshot is active and the filesystem is back.

For future reference what I actually did was find the cow dm device
for the invalid lvm snapshot from dmsetup which was the device with
the same name as the snapshot plus "-cow":

# dmsetup status
vg_root-lv_u01_dev: 0 4724490240 snapshot Invalid
vg_root-lv_u01_dev-cow: 0 1048576000 linear

Then I ran the command from that doc to set the valid bit:
# echo $'\x01' | dd of=/dev/mapper/vg_root-lv_u01_dev-cow bs=1 count=1
seek=4 conv=notrunc
1+0 records in
1+0 records out
1 byte (1 B) copied, 2.9e-05 seconds, 34.5 kB/s

Then I didn't know how to reload the dm state so I rebooted the
machine. This caused a bit of a scare because loading the lvm volumes
took about 30 minutes. I don't know why or what happened there. But it
eventually did come up. Then I ran fsck a a few times, the third time
it found no problems (the first time actually seemed to corrupt the
filesystem!).

So actually a few things didn't work as expected. Firstly the lvm
snapshot expiring actually made one of the pv's in the vg invalid:
  --- Physical volume ---
  PV Name               unknown device
  VG Name               vg_root

This caused a lot of confusion since it looked like a hardware
problem. There were no hardware errors and after rebooting that device
seems fine so I think this was caused by dm.

Then rebooting after the bit was twiddled rebooting froze for a very
long time on this step in the redhat boot process:
Setting up Logical Volume Management:
It was about 30 minutes before this appeared:
Setting up Logical Volume Management:   4 logical volume(s) in volume
group "vg_root"

I don't know what could possibly have caused that. It wasn't even
mounting anything at this stage.  I actually went for a drink at this
point sure that I had corrupted the snapshot data structures in some
weird way. One catch is I had done lvextend already -- does the
snapshot dm need to initialize all the blocks of the newly extended
cow table?

-- 
greg
