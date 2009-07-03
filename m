From: Charlie Brady <charlieb-dm-devel@budge.apana.org.au>
Subject: Re: Unstable isci path and confusing logging
Date: Fri, 3 Jul 2009 13:07:38 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0907031256580.12539@e-smith.charlieb.ott.istop.com>
References: <Pine.LNX.4.64.0906251344350.4229@e-smith.charlieb.ott.istop.com>
	<Pine.LNX.4.64.0907031226000.12539@e-smith.charlieb.ott.istop.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0907031226000.12539@e-smith.charlieb.ott.istop.com>
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


On Fri, 3 Jul 2009, Charlie Brady wrote:

> Jul  3 12:29:59 sun4150node2 multipathd: sdc: rdac checker reports path is up
> Jul  3 12:30:04 sun4150node2 multipathd: sdc: rdac checker reports path is up
> Jul  3 12:30:09 sun4150node2 multipathd: sdc: rdac checker reports path is up
> Jul  3 12:30:14 sun4150node2 multipathd: sdc: rdac checker reports path is up
> Jul  3 12:30:19 sun4150node2 multipathd: sdc: rdac checker reports path is up
> Jul  3 12:30:24 sun4150node2 multipathd: sdc: rdac checker reports path is up
> Jul  3 12:30:29 sun4150node2 multipathd: sdc: rdac checker reports path is up
> [root@sun4150node2 ~]#

This is the cycle of multipathd failing and reinstating the device:

[root@sun4150node2 ~]# grep 8:32 /var/log/messages | tail -12
Jul  3 12:57:38 sun4150node2 multipathd: 8:32: reinstated
Jul  3 12:57:38 sun4150node2 kernel: device-mapper: multipath: Failing path 8:32.
Jul  3 12:57:39 sun4150node2 multipathd: 8:32: mark as failed
Jul  3 12:57:43 sun4150node2 multipathd: 8:32: reinstated
Jul  3 12:57:44 sun4150node2 kernel: device-mapper: multipath: Failing path 8:32.
Jul  3 12:57:44 sun4150node2 multipathd: 8:32: mark as failed
Jul  3 12:57:48 sun4150node2 multipathd: 8:32: reinstated
Jul  3 12:57:50 sun4150node2 kernel: device-mapper: multipath: Failing path 8:32.
Jul  3 12:57:50 sun4150node2 multipathd: 8:32: mark as failed
Jul  3 12:57:53 sun4150node2 multipathd: 8:32: reinstated
Jul  3 12:57:53 sun4150node2 kernel: device-mapper: multipath: Failing path 8:32.
Jul  3 12:57:54 sun4150node2 multipathd: 8:32: mark as failed
[root@sun4150node2 ~]#

> As further background, I have four iscsi paths configured to two ports on two 
> controllers on a Sun StorageTek 2510 (a bug in the Sun CAM management 
> software has also configured a non-working IPV6 session).

On a related issue, is there any way to learn which of the iscsi paths 
is associated with which device node (/dev/sdX)?
