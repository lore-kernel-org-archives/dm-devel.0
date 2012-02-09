From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH] Don't add 'p' delimiter when you shouldn't
Date: Thu, 09 Feb 2012 14:33:34 -0500
Message-ID: <4F341F8E.5010406@ubuntu.com>
References: <4F0A5A27.8090107@ubuntu.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4F0A5A27.8090107@ubuntu.com>
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
List-Id: dm-devel.ids

Not heard anything back about this yet.  Does anyone have any comments
or care to merge it?

On 1/8/2012 10:08 PM, Phillip Susi wrote:
> The 'p' delimiter is supposed to be added when the base disk name
> ends in a digit.  This decision was based on the name given on the
> command line, not the canonical device name, so giving /dev/dm-0
> instead of /dev/mapper/foo triggered the digit test and added the
> 'p'.  Changed test to use the canonical name rather than the given
> name.
> 
> Index: b/kpartx/kpartx.c
> ===================================================================
> --- a/kpartx/kpartx.c
> +++ b/kpartx/kpartx.c
> @@ -310,12 +310,6 @@
>  		device = loopdev;
>  	}
>  
> -	if (delim == NULL) {
> -		delim = malloc(DELIM_SIZE);
> -		memset(delim, 0, DELIM_SIZE);
> -		set_delimiter(device, delim);
> -	}
> -
>  	off = find_devname_offset(device);
>  
>  	if (!loopdev) {
> @@ -331,6 +325,12 @@
>  	if (!mapname)
>  		mapname = device + off;
>  
> +	if (delim == NULL) {
> +		delim = malloc(DELIM_SIZE);
> +		memset(delim, 0, DELIM_SIZE);
> +		set_delimiter(mapname, delim);
> +	}
> +
>  	fd = open(device, O_RDONLY);
>  
>  	if (fd == -1) {
> 
> 
> 
> 
> --
