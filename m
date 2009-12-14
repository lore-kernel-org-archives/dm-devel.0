From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH dmraid 1/1] Ensure metadata dump of pdc
	metadata has the correct offset.
Date: Mon, 14 Dec 2009 15:35:00 +0100
Message-ID: <1260801300.7677.39.camel@o>
References: <20091211032710.161471708@suse.de>
	<20091211033030.695580934@suse.de>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091211033030.695580934@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


Applied to the sources repository.

Thanks,
Heinz

On Fri, 2009-12-11 at 14:27 +1100, NeilBrown wrote:
> plain text document attachment (pdc-metadata-dump-fix)
> a read_metadata function needds to set *offset so that file_metadata
> can create the correct xxx/dev-offset file.
> pdf_read_metadata does not set *offset.
> 
> This patch add the appropriate setting.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>  1.0.0.rc16/lib/format/ataraid/pdc.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> --- dmraid.orig/1.0.0.rc16/lib/format/ataraid/pdc.c
> +++ dmraid/1.0.0.rc16/lib/format/ataraid/pdc.c
> @@ -202,8 +202,11 @@ pdc_read_metadata(struct lib_context *lc
>  							break;
>  
>  					/* Memorize main metadata sector. */
> -					} else if (!info->u32)
> +					} else if (!info->u32) {
>  						info->u32 = *s;
> +						*offset = sub ? di->sectors - *s : *s;
> +					}
> +
>  				}
>  			}
>  		}
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
