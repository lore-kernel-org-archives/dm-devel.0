From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: Segfault running multipath -d -v 3 at HOL
Date: Thu, 13 Apr 2006 23:06:09 +0200
Message-ID: <443EBD41.5060503@free.fr>
References: <1144886522.7553.6.camel@ca-bwong3.trans.corp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1144886522.7553.6.camel@ca-bwong3.trans.corp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: bwong@pillardata.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Brian Wong a =E9crit :
> Hi Christophe,
>
> I'm seeing a segfault running `multipath -d -v 3` at HOL.  Here's the
> fix for the issue.  It might be worth applying similar logic fixes to
> the rest of the free_x() calls in free_config(); let me know if you wan=
t
> that patch too.
>  =20
Thanks. I applied this bit.
> =20
> diff --git a/libmultipath/parser.c b/libmultipath/parser.c
> index 385e4fb..bb04968 100644
> --- a/libmultipath/parser.c
> +++ b/libmultipath/parser.c
> @@ -18,6 +18,7 @@
>   */
> =20
>  #include <syslog.h>
> =20
>  #include "parser.h"
>  #include "memory.h"
> @@ -110,6 +111,9 @@ free_keywords(vector keywords)
>  	struct keyword *keyword;
>  	int i;
> =20
> +	if (!keywords) return;
> +
>  	for (i =3D 0; i < VECTOR_SIZE(keywords); i++) {
>  		keyword =3D VECTOR_SLOT(keywords, i);
>  		if (keyword->sub)
> @@ -483,3 +487,11 @@ init_data(char *conf_file, void (*init_k
> =20
>  	return r;
>  }
>
>  =20
Regards,
cvaroqui
