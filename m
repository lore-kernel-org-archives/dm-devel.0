From: christophe varoqui <christophe.varoqui@free.fr>
Subject: RE: blacklist issues and more
Date: Wed, 22 Jun 2005 21:15:57 +0200
Message-ID: <1119467757.1515.147.camel@zezette>
References: <C2EEB4E538D3DC48BF57F391F422779321AAF7@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321AAF7@SRMANNING.eng.emc.com>
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

On mer, 2005-06-22 at 12:21 -0400, goggin, edward wrote:
> On Wed, 22 Jun 2005 00:58:53 +0200
> christophe varoqui <christophe.varoqui@free.fr> wrote
> 
> > Now you also have the CLI facility to remove checkers while keeping the
> > daemon online. That or restarting the daemon or sending a SIGHUP (not
> > implemented right now) seem legitimate to me when an admin changes a
> > config file. Isn't it ?
> 
> Yes, I like the SIGHUP idea best.  I'm not sure what you mean by
> "CLI facility to remove checkers".
> 
You should check out the git head and see the recent changes in the log.

> > > 
> > > An invocation of "multipath -F" did cleanup device files in 
> > /dev on my Red
> > > Hat AS 4 host
> > > but an invocation of "dmsetup remove <map-name>" did not.  
> > I was loath to
> > > experiment
> > > with "dmsetup remove_all" on my Red Hat host since my root 
> > device on that
> > > host is on
> > > a device mapper LVM2 logical volume.  Otherwise, I suspect 
> > that this command
> > > would
> > > fail to clean up device files in the same way "dmsetup 
> > remove_all" failed.
> > > 
> > I'll wait for you to pin down this problem.
> 
> I was hoping Alasdair or Lars would comment first :))
> 
I also commited an enhancement to the map removal logic :
Layered partitions (created by kpartx) increase the bottom map usage,
preventing its removal. The patch also removes unpinned partitions.

May be you were hit by this.

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
-- 
christophe varoqui <christophe.varoqui@free.fr>
