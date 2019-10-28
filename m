From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Subject: Re: [PATCH 2/8] block: Simplify REQ_OP_ZONE_RESET_ALL
	handling
Date: Mon, 28 Oct 2019 07:49:19 +0000
Message-ID: <BYAPR04MB5749C25A8558C0ED9AB3EA6786660@BYAPR04MB5749.namprd04.prod.outlook.com>
References: <20191027140549.26272-1-damien.lemoal@wdc.com>
	<20191027140549.26272-3-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K .
	Petersen" <martin.petersen@oracle.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: Ajay Joshi <Ajay.Joshi@wdc.com>, Fomichev <Dmitry.Fomichev@wdc.com>, Hans Holmberg <Hans.Holmberg@wdc.com>, Keith Busch <kbusch@kernel.org>Dmitry, Matias Bjorling <Matias.Bjorling@wdc.com>
List-Id: dm-devel.ids

The reason code for REQ_OP_RESET_ALL is kept in a different function so
we can clearly differentiate between REQ_OP_RESET and REQ_OP_RESET_ALL
when we add new tracepoints with blktrace framework.

But if that is acceptable, then,

Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>

On 10/27/19 7:06 AM, Damien Le Moal wrote:
> There is no need for the function __blkdev_reset_all_zones() as
> REQ_OP_ZONE_RESET_ALL can be handled directly in blkdev_reset_zones()
> bio loop with an early break from the loop. This patch removes this
> function and modifies blkdev_reset_zones(), simplifying the code.
> 
> Signed-off-by: Damien Le Moal<damien.lemoal@wdc.com>
