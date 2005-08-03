From: "Reilly, Stephen (MRO)" <Steve.Reilly@hp.com>
Subject: RE: queue_if_no_paths timeout handling
Date: Wed, 3 Aug 2005 16:37:09 -0400
Message-ID: <E8C532D801BE5B479B28B626184E8CDD07C7F2DD@tayexc14.americas.cpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
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



-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of goggin, edward
Sent: Wednesday, August 03, 2005 9:36 AM
To: 'dm-devel@redhat.com'
Subject: RE: [dm-devel] queue_if_no_paths timeout handling

On Sun, 24 Jul 2005 22:17:13 +0200
Lars Marowsky-Bree <lmb@suse.de> wrote

> Proposed solution part A: multipathd should disable queue_if_no_path
> (via the message ioctl) if all paths are down for N seconds.

I like this idea.  Having the time keeping in user space in the
multipathd will help keep the kernel code simpler, but using
kernel timers will introduce even more dependency on keeping
multipathd alive for this to work correctly.  All considered,
I like the idea of using kernel timers, one per multipath
device, used in the manner you cite.
[Reilly, Stephen (MRO)] My suggestion is that this case should be
handled as if we are in single path mode.  Thus in single path case if
the path fails the internal driver timers will expire and present them
back to the user level.  I believe the DM design should follow rule and
not add or change timers and instead sue the logic already within the
kernel.

>=20
> Proposed solution part B: Must figure out a way how to throttle higher
> levels from throwing more IO at us when we're in that state. A regular
> app will be throttled by the fact that no ACK's come back, I guess.

Yes, for synchronous reads and such.  I was really thinking
about the load presented by page write back for periodic
sync/flush of page cache.

>=20
> Proposed solution part C: In case of multipathd dieing, do we need a
> last resort way for the kernel to disable queue if no path by=20
> itself so
> memory can be reclaimed, which might be necessary for multipathd being
> able to restart?

This sounds like a separate problem that needs solving since
keeping a multipathd context running (or restarting one if
there is none already) is needed whether or not all paths
are down.

Also, what about having a path auto-restore multipath attribute
which when set causes ios to be retried once on all failed paths
before being failed IFF all paths to the block device are down?
If the io succeeds on a failed path, reinstate the path from the
kernel.  Doing so will help alleviate some of the pain caused by
having the multipathd process die or getting hung up on a
synchronous memory allocation or file io.

>=20
>=20
> So, there is a more generic issue here involving the fact=20
> that dm-mpath
> and multipathd are pretty tightly coupled, and we might not be able to
> always behave "correctly" if user-space dies on us. (In fact,=20
> I can see
> this affecting not just multipathd, but even some cluster
> infrastructure.) So I have this really sick idea about this, which I'm
> now going to share with you. Grab a bucket before reading on.=20
> But maybe
> you won't find it that horrible.
>=20
> Ready? Ok, I warned you.
>=20
> Within user-space, what we do in the Linux-HA heartbeat=20
> project for some
> of these critical tasks is that we run an application heartbeat to the
> monitor process - if one fails to heartbeat for too long, we'll take
> recovery action.
>=20
> So, how about having critical user-space heartbeat to the kernel?
>=20
> (There's prior art here in the software watchdog, but that's=20
> a much more
> global hammer.)
>=20
> Just having the kernel watch whether the process keeps=20
> running won't do.
> We ought to be able to restart the user-space process, which=20
> might mean
> it exits/restarts within some timeout.
>=20

This seems similar to the respawn action attribute of
/etc/inittab and used by the init process to keep mingetty
processes up and running.

Possibly a process like multipathd could be started by a user
Space process which by sharing the same process group could
simply restart the multipathd when it died.  There could be
a single user space process similar to init or a separate
parent for each one.  Granted there is nothing preventing
the parent from getting killed via user intervention, but
it would likely die due to a coded fault like SIGSEGV since
it its code set would be simple and small.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
