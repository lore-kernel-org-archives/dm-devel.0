From: "Janec, Jozef" <jozef.janec@hp.com>
Subject: device mapper multipath and
	/sys/block/XXX/device/queue_dept
Date: Tue, 19 Oct 2010 13:25:54 +0000
Message-ID: <A510D7CF8900D246979209B696F496F67EB2557DBB@GVW1088EXB.americas.hpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello All,

I just tried change the  queue_dept for one lun which is connected to the server with device-mapper multipath

LUN1 (360060e80047f280000007f28000010b2) dm-146 HP,OPEN-V
[size=25G][features=1 queue_if_no_path][hwhandler=0]
\_ round-robin 0 [prio=12][active]
 \_ 2:0:5:85  sdbky 71:1760  [active][ready]
 \_ 2:0:4:85  sdbfg 134:1440 [active][ready]
 \_ 1:0:2:85  sdaoc 66:1216  [active][ready]
 \_ 0:0:5:85  sdaob 66:1200  [active][ready]
 \_ 3:0:2:85  sdalz 135:848  [active][ready]
 \_ 3:0:1:85  sdxv  128:592  [active][ready]
 \_ 1:0:1:85  sdvd  67:752   [active][ready]
 \_ 0:0:4:85  sdul  66:720   [active][ready]
 \_ 3:0:0:85  sdfp  130:176  [active][ready]
 \_ 2:0:3:85  sdbu  68:128   [active][ready]
 \_ 0:0:3:85  sdbs  68:96    [active][ready]
 \_ 1:0:0:85  sdbl  67:240   [active][ready]

I set on all devices /sys/block/xxx/device/queue_depth to 4

But after few sec...

They were changed to 5, and the number is increasing until it reach 16. Is there something in device mapper multipath what is changing the queue_depth?

Thanks

Jozef
