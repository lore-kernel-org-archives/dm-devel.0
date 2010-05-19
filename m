From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH 2/2] dm: only initialize full request_queue for
 request-based device
Date: Wed, 19 May 2010 10:39:00 -0400
Message-ID: <20100519143900.GC24618@redhat.com>
References: <4BEA659F.9050206@ct.jp.nec.com>
 <20100513035750.GA25523@redhat.com>
 <4BED049C.5040409@ct.jp.nec.com>
 <20100514140852.GA10373@redhat.com>
 <4BF10BF1.3040108@ct.jp.nec.com>
 <20100517172737.GA24591@redhat.com>
 <4BF25091.3000507@ct.jp.nec.com>
 <20100518134639.GA27582@redhat.com>
 <4BF37DD5.9050409@ct.jp.nec.com>
 <AANLkTinndXq8DkMBOUf5z8R_8lWRoRbDuOZ1LEmWeI21@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTinndXq8DkMBOUf5z8R_8lWRoRbDuOZ1LEmWeI21@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Jens Axboe <jens.axboe@oracle.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Vivek Goyal <vgoyal@redhat.com>
List-Id: dm-devel.ids

On Wed, May 19 2010 at  8:01am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Wed, May 19, 2010 at 1:57 AM, Kiyoshi Ueda <k-ueda@ct.jp.nec.com> =
wrote:
> > Hi Mike,
> >
> > On 05/18/2010 10:46 PM +0900, Mike Snitzer wrote:
> >> I'll post v5 of the overall patch which will revert the mapped_dev=
ice
> >> 'queue_lock' serialization that I proposed in v4. =A0v5 will conta=
in
> >> the following patch to localize all table load related queue
> >> manipulation to the _hash_lock protected critical section in
> >> table_load(). =A0So it sets the queue up _after_ the table's type =
is
> >> established with dm_table_set_type().
> >
> > dm_table_setup_md_queue() may allocate memory with blocking mode.
> > Blocking allocation inside exclusive _hash_lock can cause deadlock;
> > e.g. when it has to wait for other dm devices to resume to free som=
e
> > memory.
>=20
> We make no guarantees that other DM devices will resume before a tabl=
e
> load -- so calling dm_table_setup_md_queue() within the exclusive
> _hash_lock is no different than other DM devices being suspended whil=
e
> a request-based DM device performs its first table_load().
>=20
> My thinking was this should not be a problem as it is only valid to
> call dm_table_setup_md_queue() before the newly created request-based
> DM device has been resumed.
>=20
> AFAIK we don't have any explicit constraints on memory allocations
> during table load (e.g. table loads shouldn't depend on other devices=
'
> writeback) -- but any GFP_KERNEL allocation could recurse
> (elevator_alloc() currently uses GFP_KERNEL with kmalloc_node)...
>=20
> I'll have to review the DM code further to see if all memory
> allocations during table_load() are done via mempools.  I'll also
> bring this up on this week's LVM call.

We discussed this and I understand the scope of the problem now.

Just reiterating what you covered when you first pointed this issue out=
:

It could be that a table load gets blocked (waiting on a memory
allocation).  The table load can take as long as it needs.  But we can'=
t
have it block holding the exclusive _hash_lock while blocking.  Having
_hash_lock prevents further DM ioctls.  The table load's allocation may
be blocking waiting for writeback to a DM device that will be resumed b=
y
another thread.

Thanks again for pointing this out; I'll work to arrive at an
alternative locking scheme.  Likely introduce a lock local to the
multiple_device (effectively the 'queue_lock' I had before).  But
difference is I'd take that lock before taking _hash_lock.

I hope to have v6 available at some point today but it may be delayed b=
y
a day.

> > Also, your patch changes the queue configuration even when a table =
is
> > already active and used. =A0(e.g. Loading bio-based table to a mapp=
ed_device
> > which is already active/used as request-based sets q->requst_fn in =
NULL.)
> > That could cause some critical problems.
>=20
> Yes, that is possible and I can add additional checks to prevent this=
=2E
> But this speaks to a more general problem with the existing DM code.
>=20
> dm_swap_table() has the negative check to prevent such table loads, e=
=2Eg.:
> /* cannot change the device type, once a table is bound */
>=20
> This check should come during table_load, as part of
> dm_table_set_type(), rather than during table resume.

I'll look to address this issue in v6 too.

Regards,
Mike
