From: Ray Stell <stellr@cns.vt.edu>
Subject: mpath_ctl observation + some novice questions
Date: Thu, 15 Sep 2005 09:25:38 -0400
Message-ID: <20050915132538.GA27752@locust.cns.vt.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

I'm not a developer, but I thought I'd throw out this observation.

environment:
 - rhas4 U2 Beta - Linux pecan 2.6.9-16.EL #1 Mon Aug 15 19:58:49 EDT 2005 i686 i686 i386 GNU/Linux
 - multipath-tools-0.4.5.49.  
 - 2 QLogic PCI to Fibre Channel Host Adapters for QLA2340:
   Firmware version 3.03.15 IPX, Driver version 8.01.00b5-rh2
 - IBM ESS 2105F20 4 paths

When I used this command:  multipath -v3  
The cpu got eaten up by mpath_ctl and remains that way until reboot:

top - 21:14:55 up  3:51,  2 users,  load average: 4.18, 2.54, 1.06
Tasks:  68 total,   3 running,  65 sleeping,   0 stopped,   0 zombie
Cpu(s): 15.9% us, 84.1% sy,  0.0% ni,  0.0% id,  0.0% wa,  0.0% hi,  0.0% si
Mem:   1554428k total,   244244k used,  1310184k free,    34268k buffers
Swap:  5116620k total,        0k used,  5116620k free,   119464k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND 
 4202 root      15 -10  2324   92   72 R 99.7  0.0   4:34.19 mpath_ctl 
 4255 root      16   0  3344  928  744 R  0.3  0.1   0:00.05 top 
...

I was able to repeat this twice, but not a the third time.  I may
have something misconfigured since this is my first foray into
dm.  I'll be glad to supply any info of interest.  Thanks.

Next topic:  The number of scsi devices I'm seeing in my 
sand box is wrong.  I have 4 luns with 4 paths.  I'm only
seeing 14 devices, after one of the reboots, I only had 13.
Any clue why?

[root@pecan ~]# multipath -v2 -d
create: 1IBM_____2105____________50A22206
[size=19 GB][features="0"][hwhandler="0"]
\_ round-robin 0
  \_ 0:0:0:0 sda  8:0
  \_ 0:0:1:0 sde  8:64
  \_ 1:0:0:0 sdi  8:128
  \_ 1:0:1:0 sdm  8:192

create: 1IBM_____2105____________30A22206
[size=19 GB][features="0"][hwhandler="0"]
\_ round-robin 0
  \_ 0:0:0:1 sdb  8:16
  \_ 1:0:0:1 sdj  8:144
  \_ 1:0:1:1 sdn  8:208

create: 1IBM_____2105____________72622206
[size=19 GB][features="0"][hwhandler="0"]
\_ round-robin 0
  \_ 0:0:0:2 sdc  8:32
  \_ 0:0:1:2 sdg  8:96
  \_ 1:0:0:2 sdk  8:160
  \_ 1:0:1:2 sdo  8:224

create: 1IBM_____2105____________72722206
[size=19 GB][features="0"][hwhandler="0"]
\_ round-robin 0
  \_ 0:0:0:3 sdd  8:48
  \_ 1:0:0:3 sdl  8:176
  \_ 1:0:1:3 sdp  8:240

Next topic.  I'm a real dm novice user.  I have not
figured out how to create the disk devices and lvm fs.  Is there 
a doc on how to do this?  My guess is that I need 
to map the wwid in multipath.conf.  Is this demonstrated
somewhere?  Thanks.
============================================================
Ray Stell  stellr@vt.edu  (540) 231-4109  Tempus fugit  28^D
