From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: Multipath blacklist exceptions issues
Date: Thu, 15 Nov 2007 13:24:28 -0600
Message-ID: <20071115192428.GD4900@ether.msp.redhat.com>
References: <5201e28f0711101625r19ceaf11yd3727c424f27b7d8@mail.gmail.com>
	<20071113201804.GJ28113@ether.msp.redhat.com>
	<5201e28f0711131517p79fc4a8dk1da9bda922c3093e@mail.gmail.com>
	<20071114.154456.71084719.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20071114.154456.71084719.k-ueda@ct.jp.nec.com>
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

On Wed, Nov 14, 2007 at 03:44:56PM -0500, Kiyoshi Ueda wrote:
> 
> Why do you need to separate the first stage and the second stage?
> I don't think we need to separate them.
> I think the point is whether execute getuid callout or not.
> So we should need just 2 stages like below:
> (The keyword "pre_getuid_filter" is not so good, just a example.)
> 
> ----------------------- /etc/multipath.conf -------------------------
> # First stage filter.  Drop unneeded devices on this stage
> pre_getuid_filter {
> 	whitelist_driver "scsi|cciss"
> 	whitelist_device {
> 		vendor	"IBM"
> 		model	"S/390 DASD ECKD"
> 	}
> 	blacklist_driver "*"
> }
> 
> # Second stage filter
> filter {
> 	blacklist_devnode "sda"
> 	whitelist_wwid "012345"
> 	blacklist_wwid "*"
> 	# only wwid filter may be enough in this stage
> }
> ---------------------------------------------------------------------
> 
> ---------------------------- multipathd -----------------------------
> for_each_devnode in /sys/block {
>     o gather all sysfs information including vendor and model
>     o decide whether it is needed using the first stage filter
>       (the matching rule is that first match is used)
>     o store it in pathvec if needed
> }
> 
> for_each_remained_devnode in pathvec {
>     o run getuid callout
>     o decide whether it should be used for map by the second stage filter
>       (the matching rule is that first match is used)
> }
> ---------------------------------------------------------------------
> 
> What do you think?

This method has a lot going for it.  I like the ability to override the
default blacklisted drivers, even if it's almost never used, which you
couldn't do with an "invalid_drivers" section. I also like the finer
granularity on which devices to run the getuid callout on.

On the other hand, I agree with Stefan that there will be issues with
trying to gather the sysfs information for devices that just don't have
it.  Like he said, you can ignore them, but I wonder if this might cause
problems for the rare, but still possible, case where you expect that
a device should properly provide all its sysfs information, but for some
reason, you can't get it. In this case the device would most likely be
silently ignored.  Obviously, we can provide the information if you run
the commands with a higher verbosity.

The bigger issue I have is that there should be a way to tell multipath,
"Don't do anything."  Many people have a multipath package installed on
their systems that they don't even know about, and they don't want it to
do anything.  Right now, if you have

blacklist {
	devnode ".*"
}

You pretty much get that behaviour. If anything on their system happens
to run the multipath command, nothing much really happens.  With this
method, your adding more things that multipath has to do before if
realizes that it shouldn't be doing anything. Of course this could
easily be solved by adding the parameter to the defaults section of
multipath.conf.

defaults {
	disable yes
}

This would allow multipath to quit immediately after reading the config
file, and it would seperate the choice to disable multipath from the
blacklist setup.

-Ben

> Thanks,
> Kiyoshi Ueda
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
