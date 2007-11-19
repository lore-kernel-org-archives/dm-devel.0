From: "S. J. van Harmelen" <svh@dds.nl>
Subject: Re: Use LVM on /dev/mapper/diskname and iSCSI
Date: Mon, 19 Nov 2007 22:19:53 +0100
Message-ID: <1195507193.11489.27.camel@sanderbal>
References: <1195480602.6074.3.camel@sanderbal> <47419854.2000508@linpro.no>
	<1195484847.6074.16.camel@sanderbal>  <4741D96F.7080502@linpro.no>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4741D96F.7080502@linpro.no>
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

Tore,

Please take a look at my reply to Malaha. This is also a reply to your
message...

Hope you have the time to read it.

Thanks,

Sander


On Mon, 2007-11-19 at 19:43 +0100, Tore Anderson wrote:
> * S. J. van Harmelen
> 
> > Thanks for your help!
> > 
> > I executed the pvs command and it did find a few partitions. I use
> > iSCSI to share the LUN's to a XenSource server, and XenSource creates
> > the PV's and LV's in order to provision VM's. Didn't think of that,
> > but that's on the disk of course.
> > 
> > Is there any way to configure snapshots for these already created LVM
> > partitions? Or do I have to whipe the disk clean (rather not do
> > that, but if I have to it can be done), then create the pv's and lv's
> > and then share the lv's true iSCSI?
> > 
> > In that case XenSource will again create pv's and lv's in the shared
> > lv. Ain't that a problem?
> 
> You really need a filter line in /etc/lvm/lvm.conf, to keep LVM from 
> claiming 1) individual paths to a dm-multipath controlled LUN, and 2) 
> LUNs that are PVs used by the LVM implementation in your domUs.
> 
> You don't want LVM to be claiming the paths directly, because you'd no 
> longer have any redundancy - it will override dm-multipath.  You also 
> don't want the LVM implementation in your dom0 to be using the same 
> block device as LVM in your domU as physical volumes, as LVM is designed 
> to have exclusive access to its PVs (you might get around this with 
> CLVM, though).
> 
> Do I understand correctly if you have one LUN that contains your domO 
> (having its file systems in LVs), and several LUNs that contain your 
> domUs, which again are PVs that are supposed to be used by your domU 
> kernels?
> 
> If so you will want to keep your dom0 from claiming the domU PVs.  Use a 
> filter line that accepts only the multipath'ed volume that contains the 
> dom0 installation, and drop the rest.  For instance:
> 
> filter = [ "a|^/dev/mapper/domzero$", "r|.*" ]
> 
> ...assuming your dom0 data volume is called "domzero" in multipath.conf.
> 
> Regards
