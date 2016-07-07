From: NeilBrown <neilb@suse.com>
Subject: Re: block: fix blk_queue_split() resource exhaustion
Date: Fri, 08 Jul 2016 08:40:16 +1000
Message-ID: <87shvlf4xb.fsf@notabene.neil.brown.name>
References: <1466583730-28595-1-git-send-email-lars.ellenberg@linbit.com> <871t36ggcr.fsf@notabene.neil.brown.name> <20160707124505.GB2737@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160707124505.GB2737@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>, Ming Lei <ming.lei@canonical.com>, linux-bcache@vger.kernel.org, Zheng Liu <gnehzuil.liu@gmail.com>, Keith Busch <keith.busch@intel.com>, Takashi Iwai <tiwai@suse.de>, dm-devel@redhat.com, Ingo Molnar <mingo@redhat.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Shaohua Li <shli@kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>, Alasdair Kergon <agk@redhat.com>, Roland Kammerer <roland.kammerer@linbit.com>
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 07 2016, Mike Snitzer wrote:

> On Thu, Jul 07 2016 at  1:35am -0400,
> NeilBrown <neilb@suse.com> wrote:
>
>> On Wed, Jun 22 2016, Lars Ellenberg wrote:
>>=20
>> > For a long time, generic_make_request() converts recursion into
>> > iteration by queuing recursive arguments on current->bio_list.
>> >
>> > This is convenient for stacking drivers,
>> > the top-most driver would take the originally submitted bio,
>> > and re-submit a re-mapped version of it, or one or more clones,
>> > or one or more new allocated bios to its backend(s). Which
>> > are then simply processed in turn, and each can again queue
>> > more "backend-bios" until we reach the bottom of the driver stack,
>> > and actually dispatch to the real backend device.
>> >
>> > Any stacking driver ->make_request_fn() could expect that,
>> > once it returns, any backend-bios it submitted via recursive calls
>> > to generic_make_request() would now be processed and dispatched, before
>> > the current task would call into this driver again.
>> >
>> > This is changed by commit
>> >   54efd50 block: make generic_make_request handle arbitrarily sized bi=
os
>> >
>> > Drivers may call blk_queue_split() inside their ->make_request_fn(),
>> > which may split the current bio into a front-part to be dealt with
>> > immediately, and a remainder-part, which may need to be split even
>> > further. That remainder-part will simply also be pushed to
>> > current->bio_list, and would end up being head-of-queue, in front
>> > of any backend-bios the current make_request_fn() might submit during
>> > processing of the fron-part.
>> >
>> > Which means the current task would immediately end up back in the same
>> > make_request_fn() of the same driver again, before any of its backend
>> > bios have even been processed.
>> >
>> > This can lead to resource starvation deadlock.
>> > Drivers could avoid this by learning to not need blk_queue_split(),
>> > or by submitting their backend bios in a different context (dedicated
>> > kernel thread, work_queue context, ...). Or by playing funny re-orderi=
ng
>> > games with entries on current->bio_list.
>> >
>> > Instead, I suggest to distinguish between recursive calls to
>> > generic_make_request(), and pushing back the remainder part in
>> > blk_queue_split(), by pointing current->bio_lists to a
>> > 	struct recursion_to_iteration_bio_lists {
>> > 		struct bio_list recursion;
>> > 		struct bio_list remainder;
>> > 	}
>> >
>> > To have all bios targeted to drivers lower in the stack processed befo=
re
>> > processing the next piece of a bio targeted at the higher levels,
>> > as long as queued bios resulting from recursion are available,
>> > they will continue to be processed in FIFO order.
>> > Pushed back bio-parts resulting from blk_queue_split() will be process=
ed
>> > in LIFO order, one-by-one, whenever the recursion list becomes empty.
>>=20
>> I really like this change.  It seems to precisely address the problem.
>> The "problem" being that requests for "this" device are potentially
>> mixed up with requests from underlying devices.
>> However I'm not sure it is quite general enough.
>>=20
>> The "remainder" list is a stack of requests aimed at "this" level or
>> higher, and I think it will always exactly fit that description.
>> The "recursion" list needs to be a queue of requests aimed at the next
>> level down, and that doesn't quiet work, because once you start acting
>> on the first entry in that list, all the rest become "this" level.
>>=20
>> I think you can address this by always calling ->make_request_fn with an
>> empty "recursion", then after the call completes, splice the "recursion"
>> list that resulted (if any) on top of the "remainder" stack.
>>=20
>> This way, the "remainder" stack is always "requests for lower-level
>> devices before request for upper level devices" and the "recursion"
>> queue is always "requests for devices below the current level".
>>=20
>> I also really *don't* like the idea of punting to a separate thread
>
> Hi Neil,
>
> Was this concern about "punting to a separate thread" in reference to
> the line of work from Mikulas at the top of this 'wip' branch?
> http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=3Dwip

A little bit in response to
  https://patchwork.kernel.org/patch/7398411/
which you linked upthread, but more in response to the per-blocked
workqueue threads we now have. The (Commit df2cb6daa4) really seemed
like a lazy solution.
I may will be that the current proposal makes these threads redundant by
completely handling the first section split of a request before looking
to see if there is any more to split.

For this to work, each split would need to be a binary split.
i.e.
  If request is too big:
    1/ split into A that isn't too big and B
    2/ add B to the "remainder" queue
    3/ generate sub requests for A and submit them to "recursion" queue

Then 'A' would be completely submitted before B was started, so it would
be safe for B to wait for any resources (like something from a mempool)
that A might be using.

>
>> - it seems to be just delaying the problem.
>
> Have you looked at this closely?  Not seeing how you can say that given
> that on schedule the bios on current->bio_list are flushed.

I fully accept that it is similar to a current solution.  I just don't
like either.

In the sequence of steps given in
https://patchwork.kernel.org/patch/7398411/

step 6 would now not happen until after the bio mentioned in step 4 has
been completely submitted, and so after step5 has had a chance to
release the lock.

>
> The incremental work to delay the offload of queued bios is just meant
> to preserve existing bio submission order unless there is reason to
> believe a deadlock exists.
>
> I would agree that this timer based approach is rather "gross" to some
> degree _but_ it beats deadlocks!  This code needs fixing.  And the fix
> cannot be constrained to bio_queue_split() because DM isn't even using
> it.

Yes, the 1-second timer isn't the most elegant thing ever.  Certainly
better than a deadlock.  But I think we can do better.

Certainly DM needs fixing, as well as md (and maybe others).  The fix
should be fairly easy though.
For md/raid0, the loop in raid0_make_request would be discarded
and the
	} while (split !=3D bio);
at the end would be replaced by
       if (split !=3D bio)
              generic_queue_request(bio);

though probably with a better function name.
generic_queue_request() would add the bio to the ->remainder list.

Presumably DM could do something similar, but I'm not familiar enough
with the code to say precisely what.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXftpQAAoJEDnsnt1WYoG5coMP/0hj3sVVk3NA1KQzRKOc8KRX
fpqqTvmjJTt3NMUI1vGDnR16Pqz41zcdOwqvjfFUloY+kDRQUav1Q71bBDpkCfhu
UWj2lUqOSpmSmKT09xCi4R4MoKaCOxCV1VhYyAlxUPQiorbVaH0iQfRxAvDi+om+
emFFOSKmfslst9aOzBjZ9XCFsysOmM6j1L6kTknhxAIw1g/KXfnvvDf53U1iy0FZ
gVDG2XcIK2jJ7zIYk90v2qgRqh0JNc2BhwZcl4p0dGxCkmkdOMDa57QEFcW0iS+c
4n/yCNsxZ0PTlvisKZ9htz88RrUZtVIj7g1ZUdwnQX+YQWfOZgycr4H+6n3hbLwc
gafqhl9c9YcigU/bHSECM3Fx4qFN9I63I+MRuEBWZ764nu16ubKcsFhnJ4tz0p8p
nJ51Wa7RFvxICpmF5o8WSb1U98DpNKD+0E7YF/nZlTN42xsrdQlBDN2h9PdgFHpk
yROEI1sSljr0KbY3YElndqurvbxNZGRXrlTPpiOWf4Hni/t5mDK/Nj7e4QdruPRY
rdyz92FX3i3mXeeTOnryYBDbrk72Z2QlLmbC1ac2BPtnb8pDD8QFLu1sDzl3YigQ
SZgvBlMJCN05bJo5zfQ2E6UQ5O2hE3x8AqxKlMFeKBnlbRdiwWQx9tmu9M998c3Y
9JiCogFRZvZgw7EEyAQM
=ywyK
-----END PGP SIGNATURE-----
--=-=-=--
