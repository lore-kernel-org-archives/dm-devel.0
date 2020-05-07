From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 1/2] libmpathpersist: depend on libmultipath
Date: Thu, 07 May 2020 23:18:51 +0200
Message-ID: <8c24a3e1f995605b3ed3df2c768b0053766cd5a0.camel@suse.com>
References: <20200506073548.41756-1-list@eworm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200506073548.41756-1-list@eworm.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christian Hesse <list@eworm.de>, dm-devel@redhat.com
Cc: Christian Hesse <mail@eworm.de>
List-Id: dm-devel.ids

On Wed, 2020-05-06 at 09:35 +0200, Christian Hesse wrote:
> From: Christian Hesse <mail@eworm.de>
> 
> Without this the build fails with:
> 
> /usr/bin/ld: cannot find -lmultipath

Thank you. Strange, I've built multipath thousands of times and never
hit this error. 

> 
> Signed-off-by: Christian Hesse <mail@eworm.de>
> ---
>  Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index 1dee3680..ba1d73ba 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -28,7 +28,7 @@ all:	$(BUILDDIRS)
>  $(BUILDDIRS):
>  	$(MAKE) -C $@
>  
> -multipath multipathd mpathpersist: libmultipath
> +libmpathpersist multipath multipathd mpathpersist: libmultipath
>  mpathpersist:  libmpathpersist

Reviewed-by: Martin Wilck <mwilck@suse.com>
