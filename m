From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] dm: Fix alignment stacking on partitioned
	devices
Date: Fri, 8 Jan 2010 15:28:07 -0500
Message-ID: <20100108202807.GA21439@redhat.com>
References: <20100106025731.GA16154@redhat.com>
	<yq11vi3ud84.fsf@sermon.lab.mkp.net>
	<20100106041050.GA21438@redhat.com>
	<yq1wrzvswaa.fsf@sermon.lab.mkp.net>
	<20100106051605.GB21438@redhat.com>
	<yq1pr5nsk3z.fsf@sermon.lab.mkp.net>
	<20100106132508.GA3589@redhat.com>
	<yq1hbqxsup7.fsf@sermon.lab.mkp.net>
	<20100107185505.GA15181@redhat.com>
	<yq13a2gsal8.fsf@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <yq13a2gsal8.fsf@sermon.lab.mkp.net>
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

On Fri, Jan 08 2010 at  1:41pm -0500,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> Mike,
> 
> Mike> Seems I took the time to add a comment whose FIXME doesn't ring
> Mike> many bells now!  But ignoring that, the comment before the FIXME
> Mike> is making a veiled reference to userspace having consumed
> Mike> alignment_offset.
> 
> I read and understood the comment.  But even then explicitly zeroing out
> those two values didn't make sense (because if user space did in fact do
> the right thing they'd always be zero).
> 
> I know that the DM utilities take care of business.  And that DM devices
> are special because they are always set up by user space and not a
> kernel discovery process.
> 
> But since the code *is* in place to validate things I'm not so keen on
> you clearing fields that have been calculated and have a meaning.  For
> me it masked a case where the DM utilities did the wrong thing (because
> they were old).
> 
> With the Enterprise Linux hat on it is easy for us to specify that you
> must use this version of the kernel and the device mapper utilities.
> But reality is that lots of people are running upstream kernels on
> distributions with older userland.  And some distributions get things
> wrong, ship broken bits, etc.
> 
> It's great that new DM utils will transparently adjust the starting
> offset.  That's the way it's supposed to work.  No arguments there.
> 
> My main concern is making sure that we never get into a case where we
> run with misaligned components without indicating that there is a
> problem.  Ever!  Regardless of which DM utils might be in place.
> 
> We have the power to get that right.  All the pieces are in place.  I'd
> simply like us to stop making assumptions about user space always doing
> the right thing.

Yeap, I already agreed that those 2 lines should be removed (in the
p.s. of my previous mail).  They really aren't serving any purpose and
their justification was/is tenuous at best.

I'll get the fix, for 2.6.33, to Alasdair shortly.

Mike
