From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] dm-delay: Add a message to change delay
Date: Mon, 31 Aug 2015 22:05:57 -0400
Message-ID: <20150901020557.GA31620@redhat.com>
References: <1441056276-14288-1-git-send-email-agrover@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1441056276-14288-1-git-send-email-agrover@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andy Grover <agrover@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Aug 31, 2015 at 02:24:36PM -0700, Andy Grover wrote:
> This enables runtime modification of the read and write delay values.
> 
> Make sure if the delay time is reduced to flush currently-delayed
> bios first, to maintain ordering.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  Documentation/device-mapper/delay.txt |  8 +++++++
>  drivers/md/dm-delay.c                 | 42 +++++++++++++++++++++++++++++++++++
>  2 files changed, 50 insertions(+)
> 
> diff --git a/Documentation/device-mapper/delay.txt b/Documentation/device-mapper/delay.txt
> index 15adc55..9e80751 100644
> --- a/Documentation/device-mapper/delay.txt
> +++ b/Documentation/device-mapper/delay.txt
> @@ -10,6 +10,14 @@ Parameters:
>  With separate write parameters, the first set is only used for reads.
>  Delays are specified in milliseconds.
>  
> +Message Interface
> +-----------------
> +The delay target will accept a message of the following format:
> +
> +set_delay <read_delay> [<write_delay>]
> +

Hi Andy,

So if I want to change only write_delay and keep read_delay same, how do
I do that. Do I have to keep track of existing delay values in user space
and pass same value in read_delay to achieve this.

Thanks
Vivek

> +'man dmsetup' for more information on the message interface.
> +
>  Example scripts
>  ===============
>  [[
> diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
> index 57b6a19..04c2ab0 100644
> --- a/drivers/md/dm-delay.c
> +++ b/drivers/md/dm-delay.c
> @@ -290,6 +290,47 @@ static int delay_map(struct dm_target *ti, struct bio *bio)
>  	return delay_bio(dc, dc->read_delay, bio);
>  }
>  
> +/* Message interface
> + *	set_delay <read_delay> [<write_delay>]
> +*/
> +static int delay_message(struct dm_target *ti, unsigned argc, char **argv)
> +{
> +	struct delay_c *dc = ti->private;
> +	unsigned read_delay = dc->read_delay;
> +	unsigned write_delay = dc->write_delay;
> +	char dummy;
> +
> +	if (argc < 2 || argc > 3)
> +		goto error;
> +
> +	if (strcasecmp(argv[0], "set_delay"))
> +		goto error;
> +
> +	if (sscanf(argv[1], "%u%c", &read_delay, &dummy) != 1) {
> +		ti->error = "Invalid read delay";
> +		goto error;
> +	}
> +
> +	if (argc == 3) {
> +		if (sscanf(argv[2], "%u%c", &write_delay, &dummy) != 1) {
> +			ti->error = "Invalid write delay";
> +			goto error;
> +		}
> +	}
> +
> +	if (read_delay < dc->read_delay
> +	    || write_delay < dc->write_delay)
> +		flush_bios(flush_delayed_bios(dc, 1));
> +
> +	dc->read_delay = read_delay;
> +	dc->write_delay = write_delay;
> +	return 0;
> +
> +error:
> +	DMWARN("unrecognised message received.");
> +	return -EINVAL;
> +}
> +
>  static void delay_status(struct dm_target *ti, status_type_t type,
>  			 unsigned status_flags, char *result, unsigned maxlen)
>  {
> @@ -339,6 +380,7 @@ static struct target_type delay_target = {
>  	.map	     = delay_map,
>  	.presuspend  = delay_presuspend,
>  	.resume	     = delay_resume,
> +	.message     = delay_message,
>  	.status	     = delay_status,
>  	.iterate_devices = delay_iterate_devices,
>  };
> -- 
> 2.4.3
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
