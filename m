From: Martin Wilck <mwilck@suse.de>
Subject: Re: [PATCH] multipath-tools: document why dev_loss_tmo
 is set to infinity for HPE 3PAR
Date: Thu, 13 Dec 2018 18:16:06 +0100
Message-ID: <9f7cfda3a07fc15da864aa2b59b6eec86827060b.camel@suse.de>
References: <20181212165833.12407-1-xose.vazquez@gmail.com>
	<CAAMCDednRXQqf9hgW5kKNSEoFgVjW21BQv3FmVUSVQTiXoQk8Q@mail.gmail.com>
	<72e925c5524541dd430ba897f7463321f34ab66e.camel@suse.de>
	<CAAMCDec1ag2t=VPtFKx0UOGqECbyZLbx6HkX6vAkAqHk_crnqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAAMCDec1ag2t=VPtFKx0UOGqECbyZLbx6HkX6vAkAqHk_crnqA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Roger Heflin <rogerheflin@gmail.com>
Cc: dm-devel@redhat.com, xose.vazquez@gmail.com
List-Id: dm-devel.ids

On Thu, 2018-12-13 at 10:46 -0600, Roger Heflin wrote:
> > You are confusing fast_io_fail_tmo and dev_loss_tmo. What you just
> > described is fast_io_fail_tmo. If dev_loss_tmo expires, the SCSI
> > layer
> > does indeed remove the SCSI target. See comments on the
> > fc_remote_port_delete() function.
> > (
> the lpfc driver lets one set dev_loss_tmo and the description on the
> parameter seems like it should be fast_io_fail_tmo rather that
> dev_loss_tmo, from how it is working it appears to be used to set
> dev_loss_tmo in the scsi layer.

On my system, the docstring of lpfc.devloss_tmo says "Seconds driver
will hold I/O waiting for a device to come back". Which is basically
true, although it does not say that when the waiting is over, the
device node is removed. 

>    And the lpfc driver does not have a
> setting for the fast_io_fail_tmo and that would seem to be what is
> actually needed/wanted. 

That is set via the generic scsi_transport_fc layer. Normally you do it
with multipath-tools, as the parameter is only useful in multipath
scenarios.

>  The reason for setting it was we have had fc
> fabric failures that did not result in an error being return to
> multipath, such that multipath could not failover to the other
> working
> paths.

You should have been setting fast_io_fail_tmo in multipath.conf.


> > For multipath, what really matters is fast_io_fail_tmo.
> > dev_loss_tmo
> > only matters if fast_io_fail_tmo is unset. fast_io_fail is
> > preferred,
> > because path failure/reinstantiation is much easier to handle than
> > path
> > removal/re-addition, on both kernel and user space level. The
> > reason
> > dev_loss_tmo is not infinity by default is twofold: 1) if
> > fast_io_fail
> > is not used and dev_loss_tmo is infinity, IOs might block on a
> > removed
> > device forever; 2) even with fast_io_fail, if a lost device doesn't
> > come back after a long time, it might be good not to carry it
> > around
> > forever - chances are that the storage admin really removed the
> > device
> > or changed the zoning.
> 
> We are thinking of setting dev_loss_tmo to 86400 (24 hours) as that
> is
> a happy medium, and leaves the paths around during reasonable events,
> but results in a clean-up at 24 hours.

That sounds reasonable. But that's a matter of policy, which
differs vastly between different installations and administrator
preferences. The point I'm trying to make is: it doesn't make a lot 
of sense to tie this setting to the storage hardware properties, as
multipath currently does. It's really much more a matter of data center
administration. That's different for fast_io_fail_tmo - it makes
sense to relate this timeout to hardware properties, e.g. the time it
takes to do failover or failback.

IMO, in a way, the different dev_loss_tmo settings in multipath's
hardware table reflect the different vendor's ideas of how the storage
should be administrated rather than the actual properties of the
hardware.

> 
> > I'm wondering what you're talking about. dev_loss_tmo has been in
> > the
> > SCSI layer for ages.
> 
> Do you have an idea how many years ago the dev_loss_tmo started
> actually removing the device?   I am guessing when that was
> backported
> into rhel was what I saw it start, but iI don't know exactly when it
> was backported.

I can see it in 2.6.12 (2005):

https://elixir.bootlin.com/linux/v2.6.12/source/drivers/scsi/scsi_transport_fc.c#L1549

You need to understand that, when time starts ticking towards the
dev_loss_tmo, the FC remote port port is *already gone*. On the
transport layer, there's nothing to "remove" any more. The kernel just
keeps the SCSI layer structures and waits if the device comes back, as
it would for temporary failures such as network outage or an operator
having pulled the wrong cable.

Regards
Martin
