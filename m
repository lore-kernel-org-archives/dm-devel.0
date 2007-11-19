From: "S. J. van Harmelen" <svh@dds.nl>
Subject: Re: Use LVM on /dev/mapper/diskname and iSCSI
Date: Mon, 19 Nov 2007 22:16:36 +0100
Message-ID: <1195506996.11489.23.camel@sanderbal>
References: <1195480602.6074.3.camel@sanderbal> <47419854.2000508@linpro.no>
	<1195484847.6074.16.camel@sanderbal>
	<20071119185021.GA23100@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20071119185021.GA23100@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: malahal@us.ibm.com
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


On Mon, 2007-11-19 at 10:50 -0800, malahal@us.ibm.com wrote:
> S. J. van Harmelen [svh@dds.nl] wrote:
> > Thanks for your help!
> > 
> > I executed the pvs command and it did find a few partitions. I use iSCSI
> > to share the LUN's to a XenSource server, and XenSource creates the PV's
> > and LV's in order to provision VM's. Didn't think of that, but that's on
> > the disk of course. 
> > 
> > Is there any way to configure snapshots for these already created LVM
> > partitions?
> 
> If I understand, you exported some LUNs to XenSource server. So you
> should NOT be using those LUNs at this machine, right? You should be
> able to create snapshots at the XenSource server though.

That is correct. Sorry if I did not give enough information to
understand the problem at first, but what your saying now is correct.

I have a storage server with an MD3000 attached to it. This server runs
the multipath-tools to create redundant paths:

root@storage:~# multipath -ll
<snip>
xen (360019b9000d7e11000004485473faa94) dm-0 DELL    ,MD3000        
[size=200G][features=0][hwhandler=0]
\_ round-robin 0 [prio=3][active]
 \_ 1:0:0:3 sde 8:64  [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:1:3 sdi 8:128 [active][ghost]
<snip>

So the path that I use for sharing the LUN with the XenSource server
is /dev/mapper/xen:

root@storage:~# cat /etc/ietd.conf
<snip>
Target iqn.2007-11.local.xillan:storage.xen.disk1
          Lun 0 Path=/dev/mapper/xen,Type=blockio
<snip>

On the XenSource server I use a shared iSCSI storage so multiple servers
can access the same data so I can do live migrations. When I add the
storage XenSource creates a PV and then when I create a VM, it creates
LV's for each virtual harddisk.

So far so good I guess, as the XenSource machine uses the multipathed
drive, right?

Now I would like to take snapshots of the whole PV so I can make
backups. My thoughts where to make a PV on /dev/mapper/xen that spans
the whole disk, and then create a single LV on it. 

If I then take the path to that single LV, say /dev/volumegroup/disk1 as
target for iSCSI, then the XenSsource server should only see that LV as
the shared iSCSI repository.

But then XenSource wil create a PV and a couple of LV's in the existing
LV (created on the storage server and shared true iSCSI). Could that
create any problems or can I just do that?

In this way, I can take the snapshots on the storage server and I don't
have to create a second iSCSI target for the XenSource server, And I
don't have to make extensive use of the network (it can then be done on
one machine directly connected to both LUN's).

Sorry for the long post, but hope you give me some insight on this.

Thanks,

Sander
