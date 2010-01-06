From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] dm: Fix alignment stacking on partitioned
	devices
Date: Tue, 5 Jan 2010 23:10:51 -0500
Message-ID: <20100106041050.GA21438@redhat.com>
References: <1261591640-24380-1-git-send-email-snitzer@redhat.com>
	<20100105182735.GC6042@agk-dp.fab.redhat.com>
	<yq1637gt1hi.fsf@sermon.lab.mkp.net>
	<20100106025731.GA16154@redhat.com>
	<yq11vi3ud84.fsf@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <yq11vi3ud84.fsf@sermon.lab.mkp.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Jan 05 2010 at 10:24pm -0500,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> Mike,
> 
> Mike> After looking closer there seems to be various type
> Mike> inconsistencies in the alignment_offset and discard_alignment
> Mike> related routines (returning 'int' in places, etc).
> 
> Mike> The following patch is what I found; I have no problem with
> Mike> switching from 'unsigned long' to blk_off_t for LBD though.
> 
> I only use blk_off_t in the places where we're dealing with absolute
> offsets.
> 
> Blindly converting alignment_offset from int to unsigned long won't
> work.  We depend on being able to return -1 in case of
> misalignment. Hence int and not unsigned int.

Right, I realized/noticed that after I sent that patch.

But even with your blk_off_t patch (and prior to it with sector_t)
you're mixing int with blk_off_t in blk_stack_limits() by doing:

        alignment = queue_limit_alignment_offset(b, offset);

This helped motivate my "blind" conversion.

> Furthermore, the returned values are always modulo the granularity so
> int is plenty big.

OK.
