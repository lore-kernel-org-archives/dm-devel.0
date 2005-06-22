From: "goggin, edward" <egoggin@emc.com>
Subject: RE: blacklist issues and more
Date: Wed, 22 Jun 2005 12:21:46 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321AAF7@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, 22 Jun 2005 00:58:53 +0200
christophe varoqui <christophe.varoqui@free.fr> wrote

> Now you also have the CLI facility to remove checkers while keeping the
> daemon online. That or restarting the daemon or sending a SIGHUP (not
> implemented right now) seem legitimate to me when an admin changes a
> config file. Isn't it ?

Yes, I like the SIGHUP idea best.  I'm not sure what you mean by
"CLI facility to remove checkers".

> > (3) After experimenting with this stuff on my SuSE SLES 9 
> SP2 host, while
> > trying to run
> > performance tests I got myself into a situation where a 
> multipath mapped
> > device file referred
> > to THE WRONG LU.  I had no idea this was happening until I 
> researched why
> > dd(1) was
> > writing only half the number of 4kb records to the LU than 
> was a dd(1) to
> > the native scsi
> > device path.
> > 
> > This happened because it appears that symbolic links in 
> /dev/disk/by-name to
> > device
> > mapper device files in /dev are NOT cleaned up as a result 
> of running
> > "multipath -F",
> > "dmsetup remove <map-name>, or "dmsetup remove_all".  A subsequent
> > invocation of
> > multipath will not necessarily assign multipath mapped 
> devices to the same
> > device mapper
> > minor instances (for example, if one or more of them are 
> blacklisted after
> > the remove step)
> > causing the stale symbolic links in /dev/disk/by-name to 
> refer to the wrong
> > dm-<minor>
> > device file in /dev.
> > 
> > An invocation of "multipath -F" did cleanup device files in 
> /dev on my Red
> > Hat AS 4 host
> > but an invocation of "dmsetup remove <map-name>" did not.  
> I was loath to
> > experiment
> > with "dmsetup remove_all" on my Red Hat host since my root 
> device on that
> > host is on
> > a device mapper LVM2 logical volume.  Otherwise, I suspect 
> that this command
> > would
> > fail to clean up device files in the same way "dmsetup 
> remove_all" failed.
> > 
> I'll wait for you to pin down this problem.

I was hoping Alasdair or Lars would comment first :))
