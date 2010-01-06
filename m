From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH v2] dm: Fix alignment stacking on	partitioned
	devices
Date: Wed, 6 Jan 2010 13:55:45 +0000
Message-ID: <20100106135545.GD6042@agk-dp.fab.redhat.com>
References: <1261591640-24380-1-git-send-email-snitzer@redhat.com>
	<20100105182735.GC6042@agk-dp.fab.redhat.com>
	<yq1637gt1hi.fsf@sermon.lab.mkp.net>
	<20100106025731.GA16154@redhat.com>
	<yq11vi3ud84.fsf@sermon.lab.mkp.net>
	<20100106041050.GA21438@redhat.com>
	<yq1wrzvswaa.fsf@sermon.lab.mkp.net>
	<20100106051605.GB21438@redhat.com>
	<yq1pr5nsk3z.fsf@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <yq1pr5nsk3z.fsf@sermon.lab.mkp.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Wed, Jan 06, 2010 at 03:39:12AM -0500, Martin K. Petersen wrote:
> Alasdair, if you are OK with the approach below I propose you give an
> Acked-by: and then we can feed the patch through Jens instead of dealing
> with a clunky two-stage merge this late in the .33 game.
 
> DM does not want to know about partition offsets.  Add a partition-aware
> wrapper that DM can use when stacking block devices.
 
> +int bdev_stack_limits(struct queue_limits *t, struct block_device *bdev,
> +		      sector_t start)

Reviewed-by: Alasdair G Kergon <agk@redhat.com>

Alasdair
