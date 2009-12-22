From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: Fix alignment stacking on partitioned devices
Date: Tue, 22 Dec 2009 09:32:40 -0500
Message-ID: <20091222143240.GA9154@redhat.com>
References: <yq1aaxg7n84.fsf@sermon.lab.mkp.net>
	<20091218173322.GA4163@redhat.com>
	<yq14onk5iaa.fsf@sermon.lab.mkp.net>
	<20091221195204.GA28703@redhat.com>
	<yq1r5qn4orc.fsf@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <yq1r5qn4orc.fsf@sermon.lab.mkp.net>
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
Cc: device-mapper development <dm-devel@redhat.com>, jens.axboe@oracle.com
List-Id: dm-devel.ids

On Mon, Dec 21 2009 at 11:27pm -0500,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> Mike> If that is the case then the data "start" should be different for
> Mike> these individual PVs (one following the other).  If not, can you
> Mike> provide the 'dmsetup table' output for the associated DM devices?
> 
> Did some more runs.  It turns out the old stacking algorithm identified
> the two alignments as being incompatible for the wrong reasons.  That's
> why a message was printed with the older kernel.

OK, so is MD somehow getting things wrong?  (You originally said that
with the new stacking function MD resulted in an error but DM did not).
 
> I do find it a bit strange that you pass relative offsets to the
> stacking function and rely on the userland utilities to do the right
> thing, though.  Doesn't that mean that existing misaligned volumes will
> go undetected?  Or do you perform a check when you prepare the table
> before feeding it to the kernel?

"start" isn't a relative offset.  The "start" is absolute from the
beginning of the device.  So for old LVs that are already misaligned
they'll pass down a start that _should_ cause misalignment messages in
the kernel (via the stacking function).  I know I've seen such messages
when LVM doesn't compensate for alignment_offset but I'll revisit this
with your new stacking function.

The justification for relying on userspace to consume and adjust for
alignment_offset is: you're not creating LVM LVs with the kernel.
Metadata that (may) precede the data "start" of a volume gets layed out
(and managed) by userspace (LVM).  Not having the kernel involved in
generating the "correct" offset to data allows such concerns to be
purely in userspace (having the kernel contribute to that calculation
doesn't get us anything other than potential for split brain bugs).

Mike
