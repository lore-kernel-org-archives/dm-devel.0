From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: Integrity errors should not cause failover
Date: Wed, 18 May 2011 08:11:57 -0400
Message-ID: <20110518121156.GB18433@redhat.com>
References: <yq18vu4fw9e.fsf@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <yq18vu4fw9e.fsf@sermon.lab.mkp.net>
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
Cc: device-mapper development <dm-devel@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, May 18 2011 at 12:49am -0400,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> 
> Integrity errors need to be passed to the owner of the integrity
> metadata for processing. Consequently EILSEQ should be passed up the
> stack.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Acked-by: Mike Snitzer <snitzer@redhat.com>
> 
> ---
> 
> Ping on this one?

It has been on my personal queue but I didn't push the issue with
Alasdair (for 2.6.39).

At this point seems we should be targetting this fix for 2.6.40 but I'll
defer to Alasdair on whether he'd like to push to .39 last minute.

> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index a550a05..aa4e570 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -1290,7 +1290,7 @@ static int do_end_io(struct multipath *m, struct request *clone,
>  	if (!error && !clone->errors)
>  		return 0;	/* I/O complete */
>  
> -	if (error == -EOPNOTSUPP || error == -EREMOTEIO)
> +	if (error == -EOPNOTSUPP || error == -EREMOTEIO || error == -EILSEQ)
>  		return error;
>  
>  	if (mpio->pgpath)
