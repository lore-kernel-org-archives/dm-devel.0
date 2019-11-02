From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/8] Zone management commands support
Date: Fri, 1 Nov 2019 21:01:36 -0600
Message-ID: <926948c1-d9a0-4156-4639-bbac1d0ba10b@kernel.dk>
References: <20191027140549.26272-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191027140549.26272-1-damien.lemoal@wdc.com>
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
To: Damien Le Moal <damien.lemoal@wdc.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc: Dmitry Fomichev <dmitry.fomichev@wdc.com>, Keith Busch <kbusch@kernel.org>, Hans Holmberg <Hans.Holmberg@wdc.com>, Ajay Joshi <ajay.joshi@wdc.com>, Matias Bjorling <matias.bjorling@wdc.com>
List-Id: dm-devel.ids

On 10/27/19 8:05 AM, Damien Le Moal wrote:
> This series implements a few improvements and cleanups to zone block
> device zone reset operations with the first three patches.
> 
> The remaining of the series patches introduce zone open, close and
> finish support, allowing users of zoned block devices to explicitly
> control the condition (state) of zones.
> 
> While these operations are not stricktly necessary for the correct
> operation of zoned block devices, the open and close operations can
> improve performance for some device implementations of the ZBC and ZAC
> standards under write workloads. The finish zone operation, which
> transition a zone to the full state, can also be useful to protect a
> zone data by preventing further zone writes.
> 
> These operations are implemented by introducing the new
> REQ_OP_ZONE_OPEN, REQ_OP_ZONE_CLOSE and REQ_OP_ZONE_FINISH request codes
> and the function blkdev_zone_mgmt() to issue these requests. This new
> function also replaces the former blkdev_reset_zones() function to reset
> zones write pointer.
> 
> The new ioctls BLKOPENZONE, BLKCLOSEZONE and BLKFINISHZONE are also
> defined to allow applications to issue these new requests without
> resorting to a device passthrough interface (e.g. SG_IO).
> 
> Support for these operations is added to the SCSI sd driver, to the dm
> infrastructure (dm-linear and dm-flakey targets) and to the null_blk
> driver.

Can patch 3 go in separately, doesn't look like we need it in this
series?

Also need the DM folks to review/sign off on patch 7. Mike?

-- 
Jens Axboe
