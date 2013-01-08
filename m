From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH 1/1] libmultipath: fix segfault when vector
	is null
Date: Wed, 09 Jan 2013 00:45:37 +0100
Message-ID: <1357688737.12137.8.camel@lapoo.opensvc.com>
References: <1357673794-4894-1-git-send-email-michaelc@cs.wisc.edu>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357673794-4894-1-git-send-email-michaelc@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: michaelc@cs.wisc.edu
Cc: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

On mar., 2013-01-08 at 13:36 -0600, michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> While performing tests that caused paths to get added
> and deleted, we hit a segfault. We traced it to the
> vector struct being NULL. This patch fixes the problem
> by checking for a NULL vector before accessing it.
> 
Applied.

Thanks,
Christophe Varoqui
www.opensvc.com

> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
>  libmultipath/vector.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/libmultipath/vector.c b/libmultipath/vector.c
> index 652f118..0564224 100644
> --- a/libmultipath/vector.c
> +++ b/libmultipath/vector.c
> @@ -94,6 +94,9 @@ find_slot(vector v, void * addr)
>  {
>  	int i;
>  
> +	if (!v)
> +		return -1;
> +
>  	for (i = 0; i < (v->allocated / VECTOR_DEFAULT_SIZE); i++)
>  		if (v->slot[i] == addr)
>  			return i;
