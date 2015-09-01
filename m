From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: [PATCH] dm-delay: Add a message to change delay
Date: Tue, 1 Sep 2015 10:55:19 +0200
Message-ID: <55E567F7.1050309@redhat.com>
References: <1441056276-14288-1-git-send-email-agrover@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Dne 31.8.2015 v 23:24 Andy Grover napsal(a):
> This enables runtime modification of the read and write delay values.
>
> Make sure if the delay time is reduced to flush currently-delayed
> bios first, to maintain ordering.
>


Hi


Flush with suspend is an optional feature.

You could  'dmsetup suspend --noflush'  so IMHO there is no need for
message support - you just load new table line
and go through suspend resume (resume should be enough)

Messages are normally used for something unrelated to table line,
for table line args - you should go with standard table line load
(so dmsetup table always shows correct value)

Regards

Zdenek



> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>   Documentation/device-mapper/delay.txt |  8 +++++++
>   drivers/md/dm-delay.c                 | 42 +++++++++++++++++++++++++++++++++++
>   2 files changed, 50 insertions(+)
>
> diff --git a/Documentation/device-mapper/delay.txt b/Documentation/device-mapper/delay.txt
> index 15adc55..9e80751 100644
> --- a/Documentation/device-mapper/delay.txt
> +++ b/Documentation/device-mapper/delay.txt
> @@ -10,6 +10,14 @@ Parameters:
>   With separate write parameters, the first set is only used for reads.
>   Delays are specified in milliseconds.
>
> +Message Interface
> +-----------------
> +The delay target will accept a message of the following format:
> +
> +set_delay <read_delay> [<write_delay>]
> +
> +'man dmsetup' for more information on the message interface.
> +
>   Example scripts
>   ===============
>   [[
> diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
> index 57b6a19..04c2ab0 100644
> --- a/drivers/md/dm-delay.c
> +++ b/drivers/md/dm-delay.c
> @@ -290,6 +290,47 @@ static int delay_map(struct dm_target *ti, struct bio *bio)
>   	return delay_bio(dc, dc->read_delay, bio);
>   }
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
>   static void delay_status(struct dm_target *ti, status_type_t type,
>   			 unsigned status_flags, char *result, unsigned maxlen)
>   {
> @@ -339,6 +380,7 @@ static struct target_type delay_target = {
>   	.map	     = delay_map,
>   	.presuspend  = delay_presuspend,
>   	.resume	     = delay_resume,
> +	.message     = delay_message,
>   	.status	     = delay_status,
>   	.iterate_devices = delay_iterate_devices,
>   };
>
