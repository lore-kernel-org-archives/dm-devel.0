From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: Multipath blacklist exceptions issues
Date: Thu, 15 Nov 2007 17:03:42 -0500 (EST)
Message-ID: <20071115.170342.104029392.k-ueda@ct.jp.nec.com>
References: <5201e28f0711131517p79fc4a8dk1da9bda922c3093e@mail.gmail.com>
	<20071114.154456.71084719.k-ueda@ct.jp.nec.com>
	<20071115192428.GD4900@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20071115192428.GD4900@ether.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, bmarzins@redhat.com
List-Id: dm-devel.ids

Hi Ben,

On Thu, 15 Nov 2007 13:24:28 -0600, Benjamin Marzinski <bmarzins@redhat.com> wrote:
> On Wed, Nov 14, 2007 at 03:44:56PM -0500, Kiyoshi Ueda wrote:
> > 
> > Why do you need to separate the first stage and the second stage?
> > I don't think we need to separate them.
> > I think the point is whether execute getuid callout or not.
> > So we should need just 2 stages like below:
> > (The keyword "pre_getuid_filter" is not so good, just a example.)
> > 
> > ----------------------- /etc/multipath.conf -------------------------
> > # First stage filter.  Drop unneeded devices on this stage
> > pre_getuid_filter {
> > 	whitelist_driver "scsi|cciss"
> > 	whitelist_device {
> > 		vendor	"IBM"
> > 		model	"S/390 DASD ECKD"
> > 	}
> > 	blacklist_driver "*"
> > }
> > 
> > # Second stage filter
> > filter {
> > 	blacklist_devnode "sda"
> > 	whitelist_wwid "012345"
> > 	blacklist_wwid "*"
> > 	# only wwid filter may be enough in this stage
> > }
> > ---------------------------------------------------------------------
> > 
> > ---------------------------- multipathd -----------------------------
> > for_each_devnode in /sys/block {
> >     o gather all sysfs information including vendor and model
> >     o decide whether it is needed using the first stage filter
> >       (the matching rule is that first match is used)
> >     o store it in pathvec if needed
> > }
> > 
> > for_each_remained_devnode in pathvec {
> >     o run getuid callout
> >     o decide whether it should be used for map by the second stage filter
> >       (the matching rule is that first match is used)
> > }
> > ---------------------------------------------------------------------
> > 
> > What do you think?
> 
> This method has a lot going for it.  I like the ability to override the
> default blacklisted drivers, even if it's almost never used, which you
> couldn't do with an "invalid_drivers" section. I also like the finer
> granularity on which devices to run the getuid callout on.
> 
> On the other hand, I agree with Stefan that there will be issues with
> trying to gather the sysfs information for devices that just don't have
> it.  Like he said, you can ignore them, but I wonder if this might cause
> problems for the rare, but still possible, case where you expect that
> a device should properly provide all its sysfs information, but for some
> reason, you can't get it. In this case the device would most likely be
> silently ignored.  Obviously, we can provide the information if you run
> the commands with a higher verbosity.

I think it's no problem because of the reason below.

It depends on subsystem type whether vendor/model information exist
in sysfs or not.
Multipath-tools already has sysfs scanners for each subsystem type
(e.g. scsi_sysfs_pathinfo, ccw_sysfs_pathinfo, cciss_sysfs_pathinfo).
When there is no vendor/model information, each scanner can make
appropriate decision: for example,
  - scsi scanner will take it as error and drop the device
  - cciss scanner won't care about it and use the device

After that, devices without vendor/model information don't match
any "device" rules, either blacklist nor whitelist.
They can match other rules like "devnode" and "driver".

Thanks,
Kiyoshi Ueda
