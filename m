From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 20/23] io-controller: Per cgroup request
	descriptor support
Date: Wed, 16 Sep 2009 14:47:49 -0400
Message-ID: <20090916184749.GF5221@redhat.com>
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com>
	<1251495072-7780-21-git-send-email-vgoyal@redhat.com>
	<e98e18940909141133m5186b780r3215ce15141e4f87@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <e98e18940909141133m5186b780r3215ce15141e4f87@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Nauman Rafique <nauman@google.com>
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, mingo@elte.hu, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, s-uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

On Mon, Sep 14, 2009 at 11:33:37AM -0700, Nauman Rafique wrote:

[..]
> > =A0struct request *blk_get_request(struct request_queue *q, int rw, g=
fp_t gfp_mask)
> > =A0{
> > =A0 =A0 =A0 =A0struct request *rq;
> > + =A0 =A0 =A0 struct request_list *rl;
> >
> > =A0 =A0 =A0 =A0BUG_ON(rw !=3D READ && rw !=3D WRITE);
> >
> > =A0 =A0 =A0 =A0spin_lock_irq(q->queue_lock);
> > + =A0 =A0 =A0 rl =3D blk_get_request_list(q, NULL);
> > =A0 =A0 =A0 =A0if (gfp_mask & __GFP_WAIT) {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rq =3D get_request_wait(q, rw, NULL);
> > =A0 =A0 =A0 =A0} else {
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rq =3D get_request(q, rw, NULL, gfp_mas=
k);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rq =3D get_request(q, rw, NULL, gfp_mas=
k, rl, NULL);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!rq)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock_irq(q->que=
ue_lock);
> > =A0 =A0 =A0 =A0}
> > @@ -1085,12 +1269,13 @@ void __blk_put_request(struct request_queue *=
q, struct request *req)
> > =A0 =A0 =A0 =A0if (req->cmd_flags & REQ_ALLOCED) {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int is_sync =3D rq_is_sync(req) !=3D 0=
;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int priv =3D req->cmd_flags & REQ_ELVP=
RIV;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct request_list *rl =3D rq_rl(q, re=
q);
> >
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BUG_ON(!list_empty(&req->queuelist));
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BUG_ON(!hlist_unhashed(&req->hash));
> >
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0blk_free_request(q, req);
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 freed_request(q, is_sync, priv);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 freed_request(q, is_sync, priv, rl);
>=20
> We have a potential memory bug here. freed_request should be called
> before blk_free_request as blk_free_request might result in release of
> cgroup, and request_list. Calling freed_request after blk_free_request
> would result in operations on freed memory.
>=20

Good point Nauman. freeing rq will drop reference on the io queue. Which
in turn will drop reference on io group and if associated cgroup is
already gone, then io group will be freed hence request list pointer is
no more valid and any operation on that is bad.

So either we can take a reference on the queue, call free_request() and
then drop the reference or we can call freed_request() before
blk_free_request(). Calling freed_request() before blk_free_request()
sounds better to me. The only thing is that this function name and other
dependent function names should now be freeing_request() instead of
freed_request(). :-)

Will move freed_request() before blk_free_request() in next version.

Thanks
Vivek
