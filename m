From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 1/3] block: Add blk_queue_copy_limits()
Date: Tue, 22 Sep 2009 01:33:38 +0900
Message-ID: <4AB7AAE2.8000404@ce.jp.nec.com>
References: <4AB3B43D.9000802@ce.jp.nec.com>	<yq1eiq46ohz.fsf@sermon.lab.mkp.net>
	<4AB4F74E.7000908@ce.jp.nec.com>
	<yq1k4zt5o2f.fsf@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <yq1k4zt5o2f.fsf@sermon.lab.mkp.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <jens.axboe@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Martin K. Petersen wrote:
>>>>>> "Jun'ichi" == Jun'ichi Nomura <j-nomura@ce.jp.nec.com> writes:
> 
> Jun'ichi> Umm, with this, BLK_DEF_MAX_SECTORS becomes upper bound of
> Jun'ichi> max_hw_sectors and the values of underlying devices are not
> Jun'ichi> propagated to the stacking devices.  
> 
> Well, max_sectors is already bounded by this.  max_hw_sectors only
> really matters for PC commands, so I'm not sure it's a big deal for
> DM. But I guess we could set the default max_hw_sectors to -1.
> 
> I'm just trying to avoid these scattered if-0-set-it-to-something-else
> cases.  I'd much rather have the defaults do the right thing.

I agree with that.
I had to do the if-0-set-it-to-something-else to avoid putting unnecessary
cap on max_hw_sectors.

If we aren't sure, shouldn't we set its default to -1 or putting comments
in blk_set_default_limits() at least to avoid possible confusion in future?

Thanks,
--
Jun'ichi Nomura, NEC Corporation 
