From: "S. J. van Harmelen" <svh@dds.nl>
Subject: Re: Use LVM on /dev/mapper/diskname and iSCSI
Date: Tue, 20 Nov 2007 10:38:11 +0100
Message-ID: <1195551491.6329.16.camel@sanderbal>
References: <1195480602.6074.3.camel@sanderbal> <47419854.2000508@linpro.no>
	<1195484847.6074.16.camel@sanderbal>
	<20071119185021.GA23100@us.ibm.com>
	<1195506996.11489.23.camel@sanderbal>
	<20071119223612.GA23779@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20071119223612.GA23779@us.ibm.com>
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

On Mon, 2007-11-19 at 14:36 -0800, malahal@us.ibm.com wrote:
> S. J. van Harmelen [svh@dds.nl] wrote:
> > 
> > On the XenSource server I use a shared iSCSI storage so multiple servers
> > can access the same data so I can do live migrations. When I add the
> > storage XenSource creates a PV and then when I create a VM, it creates
> > LV's for each virtual harddisk.
> > 
> > So far so good I guess, as the XenSource machine uses the multipathed
> > drive, right?
> 
> Should.
>  
> > Now I would like to take snapshots of the whole PV so I can make
> > backups. My thoughts where to make a PV on /dev/mapper/xen that spans
> > the whole disk, and then create a single LV on it. 
> > 
> > If I then take the path to that single LV, say /dev/volumegroup/disk1 as
> > target for iSCSI, then the XenSsource server should only see that LV as
> > the shared iSCSI repository.
> > 
> > But then XenSource wil create a PV and a couple of LV's in the existing
> > LV (created on the storage server and shared true iSCSI). Could that
> > create any problems or can I just do that?
> 
> I don't see any problem. You should be able to do that, but then I am
> not an expert. Give it a try.

Thanks, I will give it a try then!

Sander
