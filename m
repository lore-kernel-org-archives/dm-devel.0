From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: dm: Fix alignment stacking on partitioned devices
Date: Mon, 21 Dec 2009 23:27:19 -0500
Message-ID: <yq1r5qn4orc.fsf@sermon.lab.mkp.net>
References: <yq1aaxg7n84.fsf@sermon.lab.mkp.net>
	<20091218173322.GA4163@redhat.com>
	<yq14onk5iaa.fsf@sermon.lab.mkp.net>
	<20091221195204.GA28703@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091221195204.GA28703@redhat.com> (Mike Snitzer's message of
	"Mon, 21 Dec 2009 14:52:04 -0500")
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
Cc: device-mapper development <dm-devel@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, jens.axboe@oracle.com
List-Id: dm-devel.ids

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> If that is the case then the data "start" should be different for
Mike> these individual PVs (one following the other).  If not, can you
Mike> provide the 'dmsetup table' output for the associated DM devices?

Did some more runs.  It turns out the old stacking algorithm identified
the two alignments as being incompatible for the wrong reasons.  That's
why a message was printed with the older kernel.

I do find it a bit strange that you pass relative offsets to the
stacking function and rely on the userland utilities to do the right
thing, though.  Doesn't that mean that existing misaligned volumes will
go undetected?  Or do you perform a check when you prepare the table
before feeding it to the kernel?


>> Note that this was run using an old EL5 LVM toolkit because I'm not
>> interested in having userland compensate for any misalignment.

Mike> OK, strikes me as odd but you must have your reasons

I'm testing the stacking function.  I'm not interested in things being
lined up.

-- 
Martin K. Petersen	Oracle Linux Engineering
