From: Martin Wilck <mwilck@suse.de>
Subject: Re: [PATCH] multipath-tools: document why dev_loss_tmo
 is set to infinity for HPE 3PAR
Date: Thu, 13 Dec 2018 00:44:30 +0100
Message-ID: <72e925c5524541dd430ba897f7463321f34ab66e.camel@suse.de>
References: <20181212165833.12407-1-xose.vazquez@gmail.com>
	<CAAMCDednRXQqf9hgW5kKNSEoFgVjW21BQv3FmVUSVQTiXoQk8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAAMCDednRXQqf9hgW5kKNSEoFgVjW21BQv3FmVUSVQTiXoQk8Q@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Roger Heflin <rogerheflin@gmail.com>, xose.vazquez@gmail.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, 2018-12-12 at 13:44 -0600, Roger Heflin wrote:

> On thing that seems to be a mess with the tmo value that is being
> inherited from the underlying driver, is that the setting for the
> scsi
> layer is significantly different from what multipath calls TMO.
> 
> In the case I have seen with the lpfc driver this is often set fairly
> low (HPE's doc references 14 seconds, and this is similar to what my
> employer is using).
> parm:           lpfc_devloss_tmo:Seconds driver will hold I/O waiting
> for a device to come back (int)
> 
> But setting this on the scsi layer causes it to quickly return an
> error to the multipath layer.  It does not mean that the scsi layer
> removes the device from the system, just that it returns an error so
> that the layer above it can deal with it. 

You are confusing fast_io_fail_tmo and dev_loss_tmo. What you just
described is fast_io_fail_tmo. If dev_loss_tmo expires, the SCSI layer
does indeed remove the SCSI target. See comments on the
fc_remote_port_delete() function.
(https://elixir.bootlin.com/linux/latest/source/drivers/scsi/scsi_transport_fc.c#L2906)

For multipath, what really matters is fast_io_fail_tmo. dev_loss_tmo
only matters if fast_io_fail_tmo is unset. fast_io_fail is preferred,
because path failure/reinstantiation is much easier to handle than path
removal/re-addition, on both kernel and user space level. The reason
dev_loss_tmo is not infinity by default is twofold: 1) if fast_io_fail
is not used and dev_loss_tmo is infinity, IOs might block on a removed
device forever; 2) even with fast_io_fail, if a lost device doesn't
come back after a long time, it might be good not to carry it around
forever - chances are that the storage admin really removed the device
or changed the zoning.

>   The multipath layer
> interprets its value of TMO as when to clean up/remove the underlying
> path that when dev_loss_tmo is hit.    TMO is used in both names, but
> they are not the same usage and meaning and the scsi layer's TMO
> should not be inherited by the multipath layer, as they don't appear
> to actually be the same thing.   In multipath it should probably be
> called remove_fault_paths or something similar.

I'm not sure what you mean with "multipath layer". The kernel dm-
multipath layer has nothing to do with dev_loss_tmo at all. multipath-
tools don't "inherit" this value, either. They *set* it to match the
settings from multipath.conf and the internal hwtable, taking other
related settings into account (in particular, no_path_retry).

> This incorrect inheritance has caused issues, as prior to multipath
> inheriting TMO from the scsi layer, multipath did not remove the
> paths
> when IO failed for TMO time. 

Sorry, no. multipathd *never* removes SCSI paths. If it receives an
event about removal of a path, it updates its own data structures, and
the maps in the dm-multipath layer. That's it.

The only thing that multipath-tools do that may cause SCSI devices to
get removed is to set dev_loss_tmo to a low value. But that would be
a matter of (unusual) configuration.

>   The paths prior to the inheritance
> stayed around and errored until the underlying issue was fixed, or a
> reboot happened, or until someone manually removed the failing paths.
> When I first saw this I had processes to deal with this, and we did
> noticed when it stated automatically cleaning up paths and it was
> good
> since it eliminated manual work, that is until it caused issues
> during
> firmware update.  HPE's update to infinity will be a response to the
> inherited TMO change causing issues.

I'm wondering what you're talking about. dev_loss_tmo has been in the
SCSI layer for ages.

Regards
Martin
