From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 3/4] mpathpersist: fix leaks
Date: Fri, 13 Sep 2019 12:17:06 -0500
Message-ID: <20190913171706.GU25414@octiron.msp.redhat.com>
References: <1568155161-9343-1-git-send-email-bmarzins@redhat.com>
	<1568155161-9343-4-git-send-email-bmarzins@redhat.com>
	<cfec1a7ebbe1e62699d26b9978a8643a798c05dd.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <cfec1a7ebbe1e62699d26b9978a8643a798c05dd.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <Martin.Wilck@suse.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Sep 13, 2019 at 07:56:13AM +0000, Martin Wilck wrote:
> On Tue, 2019-09-10 at 17:39 -0500, Benjamin Marzinski wrote:
> > If handle_args() fails while looping through the argument list, it
> > needs
> > to free batch_fn, if it has been set. Also handle_args() needs to
> > make
> > sure to free the file descriptor after it has been opened.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  mpathpersist/main.c | 31 ++++++++++++++++++++-----------
> >  1 file changed, 20 insertions(+), 11 deletions(-)
> > 
> 
> 
> Looking at this code again, I wonder why we don't "goto out" in this
> code in the "else if (prin_flag)" case:
> 
> 		if (0 == num_prin_sa)
> 		{
> 			fprintf (stderr,
> 					" No service action given for Persistent Reserve IN\n");
> 			ret = MPATH_PR_SYNTAX_ERROR;
> 		}
> 		else if (num_prin_sa > 1)
> 		{
> 			fprintf (stderr, " Too many service actions given; choose "
> 					"one only\n");
> 			ret = MPATH_PR_SYNTAX_ERROR;
> 		}
> 
> At least in the first case, prin_sa would be -1, and trying to continue
> looks unhealthy. In the second case, the error message might be treated
> as a warning and the second prin action would override the first. I
> personally would think that it would be better to assume the user made
> a mistake, and do nothing, in this case as well.

I agree. I'll respin the patches with this included.

-Ben

> Anyway, that's not your patch's fault. So:
> 
> Reviewed-by: Martin Wilck <mwilck@suse.com>
> 
> 
