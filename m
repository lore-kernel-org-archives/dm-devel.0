From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: [PATCH] dm_mapname fix in multipath-tools-0.4.4-pre11
Date: Mon, 11 Apr 2005 22:26:22 +0200
Message-ID: <1113251182.8158.2.camel@zezette>
References: <20050411.161559.74755462.k-ueda@kde.biglobe.ne.jp@kde.biglobe.ne.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050411.161559.74755462.k-ueda@kde.biglobe.ne.jp@kde.biglobe.ne.jp>
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

Nice :)
Applied, thanks.

Careful with pre11, you might have noticed the memory audit surgery is
not without glitches.

Regards,
cvaroqui

On lun, 2005-04-11 at 16:15 -0400, k-ueda@ct.jp.nec.com wrote:
> Hi Christophe,
> 
> In multipath-tools-0.4.4-pre11 kpartx/devmapper.c:135:
> -------------------------------------------
>         mapname = dm_task_get_name(dmt);
> out:
>         dm_task_destroy(dmt);
>         return mapname;
> }
> -------------------------------------------
> 
> dm_task_get_name returns a pointer to dmt->dmi.v4->name
> which will be freed at dm_task_destroy() just before return.
> 
> 
> --- multipath-tools-0.4.4-pre11/kpartx/devmapper.c      2005-04-07 09:47:26.000000000 -0400
> +++ dm-mapname-fix/kpartx/devmapper.c   2005-04-12 04:15:14.990239582 -0400
> @@ -132,7 +132,7 @@ dm_mapname(int major, int minor)
>         if (!dm_task_run(dmt))
>                 goto out;
> 
> -       mapname = dm_task_get_name(dmt);
> +       mapname = strdup(dm_task_get_name(dmt));
>  out:
>         dm_task_destroy(dmt);
>         return mapname;
> 
> 
> Regards,
> Ky (Kiyoshi Ueda)
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
-- 
christophe varoqui <christophe.varoqui@free.fr>
