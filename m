From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: [PATCH] multipath-tools: document why dev_loss_tmo
 is set to infinity for HPE 3PAR
Date: Thu, 13 Dec 2018 11:56:13 -0600
Message-ID: <CAAMCDedkQgwY5r5iC=CDk6HP8yFw9n1Q80Od+f_KWUtt-Y0fAw@mail.gmail.com>
References: <20181212165833.12407-1-xose.vazquez@gmail.com>
	<CAAMCDednRXQqf9hgW5kKNSEoFgVjW21BQv3FmVUSVQTiXoQk8Q@mail.gmail.com>
	<72e925c5524541dd430ba897f7463321f34ab66e.camel@suse.de>
	<CAAMCDec1ag2t=VPtFKx0UOGqECbyZLbx6HkX6vAkAqHk_crnqA@mail.gmail.com>
	<9f7cfda3a07fc15da864aa2b59b6eec86827060b.camel@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <9f7cfda3a07fc15da864aa2b59b6eec86827060b.camel@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: mwilck@suse.de
Cc: dm-devel@redhat.com, xose.vazquez@gmail.com
List-Id: dm-devel.ids

On Thu, Dec 13, 2018 at 11:16 AM Martin Wilck <mwilck@suse.de> wrote:
>
> On Thu, 2018-12-13 at 10:46 -0600, Roger Heflin wrote:
> > > You are confusing fast_io_fail_tmo and dev_loss_tmo. What you just
> > > described is fast_io_fail_tmo. If dev_loss_tmo expires, the SCSI
> > > layer
> > > does indeed remove the SCSI target. See comments on the
> > > fc_remote_port_delete() function.
> > > (
> > the lpfc driver lets one set dev_loss_tmo and the description on the
> > parameter seems like it should be fast_io_fail_tmo rather that
> > dev_loss_tmo, from how it is working it appears to be used to set
> > dev_loss_tmo in the scsi layer.
>
> On my system, the docstring of lpfc.devloss_tmo says "Seconds driver
> will hold I/O waiting for a device to come back". Which is basically
> true, although it does not say that when the waiting is over, the
> device node is removed.

In older version the device was not removed, so there was a behavior change.

>
> >    And the lpfc driver does not have a
> > setting for the fast_io_fail_tmo and that would seem to be what is
> > actually needed/wanted.
>
> That is set via the generic scsi_transport_fc layer. Normally you do it
> with multipath-tools, as the parameter is only useful in multipath
> scenarios.
>
> >  The reason for setting it was we have had fc
> > fabric failures that did not result in an error being return to
> > multipath, such that multipath could not failover to the other
> > working
> > paths.
>
> You should have been setting fast_io_fail_tmo in multipath.conf.

When we started setting the lpfc parameter, multipath did not yet
manage fast_io_fail_tmo nor dev_loss_tmo so it was not an option.

> > We are thinking of setting dev_loss_tmo to 86400 (24 hours) as that
> > is
> > a happy medium, and leaves the paths around during reasonable events,
> > but results in a clean-up at 24 hours.
>
> That sounds reasonable. But that's a matter of policy, which
> differs vastly between different installations and administrator
> preferences. The point I'm trying to make is: it doesn't make a lot
> of sense to tie this setting to the storage hardware properties, as
> multipath currently does. It's really much more a matter of data center
> administration. That's different for fast_io_fail_tmo - it makes
> sense to relate this timeout to hardware properties, e.g. the time it
> takes to do failover or failback.
>
> IMO, in a way, the different dev_loss_tmo settings in multipath's
> hardware table reflect the different vendor's ideas of how the storage
> should be administrated rather than the actual properties of the
> hardware.

And that is kind of the conclusion we were coming to, it is a
preference based on datacenter admin.

>

> > Do you have an idea how many years ago the dev_loss_tmo started
> > actually removing the device?   I am guessing when that was
> > backported
> > into rhel was what I saw it start, but iI don't know exactly when it
> > was backported.
>
> I can see it in 2.6.12 (2005):
>
> https://elixir.bootlin.com/linux/v2.6.12/source/drivers/scsi/scsi_transport_fc.c#L1549
>
In rhel5 (2.6.18+) it did not actually delete the device I believe
until around 5.8, so all of the magic may not have quite been working
yet.

> You need to understand that, when time starts ticking towards the
> dev_loss_tmo, the FC remote port port is *already gone*. On the
> transport layer, there's nothing to "remove" any more. The kernel just
> keeps the SCSI layer structures and waits if the device comes back, as
> it would for temporary failures such as network outage or an operator
> having pulled the wrong cable.
>

We understand that.  The issues seem to be that once the device is
deleted the process that brings the devices back as a path when the
rport/cable is fixed is not reliable (it fails say 1 in 100 events and
causes issues) when the cable is far enough removed from the host (ie
the array port connect to a fc switch).   And when routed fc storage
is involved everything gets much less reliable all around.  It always
works if the cable issue being fixed is the cable to the host, but
once it gets far enough away there seem to be an issue sometimes.   So
the hope is if the device is still there and still being probed my
multipath that there will be less reliance on the imperfect fc magic,
it may or may not help anything, and we may have to upgrade something
and actively scan and resolve path issues manually before upgrading
the next component that will take out another path.
