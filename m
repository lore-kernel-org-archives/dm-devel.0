From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] block: Require subsystems to explicitly
	allocate bio_set integrity mempool
Date: Fri, 11 Mar 2011 12:11:55 -0500
Message-ID: <yq1lj0l60pw.fsf@sermon.lab.mkp.net>
References: <20110228131028.GB3626@agk-dp.fab.redhat.com>
	<E04C10E329E0CD40816C9C17AE53BBD301863A00@kit001.kaminario.local>
	<4D6BA566.1050305@redhat.com> <yq1oc5wp5i3.fsf@sermon.lab.mkp.net>
	<4D73F104.2050807@redhat.com> <yq1y64reiu8.fsf@sermon.lab.mkp.net>
	<20110307160914.GA29697@redhat.com>
	<yq1ipvudrzo.fsf@sermon.lab.mkp.net>
	<20110308171322.GB5692@redhat.com>
	<yq1aah37y5u.fsf@sermon.lab.mkp.net>
	<20110311165305.GA28769@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110311165305.GA28769@redhat.com> (Mike Snitzer's message of
	"Fri, 11 Mar 2011 11:53:05 -0500")
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
Cc: Jens Axboe <jaxboe@fusionio.com>, device-mapper development <dm-devel@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

>> Yeah, that'll come as part of my DIX1.1 patch set.

Mike> Seems my concern should be fixed independent of a larger update
Mike> patchset.  Unless DIX isn't meaningful for "stable" kernels
Mike> without your full DIX1.1 update?

Well, I'm not aware of any shipping non-512 byte block DIF devices other
than scsi_debug.

And it's not good enough to just fix it in DM since this is a hardware
parameter that needs to be queried and bubbled up. It can't be scaled
like the rest of the topology block sizes, it's wired in the
hardware. So I just don't see much point in trying to fix it now when
any ties to the logical block size will be severed in my impending patch
set.

-- 
Martin K. Petersen	Oracle Linux Engineering
