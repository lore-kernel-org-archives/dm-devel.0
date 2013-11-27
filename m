From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/1] MD/DM RAID: Fix hang due to recent RAID5 locking
 changes
Date: Wed, 27 Nov 2013 14:12:08 +1100
Message-ID: <20131127141208.06109ed6@notabene.brown>
References: <1385335843-14021-1-git-send-email-jbrassow@redhat.com>
	<1385335843-14021-2-git-send-email-jbrassow@redhat.com>
	<20131125110315.262223cf@notabene.brown>
	<D89A7889-9B7B-40F1-AD7D-08937D168C7E@redhat.com>
	<30A220BB-6E93-44C9-A487-F23DBF546ED6@redhat.com>
	<20131126162746.4d42ef1d@notabene.brown>
	<3526D887-4D5D-4B09-9CAE-F771EFE45E6A@redhat.com>
	<E92B633B-F0C9-4D97-B97A-4B5536BE907D@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/NX8JcMN4TpMpYxt+u=GzXU4"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E92B633B-F0C9-4D97-B97A-4B5536BE907D@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brassow Jonathan <jbrassow@redhat.com>
Cc: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>
List-Id: dm-devel.ids

--Sig_/NX8JcMN4TpMpYxt+u=GzXU4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 26 Nov 2013 16:34:58 -0600 Brassow Jonathan <jbrassow@redhat.com>
wrote:

>=20
> On Nov 26, 2013, at 8:32 AM, Brassow Jonathan wrote:
>=20
> >=20
> > On Nov 25, 2013, at 11:27 PM, NeilBrown wrote:
> >=20
> >> On Mon, 25 Nov 2013 13:08:56 -0600 Brassow Jonathan <jbrassow@redhat.c=
om>
> >> wrote:
> >>=20
> >>>=20
> >>> On Nov 25, 2013, at 8:20 AM, Brassow Jonathan wrote:
> >>>=20
> >>>>=20
> >>>> On Nov 24, 2013, at 6:03 PM, NeilBrown wrote:
> >>>>=20
> >>>>> On Sun, 24 Nov 2013 17:30:43 -0600 Jonathan Brassow <jbrassow@redha=
t.com>
> >>>>> wrote:
> >>>>>=20
> >>>>>> When commit 773ca82 was made in v3.12-rc1, it caused RAID4/5/6 dev=
ices
> >>>>>> that were created via device-mapper (dm-raid.c) to hang on creatio=
n.
> >>>>>> This is not necessarily the fault of that commit, but perhaps the =
way
> >>>>>> dm-raid.c was setting-up and activating devices.
> >>>>>>=20
> >>>>>> Device-mapper allows I/O and memory allocations in the constructor
> >>>>>> (i.e. raid_ctr()), but nominal and recovery I/O should not be allo=
wed
> >>>>>> until a 'resume' is issued (i.e. raid_resume()).  It has been prob=
lematic
> >>>>>> (at least in the past) to call mddev_resume before mddev_suspend w=
as
> >>>>>> called, but this is how DM behaves - CTR then resume.  To solve the
> >>>>>> problem, raid_ctr() was setting up the structures, calling md_run(=
), and
> >>>>>> then also calling mddev_suspend().  The stage was then set for rai=
d_resume()
> >>>>>> to call mddev_resume().
> >>>>>>=20
> >>>>>> Commit 773ca82 caused a change in behavior during raid5.c:run().
> >>>>>> 'setup_conf->grow_stripes->grow_one_stripe' is called which create=
s the
> >>>>>> stripe cache and increments 'active_stripes'.
> >>>>>> 'grow_one_stripe->release_stripe' doesn't actually decrement 'acti=
ve_stripes'
> >>>>>> anymore.  The side effect of this is that when raid_ctr calls mdde=
v_suspend,
> >>>>>> it waits for 'active_stripes' to reduce to 0 - which never happens.
> >>>>>=20
> >>>>> Hi Jon,
> >>>>> this sounds like the same bug that is fixed by=20
> >>>>>=20
> >>>>> commit ad4068de49862b083ac2a15bc50689bb30ce3e44
> >>>>> Author: majianpeng <majianpeng@gmail.com>
> >>>>> Date:   Thu Nov 14 15:16:15 2013 +1100
> >>>>>=20
> >>>>> raid5: Use slow_path to release stripe when mddev->thread is null
> >>>>>=20
> >>>>> which is already en-route to 3.12.x.  Could you check if it fixes t=
he bug for
> >>>>> you?
> >>>>=20
> >>>> Sure, I'll check.  Just reading the subject of the patch, I have hig=
h hopes.  The slow path decrements 'active_stripes', which was causing the =
above problem...  I'll make sure though.
> >>>=20
> >>> Yes, this patch fixes the issue in 3.12-rc1+.
> >>>=20
> >>> However, there is still a problem I'm searching for that was introduc=
ed in commit 566c09c (at least that's what I get when bisecting).
> >>>=20
> >>> The problem only shows up when I have taken a snapshot of a RAID5 dev=
ice and only if I have cycled the device before adding the snapshot:
> >>> 1> lvcreate --type raid5 -i 3 -L 20M -n lv vg
> >>> 2> lvchange -an vg/lv
> >>> 3> lvchange -ay vg/lv
> >>> 4> lvcreate -s vg/lv -L 50M -n snap
> >>> 5> lvchange -an vg/lv
> >>> 6> lvchange -ay vg/lv -- BUG: line 292 of raid5.c
> >>>=20
> >>> The current bug triggers on the 'BUG_ON(atomic_read(&conf->active_str=
ipes)=3D=3D0)' in do_release_stripe().  I'm not sure why yet.
> >>>=20
> >>> brassow
> >>=20
> >> I've had a look and I must say I'm not sure either.
> >> I keep wondering if something is wrong with the locking in get_active_=
stripe.
> >> The region covered by device_lock is not much smaller with the whole n=
ow
> >> covered by hash_locks[hash].  I cannot see a problem with the locking =
but I
> >> might be missing something.  A missing atomic_inc of active_stripes in=
 there
> >> could cause your problem.
> >>=20
> >> As you can easily reproduce, could you try expanding the range covered=
 by
> >> device_lock to be the whole branch where sh is not NULL.  If that make=
s a
> >> difference it would be quite instructive.  I don't hold high hopes tho=
ugh.
> >=20
> > Sure, I'll try that.
> >=20
> > I've also found that I hit the BUG() on line 693 of raid5.c:get_active_=
stripe().

I have another report of that BUG - from Fengguang Wu.  I suspect it and
you're other BUG are related.

>=20
> Neil,
>=20
> That fixed it - I no longer see any BUG()s or hangs in any of my tests.

Excellent.  It means we are on the right track at least.

>=20
> I simply move the device_lock to cover the whole 'if (atomic_read(&sh->co=
unt)) ... else' conditional.  Seems that the sh->count (and other related b=
its) are being changed between the time it is checked and the time the lock=
 is acquired.
>=20
> If I had to guess, I'd say it was possible to have the following conditio=
n:
> Thread1-1: get_active_stripe(): 'if (atomic_read(&sh->count))' =3D> FALSE
> 	Thread2-1: Acquire 'device_lock'
> 	Thread2-2: Enter release_stripe_list
> 	Thread2-3: Clear STRIPE_ON_RELEASE_LIST while in release_stripe_list
> 	Thread2-4: call __release_stripe->do_release_stripe->atomic_dec_and_test=
(&sh->count)
> 	Thread2-5: Exit release_stripe_list
> 	Thread2-6: Release 'device_lock'
> Thread1-2: Acquire 'device_lock'
> Thread1-3: check !STRIPE_ON_RELEASE_LIST --> call BUG();
>=20
> Right now, get_active_stripe is checking 'count' and then waiting for the=
 lock.  The lock in the current case is simply allowing more time to set th=
e condition that we BUG on.  Moving the lock ensures that 'count' is checke=
d properly along with STRIPE_ON_RELEASE_LIST after they have been manipulat=
ed.
>=20
> If you think the analysis is correct, I can try to clean-up the language =
a little bit and submit the patch.

If a stripe is on the released_stripes list (and has STRIPE_ON_RELEASE_LIST)
set, it means that a call to __release_stripe is pending, so the ->count mu=
st
be at least 1.
So we would need some other actor to be holding device_lock, incrementing
->count, and  then placing the stripe on the released_stripes list.  I don't
think that is possible.

I think I see the race now though (don't know why I couldn't see it
yesterday .. but knowing it must be there from your testing must have
helped).

I think the race is with __get_priority_stripe().  That is the  only place
other than get_active_stripe() where we can increment ->count from zero.
So:
  1-1: get_active_stripe() sees ->count is zero
  1-2: tried to get device_lock and blocks
  2-1: meanwhile handle_active_stripes is holding ->device_lock and
       chooses this stripe from handle list.  It deletes it from the
       ->lru and increments the count - then releases ->device_lock
  1-3: get_active_stripe() sees that ->lru is empty, and complains.

You other BUG is triggered by a difference race caused by the same locking
problem.

->active_stripes counts the number of stripes which have a non-zero ->count,
or have STRIPE_HANDLE set.  STRIPE_HANDLE can only be set when ->count is
non-zero, so we just need to update this whenever count reaches zero or
leaves zero while STRIPE_HANDLE is set.
This would previously always happen under device_lock.  However
get_active_stripe() now increments ->count from zero under ->hash_locks.
This could  race with __release_stripe() which only needs device_lock
So=20
  1-1: get_active_stripe notices that ->count is not zero and skips locking
       with device_lock
  2-1: __release_stripe() decrements ->count to zero and calls
      do_release_stripe which, as STRIPE_HANDLE is not set, decrements
      ->active_stripes
  1-1: get_active_stripe proceeds to increment ->count from zero without a
       matching increment for ->active_stripes

so now ->active_stripes is 1 too small and your BUG is not far away.


So I think we do need to extend the lock region exactly as in the patch you
tried.
Sad thing is that Shaohua originally had the code like that but I talked him
out of it. :-(
http://www.spinics.net/lists/raid/msg44290.html

It seems a shame to be taking device_lock here rather than just hash_locks.
It might be possible to relax that a bit, but first we would need to measure
if it was worth it.

This is the patch I'm thinking of for now.  It also fixes up the two BUGs as
both of them are wrong.
STRIPE_ON_RELEASE_LIST has no effect on the value of ->lru, so it shouldn't
be included.  And while STRIPE_EXPANDING justifies an active stripe_head
being on an lru, it is never ever set for an inactive stripe_head (which is
always on an lru) so it shouldn't be there either.

Does that all sound convincing?

Thanks a lot,
NeilBrown


diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 47da0af6322b..7384b1ec8783 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -678,26 +678,23 @@ get_active_stripe(struct r5conf *conf, sector_t secto=
r,
 			} else
 				init_stripe(sh, sector, previous);
 		} else {
+			spin_lock(&conf->device_lock);
 			if (atomic_read(&sh->count)) {
 				BUG_ON(!list_empty(&sh->lru)
 				    && !test_bit(STRIPE_EXPANDING, &sh->state)
 				    && !test_bit(STRIPE_ON_UNPLUG_LIST, &sh->state)
-				    && !test_bit(STRIPE_ON_RELEASE_LIST, &sh->state));
+					);
 			} else {
-				spin_lock(&conf->device_lock);
 				if (!test_bit(STRIPE_HANDLE, &sh->state))
 					atomic_inc(&conf->active_stripes);
-				if (list_empty(&sh->lru) &&
-				    !test_bit(STRIPE_ON_RELEASE_LIST, &sh->state) &&
-				    !test_bit(STRIPE_EXPANDING, &sh->state))
-					BUG();
+				BUG_ON(list_empty(&sh->lru));
 				list_del_init(&sh->lru);
 				if (sh->group) {
 					sh->group->stripes_cnt--;
 					sh->group =3D NULL;
 				}
-				spin_unlock(&conf->device_lock);
 			}
+			spin_unlock(&conf->device_lock);
 		}
 	} while (sh =3D=3D NULL);
=20

--Sig_/NX8JcMN4TpMpYxt+u=GzXU4
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUpVjCDnsnt1WYoG5AQKj6Q/+JgH5j4QIgvUVq8Qm1zw0K6XnMhaKBia8
yoNtkRlJ9RBk3YHZFZqvAWsdzq0P2kEgJWQ2DdaQTD9fVs0MoRilxPY4UZIUedyG
4CrBWWUTtO50lpNMwlHDY/esWzsWbE0V3qUqqfV4r8BRDShzXXmvXeUueFNBd+8x
5kCk7eyWjtC9Fdsp6rRj4LZtli2erDZ2JE5VdXf0a28oE31Is6Usgt6NfujIxp7o
Q2tajzde1Nje/lHpFzCnN5callUYEMK8twW3giUSICG4XqEtWQRMDM+tZN3NC8rP
i9PgOWr7OnoQkqnltISXtwDs8UudpfBbG3DCTPYH960VEVtqRFf+zKB8qCH9XEwy
DX6paqhCfBS75rsC2K1X7HSHL1yploLZXGKEe+SGRpCA04NlK8JXOcxKX2gXqcO6
VgunfSENvQDxBmGkeReaNu+7eWEa1c9CefZQN0mlFbUhO25JteZ5MmA47vt+0UB/
Bto5wLJIzcj9tA3iM1c7sIdV/AWcF9WI2WUCMnGJ1nsLM583H8R+lEAGT1PaH/QD
fPR+/I/nUnEAuCQTW5ExX/9GCYltbYJbxkOm1K1WtIonNY0dP5rAl21Buc+oazxJ
qVfBMlPoYS+N86fUqAIEN3JPU7W9eGPCnu46nhVkJVbzlsEqC6Cx2CPHYsJaAPrO
5AbWFcxOJvM=
=Clfc
-----END PGP SIGNATURE-----

--Sig_/NX8JcMN4TpMpYxt+u=GzXU4--
