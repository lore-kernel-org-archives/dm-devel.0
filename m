From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm mpath: Add timeout mechanism for queue_if_no_path
Date: Mon, 6 Jan 2020 11:28:33 -0500
Message-ID: <20200106162833.GA15829@redhat.com>
References: <20200102224512.3605010-1-krisman@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200102224512.3605010-1-krisman@collabora.com>
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
Cc: Bharath Ravi <rbharath@google.com>, Khazhismel Kumykov <khazhy@google.com>, dm-devel@redhat.com, Anatol Pomazau <anatol@google.com>, kernel@collabora.com, Frank Mayhar <fmayhar@google.com>, agk@redhat.com
List-Id: dm-devel.ids

On Thu, Jan 02 2020 at  5:45pm -0500,
Gabriel Krisman Bertazi <krisman@collabora.com> wrote:

> From: Anatol Pomazau <anatol@google.com>
> 
> Add a configurable timeout mechanism to disable queue_if_no_path without
> assistance from multipathd.  In reality, this reimplements the
> no_path_retry mechanism from multipathd in kernel space, which is
> interesting for cases where we cannot rely on a daemon being present all
> the time, in case of failure or to reduce the guest footprint of cloud
> services.
> 
> Despite replicating the policy configuration on kernel space, it is
> quite an important case to prevent IOs from hanging forever, waiting for
> userspace to behave correctly.
> 
> Co-developed-by: Frank Mayhar <fmayhar@google.com>
> Signed-off-by: Frank Mayhar <fmayhar@google.com>
> Co-developed-by: Bharath Ravi <rbharath@google.com>
> Signed-off-by: Bharath Ravi <rbharath@google.com>
> Co-developed-by: Khazhismel Kumykov <khazhy@google.com>
> Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
> Signed-off-by: Anatol Pomazau <anatol@google.com>
> Co-developed-by: Gabriel Krisman Bertazi <krisman@collabora.com>
> Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>

This seems like a slippery slope.

I've heard this line of dm-multipath concern from Google before
(e.g. doesn't want to rely on availability of userspace component).

Thing is, to properly use dm-multipath (e.g. to reinstate failed paths)
multipathd really is needed no?

If not, how is it that the proposed patch is all that is missing when
multipathd isn't running?  I find that hard to appreciate.

So I'm inclined to not accept this type of change.  But especially not
until more comprehensive context is given for how Google is using
dm-multipath without multipathd.

Thanks,
Mike
