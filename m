From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: multipath-tools/path_priority pp_alua/rtpg.c p ...
Date: Wed, 02 Nov 2011 22:51:50 +0100
Message-ID: <1320270710.16195.15.camel@lapoo.opensvc.com>
References: <20111024134132.32316.qmail@sourceware.org>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20111024134132.32316.qmail@sourceware.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: dm-cvs@sourceware.org
List-Id: dm-devel.ids

> --- multipath-tools/path_priority/pp_alua/rtpg.c	2009/08/18 21:12:02	1.3.2.5
> +++ multipath-tools/path_priority/pp_alua/rtpg.c	2011/10/24 13:41:32	1.3.2.6
> @@ -29,7 +29,7 @@
>  #include "rtpg.h"
>  
>  #define SENSE_BUFF_LEN  32
> -#define DEF_TIMEOUT     300000
> +#define DEF_TIMEOUT     60000
>  

Do you want that part merged into upstream's alua prioritizer shared
object ?

Regards,
-- 
Christophe Varoqui
OpenSVC - Tools to scale
http://www.opensvc.com/
