From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH 0/2] dm crypt: Allow unaligned buffer
 lengths for skcipher devices
Date: Wed, 23 Sep 2020 21:27:32 -0400
Message-ID: <20200924012732.GA10766@redhat.com>
References: <1600281606-1446-1-git-send-email-sudhakar.panneerselvam@oracle.com>
	<3be1ea32-b6a8-41ef-a9ba-ed691434d068@default>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <3be1ea32-b6a8-41ef-a9ba-ed691434d068@default>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Cc: Damien.LeMoal@wdc.com, ssudhakarp@gmail.com, Martin Petersen <martin.petersen@oracle.com>, dm-crypt@saout.de, dm-devel@redhat.com, Shirley Ma <shirley.ma@oracle.com>, mpatocka@redhat.com, Milan Broz <gmazyland@gmail.com>, agk@redhat.com
List-Id: dm-devel.ids

You've clearly done a nice job with these changes.  Looks clean.

BUT, I'm struggling to just accept that dm-crypt needs to go to these
extra lengths purely because of one bad apple usecase.

These alignment constraints aren't new.  Are there other portions of
Linux's crypto subsystem that needed comparable fixes in order to work
with Microsfot OS initiated IO through a guest?

You forecast that these same kinds of changes are needed for AEAD and
dm-integrity... that's alarming.

Are we _certain_ there is no other way forward?
(Sorry I don't have suggestions.. I'm in "fact finding mode" ;)

Thanks,
Mike

On Wed, Sep 23 2020 at  1:01pm -0400,
Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com> wrote:

> Could someone review this patch set, please?
> 
> Thanks
> Sudhakar
> 
> > -----Original Message-----
> > From: Sudhakar Panneerselvam
> > Sent: Wednesday, September 16, 2020 12:40 PM
> > To: agk@redhat.com; snitzer@redhat.com; dm-devel@redhat.com
> > Cc: Shirley Ma <shirley.ma@oracle.com>; ssudhakarp@gmail.com; Martin
> > Petersen <martin.petersen@oracle.com>
> > Subject: [dm-devel] [RFC PATCH 0/2] dm crypt: Allow unaligned buffer lengths
> > for skcipher devices
> > 
> > Hi,
> > 
> > This changeset allows processing of unaligned bio requests in dm crypt
> > for the I/Os generated from a windows guest OS in a QEMU environment. If
> > this changeset is accepted, then I will be submitting another changeset that
> > addresses the similar issue in AEAD disks and dm-integrity module.
> > 
> > Thanks
> > Sudhakar
> > 
> > Sudhakar Panneerselvam (2):
> >   dm crypt: Allow unaligned bio buffer lengths for skcipher devices
> >   dm crypt: Handle unaligned bio buffer lengths for lmk and tcw
> > 
> >  drivers/md/dm-crypt.c | 154 +++++++++++++++++++++++++++++++++++----
> > -----------
> >  1 file changed, 108 insertions(+), 46 deletions(-)
> > 
> > --
> > 1.8.3.1
> > 
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> > 
> 
