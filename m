From: Martin Wilck <martin.wilck@suse.com>
Subject: Re: [PATCH] libmultipath: fix condlog NULL argument in
 uevent_get_env_var
Date: Fri, 05 Jun 2020 21:30:59 +0200
Message-ID: <ee3a2cc648cf1f52aefbe61c6ea27bf618973f99.camel@suse.com>
References: <1591312806-25110-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1591312806-25110-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, 2020-06-04 at 18:20 -0500, Benjamin Marzinski wrote:
> uevent_get_env_var() could call condlog with p == NULL. On gcc 10,
> this triggers warnings like:
> 
> In file included from uevent.c:47:
> In function 'uevent_get_env_var',
>     inlined from 'uevent_get_wwid' at uevent.c:170:8:
> debug.h:13:2: error: '%s' directive argument is null
> [-Werror=format-overflow=]
>    13 |  dlog(logsink, prio, fmt "\n", ##args)
>       |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> uevent.c:132:2: note: in expansion of macro 'condlog'
>   132 |  condlog(4, "%s: %s -> '%s'", __func__, attr, p);
>       |  ^~~~~~~
> uevent.c: In function 'uevent_get_wwid':
> uevent.c:132:25: note: format string is defined here
>   132 |  condlog(4, "%s: %s -> '%s'", __func__, attr, p);
>       |                         ^~
> 
> If p is NULL, use "(null)" instead.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/uevent.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Martin Wilck <mwilck@suse.com>
