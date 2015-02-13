From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: dm-io: reject unsupported DISCARD/WRITE SAME
	requests with EOPNOTSUPP
Date: Fri, 13 Feb 2015 16:12:24 -0500
Message-ID: <yq1k2zlms7b.fsf@sermon.lab.mkp.net>
References: <20150213092432.GC11034@birch.djwong.org>
	<20150213155550.GA32670@redhat.com>
	<yq1sie9mxcy.fsf@sermon.lab.mkp.net>
	<20150213200714.GC14719@birch.djwong.org>
	<20150213205858.GA7070@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150213205858.GA7070@redhat.com> (Mike Snitzer's message of
	"Fri, 13 Feb 2015 15:58:58 -0500")
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
Cc: dm-devel@redhat.com, Srinivas Eeda <srinivas.eeda@oracle.com>, agk@redhat.com, "Martin K. Petersen" <martin.petersen@oracle.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
List-Id: dm-devel.ids

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> Yeah, I'm OK with leaving it as is for now (allowing a mix).

That's fine with me as long as you're comfortable that we're handling
the corner cases correctly.

Mike> So I'll be picking your dm-io patch up for 3.20-rc.

Should also go to stable.

Mike> No, the DM table reload for Y would alter the discard capability
Mike> of Y but it will _not_ bubble up to X.

Mike> (would be nice if such limit stacking with refresh but...)

Yeah. We keep talking about this. Maybe we can have a quick brain storm
at LSF/MM?

-- 
Martin K. Petersen	Oracle Linux Engineering
