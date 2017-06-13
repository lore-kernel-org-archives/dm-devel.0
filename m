From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 4/4] multipath: Fix a potential buffer
	overflow
Date: Tue, 13 Jun 2017 12:53:13 -0700
Message-ID: <5549db47-506b-f564-19ff-8d9dd1c36177@sandisk.com>
References: <20170613163339.23005-1-bart.vanassche@sandisk.com>
	<20170613163339.23005-5-bart.vanassche@sandisk.com>
	<1497382123.4654.48.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1497382123.4654.48.camel@suse.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 06/13/17 12:29, Martin Wilck wrote:
> how about this simpler patch, as prflag is actually a boolean?
> 
> diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> index 04c73866..c31ebd34 100644
> --- a/multipathd/cli_handlers.c
> +++ b/multipathd/cli_handlers.c
> @@ -1337,7 +1337,7 @@ cli_getprstatus (void * v, char ** reply, int * len, void * data)
>         memset(*reply,0,2);
>  
>  
> -       sprintf(*reply,"%d",mpp->prflag);
> +       sprintf(*reply, "%d", !!mpp->prflag);
>         (*reply)[1]='\0';

Hello Martin,

Every sprintf() call requires careful analysis to see whether or not it
triggers a buffer overflow. I really would like to get rid of that
sprintf() call.

Thanks,

Bart.
