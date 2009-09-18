From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Re: fragmented i/o with 2.6.31?
Date: Fri, 18 Sep 2009 02:00:27 -0400
Message-ID: <yq1skek94hw.fsf@sermon.lab.mkp.net>
References: <448b15030909160834j2b127c83jab163e1860fc9aa1@mail.gmail.com>
	<448b15030909160922o84c2d6gc8ead8226dd8777a@mail.gmail.com>
	<4AB1ED1F.1010203@ct.jp.nec.com> <4AB1FDEE.5020500@ce.jp.nec.com>
	<20090917131113.GA8163@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090917131113.GA8163@redhat.com> (Mike Snitzer's message of
	"Thu, 17 Sep 2009 09:11:14 -0400")
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
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Alasdair Kergon <agk@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

>> >  	blk_set_default_limits(limits);
>> > + limits->max_sectors = 0;
>> > + limits->max_hw_sectors = 0;
>> 
Mike> Seems like we may want some common variant in block even though
Mike> I'm not aware of other block drivers that would benefit...

Mike> But I'll defer to Martin and/or Jens on whether these helpers are
Mike> fine to stay in dm-table.c or should be worked into blk-settings.c

In the pre-topology days we set max_sectors to SAFE_MAX_SECTORS upon
creation of a queue.  This is an old ATA-ism that's been around for a
ages.

Ideally we'd simply nuke it and drivers that really needed to lower the
bar would explicitly call blk_queue_max_sectors().  However, I'm afraid
to change the default because I'm sure there are legacy drivers lurking
somewhere that depend on it.

Seeing as blk_set_default_limits() is mostly aimed at stacking drivers I
think I'd prefer moving SAFE_MAX_SECTORS back to blk_queue_make_request
and then set max_sectors and max_hw_sectors to 0 in default_limits.

Would that work for you guys?

-- 
Martin K. Petersen	Oracle Linux Engineering
