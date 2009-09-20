From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/3] block: Add blk_queue_copy_limits()
Date: Sun, 20 Sep 2009 17:00:24 -0400
Message-ID: <yq1k4zt5o2f.fsf@sermon.lab.mkp.net>
References: <4AB3B43D.9000802@ce.jp.nec.com>
	<yq1eiq46ohz.fsf@sermon.lab.mkp.net> <4AB4F74E.7000908@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4AB4F74E.7000908@ce.jp.nec.com> (Jun'ichi Nomura's message of
	"Sun, 20 Sep 2009 00:22:54 +0900")
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

>>>>> "Jun'ichi" == Jun'ichi Nomura <j-nomura@ce.jp.nec.com> writes:

Jun'ichi> Umm, with this, BLK_DEF_MAX_SECTORS becomes upper bound of
Jun'ichi> max_hw_sectors and the values of underlying devices are not
Jun'ichi> propagated to the stacking devices.  

Well, max_sectors is already bounded by this.  max_hw_sectors only
really matters for PC commands, so I'm not sure it's a big deal for
DM. But I guess we could set the default max_hw_sectors to -1.

I'm just trying to avoid these scattered if-0-set-it-to-something-else
cases.  I'd much rather have the defaults do the right thing.

-- 
Martin K. Petersen	Oracle Linux Engineering
