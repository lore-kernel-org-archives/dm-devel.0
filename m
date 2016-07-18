From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] multipath-tools: replace -shared with
 $(SHARED_FLAGS) in Makefile
Date: Mon, 18 Jul 2016 17:36:14 +0200
Message-ID: <69fb937b-0bda-5221-bcdd-7e76fd8f2556@gmail.com>
References: <1468854746-11614-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1468854746-11614-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 07/18/2016 05:12 PM, Xose Vazquez Perez wrote:
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmpathpersist/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile
> index a2dd7ed..93e106d 100644
> --- a/libmpathpersist/Makefile
> +++ b/libmpathpersist/Makefile
> @@ -19,7 +19,7 @@ all: $(LIBS)
>  
>  $(LIBS):
>  	$(CC) -Wall -fPIC -c $(CFLAGS) *.c
> -	$(CC)  -shared $(LIBDEPS) -Wl,-soname=$@ $(CFLAGS) -o $@ $(OBJS)
> +	$(CC) $(SHARED_FLAGS) $(LIBDEPS) -Wl,-soname=$@ $(CFLAGS) -o $@ $(OBJS)
>  	$(LN) $(LIBS) $(DEVLIB)
>  	$(GZIP) mpath_persistent_reserve_in.3 > mpath_persistent_reserve_in.3.gz
>  	$(GZIP) mpath_persistent_reserve_out.3 > mpath_persistent_reserve_out.3.gz
> 

DROP this one, DUPLICATE !!!

Thank you.
