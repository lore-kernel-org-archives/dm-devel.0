From: Dan Smith <danms@us.ibm.com>
Subject: Re: dm-userspace memory consumption in remap cache
Date: Fri, 25 Aug 2006 11:43:03 -0700
Message-ID: <m3zmdsbqrs.fsf@guaranine.beaverton.ibm.com>
References: <44EF3DC5.2040403@cs.cmu.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1703137482=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Gilbert <bgilbert@cs.cmu.edu>
Cc: dm-devel@redhat.com, Niraj Tolia <ntolia@cmu.edu>
List-Id: dm-devel.ids

--===============1703137482==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--=-=-=
Content-Transfer-Encoding: quoted-printable

BG> I've been playing with a program which uses the
BG> libdmu/libdevmapper interface to map a block device through
BG> dm-userspace.  (I haven't been using cowd; I'm looking to
BG> integrate dmu support into an existing program.)

Very cool!

BG> I noticed that after I wrote 1 GB of data to a dmu device with a 4
BG> KB blocksize, the dm-userspace-remaps slab cache consumed about 39
BG> MB of memory.=20=20

Ah, right.

BG> Looking at alloc_remap_atomic(), dmu makes no attempt to reuse
BG> dmu_maps until a memory allocation fails, so that potentially dmu
BG> could force a large amount of data out of the page cache to make
BG> room for its map.

That's true.  Good point.

BG> 1. Periodically invalidate the entire table.  When cowd does this
BG> right now (on SIGHUP), it invalidates each page individually,
BG> which is not very pleasant.  I suppose this could be done by
BG> loading a new dm table.

Right, invalidating the entire table, one remap at a time, would be a
bad thing.  The current SIGHUP behavior was just intended to be a
mechanism for me to test the invalidation process.

BG> 2. Periodically trigger block invalidations from userspace, fired
BG> by either the completion notification mechanism or a periodic
BG> timer. Userspace couldn't do this in an LRU fashion, since it
BG> doesn't see remap cache hits.

Right.  We could push statistic information back to cowd when there
was nothing else to do.  That might be interesting, but probably not
the best way to solve this particular issue.

BG> (As an aside, I haven't been able to figure out the semantics of
BG> the completion notification mechanism.  Could you provide an
BG> example of how you expect it to be used from the userspace side?)

Recent versions of cowd use this to prevent the completion (endio)
From=20firing until it has flushed its internal metadata mapping to
disk, to prevent the data from being written and the completion event
sent, when the data isn't really on the disk (well, it's on the disk,
but if we crash before we write our metadata, we can't tell that it's
really there during recovery).

BG> 3. Map in dm-linear when there are large consecutive ranges, to
BG> try to keep the table size down.  Some of the early dm-cow design
BG> notes mentioned this approach*, but I notice that the current cowd
BG> doesn't use it.  Is this still a recommended procedure?

I don't think this is the best approach, because if you want to
invalidate a mapping, you'd have to split the dm-linear back up,
suspend/resume the device, etc.

Initially, I was planning to take a cow-centric approach, where
dm-linear could be used to map the sections that were already mapped.
Now that I'm focusing on a more generic approach, we want it to be
more flexible, which is why I implemented a hash table for the remaps
(my initial plan was to remap with dm-linear for performance reasons).

BG> From the kernel side -- if the remap cache in the kernel is
BG> expected to be a subset of the mapping information maintained by
BG> userspace, it seems as though it should be possible to more
BG> aggressively reuse the LRU dmu_maps.=20=20

Yes.

BG> That would impose a performance penalty for the extra map requests
BG> to userspace, but I wonder how that balances against having a
BG> larger page cache.

Correct.

BG> Thoughts?

So, my preference would be to put a limit on the number of remaps that
we maintain "cached" in the kernel.  The existing MRU list (which is
an LRU list if you traverse it backwards) would allow us to more
aggressively re-use remaps as we approached the limit.  Setting a
higher limit at device creation time would allow for more memory
usage, but better performance.

My testing shows that communication with userspace (i.e. to refresh a
mapping that we expired to make room for another) is not as much of a
performance hit as I would have initially imagined.  Thus, I think the
above would be a good way to limit a full-scale memory takeover by
dm-userspace :)

Now that I know at least someone is paying attention, I'll try to get
my latest dm-userspace and cowd versions out on this list.  A small
fix has been made to dm-userspace, and several improvements and fixes
have been made to cowd.  After I post my current code, I'll implement
the memory limit/aggressive reuse functionality and post that as well.

Thanks!

=2D-=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFE70S5wtEf7b4GJVQRAlgiAJ4sGHDpcN9GAmjZHMu4kabYepEWvgCfRBvQ
YIxzMrKuqbnmQmx8yBagij4=
=+7jG
-----END PGP SIGNATURE-----
--=-=-=--


--===============1703137482==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1703137482==--
