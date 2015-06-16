From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 2/4] dm stats: support precise timestamps
Date: Tue, 16 Jun 2015 11:33:45 -0400
Message-ID: <20150616153345.GA1069@redhat.com>
References: <alpine.LRH.2.02.1506091705160.1545@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1506091721180.1545@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1506091721180.1545@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, Laurence Oberman <loberman@redhat.com>, Tao Ma <boyu.mt@taobao.com>, Robin Dong <sanbai@alibaba-inc.com>, dm-devel@redhat.com, Coly Li <colyli@gmail.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Jun 09, 2015 at 05:21:39PM -0400, Mikulas Patocka wrote:

[..]
>  Messages
>  ========
>  
> -    @stats_create <range> <step> [<program_id> [<aux_data>]]
> +    @stats_create <range> <step>
> +    		[<number_of_optional_arguments> <optional_arguments>...]
> +		[<program_id> [<aux_data>]]
>  
>  	Create a new region and return the region_id.
>  
> @@ -48,6 +54,17 @@ Messages
>  	  "/<number_of_areas>" - the range is subdivided into the specified
>  				 number of areas.
>  
> +	<number_of_optional_arguments>
> +	  The number of optional arguments
> +
> +	<optional_arguments>
> +	  The following optional arguments are supported
> +	  precise_timestamps - use precise timer with nanosecond resolution
> +	  	instead of the "jiffies" variable.  When this argument is
> +		used, the resulting times are in nanoseconds instead of
> +		milliseconds.  Precise timestamps are a little bit slower
> +		to obtain than jiffies-based timestamps.
> +

Instead of "precise_timestams" will it make sense to call it
"nanosecond_timestamps" or "ns_timestamps".


>  	<program_id>
>  	  An optional parameter.  A name that uniquely identifies
>  	  the userspace owner of the range.  This groups ranges together

We are adding these new parameters/arguments in between existing parameters.
Will it break any of the existing scritps. Will it make sense to add these
new parameters at the end. It is more intuitive.

Also, I was wondering that why do we need to introduce this notion of
number of optional arguments. Can't we just introduce another optional
parameter [ns_timestamps]. That feels little simpler.

Thanks
Vivek
