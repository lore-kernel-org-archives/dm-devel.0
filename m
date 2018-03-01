From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [RFC PATCH 09/20] multipath-tools: Makefile.inc: use
 -Werror=cast-qual
Date: Wed, 28 Feb 2018 23:59:48 -0600
Message-ID: <20180301055948.GY14513@octiron.msp.redhat.com>
References: <20180220132658.22295-1-mwilck@suse.com>
	<20180220132658.22295-10-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180220132658.22295-10-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Feb 20, 2018 at 02:26:47PM +0100, Martin Wilck wrote:
> Casting "const" away is often an indicator for wrong code.
> Add a compiler flag to warn about such possible breakage.
> 

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  Makefile.inc | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Makefile.inc b/Makefile.inc
> index eb99c36010c1..a5b9d4e3fa74 100644
> --- a/Makefile.inc
> +++ b/Makefile.inc
> @@ -87,6 +87,7 @@ STACKPROT := $(call TEST_CC_OPTION,-fstack-protector-strong,-fstack-protector)
>  OPTFLAGS	= -O2 -g -pipe -Wall -Wextra -Wformat=2 -Werror=implicit-int \
>  		  -Werror=implicit-function-declaration -Werror=format-security \
>  		  -Wno-sign-compare -Wno-unused-parameter -Wno-clobbered \
> +		  -Werror=cast-qual -Werror=discarded-qualifiers \
>  		  -Wp,-D_FORTIFY_SOURCE=2 $(STACKPROT) \
>  		  --param=ssp-buffer-size=4
>  
> -- 
> 2.16.1
