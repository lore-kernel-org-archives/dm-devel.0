From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/3] block: Add blk_queue_copy_limits()
Date: Fri, 18 Sep 2009 16:30:40 -0400
Message-ID: <20090918203040.GA6031@redhat.com>
References: <4AB3B43D.9000802@ce.jp.nec.com>
	<yq1eiq46ohz.fsf@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <yq1eiq46ohz.fsf@sermon.lab.mkp.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

On Fri, Sep 18 2009 at  3:28pm -0400,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Jun'ichi" == Jun'ichi Nomura <j-nomura@ce.jp.nec.com> writes:
> 
> +	if (q->limits.max_sectors == 0 || q->limits.max_hw_sectors == 0)
> +		blk_queue_max_sectors(q, SAFE_MAX_SECTORS);
> 
> I'm really not keen on perpetuating SAFE_MAX_SECTORS for something that
> was written in this millennium.
> 
> I'd much rather we just do this, then:
> 
> block: Set max_sectors correctly for stacking devices
> 
> The topology changes unintentionally caused SAFE_MAX_SECTORS to be set
> for stacking devices.  Set the default limit to BLK_DEF_MAX_SECTORS and
> provide SAFE_MAX_SECTORS in blk_queue_make_request() for legacy hw
> drivers that depend on the old behavior.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

Nice.  Avoids the need for a safe queue_limits copy and associated naunce.

Acked-by: Mike Snitzer <snitzer@redhat.com>
