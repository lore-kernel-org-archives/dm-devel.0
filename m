From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH] multipath-tools: remove hwhandler when it's
	alua
Date: Wed, 12 Oct 2016 11:20:55 -0500
Message-ID: <20161012162055.GE1972@octiron.msp.redhat.com>
References: <20161006185021.3625-1-xose.vazquez@gmail.com>
	<CABr-GnfHUoWn_q4LfvhDeF6w_vPcMg8VRjEN98quZ6+oes1Ryw@mail.gmail.com>
	<1d46912b-0cad-89e4-2bd6-2b4c9e3fe67f@suse.de>
	<305ee5f4-8a06-4f33-6f72-892c0a9919a2@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <305ee5f4-8a06-4f33-6f72-892c0a9919a2@gmail.com>
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

On Wed, Oct 12, 2016 at 01:06:10PM +0200, Xose Vazquez Perez wrote:

> On 10/11/2016 08:22 AM, Hannes Reinecke wrote:
> 
> > Autodetection will only work if the hardware handler is loaded.
> > If the handler is _not_ loaded autodetection won't work, either.
> > And if we add this patch multipath will never load the modules, neither.
> > So we need this functionality as a fallback if autodetect does not work.
> 
> I'm pretty sure all works flawlessly with this patch. Because I use similar
> options for EMC VNX7500(CLARiiON) configured as ALUA "Failover Mode 4 (Asymmetric Active/Active)",
> with SLES-11/12 and RHEL-6 booting from SAN.
> 
> For SLES it was added to DGC config:
> retain_attached_hw_handler yes
> detect_prio yes
> 
> In RHEL it's included by default:
> http://pkgs.fedoraproject.org/cgit/rpms/device-mapper-multipath.git/plain/0117-RHBZ-1198424-autodetect-clariion-alua.patch
> 
> And the modules are preloaded by multipathd/multipathd.service:
> ExecStartPre=/sbin/modprobe -a scsi_dh_alua scsi_dh_emc scsi_dh_rdac dm-multipath
> 
> 
> RDAC devices also depend *exclusively* on "retain_attached_hw_handler" and "detect_prio"
> to run in ALUA mode.

The purpose of the the "retain_attached_hw_handler" and "detect_prio"
options were to allow devices that support ALUA and non-ALUA modes, to
detect which mode the device was in, so that the builtin configuration
would work correctly for both modes.

If a device is ALUA only, I don't see any benefit to not hardcoding
that.  Simply from a ease-of-use persepective, having ALUA in the
configuration make it obvious how the device is supposed to be
configured.  But more importantly, as has already been metioned, it's
more robust to hardcode the ALUA handler for the devices that need it in
case the handler was not attached before multipath started working on
the device.  Also, if I recall correctly, for the device handler to get
attached correctly, we don't just need the device handler module
isntalled before multipathd starts. We need it installed when the path
device is initially discovered.

The more I think about this, the more I think we might want to revisit
some to the configuration simplifications that have been made.  In some
cases, I think they went too far. For instance, most devices will work
correctly regardless of the values for things like "rr_minio_rq" and
"path_selector", so I have no objection to these values being removed
from the device configuartion, if they are the same as the default
values.  On the other hand, we have things like "hardware_handler" and
"path_checker", where the device simply will not function correctly with
certain values.  For these attributes, it makes sense to leave them in
the device configuration, even if they are the same as the default
values.  The goal should be that you can't break any device
configurations by changing the default values.

-Ben
