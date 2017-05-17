From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 1/2] libmultipath: print.c: make sure lines
 are 0-terminated
Date: Wed, 17 May 2017 14:17:55 +0000
Message-ID: <1495030674.2945.4.camel@sandisk.com>
References: <20170517135439.25935-1-mwilck@suse.com>
	<20170517135439.25935-2-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170517135439.25935-2-mwilck@suse.com>
Content-Language: en-US
Content-ID: <15DAA6C3E8B4BE4CBAC39C6736D76C61@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "mwilck@suse.com" <mwilck@suse.com>, "hare@suse.de" <hare@suse.de>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, 2017-05-17 at 15:54 +0200, Martin Wilck wrote:
>  #define ENDLINE \
> -		if (c > line) \
> -			line[c - line - 1] = '\n'
> +		if (c > line) {				\
> +			if (c <= line + len - 1) {	\
> +				*(c - 1) = '\n';	\
> +				*c = '\0';		\
> +			} else				\
> +				line[len - 1] = '\0';	\
> +		}

Hello Martin,

Please convert ENDLINE from a macro into a function. Functions are
easier to maintain than macros.

Thanks,

Bart.
