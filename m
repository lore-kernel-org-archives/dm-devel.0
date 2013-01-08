From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH] Don't add 'p' delimiter when you shouldn't
Date: Tue, 08 Jan 2013 08:04:59 +0100
Message-ID: <1357628699.3819.4.camel@lapoo.opensvc.com>
References: <1357588581-29831-1-git-send-email-psusi@ubuntu.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357588581-29831-1-git-send-email-psusi@ubuntu.com>
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
Cc: Phillip Susi <psusi@ubuntu.com>
List-Id: dm-devel.ids

On lun., 2013-01-07 at 14:56 -0500, Phillip Susi wrote:
> The 'p' delimiter is supposed to be added when the base disk name ends
> in a digit.  This decision was based on the name given on the command
> line, not the canonical device name, so giving /dev/dm-0 instead of
> /dev/mapper/foo triggered the digit test and added the 'p'.  Changed
> test to use the canonical name rather than the given name.
> 
Isn't that already merged ?

commit 02ce0e8f40f10c0d0c6ad15b3abd02cb43653879
Author: Phillip Susi <psusi@ubuntu.com>
Date:   Thu Feb 9 21:16:21 2012 +0100

    [kpartx] Don't add 'p' delimiter when you shouldn't
    
    The 'p' delimiter is supposed to be added when the base disk name
    ends in a digit.  This decision was based on the name given on the
    command line, not the canonical device name, so giving /dev/dm-0
    instead of /dev/mapper/foo triggered the digit test and added the
    'p'.  Changed test to use the canonical name rather than the given
    name.

Regards,
Christophe Varoqui
www.opensvc.com

> Signed-off-by: Phillip Susi <psusi@ubuntu.com>
> ---
>  kpartx/kpartx.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
> index 0711450..08f3407 100644
> --- a/kpartx/kpartx.c
> +++ b/kpartx/kpartx.c
> @@ -323,12 +323,6 @@ main(int argc, char **argv){
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
> @@ -350,6 +344,12 @@ main(int argc, char **argv){
>  		return 0;
>  	}
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
