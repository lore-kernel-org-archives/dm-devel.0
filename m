From: Marc Lehmann <schmorp@schmorp.de>
Subject: Re: all cache blocks marked as dirty in writethrough
 mode, no way to avoid
Date: Tue, 23 Dec 2014 11:00:56 +0100
Message-ID: <20141223100056.GA2598@schmorp.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi!

I wrote http://www.redhat.com/archives/dm-devel/2014-June/msg00082.html a
while ago, but never received a reply. I saw a reply by Joe Thomber on the
list archives at
http://www.redhat.com/archives/dm-devel/2014-June/msg00084.html only now, so
my reply is a bit late.

I am still not subscribed to the list, and CC of any rpelies would still be
appreciated :)

In any case, some things do not add up, or leave some open questions. I
now tried dm-cache again via lvm on 3.18.1, instead of using my own script
(I tend to trust lvm more), and effectively see the same symptoms. In any
case:

- It uses more metadata than expected.

  It would be nice to be able to see in advance how large it is. right now,
  I have to effectively guess, ap=FCparently risk data loss to try out and =
so
  on.

  In fact, it would be nice to see how large the metadata device usage is,
  even after creating it. Right, now, this is a black box with no
  documentation and no way to know in advance how much data will be needed,
  and no way to check afterwards how much is needed.

- It assumes the cache is dirty if something went wrong during the

  Hmm, first, how can a cache in writethrough mode ever be dirty, and why
  would the correct solution ever be to write back the cache in writethrough
  mode?

  Surely, if the origin device and the cache are not coherent, then either
  one has a newer version of some block, but why always chose the cache
  one? In http://www.redhat.com/archives/dm-devel/2013-July/msg00117.html
  I can also read that this shouldn't be the case.

  Right now, after every reboot, the system is unresponsive due to writing
  back dirty blocks, for half an hour. That makes the dm-cache rather
  useless, which brings me to another question:

  How does one properly deactivate/activate dm-cache? At the moment, I do
  lvchange -an on every dm-cache before rebooting, which roughly takes
  half a minute of 100% system time, while reading slowly from the metadata
  device, and then tears down the dm table.

  On bootup, lvm runs cache_check, which results in no error and a working
  device, takinjg about half a minute of system time per cache (I
  initially had the problem that the dm-cache module and cache_check were
  not included in the initrd, but after fixing this, lvm gives no warning
  and simply activates the cache on initial activation inside the initrd).

  Then it starts to write back all cached blocks on all caches:

  0 38654705664 cache 8 1304/15360 64 340264/655360 149 127 44 0 0 0 287719=
 1
  writethrough 2 migration_threshold 65536 mq 10 random_threshold 4
  sequential_threshold 512 discard_promote_adjustment 1
  read_promote_adjustment 4 write_promote_adjustment 8

  So, I think writing back cache data from a writethrough cache is at least
  very questionable, and certainly not usable in practise even for moderate=
ly
  large caches (mine are 20GB at the moment, filled to only about 20-50% - =
with
  a full cache, a server is basically unusable for many hours after a
  reboot).

- There is an 18 second pause when removing the cache dev.

  "This is when the dirty bitset and discard bitset get written."

  This is still there with lvm, although vmstat shows no write activity,
  only read activity, so something doesn't quite hold up. Maybe lvm runs
  cache_check on teardown or something similar, which seems to have this
  effect.

  (I didn't verify whether cache_check or something else causes this, lvm
  runs this automatically without giving a visual indication for it).

- There's a constant 4k background load to the metadata device.

  Good news, no such thing occurs in 3.18.1 anymore.

Thanks for any input - I would really love to use dm-cache, but it seems
to be viable only for systems that never shut down right now - I can live
with a minute or so on shutdown or reboot, but I cannot wait hours after
poweron for the server to become usable.

-- =

                The choice of a       Deliantra, the free code+content MORPG
      -----=3D=3D-     _GNU_              http://www.deliantra.net
      ----=3D=3D-- _       generation
      ---=3D=3D---(_)__  __ ____  __      Marc Lehmann
      --=3D=3D---/ / _ \/ // /\ \/ /      schmorp@schmorp.de
      -=3D=3D=3D=3D=3D/_/_//_/\_,_/ /_/\_\
