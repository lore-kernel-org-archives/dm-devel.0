From: Alan Kasindorf <akasindorf@mail.communityconnect.com>
Subject: multipath-tools-0.4.4 on 3par unknown path failure issue
Date: Wed, 10 Aug 2005 17:49:40 -0400
Message-ID: <42FA7674.4070201@mail.communityconnect.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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

Hey,

I have ~10 machines running multipath-tools-0.4.4 on RHEL ES 4.1 (latest 
everything). Machines are mounting multipathed mounts on an EMC clariion 
and a 3PAR SAN device, over the same fabric.

At some random point in time today, one of the machines lost one of its 
four 3par mounts. All other mounts worked fine. This has happened once 
or twice before as well, but we rebooted before I had time to inspect 
the issue.

multipath -v3 -l showed this status on the bad path;

params = 1 queue_if_no_path 0 1 1 round-robin 0 2 1 8:64 1000 8:176 1000
status = 1 3 0 1 1 E 0 2 0 8:64 F 3574 8:176 F 3574
exports (350002ac0005b02a4)
[size=150 GB][features="1 queue_if_no_path"][hwhandler="0"]
\_ round-robin 0 [enabled][first]
  \_ 5:0:0:3 sde  8:64    [ready ][failed]
  \_ 6:0:1:3 sdl  8:176   [ready ][failed]

This was being spammed into /var/log/messages once every five seconds 
(the multipathd polling interval):

Aug 10 15:35:43 cc42-86 multipathd: 8:64: tur checker reports path is up
Aug 10 15:35:43 cc42-86 multipathd: devmap event (8163) on exports
Aug 10 15:35:43 cc42-86 kernel: device-mapper: dm-multipath: Failing 
path 8:176.
Aug 10 15:35:43 cc42-86 kernel: device-mapper: dm-multipath: Failing 
path 8:64.
Aug 10 15:35:43 cc42-86 multipathd: 8:176: tur checker reports path is up
Aug 10 15:35:43 cc42-86 kernel: cdrom: open failed.
Aug 10 15:35:43 cc42-86 kernel: device-mapper: dm-multipath: Failing 
path 8:176.
Aug 10 15:35:43 cc42-86 kernel: device-mapper: dm-multipath: Failing 
path 8:64.
Aug 10 15:35:43 cc42-86 kernel: cdrom: open failed.
Aug 10 15:35:43 cc42-86 multipathd: open(/dev/hdc) failed
Aug 10 15:35:43 cc42-86 multipathd: mark 8:64 as failed
Aug 10 15:35:43 cc42-86 multipathd: mark 8:176 as failed
Aug 10 15:35:43 cc42-86 multipathd: devmap event (8164) on exports
Aug 10 15:35:43 cc42-86 kernel: cdrom: open failed.
Aug 10 15:35:43 cc42-86 multipathd: open(/dev/hdc) failed
Aug 10 15:35:43 cc42-86 kernel: cdrom: open failed.
Aug 10 15:35:43 cc42-86 multipathd: open(/dev/hdc) failed

tur sees it up, kernel says it's down, ad infinitum.

Nothing I tried could elicit a more detailed error about why this was 
happening. The mount on top of it is a normal ext3 mount, and wasn't 
being accessed at the time of the failure as far as I know.

I switched off the queue_if_no_path option globally in the 
mulitpath.conf file. Immediately the ext3 journal failed out, and 
multipath brought both paths back as active:

exports (350002ac0005b02a4)
[size=150 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active][first]
  \_ 5:0:0:3 sde  8:64    [ready ][active]
  \_ 6:0:1:3 sdl  8:176   [ready ][active]

I was able to fsck the device and remount it without issue or reboot 
after that. Since, I've left the queue option disabled to see if the 
problem creeps back.

I basically have a default multipath.conf file, with some WWN to alias 
mappings, had the queue_if_no_path option enabled, and the EMC device 
info added. The problem's on the 3par however. Only one of the four 3par 
mounts on the machine was having issues.

Is this known at all? Is there anything else I can provide so that we 
can figure out why this happened? I had been running multipath tools for 
two months on a test box and never encounterred this problem. It's only 
snuck up as we've started deploying it on more machines for 
pre-production. All of the servers are identical... redhat ES4.1, same 
qla2300 fiber cards, same CPUs/etc.

We also encounterred the EMC ghost LUN issue (discussed on here once), 
which is especially bad if queue_if_no_path is enabled. Sometimes 
causing a kernel panic and bringing the machine down :(

Any assistance on the first or second issue would be appreciated!

Thanks,
-Alan
