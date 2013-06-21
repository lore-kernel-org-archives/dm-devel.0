From: Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH 07/10] idr: Rename idr_alloc() ->
	idr_alloc_range()
Date: Fri, 21 Jun 2013 08:43:18 +0530
Message-ID: <20130621031318.GC23141@intel.com>
References: <1371600150-23557-1-git-send-email-koverstreet@google.com>
	<1371600150-23557-8-git-send-email-koverstreet@google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1371600150-23557-8-git-send-email-koverstreet@google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kent Overstreet <koverstreet@google.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, Tatyana Nikolova <Tatyana.E.Nikolova@intel.com>, Linus Walleij <linus.walleij@linaro.org>, Paul Mackerras <paulus@samba.org>, Christoph Hellwig <hch@lst.de>, Alon Levy <alevy@redhat.com>, Davidlohr Bueso <davidlohr.bueso@hp.com>, Ohad Ben-Cohen <ohad@wizery.com>, "John W. Linville" <linville@tuxdriver.com>, Inki Dae <inki.dae@samsung.com>, Alex Williamson <alex.williamson@redhat.com>, David Teigland <teigland@redhat.com>, Joel Becker <jlbec@evilplan.org>, Tim Gardner <tim.gardner@canonical.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Seung-Woo Kim <sw0312.kim@samsung.com>, linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, tj@kernel.org, Guo Chao <yan@linux.vnet.ibm.com>, akpm@linux-foundation.orgAndy Grover <a>
List-Id: dm-devel.ids

On Tue, Jun 18, 2013 at 05:02:27PM -0700, Kent Overstreet wrote:
> Then also add an idr_alloc() wrapper, without the start/end arguments -
> for consistency with the ida interfaces.
> =

> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Chas Williams <chas@cmf.nrl.navy.mil>
> Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: David Airlie <airlied@linux.ie>
> Cc: Inki Dae <inki.dae@samsung.com>
> Cc: Joonyoung Shim <jy0922.shim@samsung.com>
> Cc: Seung-Woo Kim <sw0312.kim@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Wolfram Sang <wsa@the-dreams.de>
> Cc: Roland Dreier <roland@kernel.org>
> Cc: Sean Hefty <sean.hefty@intel.com>
> Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
> Cc: Steve Wise <swise@chelsio.com>
> Cc: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
> Cc: Christoph Raisch <raisch@de.ibm.com>
> Cc: Mike Marciniszyn <infinipath@intel.com>
> Cc: Alasdair Kergon <agk@redhat.com>
> Cc: dm-devel@redhat.com
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Alex Dubov <oakad@yahoo.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Chris Ball <cjb@laptop.org>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Anton Vorontsov <cbou@mail.ru>
> Cc: Rodolfo Giometti <giometti@enneenne.com>
> Cc: Ohad Ben-Cohen <ohad@wizery.com>
> Cc: Anil Gurumurthy <agurumur@brocade.com>
> Cc: Vijaya Mohan Guvva <vmohan@brocade.com>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: James Smart <james.smart@emulex.com>
> Cc: Doug Gilbert <dgilbert@interlog.com>
> Cc: Willem Riede <osst@riede.org>
> Cc: "Kai M=E4kisara" <Kai.Makisara@kolumbus.fi>
> Cc: Omar Ramirez Luna <omar.ramirez@copitl.com>
> Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Eduardo Valentin <eduardo.valentin@ti.com>
> Cc: "Hans J. Koch" <hjk@hansjkoch.de>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Christine Caulfield <ccaulfie@redhat.com>
> Cc: David Teigland <teigland@redhat.com>
> Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Cc: "John W. Linville" <linville@tuxdriver.com>
> Cc: Guo Chao <yan@linux.vnet.ibm.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Dave Airlie <airlied@redhat.com>
> Cc: Alon Levy <alevy@redhat.com>
> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Thomas Hellstrom <thellstrom@vmware.com>
> Cc: Brian Paul <brianp@vmware.com>
> Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> Cc: Dmitry Torokhov <dtor@vmware.com>
> Cc: Sasha Levin <sasha.levin@oracle.com>
> Cc: Erez Shitrit <erezsh@mellanox.co.il>
> Cc: Tatyana Nikolova <Tatyana.E.Nikolova@intel.com>
> Cc: Haggai Eran <haggaie@mellanox.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Andy Grover <agrover@redhat.com>
> Cc: Masanari Iida <standby24x7@gmail.com>
> Cc: Tim Gardner <tim.gardner@canonical.com>
> Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Michel Lespinasse <walken@google.com>

For dmaengine:

Acked-by: Vinod Koul <vinod.koul@intel.com>
  =

> diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
> index 93f7992..0300f5b 100644
> --- a/drivers/dma/dmaengine.c
> +++ b/drivers/dma/dmaengine.c
> @@ -697,7 +697,7 @@ static int get_dma_id(struct dma_device *device)
>  =

>  	mutex_lock(&dma_list_mutex);
>  =

> -	rc =3D idr_alloc(&dma_idr, NULL, 0, 0, GFP_KERNEL);
> +	rc =3D idr_alloc(&dma_idr, NULL, GFP_KERNEL);
>  	if (rc >=3D 0)
>  		device->dev_id =3D rc;
>

--
~Vinod  =
