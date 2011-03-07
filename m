From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: mirrored device with thousand of mappingtableentries
Date: Mon, 07 Mar 2011 15:22:33 -0500
Message-ID: <yq1r5aiel4m.fsf@sermon.lab.mkp.net>
References: <20110228114801.GZ3626@agk-dp.fab.redhat.com>
	<E04C10E329E0CD40816C9C17AE53BBD3018639CE@kit001.kaminario.local>
	<20110228121149.GA3626@agk-dp.fab.redhat.com>
	<E04C10E329E0CD40816C9C17AE53BBD3018639D7@kit001.kaminario.local>
	<20110228131028.GB3626@agk-dp.fab.redhat.com>
	<E04C10E329E0CD40816C9C17AE53BBD301863A00@kit001.kaminario.local>
	<4D6BA566.1050305@redhat.com> <yq1oc5wp5i3.fsf@sermon.lab.mkp.net>
	<4D73F104.2050807@redhat.com> <yq1y64reiu8.fsf@sermon.lab.mkp.net>
	<20110307201027.GB31194@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110307201027.GB31194@redhat.com> (Mike Snitzer's message of
	"Mon, 7 Mar 2011 15:10:27 -0500")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> So it seems we need to establish bi->sector_size during the final
Mike> stage of blk_integrity_register(), e.g. when a template is passed.
Mike> Not sure if you'd agree with that change in general but it'll work
Mike> for DM because the queue_limits are established before
Mike> dm_table_set_integrity() is set.

Let me contemplate a bit since I already have some changes brewing in
this area (T10 now permits protection information to be placed at
non-logical block size intervals).

-- 
Martin K. Petersen	Oracle Linux Engineering
