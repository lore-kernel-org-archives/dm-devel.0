From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] libmultipath: don't lock block device but
	use lock files
Date: Sun, 24 May 2015 09:07:24 +0200
Message-ID: <556178AC.2010501@suse.de>
References: <5560EA5C.6040001@iwakd.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070206090401090509020604"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5560EA5C.6040001@iwakd.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christian Seiler <christian@iwakd.de>, dm-devel@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------070206090401090509020604
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by mx6-phx2.redhat.com id t4O77aXW018131

On 05/23/2015 11:00 PM, Christian Seiler wrote:
> In recent versions udev uses flock() on the device node itself,
> breaking libmultipath's current locking logic. Since libmultipath
> doesn't actually modify anything on the device itself (and hence does
> not actually need an exclusive lock on the device node, unlike e.g.
> tools that create partitions etc.), and the reason for the lock is to
> guard against multipath interfering with multipathd, use lock files
> (named after the devices) in /run/lock/multipath instead.
>=20
> See the discussion under:
> https://www.redhat.com/archives/dm-devel/2014-December/msg00083.html
> Especially:
> https://www.redhat.com/archives/dm-devel/2014-December/msg00117.html
>=20
> Signed-off-by: Christian Seiler <christian@iwakd.de>
>=20
> ---
Well ... couldn't you just use a shared lock here?

I thought to have send this patch already; hmm.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg)

--------------070206090401090509020604
Content-Type: text/x-patch;
 name="multipath-shared-lock.patch"
Content-Disposition: attachment;
 filename="multipath-shared-lock.patch"
Content-Transfer-Encoding: 7bit

From 841977fc9c3432702c296d6239e4a54291a6007a Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@suse.de>
Date: Tue, 24 Jun 2014 08:49:15 +0200
Subject: [PATCH] libmultipath: use a shared lock to co-operate with udev

udev since v214 is placing a shared lock on the device node
whenever it's processing the event. This introduces a race
condition with multipathd, as multipathd is processing the
event for the block device at the same time as udev is
processing the events for the partitions.
And a lock on the partitions will also be visible on the
block device itself, hence multipathd won't be able to
lock the device.
When multipath manages to take a lock on the device,
udev will fail, and consequently ignore this entire event.
Which in turn might cause the system to malfunction as it
might have been a crucial event like 'remove' or 'link down'.

So we should better use LOCK_SH here; with that the flock
call in multipathd _and_ udev will succeed and the events
can be processed.

References: bnc#883878

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 0ddd3d5..dc2ebf0 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -529,7 +529,7 @@ lock_multipath (struct multipath * mpp, int lock)
 		if (!pgp->paths)
 			continue;
 		vector_foreach_slot(pgp->paths, pp, j) {
-			if (lock && flock(pp->fd, LOCK_EX | LOCK_NB) &&
+			if (lock && flock(pp->fd, LOCK_SH | LOCK_NB) &&
 			    errno == EWOULDBLOCK)
 				goto fail;
 			else if (!lock)

--------------070206090401090509020604
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 7bit


--------------070206090401090509020604--
