From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V2] multipathd daemon: Fix incorrect use of
 CLOCK_MONOTONIC in pthread
Date: Wed, 9 Aug 2017 16:25:06 +0000
Message-ID: <1502295904.2356.5.camel@wdc.com>
References: <20170809132214.3081-1-fge@redhat.com>
	<20170809162126.7831-1-fge@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170809162126.7831-1-fge@redhat.com>
Content-Language: en-US
Content-ID: <BEDEB9B4AB7D4C4FB91D7670F3E44661@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>, "fge@redhat.com" <fge@redhat.com>
List-Id: dm-devel.ids

On Thu, 2017-08-10 at 00:21 +0800, Gris Ge wrote:
> diff --git a/multipathd/cli.c b/multipathd/cli.c
> index 32d49766..002abe61 100644
> --- a/multipathd/cli.c
> +++ b/multipathd/cli.c
> @@ -475,7 +475,7 @@ parse_cmd (char * cmd, char ** reply, int * len, void * data, int timeout )
>  	/*
>  	 * execute handler
>  	 */
> -	if (clock_gettime(CLOCK_MONOTONIC, &tmo) == 0) {
> +	if (clock_gettime(CLOCK_REALTIME, &tmo) == 0) {
>  		tmo.tv_sec += timeout;
>  	} else {
>  		tmo.tv_sec = 0;

Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
