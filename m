From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/7] Fix muitpath/multipathd flush issue
Date: Fri, 3 Jul 2020 12:39:09 -0400
Message-ID: <20200703163909.GA7187@redhat.com>
References: <20200618180458.GI5894@octiron.msp.redhat.com>
	<c5e95e7bc75b11e811854ff0b0988ff19ef45e13.camel@suse.com>
	<20200618230625.GJ5894@octiron.msp.redhat.com>
	<5357998bd17e1147fd3a6615e03251d1aa4900d8.camel@suse.com>
	<20200702031449.GB29962@octiron.msp.redhat.com>
	<8158d509bca2cae483d553defdd1eb378c16d813.camel@suse.com>
	<20200702151829.GA11089@octiron.msp.redhat.com>
	<cd568c7aabaa102db8ef6ba8ceb87b96d62f632c.camel@suse.com>
	<20200702194128.GG11089@octiron.msp.redhat.com>
	<be1e8d96543bc86a6a194bb9c708fba91878d9c9.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <be1e8d96543bc86a6a194bb9c708fba91878d9c9.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Martin Wilck <Martin.Wilck@suse.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "zkabelac@redhat.com" <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Fri, Jul 03 2020 at 11:12am -0400,
Martin Wilck <Martin.Wilck@suse.com> wrote:

> On Thu, 2020-07-02 at 14:41 -0500, Benjamin Marzinski wrote:
> > On Thu, Jul 02, 2020 at 04:45:21PM +0000, Martin Wilck wrote:
> > > 
> > > What's wrong with deferred remove? After all, the user explicitly
> > > asked
> > > for a flush. As long as some other process has the device open, it
> > > won't be removed. That's why I like the O_EXCL idea, which will
> > > allow
> > > small programs like blkid to access the device, but will cause all
> > > attempts to mount or add stacked devices to fail until the device
> > > is
> > > actually removed. I see no reason no to do this, as it's a race
> > > anyway
> > > if some other process opens the device when we're supposed to flush
> > > it
> > > and the opencount already dropped to 0. By using O_EXCL, we just
> > > increase multipathd's chances to win the race and do what the user
> > > asked for.
> > 
> > I'm not actually a fan of deferred remove in general. It leaves the
> > device in this weird state were it is there but no longer openable. 
> 
> Ok, I didn't expect that ;-)
> 
> AFAICS, devices in DEFERRED REMOVE state are actually still openable. I
> just tested this once more on a 5.3 kernel.
> 
> As long as the device is opened by some process and thus not removed,
> it can be opened by other processes, and is not deleted until the last
> opener closes it. It's even possible to create new device mapper layers
> like kpartx partitions on top of a DM device in DEFERRED REMOVE state.
> 
> > I
> > wish I had originally dealt with deferred removes by having
> > multipathd
> > occasionally try to flush devices with no paths, or possibly listen
> > for
> > notifications that the device has been closed, and flush then.
> > 
> > My specific objections here are that not all things that open a
> > device
> > for longer than an instant do so with O_EXCL.  So it's very possible
> > that you run "multipath -F", it returns having removed a number of
> > unused devices.  But some of the devices it didn't remove were opened
> > without O_EXCL, and they will stick around for a while, and then
> > suddenly disappear.  Even if they don't say around for that long,
> > this
> > is a can still effect scripts or other programs that are expecting to
> > check the device state immediately after calling multipath -F, and
> > having it not change a second or so later. So far multipath -f/-F
> > will
> > not return until it has removed all the removeable devices (and
> > waited
> > for them to be removed from udev). I think it should stay this way.
> 
> I see. That's a valid point. IMHO it'd be better if the kernel didn't
> allow any new access to devices in "deferred remove" state, and
> possibly sent a REMOVE uevent and hide the device immediately after the
> deferred remove ioctl. 
> 
> That would also be closer to how "lazy umount" (umount -l) behaves.
> But I'm certainly overlooking some subtle semantic issues. 
> 
> @Mike, Zdenek: perhaps you can explain why "deferred remove" behaves
> like this?

"deferred remove" was introduced with commits:

2c140a246dc dm: allow remove to be deferred
acfe0ad74d2 dm: allocate a special workqueue for deferred device removal

The feature was developed to cater to the docker "devicemapper" graph
driver [1][2] that uses DM thin provisioning in the backend (Red Hat's
openshift once used a docker that used thinp in production for thinp's
snapshot capabilities. overlayfs is now used instead because it allows
page cache sharing which results in the ability to support vastly more
containers that all are layered on snapshots of the same "device").

Anyway, back to deferred remove: docker's Go-lang based implementation
and storage graph driver interface were clumsily written to require this
lazy removal of used resources.  As such, we had to adapt and the result
was "deferred device" remove that really could be used by any DM device.

Docker couldn't have later opens fail due to a pending removal -- it'd
break their app.  So if you want it to do what you'd have imagined it to
be; we'll need to introduce a new flag that alters the behavior (maybe
as a module param off of DM core's dm-mod.ko).  Patches welcome -- but
you'll need a pretty good reason (not read back far enough but maybe
you have one?).

Thanks,
Mike

 
[1] https://docs.docker.com/storage/storagedriver/device-mapper-driver/
[2] https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux_atomic_host/7/html/managing_containers/managing_storage_with_docker_formatted_containers
