From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: block: Introduce helper to reset queue limits to
	default values
Date: Mon, 15 Jun 2009 10:56:52 -0400
Message-ID: <20090615145652.GB18527@redhat.com>
References: <1244524492-2292-1-git-send-email-snitzer@redhat.com>
	<yq1ski860ok.fsf@sermon.lab.mkp.net>
	<20090610140028.GD25088@redhat.com>
	<yq1ocsw55t6.fsf@sermon.lab.mkp.net>
	<20090610211235.GF25088@redhat.com>
	<yq1k53j68wj.fsf@sermon.lab.mkp.net>
	<20090610230804.GR647@agk-dp.fab.redhat.com>
	<yq1y6rz4ijs.fsf@sermon.lab.mkp.net>
	<20090611094311.GT647@agk-dp.fab.redhat.com>
	<yq1r5xqhwu7.fsf_-_@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <yq1r5xqhwu7.fsf_-_@sermon.lab.mkp.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jens.axboe@oracle.com
Cc: device-mapper development <dm-devel@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, martin.petersen@oracle.com
List-Id: dm-devel.ids

On Fri, Jun 12 2009 at 12:58am -0400,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> 
> DM reuses the request queue when swapping in a new device table.
> Introduce blk_set_default_limits() which can be used to reset the the
> queue_limits prior to stacking devices.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Acked-by: Alasdair G Kergon <agk@redhat.com>

Jens,

Do you intend to provide this patch in your next push to Linus for
2.6.31?  I have a dependency on this patch for DM topology support.

Acked-by: Mike Snitzer <snitzer@redhat.com>
