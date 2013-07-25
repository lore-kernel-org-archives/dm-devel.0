From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: Substantial performance difference when
 reading/writing to device-mapper vs. the individual device
Date: Thu, 25 Jul 2013 18:38:36 +0900
Message-ID: <51F0F21C.5090000@ce.jp.nec.com>
References: <CAKLAu3bqSff-She6hiRB6+2e0syu0AgxtwYiR0A9CP-yLVBm6Q@mail.gmail.com>
	<CAKLAu3bcJEggXFbdR2qh=yJ=H6nyq2DZKHxUXoYQJ6o3Jk1Qfg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAKLAu3bcJEggXFbdR2qh=yJ=H6nyq2DZKHxUXoYQJ6o3Jk1Qfg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, mykaul@gmail.com
List-Id: dm-devel.ids

On 07/24/13 20:49, Kaul wrote:
> Could it be explained by the difference in max_segments between the different devices and the dm device?

It depends on work load.
Have you already checked IO pattern with "iostat -xN"?
For mostly sequential IO where a lot of segments are merged,
"max_segments" might affect the performance.
For mostly random and small IO where merge does not occur so often,
it does not likely matter.

> Sounds like https://bugzilla.redhat.com/show_bug.cgi?id=755046 which is supposed to be fixed in 6.4, I reckon:

You could check other request_queue parameters to see if any differences
between dm device an sd device exist.  (/sys/class/block/*/queue/*)
Many of them could affect performance.
Also I think you should check if the same phenomenon happens with the
latest upstream kernel to get feedbacks from upstream mailing list.

The other thing I would check is CPU load, perhaps starting with commands
like top and mpstat, whether there are enough idle cycles left for the
application/kernel to submit/process IOs.

> 3514f0c5615a00003 dm-3 XtremIO,XtremApp
> size=1.0T features='0' hwhandler='0' wp=rw
> `-+- policy='queue-length 0' prio=1 status=active
>   |- 0:0:2:2 sdi  8:128  active ready running
>   |- 0:0:3:2 sdl  8:176  active ready running
>   |- 0:0:1:2 sdf  8:80   active ready running
>   |- 0:0:0:2 sdc  8:32   active ready running
>   |- 1:0:0:2 sds  65:32  active ready running
>   |- 1:0:3:2 sdab 65:176 active ready running
>   |- 1:0:2:2 sdy  65:128 active ready running
>   `- 1:0:1:2 sdv  65:80  active ready running
>  
> 
> [root@lg545 ~]# cat /sys/class/block/dm-3/queue/max_segments
> 128
> [root@lg545 ~]# cat /sys/class/block/sdi/queue/max_segments
> 1024
> [root@lg545 ~]# cat /sys/class/block/sdl/queue/max_segments
> 1024
> [root@lg545 ~]# cat /sys/class/block/sdf/queue/max_segments
> 1024
> [root@lg545 ~]# cat /sys/class/block/sdc/queue/max_segments
> 1024
> [root@lg545 ~]# cat /sys/class/block/sds/queue/max_segments
> 1024
> [root@lg545 ~]# cat /sys/class/block/sdab/queue/max_segments
> 1024
> [root@lg545 ~]# cat /sys/class/block/sdy/queue/max_segments
> 1024
> [root@lg545 ~]# cat /sys/class/block/sdv/queue/max_segments
> 1024
> 
> 
> On Mon, Jul 22, 2013 at 2:47 PM, Kaul <mykaul@gmail.com <mailto:mykaul@gmail.com>> wrote:
> 
>     We are seeing a substantial difference in performance when we perform a read/write to /dev/mapper/... vs. the specific device (/dev/sdXX)
>     What can we do to further isolate the issue?
> 
>     We are using CentOS 6.4, with all updates, 2 CPUs, 4 FC ports:
>     Here's a table comparing the results:
> 
>     # of LUNs
>     # of Paths per device
>     Native Multipath Device
>     IO Pattern
>     IOPS
>     Latency Micro
>     BW KBps
> 
>     4
>     16
>     No
>     100% Read
>     605,661.4
>     3,381
>     2,420,736
> 
>     4
>     16
>     No
>     100% Write
>     477,515.1
>     4,288
>     1,908,736
> 
>     8
>     16
>     No
>     100% Read
>     663,339.4
>     6,174
>     2,650,112
> 
>     8
>     16
>     No
>     100% Write
>     536,936.9
>     7,628
>     2,146,304
> 
>     4
>     16
>     Yes
>     100% Read
>     456,108.9
>     1,122
>     1,824,256
> 
>     4
>     16
>     Yes
>     100% Write
>     371,665.8
>     1,377
>     1,486,336
> 
>     8
>     16
>     Yes
>     100% Read
>     519,450.2
>     1,971
>     2,077,696
> 
>     8
>     16
>     Yes
>     100% Write
>     448,840.4
>     2,281
>     1,795,072

-- 
Jun'ichi Nomura, NEC Corporation
