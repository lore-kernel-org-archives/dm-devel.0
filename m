From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/7] dm core: add core functions for
	request-based dm
Date: Fri, 24 Apr 2009 10:45:52 +0200
Message-ID: <49F17C40.6020402@suse.de>
References: <49F17409.4060201@ct.jp.nec.com> <49F17477.1010807@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49F17477.1010807@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, device-mapper development <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Kiyoshi Ueda wrote:
> This patch adds core functions for request-based dm.
>=20
> When struct mapped device (md) is initialized, md->queue has
> an I/O scheduler and the following functions are used for
> request-based dm as the queue functions:
>     make_request_fn: dm_make_request()
>     pref_fn:         dm_prep_fn()
>     request_fn:      dm_request_fn()
>     softirq_done_fn: dm_softirq_done()
>     lld_busy_fn:     dm_lld_busy()
> Actual initializations are done in another patch (PATCH 3).
>=20
> Below is a brief summary of how request-based dm behaves, including:
>   - making request from bio
>   - cloning, mapping and dispatching request
>   - completing request and bio
>   - suspending md
>   - resuming md
>=20
>=20
> bio to request
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> md->queue->make_request_fn() (dm_make_request()) calls__make_request()
> for a bio submitted to the md.
> Then, the bio is kept in the queue as a new request or merged into
> another request in the queue if possible.
>=20
>=20
> Cloning and Mapping
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Cloning and mapping are done in md->queue->request_fn() (dm_request_fn(=
)),
> when requests are dispatched after they are sorted by the I/O scheduler=
.
>=20
> dm_request_fn() checks busy state of underlying devices using
> target's busy() function and stops dispatching requests to keep them
> on the dm device's queue if busy.
> It helps better I/O merging, since no merge is done for a request
> once it is dispatched to underlying devices.
>=20
> Actual cloning and mapping are done in dm_prep_fn() and map_request()
> called from dm_request_fn().
> dm_prep_fn() clones not only request but also bios of the request
> so that dm can hold bio completion in error cases and prevent
> the bio submitter from noticing the error.
> (See the "Completion" section below for details.)
>=20
> After the cloning, the clone is mapped by target's map_rq() function
> and inserted to underlying device's queue using
> blk_insert_cloned_request().
>=20
>=20
> Completion
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Request completion can be hooked by rq->end_io(), but then, all bios
> in the request will have been completed even error cases, and the bio
> submitter will have noticed the error.
> To prevent the bio completion in error cases, request-based dm clones
> both bio and request and hooks both bio->bi_end_io() and rq->end_io():
>     bio->bi_end_io(): end_clone_bio()
>     rq->end_io():     end_clone_request()
>=20
> Summary of the request completion flow is below:
> blk_end_request() for a clone request
>   =3D> __end_that_request_first()
>      =3D> bio->bi_end_io() =3D=3D end_clone_bio() for each clone bio
>         =3D> Free the clone bio
>         =3D> Success: Complete the original bio (blk_update_request())
>            Error:   Don't complete the original bio
>   =3D> end_that_request_last()
>      =3D> rq->end_io() =3D=3D end_clone_request()
>         =3D> blk_complete_request()
>            =3D> dm_softirq_done()
>               =3D> Free the clone request
>               =3D> Success: Complete the original request (blk_end_requ=
est())
>                  Error:   Requeue the original request
>=20
> end_clone_bio() completes the original request on the size of
> the original bio in successful cases.
> Even if all bios in the original request are completed by that
> completion, the original request must not be completed yet to keep
> the ordering of request completion for the stacking.
> So end_clone_bio() uses blk_update_request() instead of
> blk_end_request().
> In error cases, end_clone_bio() doesn't complete the original bio.
> It just frees the cloned bio and gives over the error handling to
> end_clone_request().
>=20
> end_clone_request(), which is called with queue lock held, completes
> the clone request and the original request in a softirq context
> (dm_softirq_done()), which has no queue lock, to avoid a deadlock
> issue on submission of another request during the completion:
>     - The submitted request may be mapped to the same device
>     - Request submission requires queue lock, but the queue lock
>       has been held by itself and it doesn't know that
>=20
> The clone request has no clone bio when dm_softirq_done() is called.
> So target drivers can't resubmit it again even error cases.
> Instead, they can ask dm core for requeueing and remapping
> the original request in that cases.
>=20
>=20
> suspend
> =3D=3D=3D=3D=3D=3D=3D
> Request-based dm uses stopping md->queue as suspend of the md.
> For noflush suspend, just stops md->queue.
>=20
> For flush suspend, inserts a marker request to the tail of md->queue.
> And dispatches all requests in md->queue until the marker comes to
> the front of md->queue.  Then, stops dispatching request and waits
> for the all dispatched requests to complete.
> After that, completes the marker request, stops md->queue and
> wake up the waiter on the suspend queue, md->wait.
>=20
>=20
> resume
> =3D=3D=3D=3D=3D=3D
> Starts md->queue.
>=20
>=20
> Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Markus Rex, HRB 16746 (AG N=C3=BCrnberg)
