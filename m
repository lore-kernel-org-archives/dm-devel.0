From: "Stewart, Sean" <Sean.Stewart@netapp.com>
Subject: Re: [PATCH] libmultipath: Use existing user friendly
 name if possible
Date: Fri, 11 Apr 2014 17:01:47 +0000
Message-ID: <1397235706.29991.8.camel@ict-vth-stewarts01.ict.englab.netapp.com>
References: <8255ED565A0EAA4A960625E27D49DBF24AC9EB61@SACEXCMBX04-PRD.hq.netapp.com>
	<20140411160338.GA17578@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140411160338.GA17578@localhost.localdomain>
Content-Language: en-US
Content-ID: <18C0D3CE4EA8274996C47F9EBDFB22D0@hq.netapp.com>
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

On Fri, 2014-04-11 at 17:03 +0100, Bryn M. Reeves wrote:
> On Fri, Mar 28, 2014 at 09:01:14PM +0000, Stewart, Sean wrote:
> > When a system is booted to the SAN, a condition can occur where one
> > user friendly name is given to a disk during boot, but multipathd tries
> > to allocate a different one after boot. If the second alias is already
> > used by another device, multipathd can't rename it. Multipathd then has
> > incorrect information about the alias/wwid relationships, which can
> > result in paths being added to the wrong map.
> 
> This should only happen if the initramfs and root file system have
> inconsistent multipath configurations (either multipath.conf or bindings
> / wwids file mismatched). That's not really a valid configuration for
> the system to be in and leads to the type of problems you describe.

That is true that it only happens if they are out of sync.  We tried
remaking the initramfs to fix the problem, but it didn't help.
> 
> > This patch works around this problem by first trying to use the alias
> > already bound to a device during boot.  If the bindings file has that
> > alias bound to a different device, it'll auto generate a new alias to
> > rename it to.
> 
> To be honest I'd prefer to see this cause an error. These types of
> configurations currently run the risk of silent data corruption - I'd
> much rather deal with a system that refuses to boot due to an out of
> date initramfs image than one that quietly remaps paths in unexpected
> ways.

The issue, though, is that the system does not refuse to boot.  In the
case we saw, it booted anyway, our QA engineer ran a test, and it ended
with a data corruption.  A user could perform a fresh installation, map
new luns, reboot, and without any way of realizing it have essentially a
ticking time bomb on their hands, ready to go off as soon as there's a
blip in the SAN.

Here's some sample output from when I recreated the problem on my local
system:

I started with a fresh sanboot installation to verify I see the problem:
Bindings file:
mpatha 360080e50001b08100000184e5320d0f3
mpathb 360080e50001b0810000018705320f03d
mpathc 360080e50001b0810000004a051ef5f71
mpathd 360080e50001b076d0000cd8251ef5fe5
mpathe 360080e50001b076d0000cd8651ef5ff0
mpathf 360080e50001b076d0000cd8851ef5ff6
Multipath -ll
[root@localhost ~]# multipath -ll | grep mpath
mpathe (360080e50001b076d0000cd8251ef5fe5) dm-3 LSI     ,INF-01-00
mpathd (360080e50001b076d0000cd8651ef5ff0) dm-2 LSI     ,INF-01-00
mpathc (360080e50001b076d0000cd8851ef5ff6) dm-1 LSI     ,INF-01-00
mpathb (360080e50001b0810000004a051ef5f71) dm-0 LSI     ,INF-01-00
mpathf (360080e50001b0810000018705320f03d) dm-4 LSI     ,INF-01-00

During bootup, it assigned 360080e50001b076d0000cd8251ef5fe5 to be
mpathe.  After the system came up, it tried to assign it to be mpathd.
When it tried to rename it, it failed because there's already an
mpathd.  
Here's an example of how that can show up in the logs:
Mar 18 15:52:15 localhost multipathd: 360080e50001b0810000004a051ef5f71:
unable to rename mpathe to mpathb (mpathb is used by
360080e50001b076d0000cd8251ef5fe5)
Mar 18 15:52:15 localhost multipathd: 360080e50001b076d0000cd8251ef5fe5:
unable to rename mpathb to mpathc (mpathc is used by
360080e50001b076d0000cd8651ef5ff0)
Mar 18 15:52:15 localhost multipathd: 360080e50001b076d0000cd8651ef5ff0:
unable to rename mpathc to mpathd (mpathd is used by
360080e50001b076d0000cd8851ef5ff6)
Mar 18 15:52:15 localhost multipathd: 360080e50001b076d0000cd8851ef5ff6:
unable to rename mpathd to mpathe (mpathe is used by
360080e50001b0810000004a051ef5f71)

So, if I delete a path from mpathe, then scan it again, it ends up
incorrectly with mpathd (because that's the alias multipathd thinks is
assigned to that WWID).  The maps end up looking like this:
mpathe (360080e50001b076d0000cd8251ef5fe5) dm-3 LSI     ,INF-01-00
size=2.0G features='4 queue_if_no_path pg_init_retries 50
retain_attached_hw_handle' hwhandler='1 rdac' wp=rw
|-+- policy='service-time 0' prio=14 status=active
| |- 1:0:1:2 sdc 8:32  active ready running
| `- 4:0:1:2 sdm 8:192 active ready running
`-+- policy='service-time 0' prio=9 status=enabled
  |- #:#:#:# -   #:#   active faulty running
  `- 4:0:2:2 sdr 65:16 active ready running
mpathd (360080e50001b076d0000cd8651ef5ff0) dm-2 LSI     ,INF-01-00
size=2.0G features='4 queue_if_no_path pg_init_retries 50
retain_attached_hw_handle' hwhandler='1 rdac' wp=rw
|-+- policy='service-time 0' prio=14 status=active
| |- 1:0:1:3 sdd 8:48  active ready running
| |- 4:0:1:3 sdn 8:208 active ready running
| |- 1:0:1:2 sdc 8:32  active ready running
| `- 4:0:1:2 sdm 8:192 active ready running
`-+- policy='service-time 0' prio=9 status=enabled
  |- 1:0:2:3 sdi 8:128 active ready running
  |- 4:0:2:3 sds 65:32 active ready running
  |- 4:0:2:2 sdr 65:16 active ready running
  `- 1:0:2:2 sdu 65:64 active ready running

If a user wants a specific alias, they should still configure it through
multipath.conf.  It just prevents a potentially really bad condition
that could occur, if the setting is enabled, and something as simple as
adding new luns is done.

Thanks,
Sean

> 
> Regards,
> Bryn.
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
