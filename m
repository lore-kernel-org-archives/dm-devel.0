From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [RFC PATCH 01/20] multipath(d)/Makefile: add
 explicit dependency on libraries
Date: Wed, 28 Feb 2018 23:35:56 -0600
Message-ID: <20180301053556.GR14513@octiron.msp.redhat.com>
References: <20180220132658.22295-1-mwilck@suse.com>
	<20180220132658.22295-2-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180220132658.22295-2-mwilck@suse.com>
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

On Tue, Feb 20, 2018 at 02:26:39PM +0100, Martin Wilck wrote:
> Otherwise the binaries won't be re-linked if the libraries change.
> 

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipath/Makefile  | 2 +-
>  multipathd/Makefile | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/multipath/Makefile b/multipath/Makefile
> index 654568af3576..0828a8f72db7 100644
> --- a/multipath/Makefile
> +++ b/multipath/Makefile
> @@ -14,7 +14,7 @@ OBJS = main.o
>  
>  all: $(EXEC)
>  
> -$(EXEC): $(OBJS)
> +$(EXEC): $(OBJS) $(multipathdir)/libmultipath.so $(mpathcmddir)/libmpathcmd.so
>  	$(CC) $(CFLAGS) $(OBJS) -o $(EXEC) $(LDFLAGS) $(LIBDEPS)
>  	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
>  	$(GZIP) $(EXEC).conf.5 > $(EXEC).conf.5.gz
> diff --git a/multipathd/Makefile b/multipathd/Makefile
> index 251690ec5e2a..4c9d29634160 100644
> --- a/multipathd/Makefile
> +++ b/multipathd/Makefile
> @@ -28,7 +28,7 @@ EXEC = multipathd
>  
>  all : $(EXEC)
>  
> -$(EXEC): $(OBJS)
> +$(EXEC): $(OBJS) $(multipathdir)/libmultipath.so $(mpathcmddir)/libmpathcmd.so
>  	$(CC) $(CFLAGS) $(OBJS) $(LDFLAGS) -o $(EXEC) $(LIBDEPS)
>  	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
>  
> -- 
> 2.16.1
