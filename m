From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: release 0.4.4 ?
Date: Tue, 19 Apr 2005 23:14:55 +0200
Message-ID: <1113945295.24817.59.camel@zezette>
References: <1113731446.24817.4.camel@zezette>
	<20050419174523.GS9049@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050419174523.GS9049@agk.surrey.redhat.com>
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

Merged

On mar, 2005-04-19 at 18:45 +0100, Alasdair G Kergon wrote:
> --- multipath-tools-0.4.4.2/libmultipath/cache.c        2005-04-11
> 10:46:14.000000000 +0100
> +++ multipath-tools-0.4.4.2-new/libmultipath/cache.c    2005-04-19
> 18:20:16.000000000 +0100
> @@ -86,7 +86,7 @@
>         off_t record_len;
>         struct path * pp;
>  
> -       fd = open(CACHE_TMPFILE, O_RDWR|O_CREAT);
> +       fd = open(CACHE_TMPFILE, O_RDWR|O_CREAT, 0600);
>  
>         if (fd < 0)
>                 return 1;
> 
-- 
christophe varoqui <christophe.varoqui@free.fr>
