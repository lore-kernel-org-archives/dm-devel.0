From: "S. J. van Harmelen" <svh@dds.nl>
Subject: Re: Use LVM on /dev/mapper/diskname
Date: Mon, 19 Nov 2007 19:16:49 +0100
Message-ID: <1195496209.6074.44.camel@sanderbal>
References: <1195480602.6074.3.camel@sanderbal> <47419854.2000508@linpro.no>
	<20071119172219.GA22727@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20071119172219.GA22727@us.ibm.com>
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

P.S. When I run pvscan I get this output:

root@storage:~# pvscan
  /dev/sdc: read failed after 0 of 4096 at 0: Input/output error
  /dev/sdc: read failed after 0 of 4096 at 214748299264: Input/output
error
  /dev/sdc: read failed after 0 of 4096 at 0: Input/output error
  /dev/sdd: read failed after 0 of 4096 at 0: Input/output error
  /dev/sdd: read failed after 0 of 4096 at 214748299264: Input/output
error
  /dev/sdd: read failed after 0 of 4096 at 0: Input/output error
  /dev/sdf: read failed after 0 of 4096 at 0: Input/output error
  /dev/sdf: read failed after 0 of 4096 at 214748299264: Input/output
error
  /dev/sdf: read failed after 0 of 4096 at 0: Input/output error
  /dev/sdi: read failed after 0 of 4096 at 0: Input/output error
  /dev/sdi: read failed after 0 of 4096 at 214748299264: Input/output
error
  /dev/sdi: read failed after 0 of 4096 at 0: Input/output error
  PV /dev/dm-0   VG VG_XenStorage-755d6649-e770-6f01-5e17-fd7f8dcd8651
lvm2 [199.99 GB / 185.49 GB free]
  Total: 1 [199.99 GB] / in use: 1 [199.99 GB] / in no VG: 0 [0   ]

So here it does see the dm-0? Please advice...

Sander


On Mon, 2007-11-19 at 09:22 -0800, malahal@us.ibm.com wrote:
> Tore Anderson [tore@linpro.no] wrote:
> > * S. J. van Harmelen
> > 
> > > I have a couple of LUN's that are handled by the multipath driver.
> > > This works great, but now I want to use LVM so I can take snapshots
> > > of one LUN to another LUN.
> > > 
> > > Can someone tell me how to do this?
> > > 
> > > When I do pvcreate /dev/mapper/diskname I get an error that the disk
> > > is already part of an volume group. But I sertainly did not configure
> > > that.
> > > 
> > > Can it be that the multipath driver of devmapper did that?
> > 
> > If you have a PV signature on the volume, LVM might have used one of the
> > paths instead of using the multipath'ed device under /dev/mapper.  You
> > should be able to check this by running the command "pvs" - it should
> > list all the detected PVs on your system.
> 
> If LVM uses single pathed disks like /dev/sda, then multipath can't use
> the same path to make a multipathed device, right? My guess is that
> /dev/mapper/multipath-name is indeed part of the LVM in your case. I
> would like to know what happened otherwise. Thank you.
> 
> --Malahal.
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
