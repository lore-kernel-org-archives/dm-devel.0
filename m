From: Charlie Brady <charlieb-dm-devel@budge.apana.org.au>
Subject: Unstable isci path and confusing logging
Date: Fri, 3 Jul 2009 12:46:52 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0907031226000.12539@e-smith.charlieb.ott.istop.com>
References: <Pine.LNX.4.64.0906251344350.4229@e-smith.charlieb.ott.istop.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0906251344350.4229@e-smith.charlieb.ott.istop.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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


On Thu, 25 Jun 2009, Charlie Brady wrote:

> multipathd logs a path checker message whenever state changes. But it also 
> logs every non-changed message when verbosity is >=4 and newstate is PATH_UP 
> or PATH_GHOST, and every non-changed message when verbosity is >= 2 and 
> newstate is PATH_DOWN.
>
> I believe that the message should only be logged, once, when state changes.

I have a mystery related to state change logging which I hope somebody can 
help me solve.

I am running multipathd with the following patch applied (as well as the 
patch from 
https://www.redhat.com/archives/dm-devel/2009-June/msg00293.html which 
updates that checker message with each poll):

> Signed-off-by: Charlie Brady <charlieb@budge.apana.org.au>
>
> --- multipath-tools-0.4.7.rhel5.13/multipathd/main.c	2009-06-25 
> 13:32:57.248455000 -0400
> +++ mezzanine_patched_multipath-tools-0.4.7.rhel5.13/multipathd/main.c 
> 2009-06-25 13:32:12.968639000 -0400
> @@ -1041,7 +1041,6 @@
> 			 		enable_group(pp);
> 			 }
> 			 else if (newstate == PATH_UP || newstate ==
> 			 PATH_GHOST) {
> -				LOG_MSG(4, checker_message(&pp->checker));
> 				 /*
> 				  * double the next check delay.
> 				  * max at conf->max_checkint
> @@ -1055,8 +1054,6 @@
> 				 condlog(4, "%s: delay next check %is",
> 			 			pp->dev_t, pp->tick);
> 			}
> -			else if (newstate == PATH_DOWN)
> -				LOG_MSG(2, checker_message(&pp->checker));
>
> 			pp->state = newstate;

Therefore, the only logging of checker_message() remaining is this:

...
                         if (newstate != pp->state) {
                                 int oldstate = pp->state;
                                 pp->state = newstate;
                                 LOG_MSG(1, checker_message(&pp->checker));
...

What I am seeing however is this:

[root@sun4150node2 ~]# grep 'rdac checker' /var/log/messages | tail -10
Jul  3 12:29:44 sun4150node2 multipathd: sdc: rdac checker reports path is up
Jul  3 12:29:49 sun4150node2 multipathd: sdc: rdac checker reports path is up
Jul  3 12:29:54 sun4150node2 multipathd: sdc: rdac checker reports path is up
Jul  3 12:29:59 sun4150node2 multipathd: sdc: rdac checker reports path is up
Jul  3 12:30:04 sun4150node2 multipathd: sdc: rdac checker reports path is up
Jul  3 12:30:09 sun4150node2 multipathd: sdc: rdac checker reports path is up
Jul  3 12:30:14 sun4150node2 multipathd: sdc: rdac checker reports path is up
Jul  3 12:30:19 sun4150node2 multipathd: sdc: rdac checker reports path is up
Jul  3 12:30:24 sun4150node2 multipathd: sdc: rdac checker reports path is up
Jul  3 12:30:29 sun4150node2 multipathd: sdc: rdac checker reports path is up
[root@sun4150node2 ~]#

So I am seeing repeated logging of 'up' state messages, although I only 
expect to see one message per state change.

As further background, I have four iscsi paths configured to two ports on 
two controllers on a Sun StorageTek 2510 (a bug in the Sun CAM management 
software has also configured a non-working IPV6 session).

[root@sun4150node2 ~]# iscsiadm -m node -P 1
Target: iqn.1986-03.com.sun:2510.600a0b800049afbd000000004a36468f
         Portal: 10.37.13.101:3260,1
                 Iface Name: default
         Portal: [fe80:0000:0000:0000:02a0:b8ff:fe4a:1c6d]:3260,1
                 Iface Name: default
         Portal: 10.37.13.104:3260,2
                 Iface Name: default
         Portal: 10.37.13.103:3260,2
                 Iface Name: default
         Portal: 10.37.13.102:3260,1
                 Iface Name: default
[root@sun4150node2 ~]#

Two of the 2510's port connections are disconnected (10.37.13.103 and 
10.37.13.104).

The path checker apparently finds the 8:32 path as intermittent:

[root@sun4150node2 ~]# echo show paths | multipathd -k
multipathd> hcil     dev dev_t pri dm_st   chk_st   next_check
10:0:0:0 sdd 8:48  100 [failed][faulty] XXXXXXXX.. 4/5
11:0:0:0 sde 8:64  100 [failed][faulty] XXXXXXXX.. 4/5
9:0:0:0  sdb 8:16  0   [active][ready]  XXXXXX.... 12/20
12:0:0:0 sdc 8:32  0   [failed][faulty] XXXXXX.... 3/5
multipathd> [root@sun4150node2 ~]#
[root@sun4150node2 ~]#
[root@sun4150node2 ~]# echo show paths | multipathd -k
multipathd> hcil     dev dev_t pri dm_st   chk_st   next_check
10:0:0:0 sdd 8:48  100 [failed][faulty] XX........ 1/5
11:0:0:0 sde 8:64  100 [failed][faulty] XX........ 1/5
9:0:0:0  sdb 8:16  0   [active][ready]  XX........ 4/20
12:0:0:0 sdc 8:32  0   [active][ready]  XXXXXXXXXX 5/5
multipathd> [root@sun4150node2 ~]# echo show paths | multipathd -k
multipathd> hcil     dev dev_t pri dm_st   chk_st   next_check
10:0:0:0 sdd 8:48  100 [failed][faulty] XXXXXX.... 3/5
11:0:0:0 sde 8:64  100 [failed][faulty] XXXXXX.... 3/5
9:0:0:0  sdb 8:16  0   [active][ready]  XXXXXXXX.. 16/20
12:0:0:0 sdc 8:32  0   [failed][faulty] XXXX...... 2/5
multipathd> [root@sun4150node2 ~]#

Here is a longer excerpt from syslog:

Jul  3 12:33:41 sun4150node2 iscsid: connect failed (113)
Jul  3 12:33:44 sun4150node2 multipathd: sdc: rdac checker reports path is 
up
Jul  3 12:33:44 sun4150node2 multipathd: 8:32: reinstated
Jul  3 12:33:44 sun4150node2 multipathd: mpath0: remaining active paths: 2
Jul  3 12:33:44 sun4150node2 multipathd: mpath0: switch to path group #1
Jul  3 12:33:44 sun4150node2 multipathd: mpath0: switch to path group #1
Jul  3 12:33:44 sun4150node2 multipathd: dm-2: add map (uevent)
Jul  3 12:33:44 sun4150node2 multipathd: dm-2: devmap already registered
Jul  3 12:33:45 sun4150node2 kernel: iscsi: cmd 0x12 is not queued (8)
Jul  3 12:33:45 sun4150node2 kernel: iscsi: cmd 0x12 is not queued (8)
Jul  3 12:33:47 sun4150node2 kernel: device-mapper: multipath: Failing 
path 8:32.
Jul  3 12:33:47 sun4150node2 multipathd: dm-2: add map (uevent)
Jul  3 12:33:47 sun4150node2 multipathd: dm-2: devmap already registered
Jul  3 12:33:47 sun4150node2 multipathd: 8:32: mark as failed
Jul  3 12:33:47 sun4150node2 multipathd: mpath0: remaining active paths: 1
Jul  3 12:33:47 sun4150node2 iscsid: connect failed (113)
Jul  3 12:33:47 sun4150node2 iscsid: connect failed (113)
Jul  3 12:33:49 sun4150node2 multipathd: sdc: rdac checker reports path is 
up
Jul  3 12:33:49 sun4150node2 multipathd: 8:32: reinstated
Jul  3 12:33:49 sun4150node2 multipathd: mpath0: remaining active paths: 2
Jul  3 12:33:49 sun4150node2 multipathd: mpath0: switch to path group #1
Jul  3 12:33:49 sun4150node2 multipathd: mpath0: switch to path group #1
Jul  3 12:33:49 sun4150node2 multipathd: dm-2: add map (uevent)
Jul  3 12:33:49 sun4150node2 multipathd: dm-2: devmap already registered
Jul  3 12:33:50 sun4150node2 multipathd: dm-2: add map (uevent)
Jul  3 12:33:50 sun4150node2 multipathd: dm-2: devmap already registered
Jul  3 12:33:50 sun4150node2 kernel: device-mapper: multipath: Failing 
path 8:32.
Jul  3 12:33:50 sun4150node2 kernel: iscsi: cmd 0x12 is not queued (8)
Jul  3 12:33:50 sun4150node2 multipathd: 8:32: mark as failed
Jul  3 12:33:50 sun4150node2 multipathd: mpath0: remaining active paths: 1

I'd be most grateful if someone can help me make sense of this. And 
preferably help me find and fix the bug.

multipath-tools version is 0.4.7.rhel5.13.
