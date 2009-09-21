From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/3] block: Add blk_queue_copy_limits()
Date: Mon, 21 Sep 2009 21:45:18 +0200
Message-ID: <20090921194518.GJ23126@kernel.dk>
References: <4AB3B43D.9000802@ce.jp.nec.com>
	<yq1eiq46ohz.fsf@sermon.lab.mkp.net>
	<4AB4F74E.7000908@ce.jp.nec.com>
	<yq1k4zt5o2f.fsf@sermon.lab.mkp.net>
	<4AB7AAE2.8000404@ce.jp.nec.com>
	<yq1iqfc3wyw.fsf@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <yq1iqfc3wyw.fsf@sermon.lab.mkp.net>
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
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Sep 21 2009, Martin K. Petersen wrote:
> >>>>> "Jun'ichi" == Jun'ichi Nomura <j-nomura@ce.jp.nec.com> writes:
> 
> Jun'ichi> If we aren't sure, shouldn't we set its default to -1 or
> Jun'ichi> putting comments in blk_set_default_limits() at least to avoid
> Jun'ichi> possible confusion in future?
> 
> Jens, what do you think about this?  Goes on top of what you have
> queued...

Look sane, applied.

-- 
Jens Axboe
