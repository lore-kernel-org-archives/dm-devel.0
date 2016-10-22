From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] multipath-tools: remove hwhandler when it's
	alua
Date: Sat, 22 Oct 2016 19:58:29 +0200
Message-ID: <2f81785a-58fc-77e6-34ad-c46e99d6683d@gmail.com>
References: <20161006185021.3625-1-xose.vazquez@gmail.com>
	<CABr-GnfHUoWn_q4LfvhDeF6w_vPcMg8VRjEN98quZ6+oes1Ryw@mail.gmail.com>
	<1d46912b-0cad-89e4-2bd6-2b4c9e3fe67f@suse.de>
	<305ee5f4-8a06-4f33-6f72-892c0a9919a2@gmail.com>
	<20161012162055.GE1972@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161012162055.GE1972@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 10/12/2016 06:20 PM, Benjamin Marzinski wrote:

> On Wed, Oct 12, 2016 at 01:06:10PM +0200, Xose Vazquez Perez wrote:

>> RDAC devices also depend *exclusively* on "retain_attached_hw_handler"
>> and "detect_prio" to run in ALUA mode.

> The purpose of the the "retain_attached_hw_handler" and "detect_prio"
> options were to allow devices that support ALUA and non-ALUA modes, to
> detect which mode the device was in, so that the builtin configuration
> would work correctly for both modes.

Then that is validating my point, hwhandler="1 alua" is superfluous.
Because it's autodetected and autoconfigured from the array, first from
the kernel and later from multipath-tools.

> If a device is ALUA only, I don't see any benefit to not hardcoding
> that.  Simply from a ease-of-use persepective, having ALUA in the
> configuration make it obvious how the device is supposed to be
> configured.

It's redundant having RETAIN_HWHANDLER_ON and hwhandler="1 alua" defined.

>  But more importantly, as has already been metioned, it's
> more robust to hardcode the ALUA handler for the devices that need it in
> case the handler was not attached before multipath started working on
> the device.

Why you do not trust the SCSI subsystem? It seems a bit paranoid.
Anyway, if you are really uncomfortable with the change, this patch
should be dropped.

> Also, if I recall correctly, for the device handler to get
> attached correctly, we don't just need the device handler module
> isntalled before multipathd starts. We need it installed when the path
> device is initially discovered.

This is a kernel modules dependency bug. Distributions can bypass it
by including these modules in the initrd image.

> The more I think about this, the more I think we might want to revisit
> some to the configuration simplifications that have been made.

Could you please review all commits?
git log -p --reverse --since="Mon Jun 13 16:38:50 2016" libmultipath/hwtable.c
What should be removed?

> In some cases, I think they went too far. For instance, most devices will work
> correctly regardless of the values for things like "rr_minio_rq" and
> "path_selector", so I have no objection to these values being removed
> from the device configuartion, if they are the same as the default
> values.  On the other hand, we have things like "hardware_handler" and
> "path_checker", where the device simply will not function correctly with
> certain values.  For these attributes, it makes sense to leave them in
> the device configuration, even if they are the same as the default
> values.

Related to path_checker, only two changes were done:
6019c4e0 replace TUR by RDAC in two RDAC devices
40fd537c replace DIRECTIO by TUR(default)

Related to hardware_handler, no relevant changes were done.

> The goal should be that you can't break any device
> configurations by changing the default values.

It is going to be too verbose, you should send a patch to prove your thoughts.

Thank you.
