From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 7/8] dm: add zone open,
	close and finish support
Date: Tue, 5 Nov 2019 11:34:21 -0500
Message-ID: <20191105163421.GA22009@redhat.com>
References: <20191027140549.26272-1-damien.lemoal@wdc.com>
	<20191027140549.26272-8-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191027140549.26272-8-damien.lemoal@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, Ajay Joshi <ajay.joshi@wdc.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>, Hans Holmberg <Hans.Holmberg@wdc.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Keith Busch <kbusch@kernel.org>, Matias Bjorling <matias.bjorling@wdc.com>
List-Id: dm-devel.ids

On Sun, Oct 27 2019 at 10:05am -0400,
Damien Le Moal <damien.lemoal@wdc.com> wrote:

> From: Ajay Joshi <ajay.joshi@wdc.com>
>=20
> Implement REQ_OP_ZONE_OPEN, REQ_OP_ZONE_CLOSE and REQ_OP_ZONE_FINISH
> support to allow explicit control of zone states.
>=20
> Contains contributions from Matias Bjorling, Hans Holmberg and
> Damien Le Moal.
>=20
> Signed-off-by: Ajay Joshi <ajay.joshi@wdc.com>
> Signed-off-by: Matias Bjorling <matias.bjorling@wdc.com>
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>

Acked-by: Mike Snitzer <snitzer@redhat.com>
