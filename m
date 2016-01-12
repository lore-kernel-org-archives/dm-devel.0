From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 1/2] dm stripe: document that chunk size is
 specified in sectors (resend)
Date: Tue, 12 Jan 2016 12:59:24 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1601121258060.5769@file01.intranet.prod.int.rdu2.redhat.com>
References: <56952c84.020d620a.94f42.2f06@mx.google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <56952c84.020d620a.94f42.2f06@mx.google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Cc: dm-devel@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids



On Wed, 13 Jan 2016, kusumi.tomohiro@gmail.com wrote:

> From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
> 
> Mention it's in sector similar to f49e869.
> It sounds like one specifies it in a number like 4096.
> 
> Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
> ---
>  Documentation/device-mapper/striped.txt |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/device-mapper/striped.txt b/Documentation/device-mapper/striped.txt
> index 45f3b91..f109b54 100644
> --- a/Documentation/device-mapper/striped.txt
> +++ b/Documentation/device-mapper/striped.txt
> @@ -9,8 +9,8 @@ devices in parallel.
>  
>  Parameters: <num devs> <chunk size> [<dev path> <offset>]+
>      <num devs>: Number of underlying devices.
> -    <chunk size>: Size of each chunk of data. Must be at least as
> -                  large as the system's PAGE_SIZE.
> +    <chunk size>: Size of each chunk of data in sectors. Must be
> +                  at least as large as the system's PAGE_SIZE.
>      <dev path>: Full pathname to the underlying block-device, or a
>                  "major:minor" device-number.
>      <offset>: Starting sector within the device.
> -- 
> 1.7.1

It is not required that the chunk size must be at least as larget as the 
page size, so that sentence should be dropped too.

Mikulas
