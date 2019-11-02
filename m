From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 6/8] scsi: sd_zbc: add zone open, close,
	and finish support
Date: Fri, 01 Nov 2019 20:43:33 -0400
Message-ID: <yq1ftj75cqy.fsf@oracle.com>
References: <20191027140549.26272-1-damien.lemoal@wdc.com>
	<20191027140549.26272-7-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191027140549.26272-7-damien.lemoal@wdc.com> (Damien Le Moal's
	message of "Sun, 27 Oct 2019 23:05:47 +0900")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, Ajay Joshi <ajay.joshi@wdc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>, Hans Holmberg <Hans.Holmberg@wdc.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org, Keith Busch <kbusch@kernel.org>, Matias Bjorling <matias.bjorling@wdc.com>
List-Id: dm-devel.ids


Damien,

> Implement REQ_OP_ZONE_OPEN, REQ_OP_ZONE_CLOSE and REQ_OP_ZONE_FINISH
> support to allow explicit control of zone states.
>
> Contains contributions from Matias Bjorling, Hans Holmberg,
> Keith Busch and Damien Le Moal.

Looks fine.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

--=20
Martin K. Petersen=09Oracle Linux Engineering
