From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 6/7] multipath.conf.5: document no_path_retry
 vs. queue_if_no_path
Date: Thu, 15 Jun 2017 14:57:17 -0500
Message-ID: <20170615195717.GG2940@octiron.msp.redhat.com>
References: <20170613225554.11181-1-mwilck@suse.com>
	<20170613225554.11181-7-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170613225554.11181-7-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

On Wed, Jun 14, 2017 at 12:55:53AM +0200, Martin Wilck wrote:
> Clarify the documentation about option precedence.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipath/multipath.conf.5 | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index f04ff194..e6944faf 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -365,7 +365,9 @@ Possible values for the feature list are:
>  .\" XXX
>  .I queue_if_no_path
>  (Superseded by \fIno_path_retry\fR) (Since ??? kernel) Queue I/O if no path is active.
> -Identical to the \fIno_path_retry\fR with \fIqueue\fR value. See KNOWN ISSUES.
> +Identical to the \fIno_path_retry\fR with \fIqueue\fR value. If both this
> +feature and \fIno_path_retry\fR are set, the latter value takes
> +precedence. See KNOWN ISSUES. 

Speaking of nits, the above line adds trailing whitespace.

-Ben

>  .TP
>  .I no_partitions
>  Disable automatic partitions generation via kpartx.
> -- 
> 2.13.0
