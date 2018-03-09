From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] multipath-tools: Remove trailing/leading
 whitespaces and reformat code
Date: Fri, 9 Mar 2018 22:04:08 +0000
Message-ID: <1520633047.2907.14.camel@wdc.com>
References: <20180309220053.3022-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180309220053.3022-1-xose.vazquez@gmail.com>
Content-Language: en-US
Content-ID: <DE7FAA90875B70408DBD162574038281@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "xose.vazquez@gmail.com" <xose.vazquez@gmail.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, 2018-03-09 at 23:00 +0100, Xose Vazquez Perez wrote:
>  # Check whether a function with name $1 has been declared in header file $2.
> -check_func =								       \
> -    $(shell								       \
> +check_func = $(shell \
>  	if grep -Eq "^[^[:blank:]]+[[:blank:]]+$1[[:blank:]]*(.*)*" "$2"; then \
> -	   found=1;							       \
> -	   status="yes";						       \
> -	else								       \
> -	   found=0;							       \
> -	   status="no";							       \
> -	fi;								       \
> -	echo 1>&2 "Checking for $1 in $2 ... $$status";			       \
> -	echo "$$found"							       \
> -    )
> +		found=1; \
> +		status="yes"; \
> +	else \
> +		found=0; \
> +		status="no"; \
> +	fi; \
> +	echo 1>&2 "Checking for $1 in $2 ... $$status"; \
> +	echo "$$found" \
> +	)

Whitespace-only patches are not useful, and on top of that you are making the code
much more ugly by breaking the alignment of the trailing backslahes. Yikes!

Bart.
