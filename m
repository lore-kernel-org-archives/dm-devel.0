From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: [PATCH] call dm_lib_release/exit explicitly in
	multipath-tools
Date: Tue, 17 May 2005 00:44:58 +0200
Message-ID: <1116283498.9352.41.camel@zezette>
References: <20050516.150625.74755942.k-ueda@kde.biglobe.ne.jp@kde.biglobe.ne.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050516.150625.74755942.k-ueda@kde.biglobe.ne.jp@kde.biglobe.ne.jp>
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

Applied, thanks.

On lun, 2005-05-16 at 15:06 -0400, Kiyoshi Ueda wrote:
> Hi Christophe,
> 
> multipath-tools should call dm_lib_release() and dm_lib_exit() 
> before it returns.  Then, libdevmapper will call update_devs()
> and finalize the device node operation which creates
> /dev/mapper/<map_name>.
> 
> This patch may not be needed if the latest libdevmapper of the
> device-mapper CVS is used, since in the latest version, 
> dm_lib_exit() calls dm_lib_release() and dm_lib_exit() is called
> by default when the program returns.
> 
> Regards,
> Kiyoshi Ueda
> 
> 
> diff -rup multipath-tools.org/multipath/main.c multipath-tools/multipath/main.c
> --- multipath-tools.org/multipath/main.c        2005-05-16 12:37:24.000000000 -0400
> +++ multipath-tools/multipath/main.c    2005-05-16 12:34:41.000000000 -0400
> @@ -1004,6 +1004,8 @@ out:
>         free_multipathvec(curmp, KEEP_PATHS);
>         free_pathvec(pathvec, FREE_PATHS);
>         free_config(conf);
> +       dm_lib_release();
> +       dm_lib_exit();
>  #ifdef _DEBUG_
>         dbg_free_final(NULL);
>  #endif
> diff -rup multipath-tools.org/kpartx/kpartx.c multipath-tools/kpartx/kpartx.c
> --- multipath-tools.org/kpartx/kpartx.c 2005-05-16 12:37:36.000000000 -0400
> +++ multipath-tools/kpartx/kpartx.c     2005-05-16 12:36:36.000000000 -0400
> @@ -429,6 +429,10 @@ main(int argc, char **argv){
>                 if (n > 0)
>                         break;
>         }
> +
> +       dm_lib_release();
> +       dm_lib_exit();
> +
>         return 0;
>  }
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
-- 
christophe varoqui <christophe.varoqui@free.fr>
