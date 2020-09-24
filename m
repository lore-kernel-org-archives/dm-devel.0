From: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Subject: Re: [RFC PATCH 0/2] dm crypt: Allow unaligned buffer
 lengths for skcipher devices
Date: Thu, 24 Sep 2020 09:55:01 -0700 (PDT)
Message-ID: <378f445c-2136-4d17-ac2f-355b7850d28a@default>
References: <1600281606-1446-1-git-send-email-sudhakar.panneerselvam@oracle.com>
	<3be1ea32-b6a8-41ef-a9ba-ed691434d068@default>
	<20200924012732.GA10766@redhat.com>
	<20200924051419.GA16103@sol.localdomain>
	<1c44946e-9661-16f7-1c38-32d666b55fb2@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1c44946e-9661-16f7-1c38-32d666b55fb2@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <gmazyland@gmail.com>, Eric Biggers <ebiggers@kernel.org>, Mike Snitzer <snitzer@redhat.com>
Cc: Damien.LeMoal@wdc.com, ssudhakarp@gmail.com, Martin Petersen <martin.petersen@oracle.com>, dm-crypt@saout.de, mpatocka@redhat.com, dm-devel@redhat.com, Ma <shirley.ma@oracle.com>, Shirley, agk@redhat.com
List-Id: dm-devel.ids

Hello Milan,

> -----Original Message-----
> From: Milan Broz [mailto:gmazyland@gmail.com]
> Sent: Thursday, September 24, 2020 2:16 AM
> To: Eric Biggers <ebiggers@kernel.org>; Mike Snitzer <snitzer@redhat.com>
> Cc: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>;
> Damien.LeMoal@wdc.com; ssudhakarp@gmail.com; Martin Petersen
> <martin.petersen@oracle.com>; dm-crypt@saout.de; dm-devel@redhat.com;
> Shirley Ma <shirley.ma@oracle.com>; mpatocka@redhat.com;
> agk@redhat.com
> Subject: Re: [dm-devel] [RFC PATCH 0/2] dm crypt: Allow unaligned buffer
> lengths for skcipher devices
> 
> On 24/09/2020 07:14, Eric Biggers wrote:
> > On Wed, Sep 23, 2020 at 09:27:32PM -0400, Mike Snitzer wrote:
> >> You've clearly done a nice job with these changes.  Looks clean.
> >>
> >> BUT, I'm struggling to just accept that dm-crypt needs to go to these
> >> extra lengths purely because of one bad apple usecase.
> >>
> >> These alignment constraints aren't new.  Are there other portions of
> >> Linux's crypto subsystem that needed comparable fixes in order to work
> >> with Microsfot OS initiated IO through a guest?
> >>
> >> You forecast that these same kinds of changes are needed for AEAD and
> >> dm-integrity... that's alarming.
> >>
> >> Are we _certain_ there is no other way forward?
> >> (Sorry I don't have suggestions.. I'm in "fact finding mode" ;)
> >>
> >
> > I don't understand why this is needed, since dm-crypt already sets its
> > logical_block_size to its crypto sector_size.  Isn't it expected that I/O that
> > isn't aligned to logical_block_size fails?  It's the I/O submitter's
> > responsibility to ensure logical_block_size alignment of all I/O segments.
> > Exactly how is the misaligned I/O actually being submitted here?
> 
> Thanks for mentioning it - exactly that I asked when reading this patch...
> It seems that we are here fixing a problem that is just caused when someone
> ignores clearly set restrictions.
> 
> Who is submitting these bioses? Why can it not be fixed there?
> 
> What happens with writes to fs journals, etc., is it still safe if we are
> processing such unaligned bios?

I don't follow your question regarding fs journals. I am not sure why it is not safe to process unaligned bio segment lengths of fs journals writes. Could you explain with some example on why that would be a problem?

Please see my reply to Eric's/Mike's email, in that, I explained why this issue needs to be fixed in dm-crypt. I hope I have answered to your questions there. If not, let me know, I will try to answer.

Thanks
Sudhakar

> 
> Milan
