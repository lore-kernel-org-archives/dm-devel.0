From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 02/19] io-controller: Common flat fair
	queuing code in elevaotor layer
Date: Wed, 17 Jun 2009 08:59:32 -0400
Message-ID: <20090617125932.GA15473@redhat.com>
References: <1244513342-11758-1-git-send-email-vgoyal@redhat.com>
	<1244513342-11758-3-git-send-email-vgoyal@redhat.com>
	<af41c7c40906161244q61fd47c5u1a10243c8839938@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <af41c7c40906161244q61fd47c5u1a10243c8839938@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Divyesh Shah <dpshah@google.com>
Cc: dhaval@linux.vnet.ibm.com, snitzer@redhat.com, peterz@infradead.org, dm-devel@redhat.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, akpm@linux-foundation.org, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, s-uchida@ap.jp.nec.com, righi.andrea@gmail.com, jbaron@redhat.com
List-Id: dm-devel.ids

On Tue, Jun 16, 2009 at 12:44:58PM -0700, Divyesh Shah wrote:
> On Mon, Jun 8, 2009 at 7:08 PM, Vivek Goyal<vgoyal@redhat.com> wrote:
> > void elv_deactivate_ioq(struct elv_fq_data *efqd, struct io_queue *io=
q,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 int requeue)
> > +{
> > + =A0 =A0 =A0 if (ioq =3D=3D efqd->active_queue)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 elv_reset_active_ioq(efqd);
> > +
> > + =A0 =A0 =A0 bfq_deactivate_entity(&ioq->entity, requeue);
> > +}
>=20
> The check for ioq =3D=3D efqd->active_queue and the call to
> elv_reset_active_ioq() seem to be unnecessary. This gets called from
> elv_del_ioq_busy() which has 2 callers which:
> - either explicitly check for ioq !=3D efqd->active_queue
> - or call elv_reset_active_ioq() right before invoking this function
>=20
> This was needed earlier as the io_ioq_move() function didn't fall in
> one of the 2 categories above. This has been done away with the ref
> counting patch, AFAICT.

True. Looks like we don't need above reset_active_ioq() call in
deactivate_ioq(). I will get rid of it in next posting. Thanks.

Vivek
