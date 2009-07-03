From: Charlie Brady <charlieb-dm-devel@budge.apana.org.au>
Subject: Re: Unstable isci path and confusing logging
Date: Fri, 3 Jul 2009 13:14:18 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0907031312050.12539@e-smith.charlieb.ott.istop.com>
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

> As further background, I have four iscsi paths configured to two ports on two 
> controllers on a Sun StorageTek 2510 (a bug in the Sun CAM management 
> software has also configured a non-working IPV6 session).
...
> The path checker apparently finds the 8:32 path as intermittent:

I have found these logs:

Jul  2 15:33:29 sun4150node2 kernel: sd 9:0:0:0: rdac: LUN 0 (unowned)
Jul  3 10:07:34 sun4150node2 kernel: sd 9:0:0:0: queueing MODE_SELECT command.
Jul  3 10:07:34 sun4150node2 kernel: sd 9:0:0:0: MODE_SELECT failed with sense 0x62904.
Jul  3 10:07:37 sun4150node2 kernel: sd 9:0:0:0: queueing MODE_SELECT command.

and wonder whether this thread (and patch) is relevant:

http://kerneltrap.org/mailarchive/linux-scsi/2008/10/30/3873414

I'll apply the patch, build new scsi_dh_rdac module, reboot and see what 
the state is.
