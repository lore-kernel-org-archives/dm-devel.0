From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Subject: Re: [PATCH 2/8] block: Simplify REQ_OP_ZONE_RESET_ALL
	handling
Date: Mon, 28 Oct 2019 08:37:17 +0000
Message-ID: <BYAPR04MB57490F22E67DC5B172A3A9FE86660@BYAPR04MB5749.namprd04.prod.outlook.com>
References: <20191027140549.26272-1-damien.lemoal@wdc.com>
	<20191027140549.26272-3-damien.lemoal@wdc.com>
	<BYAPR04MB5749C25A8558C0ED9AB3EA6786660@BYAPR04MB5749.namprd04.prod.outlook.com>
	<BYAPR04MB58160668CEB54919B22AC2FBE7660@BYAPR04MB5816.namprd04.prod.outlook.com>
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

On 10/28/19 12:54 AM, Damien Le Moal wrote:
> Isn't the trace point under submit_bio() in
> generic_make_request_checks() ? So removing the function is not a
> problem for tracing as far as I can tell. Am I missing something ?

Yes you are right, I completely missed that.

Sorry I've created confusion with block_dump and tracepoint.

Block trace code is fine.

The block_dump code under the submit_bio() is only dumps the bios with
the data:-


1171                 if (unlikely(block_dump)) {
1172                         char b[BDEVNAME_SIZE];
1173                         printk(KERN_DEBUG "%s(%d): %s block %Lu on 
%s (%u sectors)\n",
1174                         current->comm, task_pid_nr(current),
1175                                 op_is_write(bio_op(bio)) ? "WRITE" 
: "READ",
1176                                 (unsigned long 
long)bio->bi_iter.bi_sector,
1177                                 bio_devname(bio, b), count);
1178                 }


I've posted patch-series [1] in the past to move that code out but it 
didn't go anywhere in anticipation of more data less requests.

Since it is taking longer to have blktrace extensions RFC to move 
forward and [1] didn't go anywhere I wanted to use block_dump
parameter in the blk-zoned.c (not an ideal situation) so that we can 
have atleast minimal debug support for the new REQ_OP_ZONE_XXX 
operations until we get block trace extensions in the kernel.

Nonetheless, I'll just a send a patch on the top of this which will
make discussion much easier.


[1] :- 
https://lore.kernel.org/linux-block/DM6PR04MB57546ECC4CFDDB5535E3382586FB0@DM6PR04MB5754.namprd04.prod.outlook.com/T/
