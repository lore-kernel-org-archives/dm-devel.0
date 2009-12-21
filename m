From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: dm: Fix alignment stacking on partitioned devices
Date: Mon, 21 Dec 2009 12:49:33 -0500
Message-ID: <yq14onk5iaa.fsf@sermon.lab.mkp.net>
References: <yq1aaxg7n84.fsf@sermon.lab.mkp.net>
	<20091218173322.GA4163@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091218173322.GA4163@redhat.com> (Mike Snitzer's message of
	"Fri, 18 Dec 2009 12:33:23 -0500")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jens.axboe@oracle.com
List-Id: dm-devel.ids

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> This is not required because DM assumes alignment_offset has
Mike> already been accounted for by the caller (e.g. LVM2 or some other
Mike> ficitional DM consumer).

Mike> Below, "start" represents the aligned start of the data for a
Mike> given volume.  That start must have already been shifted by
Mike> alignment_offset; as is the case with lvm2 (>= 2.02.51), see the
Mike> following lvm2 commits:
Mike> http://sources.redhat.com/git/gitweb.cgi?p=lvm2.git;a=commit;h=282029eb45e56
Mike> http://sources.redhat.com/git/gitweb.cgi?p=lvm2.git;a=commit;h=6c88b6c660020

Mike> All this being said, how did you arrive at this patch?  Why do you
Mike> feel it is needed?  Was it just from code inspection?

Interesting.

I have one case in my topology test scripts that prints a DM alignment
warning with the old stacking algorithm but doesn't with the new one.  A
bit surprising given that the new approach is much more picky.  MD
correctly prints a warning for the same device with both algorithms.

So I added a few printks and noticed that DM was calling the stacking
function with the same start sector for both devices.  That seemed odd
because the PV devices are misaligned partitions on the same disk.

Note that this was run using an old EL5 LVM toolkit because I'm not
interested in having userland compensate for any misalignment.

-- 
Martin K. Petersen	Oracle Linux Engineering
