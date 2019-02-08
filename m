From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: don't overallocate the tags space
Date: Fri, 8 Feb 2019 11:02:36 -0500
Message-ID: <20190208160235.GA8620@redhat.com>
References: <alpine.LRH.2.02.1902081048510.1182@file01.intranet.prod.int.rdu2.redhat.com>
	<1549641492.34241.81.camel@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1549641492.34241.81.camel@acm.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bvanassche@acm.org>
Cc: Ming Lei <minlei@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Fri, Feb 08 2019 at 10:58am -0500,
Bart Van Assche <bvanassche@acm.org> wrote:

> On Fri, 2019-02-08 at 10:52 -0500, Mikulas Patocka wrote:
> > bio_sectors returns the value in the units of 512-byte sectors (no matter
> > what's the real sector size of the device). dm-crypt multiplies
> > bio_sectors by on_disk_tag_size to calculate the space allocated for
> > integrity tags. If dm-crypt is running with sector size larger than 512,
> > it allocates more data than what's needed.
> > 
> > Device mapper trimmed this extra space when passing the bio to
> > dm-integrity, so this bug didn't result in any visible misbehavior. This
> > bug showed up when device mapper stopped trimming the bio.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > Reported-by: Milan Broz <mbroz@redhat.com>
> 
> Hi Mikulas,
> 
> Is this a fix for commit fa8db4948f52 ("dm: don't use bio_trim() afterall")?
> If so, please consider adding a "Fixes:" tag.

No, it isn't.  It stands on its own.

But yes, it could serve as a replacement for fa8db4948f52 ("dm: don't
use bio_trim() afterall").  But using bio_trim() isn't critical, and I
intend to remove all of DM's internal bio splitting for 5.1 or later
anyway.
