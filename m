From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [PATCH -next] dm: fix dm-log-userspace printk format
Date: Fri, 19 Jun 2009 13:32:56 -0500
Message-ID: <63B19258-D345-472C-8923-1A7F91F466A1@redhat.com>
References: <20090619172622.05adb236.sfr@canb.auug.org.au>
	<4A3BD7D2.6020803@oracle.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v935.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4A3BD7D2.6020803@oracle.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: randy.dunlap@oracle.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, device-mapper development <dm-devel@redhat.com>, linux-next@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

thanks, I've pulled this into my patch as well.

  brassow

On Jun 19, 2009, at 1:24 PM, Randy Dunlap wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Fix printk format warning:
>
> drivers/md/dm-log-userspace-transfer.c:110: warning: format '%lu'  
> expects type 'long unsigned int', but argument 4 has type 'size_t'
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Jonathan Brassow <dm-devel@redhat.com>
> Cc: dm-devel@redhat.com
> ---
> drivers/md/dm-log-userspace-transfer.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- linux-next-20090619.orig/drivers/md/dm-log-userspace-transfer.c
> +++ linux-next-20090619/drivers/md/dm-log-userspace-transfer.c
> @@ -108,7 +108,7 @@ static int fill_pkg(struct cn_msg *msg,
> 				*(pkg->data_size) = 0;
> 		} else if (tfr->data_size > *(pkg->data_size)) {
> 			DMERR("Insufficient space to receive package [%u] "
> -			      "(%u vs %lu)", tfr->request_type,
> +			      "(%u vs %zu)", tfr->request_type,
> 			      tfr->data_size, *(pkg->data_size));
>
> 			*(pkg->data_size) = 0;
>
>
> -- 
> ~Randy
> LPC 2009, Sept. 23-25, Portland, Oregon
> http://linuxplumbersconf.org/2009/
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
