From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: dm-io: reject unsupported DISCARD/WRITE SAME
	requests with EOPNOTSUPP
Date: Fri, 13 Feb 2015 14:21:01 -0500
Message-ID: <yq1sie9mxcy.fsf@sermon.lab.mkp.net>
References: <20150213092432.GC11034@birch.djwong.org>
	<20150213155550.GA32670@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150213155550.GA32670@redhat.com> (Mike Snitzer's message of
	"Fri, 13 Feb 2015 10:55:50 -0500")
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
Cc: dm-devel@redhat.com, Srinivas Eeda <srinivas.eeda@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, agk@redhat.com, "Darrick J. Wong" <darrick.wong@oracle.com>
List-Id: dm-devel.ids

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> When I implemented dm_table_supports_discards() I consciously
Mike> allowed a DM table to contain a mix of discard support.  I'm now
Mike> wondering where it is we benefit from that?  Seems like more of a
Mike> liability than anything -- so a bigger hammer approach to fixing
Mike> this would be to require all targets and all devices in a DM table
Mike> support discard.

I think our original rationale was that since discard is only a hint it
would be fine to mix and match. And at the time there seemed to be value
in supporting a heterogeneous setups with say a disk drive and an SSD.

Back then the SSD vendors were all busy telling us how crucial discard
would be going forward. However, that turned out not to be the case and
discard often causes more problems than it solves. So I'm perfectly OK
with requiring all devices in a table to have the same capabilities. In
many ways I think that's a cleaner approach.

-- 
Martin K. Petersen	Oracle Linux Engineering
