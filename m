From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 02/24] io-controller: Core of the elevator
	fair queuing
Date: Thu, 27 Aug 2009 17:08:48 -0400
Message-ID: <20090827210848.GA3821@redhat.com>
References: <1250451046-9966-1-git-send-email-vgoyal@redhat.com>
	<1250451046-9966-3-git-send-email-vgoyal@redhat.com>
	<4A95F444.9040705@cn.fujitsu.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A95F444.9040705@cn.fujitsu.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, s-uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com
List-Id: dm-devel.ids

On Thu, Aug 27, 2009 at 10:49:40AM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> ...
> > +static void update_min_vdisktime(struct io_service_tree *st)
> > +{
> > +	u64 vdisktime;
> > +
> > +	if (st->active_entity)
> > +		vdisktime =3D st->active_entity->vdisktime;
> > +
> > +	if (st->rb_leftmost) {
> > +		struct io_entity *entity =3D rb_entry(st->rb_leftmost,
> > +						struct io_entity, rb_node);
> > +
> > +		if (!st->active_entity)
> > +			vdisktime =3D entity->vdisktime;
> > +		else
> > +			vdisktime =3D min_vdisktime(vdisktime, entity->vdisktime);
> > +	}
> > +
> > +	st->min_vdisktime =3D max_vdisktime(st->min_vdisktime, vdisktime);
> > +}
>=20
> block/elevator-fq.c: In function =E2=80=98elv_ioq_slice_expired=E2=80=99=
:
> block/elevator-fq.c:132: warning: =E2=80=98vdisktime=E2=80=99 may be us=
ed uninitialized in this function
> LD      block/built-in.o
>=20
> We'd better initialize vdisktime at first.
>=20

Thanks Gui. Will fix in next posting.

Vivek

> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/elevator-fq.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>=20
> diff --git a/block/elevator-fq.c b/block/elevator-fq.c
> index d04e925..a4161c2 100644
> --- a/block/elevator-fq.c
> +++ b/block/elevator-fq.c
> @@ -131,6 +131,8 @@ static void update_min_vdisktime(struct io_service_=
tree *st)
>  {
>  	u64 vdisktime;
> =20
> +	vdisktime =3D st->min_vdisktime;
> +
>  	if (st->active_entity)
>  		vdisktime =3D st->active_entity->vdisktime;
> =20
> --=20
> 1.5.4.rc3
