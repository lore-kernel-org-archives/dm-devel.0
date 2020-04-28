From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 1/3] md: multipath: Encapsulate parameters
 passed to selectors
Date: Tue, 28 Apr 2020 13:20:29 -0400
Message-ID: <20200428172028.GA17285@redhat.com>
References: <20200428005146.242231-1-krisman@collabora.com>
	<20200428005146.242231-2-krisman@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200428005146.242231-2-krisman@collabora.com>
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
Cc: dm-devel@redhat.com, kernel@collabora.com, khazhy@google.com, agk@redhat.com
List-Id: dm-devel.ids

On Mon, Apr 27 2020 at  8:51pm -0400,
Gabriel Krisman Bertazi <krisman@collabora.com> wrote:

> Different selector will use different parameters, which means .io_start
> and .io_end will get their signatures modified to include more and more
> parameters.  This encapsulates the data in a structure so we can
> simplify the interface for future users.  For now it only passes
> nr_bytes, but HST will require start_time already.
> 
> Cc: Khazhismel Kumykov <khazhy@google.com>
> Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>

I really don't see HST's need for start_time_ns in the path selector's
end_io hook as a solid justification for this encapsulation.

Especially in that the parameters needed for ps's start_io and end_io
really aren't symmetric.  Imposing that they are just causes needless
code (an example of that is in patch 2/3).

So please drop this encapsulation.

Thanks,
Mike
