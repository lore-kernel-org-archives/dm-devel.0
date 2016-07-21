From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] multipathd: restore paths after reconfigure
Date: Thu, 21 Jul 2016 09:29:37 -0700
Message-ID: <758f2ab7-c8ed-06d9-f891-5cdaf893a5a7@sandisk.com>
References: <1467409569-16088-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1467409569-16088-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On 07/01/2016 02:46 PM, Benjamin Marzinski wrote:
> multipathd has code to finish gathering the information of paths that
> were not active at the time they were discovered. When the checker loop
> goes to check a path, and notices that it wasn't fully initialized, it
> is supposed to complete the initialization.  However the code is broken.
> This means that if you reconfigure multipathd while paths are down, they
> will no longer be usable. This patch makes sure that check_path will
> actually rerun pathinfo to finish setting up the path, so that after the
> path comes back up, it will be usable again.
> [ ... ]
> @@ -1779,7 +1785,13 @@ checkerloop (void *ap)
>  			lock(vecs->lock);
>  			pthread_testcancel();
>  			vector_foreach_slot (vecs->pathvec, pp, i) {
> -				num_paths += check_path(vecs, pp, ticks);
> +				rc = check_path(vecs, pp, ticks);
> +				if (rc < 0) {
> +					vector_del_slot(vecs->pathvec, i);
> +					free_path(pp);
> +					i--;
> +				} else;
> +					num_paths += rc;
>  			}
>  			lock_cleanup_pop(vecs->lock);
>  		}

Hi Ben,

Was the semicolon after the "else" intended or was it a typo?

Thanks,

Bart.
