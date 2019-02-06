From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Regression in 5.0-rc4 device-mapper - integrity data
	invalid
Date: Wed, 6 Feb 2019 09:45:26 -0500
Message-ID: <20190206144526.GA18177@redhat.com>
References: <579347b4-2a97-91c8-7f55-3a72d62829e9@gmail.com>
	<20190205221807.GA13749@redhat.com>
	<7d654fe6-c120-74a9-972e-85fc3f18f442@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <7d654fe6-c120-74a9-972e-85fc3f18f442@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <gmazyland@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

On Wed, Feb 06 2019 at  2:26am -0500,
Milan Broz <gmazyland@gmail.com> wrote:

> On 05/02/2019 23:18, Mike Snitzer wrote:
> > On Tue, Feb 05 2019 at 12:06pm -0500,
> > Milan Broz <gmazyland@gmail.com> wrote:
> > 
> >> Hi Mike,
> >>
> >> since 5.0-rc4 we are not able to use LUKS2 devices with 4k sector size.
> >>
> >> For example,
> >> # cryptsetup luksFormat --type luks2 -c aes-xts-plain64 --integrity hmac-sha256 /dev/sdc --sector-size 4096
> >>
> >> fails with these syslog errors:
> >>   device-mapper: crypt: Integrity AEAD, tag size 32, IV size 0.
> >>   device-mapper: integrity: Invalid integrity data size 32768, expected 4096
> >>   device-mapper: integrity: Invalid integrity data size 32768, expected 4096
> >>
> >> (with 512-byte sectors it seems to work ok)
> >>
> >> Bisect shows this commit in rc4 is the problematic one (reverting fixes the problem):
> >>
> >> commit 57c36519e4b949f89381053f7283f5d605595b42
> >> Author: Mike Snitzer <snitzer@redhat.com>
> >> Date:   Wed Jan 16 18:53:26 2019 -0500
> >>
> >>     dm: fix clone_bio() to trigger blk_recount_segments()
> >>     
> >>     DM's clone_bio() now benefits from using bio_trim() by fixing the fact
> >>     that clone_bio() wasn't clearing BIO_SEG_VALID like bio_trim() does;
> >>     which triggers blk_recount_segments() via bio_phys_segments().
> >>     
> >>     Reviewed-by: Ming Lei <ming.lei@redhat.com>
> >>     Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> >>
> >> Could you please check what is missing in the patch?
> > 
> > Could be that this bio_trim() check is causing it to return early?:
> > 
> >   if (offset == 0 && size == bio->bi_iter.bi_size)
> >      	     return;
> 
> 
> Yes, this condition causes that bio_integrity_trim() is not called.
> Removing this early return in bio_trim() fixes the issue.
> 
> Not sure how this can happen though, the integrity offset should be in sync here...

OK, think we need to get to the bottom of it now then ...
 
> > But I'll just effectively revert 57c36519e4b94.  I don't have time right
> > now to dwell on _why_ this patch, which seemed to be obvious cleanup,
> > isn't safe.

... otherwise by reverting we'd be papering over this unexplained bug.
We can always revert next week if the reason isn't found.  But I'd like
to get to the bottom of this.

Mike
