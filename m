From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 08/14] libmultipath: donot free *dst if
 REALLOC fails in, merge_words
Date: Fri, 4 Sep 2020 16:11:09 -0500
Message-ID: <20200904211109.GD11108@octiron.msp.redhat.com>
References: <37544d4c-950f-4281-3b66-e4d1884c5167@huawei.com>
	<f8ec7113-a9da-46a0-16c8-1e245f9592f0@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <f8ec7113-a9da-46a0-16c8-1e245f9592f0@huawei.com>
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
To: lixiaokeng <lixiaokeng@huawei.com>
Cc: linfeilong <linfeilong@huawei.com>, dm-devel mailing list <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

On Wed, Sep 02, 2020 at 03:20:29PM +0800, lixiaokeng wrote:
> In merge_words func, if REALLOC() fails, the input *dst will
> be freed. If so, mpp->hwhandler| mpp->features|mpp->selector
> may be set to NULL after calling merge_words func in
> disassemble_map func. This may cause accessing freed memory
> problem.
> 

I'm not sure that this is the right way to fix the issue you're seeing.
If merge_words() frees mpp->hwhandler| mpp->features|mpp->selector, it
also sets them to NULL.  I don't see any place in disassemble_map()
where these would be accessed if merge_words() freed them.  Even with
this fix, there are still cases where disassemble_map() will return 1,
with these members set to NULL. If there is something that is
dereferencing them without checking if they're NULL, we should fix that.
But simply making them include partial information doesn't seem like it
fixes anything.

Am I missing something here?

-Ben

> Here, we donot free *dst if REALLOC() fails in merge_words func.
> 
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
> ---
>  libmultipath/dmparser.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
> index c1031616..482e9d0e 100644
> --- a/libmultipath/dmparser.c
> +++ b/libmultipath/dmparser.c
> @@ -26,13 +26,12 @@ merge_words(char **dst, const char *word)
> 
>  	dstlen = strlen(*dst);
>  	len = dstlen + strlen(word) + 2;
> -	*dst = REALLOC(*dst, len);
> +	p = REALLOC(*dst, len);
> 
> -	if (!*dst) {
> -		free(p);
> +	if (!p)
>  		return 1;
> -	}
> 
> +	*dst = p;
>  	p = *dst + dstlen;
>  	*p = ' ';
>  	++p;
> -- 
