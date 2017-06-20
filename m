From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH] mpathpersist.8: add missing documentation
 for -K, -C, -l
Date: Tue, 20 Jun 2017 17:43:06 -0500
Message-ID: <20170620224306.GL2940@octiron.msp.redhat.com>
References: <20170522221643.18826-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170522221643.18826-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, May 23, 2017 at 12:16:43AM +0200, Martin Wilck wrote:

ACK

-Ben

> Furthermore, add a reference to the sg_persist man page.
> ---
>  mpathpersist/mpathpersist.8 | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/mpathpersist/mpathpersist.8 b/mpathpersist/mpathpersist.8
> index 4b15666f..a8982e65 100644
> --- a/mpathpersist/mpathpersist.8
> +++ b/mpathpersist/mpathpersist.8
> @@ -34,6 +34,12 @@ attribute must be defined in the \fI/etc/multipath.conf\fR file. Otherwise the
>  \fBmultipathd\fR daemon will not check for persistent reservation for newly
>  discovered paths or reinstated paths.
>  .
> +.LP
> +\fBmpathpersist\fR supports the same command-line options as the
> +\fBsg_persist\fR utility.
> +.
> +Consult the \fBsg_persist (8)\fR manual page for an in-depth discussion of the
> +various options.
>  .
>  .\" ----------------------------------------------------------------------------
>  .SH OPTIONS
> @@ -89,6 +95,10 @@ PR Out parameter 'APTPL'.
>  PR In: Read Keys.
>  .
>  .TP
> +.BI \--param-rk=\fIRK\fB|\-K " RK"
> +PR Out parameter reservation key (RK is in hex, up to 8 bytes).
> +.
> +.TP
>  .BI \--param-sark=\fISARK\fB|\-S " SARK"
>  PR Out parameter service action reservation key (SARK is in hex).
>  .
> @@ -97,6 +107,10 @@ PR Out parameter service action reservation key (SARK is in hex).
>  PR Out: Preempt.
>  .
>  .TP
> +.B \--clear|\-C
> +PR Out: Clear registrations.
> +.
> +.TP
>  .B \--preempt-abort|\-A
>  PR Out: Preempt and Abort.
>  .
> @@ -140,6 +154,10 @@ PR Out: Reserve.
>  .BI \--transport-id=\fITIDS\fB|\-X " TIDS"
>  TransportIDs can be mentioned in several forms.
>  .
> +.TP
> +.BI \--alloc-length=\fILEN\fB|\-l " LEN"
> +PR In: maximum allocation length. LEN is a decimal number between 0 and 8192.
> +.
>  .
>  .\" ----------------------------------------------------------------------------
>  .SH EXAMPLE
> @@ -164,7 +182,8 @@ Read the reservation status of the /dev/mapper/mpath9 device:
>  .\" ----------------------------------------------------------------------------
>  .
>  .BR multipath (8),
> -.BR multipathd (8).
> +.BR multipathd (8),
> +.BR sg_persist (8).
>  .
>  .
>  .\" ----------------------------------------------------------------------------
> -- 
> 2.12.2
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
