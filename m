From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] dm: Fix alignment stacking on partitioned
	devices
Date: Tue, 05 Jan 2010 23:16:13 -0500
Message-ID: <yq1wrzvswaa.fsf@sermon.lab.mkp.net>
References: <1261591640-24380-1-git-send-email-snitzer@redhat.com>
	<20100105182735.GC6042@agk-dp.fab.redhat.com>
	<yq1637gt1hi.fsf@sermon.lab.mkp.net>
	<20100106025731.GA16154@redhat.com>
	<yq11vi3ud84.fsf@sermon.lab.mkp.net>
	<20100106041050.GA21438@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100106041050.GA21438@redhat.com> (Mike Snitzer's message of
	"Tue, 5 Jan 2010 23:10:51 -0500")
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
Cc: device-mapper development <dm-devel@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> But even with your blk_off_t patch (and prior to it with sector_t)
Mike> you're mixing int with blk_off_t in blk_stack_limits() by doing:

Mike>         alignment = queue_limit_alignment_offset(b, offset);

Mike> This helped motivate my "blind" conversion.

Yeah.  However, that particular wart is fixed by an unrelated patch in
my queue wrt. discard alignment.  But I wanted something you guys could
look at that applied on top of upstream.

I'm tinkering with a few things on this end to see if I can make
the distinction between an offset and an alignment obvious.

-- 
Martin K. Petersen	Oracle Linux Engineering
