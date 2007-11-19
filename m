From: "S. J. van Harmelen" <svh@dds.nl>
Subject: Re: Use LVM on /dev/mapper/diskname and iSCSI
Date: Mon, 19 Nov 2007 16:07:27 +0100
Message-ID: <1195484847.6074.16.camel@sanderbal>
References: <1195480602.6074.3.camel@sanderbal> <47419854.2000508@linpro.no>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <47419854.2000508@linpro.no>
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

Thanks for your help!

I executed the pvs command and it did find a few partitions. I use iSCSI
to share the LUN's to a XenSource server, and XenSource creates the PV's
and LV's in order to provision VM's. Didn't think of that, but that's on
the disk of course. 

Is there any way to configure snapshots for these already created LVM
partitions? Or do I have to whipe the disk clean (rather not do that,
but if I have to it can be done), then create the pv's and lv's and then
share the lv's true iSCSI?

In that case XenSource will again create pv's and lv's in the shared lv.
Ain't that a problem?

Sander



On Mon, 2007-11-19 at 15:06 +0100, Tore Anderson wrote:
> * S. J. van Harmelen
> 
> > I have a couple of LUN's that are handled by the multipath driver.
> > This works great, but now I want to use LVM so I can take snapshots
> > of one LUN to another LUN.
> > 
> > Can someone tell me how to do this?
> > 
> > When I do pvcreate /dev/mapper/diskname I get an error that the disk
> > is already part of an volume group. But I sertainly did not configure
> > that.
> > 
> > Can it be that the multipath driver of devmapper did that?
> 
> If you have a PV signature on the volume, LVM might have used one of the
> paths instead of using the multipath'ed device under /dev/mapper.  You
> should be able to check this by running the command "pvs" - it should
> list all the detected PVs on your system.
> 
> If this was the problem, you can avoid it by instructing LVM to not scan
> SCSI devices directly, by adding a line in /etc/lvm/lvm.conf like this:
> 
> device {
>   filter = [ "a|^/dev/mapper/.*|", "r|.*|" ]
> }
> 
> This will make LVM only look at devices in /dev/mapper/ as possible PV
> candidates, ignoring all other devices.  Beware if you have a PV on the
> internal drives though, you might want to have something like this
> instead in that case (if that PV is on /dev/sda2, for instance):
> 
>   filter = [ "a|^/dev/mapper/.*|", "a|^/dev/sda2$|", "r|.*|" ]
> 
> Make sure lvm.conf makes its way into the initramfs if you start the LVM
> stuff there.  I know Ubuntu doesn't include this file by default, at least.
> 
> Regards
