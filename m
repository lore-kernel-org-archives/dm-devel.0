From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] dm mpath: Add timeout mechanism for
	queue_if_no_path
Date: Tue, 14 Jan 2020 11:53:29 -0500
Message-ID: <20200114165329.GA11499@redhat.com>
References: <20200113224127.3367484-1-krisman@collabora.com>
	<20200114161505.GA48507@lobo> <85pnfmyp7t.fsf@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <85pnfmyp7t.fsf@collabora.com>
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
To: Gabriel Krisman Bertazi <krisman@collabora.com>
Cc: dm-devel@redhat.com, kernel@collabora.com, khazhy@google.com
List-Id: dm-devel.ids

On Tue, Jan 14 2020 at 11:31am -0500,
Gabriel Krisman Bertazi <krisman@collabora.com> wrote:

> Mike Snitzer <snitzer@redhat.com> writes:
> 
> > On Mon, Jan 13 2020 at  5:41P -0500,
> > Gabriel Krisman Bertazi <krisman@collabora.com> wrote:
> >
> >> From: Anatol Pomazau <anatol@google.com>
> >> 
> >> Add a configurable timeout mechanism to disable queue_if_no_path without
> >> assistance from multipathd.  In reality, this reimplements the
> >> no_path_retry mechanism from multipathd in kernel space, which is
> >> interesting to prevent processes from hanging indefinitely in cases
> >> where the daemon might be unable to respond, after a failure or for
> >> whatever reason.
> >> 
> >> Despite replicating the policy configuration on kernel space, it is
> >> quite an important case to prevent IOs from hanging forever, waiting for
> >> userspace to behave correctly.
> >> 
> >> v2:
> >>   - Use a module parameter instead of configuring per table
> >>   - Simplify code
> >> 
> >> Co-developed-by: Frank Mayhar <fmayhar@google.com>
> >> Signed-off-by: Frank Mayhar <fmayhar@google.com>
> >> Co-developed-by: Bharath Ravi <rbharath@google.com>
> >> Signed-off-by: Bharath Ravi <rbharath@google.com>
> >> Co-developed-by: Khazhismel Kumykov <khazhy@google.com>
> >> Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
> >> Signed-off-by: Anatol Pomazau <anatol@google.com>
> >> Co-developed-by: Gabriel Krisman Bertazi <krisman@collabora.com>
> >> Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
> >
> > All these tags seem rather excessive (especially in that you aren't cc
> > most of them on the submission).  Please review/scrub.  Just seems odd
> > that so many had a hand in this relatively small patch.
> 
> Hey,
> 
> I removed some of the Cc's because those emails addresses were bouncing.
> Still, I kept the lines for credits.  I got the bounces when sending v1.

Hmm, if their emails bounce, not a lot of point detailing them.

> > The Signed-off-by for anatol@google.com seems wrong, or did Anatol
> > shephard this patch at some point?  Or did you mean Reviewed-by?
> > Something else?
> 
> Anatol was the main author, as listed in the From: header.  This
> seems correct with regard to the ordering rules of
> Documentation/process/submitting-patches.rst, in particular the second
> example, (Example of a patch submitted by a Co-developed-by: author::).
> 
> Am I missing something?

No, I missed that Anatol is main author.  I'd have noticed once I
applied the patch via 'git am' but...

> 
> >
> > Anyway, if in the end you hold these tags to reflect the development
> > evolution of this patch then so be it ;)
> >
> > I've reviewed the changes and found various things I felt were
> > worthwhile to modify.  Summary:
> >
> > - included missing <linux/timer.h>
> > - added MODULE_PARM_DESC
> > - moved new functions to reduce needed forward declarations
> > - tweaked queue_if_no_path_timeout_work's DMWARN message
> > - added lockdep_assert_held to enable_nopath_timeout
> > - renamed static queue_if_no_path_timeout to queue_if_no_path_timeout_secs
> > - use READ_ONCE when accessing queue_if_no_path_timeout_secs
> >
> 
> The changes you made look good to me and your version of the patch
> passes my testcase.

OK, thanks.

Mike
