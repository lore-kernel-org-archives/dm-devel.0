From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v2 03/17] libmultipath: fix leak in foreign
	code
Date: Tue, 11 Feb 2020 16:47:55 -0600
Message-ID: <20200211224755.GH30153@octiron.msp.redhat.com>
References: <1580929100-32572-1-git-send-email-bmarzins@redhat.com>
	<1580929100-32572-4-git-send-email-bmarzins@redhat.com>
	<10b549834e581e0ec3b9aba230c2f01c43db6c11.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <10b549834e581e0ec3b9aba230c2f01c43db6c11.camel@suse.com>
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
To: Martin Wilck <mwilck@suse.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Feb 11, 2020 at 10:36:19AM +0100, Martin Wilck wrote:
> Hi Ben, hi Christophe,
> 
> On Wed, 2020-02-05 at 12:58 -0600, Benjamin Marzinski wrote:
> > If scandir fails or finds no foreign libraries, enable_re needs to be
> > freed before exitting.
> > 
> > Fixes: 8d03eda4 'multipath.conf: add "enable_foreign" parameter'
> > Reviewed-by: Martin Wilck <mwilck@suse.com>
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/foreign.c | 11 +++++++----
> >  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> While trying to merge your series into my tree, I realized that this
> patch conflicts with my previously submitted patch "libmultipath:
> _init_foreign(): fix possible memory leak"
> https://www.redhat.com/archives/dm-devel/2019-October/msg00104.html
> which fixed the same issue.
> 
> The two patches are almost equal, so I really don't care which one
> is eventually taken. I just wanted to alert Christophe about the
> conflict.
> 
> Anyway, I thought that you'd ACK'd my October 72-part patch series in
> the following messages:
> 
> https://www.redhat.com/archives/dm-devel/2019-October/msg00214.html
>   (Ben: ACK on v2 of 72-part series "multipath-tools: cleanup and
> warning enablement", except 16/72 "libmultipath: make path_discovery()
> pthread_cancel()-safe")
> https://www.redhat.com/archives/dm-devel/2019-November/msg00016.html
>   (Ben: ACK on 16/72 "libmultipath: make path_discovery()
> pthread_cancel()-safe", after discussion)
> https://www.redhat.com/archives/dm-devel/2019-November/msg00085.html
>   (Ben: Ack on v2->v3 change, updated patch v3 45/72 "libmultipath: fix
> -Wsign-compare warnings with snprintf()")
> 
> Please clarify if I misunderstood that and the series still needs work
> from your PoV.

No. Your fix is fine. It's my bad. I didn't rebase my branch on top of
your fixes.

-Ben
 
> Regards
> Martin
> 
> 
> > 
> > diff --git a/libmultipath/foreign.c b/libmultipath/foreign.c
> > index 4b34e141..68e9a9b8 100644
> > --- a/libmultipath/foreign.c
> > +++ b/libmultipath/foreign.c
> > @@ -129,7 +129,7 @@ static int _init_foreign(const char
> > *multipath_dir, const char *enable)
> >  	char pathbuf[PATH_MAX];
> >  	struct dirent **di;
> >  	struct scandir_result sr;
> > -	int r, i;
> > +	int r, i, ret = 0;
> >  	regex_t *enable_re = NULL;
> >  
> >  	foreigns = vector_alloc();
> > @@ -157,13 +157,15 @@ static int _init_foreign(const char
> > *multipath_dir, const char *enable)
> >  	if (r == 0) {
> >  		condlog(3, "%s: no foreign multipath libraries found",
> >  			__func__);
> > -		return 0;
> > +		ret = 0;
> > +		goto out;
> >  	} else if (r < 0) {
> >  		r = errno;
> >  		condlog(1, "%s: error %d scanning foreign multipath
> > libraries",
> >  			__func__, r);
> >  		_cleanup_foreign();
> > -		return -r;
> > +		ret = -r;
> > +		goto out;
> >  	}
> >  
> >  	sr.di = di;
> > @@ -250,8 +252,9 @@ static int _init_foreign(const char
> > *multipath_dir, const char *enable)
> >  		free_foreign(fgn);
> >  	}
> >  	pthread_cleanup_pop(1); /* free_scandir_result */
> > +out:
> >  	pthread_cleanup_pop(1); /* free_pre */
> > -	return 0;
> > +	return ret;
> >  }
> >  
> >  int init_foreign(const char *multipath_dir, const char *enable)
> 
