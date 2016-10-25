From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH] multipath-tools: remove hwhandler when it's
	alua
Date: Tue, 25 Oct 2016 12:24:05 -0500
Message-ID: <20161025172405.GP1972@octiron.msp.redhat.com>
References: <20161006185021.3625-1-xose.vazquez@gmail.com>
	<CABr-GnfHUoWn_q4LfvhDeF6w_vPcMg8VRjEN98quZ6+oes1Ryw@mail.gmail.com>
	<1d46912b-0cad-89e4-2bd6-2b4c9e3fe67f@suse.de>
	<305ee5f4-8a06-4f33-6f72-892c0a9919a2@gmail.com>
	<20161012162055.GE1972@octiron.msp.redhat.com>
	<2f81785a-58fc-77e6-34ad-c46e99d6683d@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <2f81785a-58fc-77e6-34ad-c46e99d6683d@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Sat, Oct 22, 2016 at 07:58:29PM +0200, Xose Vazquez Perez wrote:
> On 10/12/2016 06:20 PM, Benjamin Marzinski wrote:
> 
> > On Wed, Oct 12, 2016 at 01:06:10PM +0200, Xose Vazquez Perez wrote:
> 
> >> RDAC devices also depend *exclusively* on "retain_attached_hw_handler"
> >> and "detect_prio" to run in ALUA mode.
> 
> > The purpose of the the "retain_attached_hw_handler" and "detect_prio"
> > options were to allow devices that support ALUA and non-ALUA modes, to
> > detect which mode the device was in, so that the builtin configuration
> > would work correctly for both modes.
> 
> Then that is validating my point, hwhandler="1 alua" is superfluous.
> Because it's autodetected and autoconfigured from the array, first from
> the kernel and later from multipath-tools.
> 
> > If a device is ALUA only, I don't see any benefit to not hardcoding
> > that.  Simply from a ease-of-use persepective, having ALUA in the
> > configuration make it obvious how the device is supposed to be
> > configured.
> 
> It's redundant having RETAIN_HWHANDLER_ON and hwhandler="1 alua" defined.
> 

I'm not denying that it is reduntant if the hardware handler gets
attached by the scsi subsystem. I'm objecting because I've seen cases
where the hardware handler does not get attached by the scsi subsystem.
Also, it means that the device will still be configured correctly if the
user disables "retain_attached_hw_handler" in the defaults section.

> >  But more importantly, as has already been metioned, it's
> > more robust to hardcode the ALUA handler for the devices that need it in
> > case the handler was not attached before multipath started working on
> > the device.
> 
> Why you do not trust the SCSI subsystem? It seems a bit paranoid.
> Anyway, if you are really uncomfortable with the change, this patch
> should be dropped
> 

Because I've seen cases where it doesn't work. They were always dealing
with devices not getting correctly set up at boot, and they are
solvable, but there is no reason why we need to make solving them
necessary in these cases.

> > Also, if I recall correctly, for the device handler to get
> > attached correctly, we don't just need the device handler module
> > isntalled before multipathd starts. We need it installed when the path
> > device is initially discovered.
> 
> This is a kernel modules dependency bug. Distributions can bypass it
> by including these modules in the initrd image.

Sure, but why should we not just be convenient and include the hardware
handler in the device config, to avoid this necessity?
 
> > The more I think about this, the more I think we might want to revisit
> > some to the configuration simplifications that have been made.
> 
> Could you please review all commits?
> git log -p --reverse --since="Mon Jun 13 16:38:50 2016" libmultipath/hwtable.c
> What should be removed?

Here are some ones that demonstrate what I'm talking about

f568ca361a614389b316707091708ba1be972588
92ea4f9e61216a066b9637386142c3f0a054dbae
af186a82594248160dff5d759f9dbdea6a42befb (except minio/minio_rq)
1db20948432b75dad1ba13daa50b9f66e8eb78b2
40fd537c4966ec195641e004b756127e94d5e817

In these patches we are removing configuration parameters that are
necessary for the device to function correctly. If the user changes
these values in the defaults section, it will break the builtin device
configurations.  The idea for the defaults section values is that they
are used for cases where there isn't a builtin configuration for the
device.  But by making the device configuration depend on the defaults
section, this is no longer the case.

> > In some cases, I think they went too far. For instance, most devices will work
> > correctly regardless of the values for things like "rr_minio_rq" and
> > "path_selector", so I have no objection to these values being removed
> > from the device configuartion, if they are the same as the default
> > values.  On the other hand, we have things like "hardware_handler" and
> > "path_checker", where the device simply will not function correctly with
> > certain values.  For these attributes, it makes sense to leave them in
> > the device configuration, even if they are the same as the default
> > values.
> 
> Related to path_checker, only two changes were done:
> 6019c4e0 replace TUR by RDAC in two RDAC devices
> 40fd537c replace DIRECTIO by TUR(default)
> 
> Related to hardware_handler, no relevant changes were done.

I don't have issues with these at all.

> > The goal should be that you can't break any device
> > configurations by changing the default values.
> 
> It is going to be too verbose, you should send a patch to prove your thoughts.

huh? We used to do this. In fact, we also had a bunch of parameters that
weren't necessary for the devices to work correctly in almost every
device configuration. I am fully in support of removing the unnecessary
parameters from the config configuration section, like "rr_minio_rq",
"path_selector", etc.

I would argue that all builtin device configurations should include:

pgpolicy
checker_name
hwhandler
prio_name
prio_args

even if they match the default value, since using the wrong value here
can easily make the device not work at all. I can see reasons for and
against always including

uid_attribute
features
pgfailback
retain_hwhandler
detect_prio

uid attribute is so universal, that it's likely that if the user wants
to change it, they want to change it for all devices, and its quite
possible for udev to offer another variable that works equally well for
all the devices that currently use "ID_SERIAL".

Again with features, the user could conceivably want to add a new
feature to all the devices, and in this case, it's very possible that it
wouldn't break anything

While all devices should work with any pgfailback setup, multipathd does
different amounts of work with the different policies, so I could go
either way here.

With retain_hwhandler and detect_prio, I can see where users would want
to keep those for the devices that really do have multiple modes, while
removing them for all the devices that don't need them.

As far as all the other parameters, I like the idea of only including
them if they are different from the defaults, since they aren't
necessary for the device to function correctly, and it does make them
easier to configure across a range of devices.

I think the rule should be, if the device can be made unusable by
changing a parameter, then that parameter should be set in the devices
configuration, even if it matchces the default. If not, then it should
only be set in the devices section if it's different from the default.

-Ben

> Thank you.
