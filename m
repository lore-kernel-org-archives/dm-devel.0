From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: blacklist issues and more
Date: Wed, 22 Jun 2005 00:58:53 +0200
Message-ID: <1119394733.1515.130.camel@zezette>
References: <C2EEB4E538D3DC48BF57F391F422779321AAEB@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321AAEB@SRMANNING.eng.emc.com>
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

On mar, 2005-06-21 at 15:50 -0400, goggin, edward wrote:
> (1) When I change the multipath config file to blacklist an already
> multipathed block device,
> I must first remove that device from the active multipath configuration via
> "multipath -F" or
> "dmsetup remove <map-name>" then run "multipath".  Seems like I should not
> have to do
> all of this.  A simple invocation of "multipath" after modifying the
> multipath configuration file
> should do it instead by checking the current configuration and
> removing/closing the mapped
> device for me if that device is currently in the active multipath
> configuration.
> 
Yes, this was the designed behaviour not to remove disappearing paths
from the maps. He had to go this way because multipathed used to invoke
multipath for maps reconfiguration upon checker events.

Alasdair was reluctant to reload maps in critical paths, so this
heuristic avoided such unwanted reload. (see pgcmp2 comment header in
the code).

This is not the case anymore in the 0.4.5 dev branch : now the daemon
never touch the maps, it just sends "DM messages". So I guess it's safe
to remove that heuristic.

Done in git head.

Be aware that with the remote port class, all block devices seen through
an unvailable target will be wiped from the kernel. Triggers events,
then multipath exec, then a map amputed from the associated paths gets
reloaded.

I don't envision your suggested mod to be a problem here, but maybe you
will find one afterall ...

> Also, don't we need a multipath(8) capability to remove a specific multipath
> mapped device
> from the active configuration?
> 
Back from the tail of the TODO to the head ? :)
I sure intented to do it, but lacked incentive.
It's now done, and will appear in git head soon.

> (2) This isn't even sufficient since the multipathd holds an open on each
> multipath mapped
> device.  One result of this is that the target devices used by the mapped
> device are not
> available for use by any application which must "claim" them exclusively,
> for example,
> mount(8) or for use via raw io.  I must kill multipathd before I can use any
> of the target
> devices by these "claiming" applications.  Seems like multipath should get
> multipathd
> to close its open on the newly blacklisted block device.
> 
Now you also have the CLI facility to remove checkers while keeping the
daemon online. That or restarting the daemon or sending a SIGHUP (not
implemented right now) seem legitimate to me when an admin changes a
config file. Isn't it ?

> (3) After experimenting with this stuff on my SuSE SLES 9 SP2 host, while
> trying to run
> performance tests I got myself into a situation where a multipath mapped
> device file referred
> to THE WRONG LU.  I had no idea this was happening until I researched why
> dd(1) was
> writing only half the number of 4kb records to the LU than was a dd(1) to
> the native scsi
> device path.
> 
> This happened because it appears that symbolic links in /dev/disk/by-name to
> device
> mapper device files in /dev are NOT cleaned up as a result of running
> "multipath -F",
> "dmsetup remove <map-name>, or "dmsetup remove_all".  A subsequent
> invocation of
> multipath will not necessarily assign multipath mapped devices to the same
> device mapper
> minor instances (for example, if one or more of them are blacklisted after
> the remove step)
> causing the stale symbolic links in /dev/disk/by-name to refer to the wrong
> dm-<minor>
> device file in /dev.
> 
> An invocation of "multipath -F" did cleanup device files in /dev on my Red
> Hat AS 4 host
> but an invocation of "dmsetup remove <map-name>" did not.  I was loath to
> experiment
> with "dmsetup remove_all" on my Red Hat host since my root device on that
> host is on
> a device mapper LVM2 logical volume.  Otherwise, I suspect that this command
> would
> fail to clean up device files in the same way "dmsetup remove_all" failed.
> 
I'll wait for you to pin down this problem.

Regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>
