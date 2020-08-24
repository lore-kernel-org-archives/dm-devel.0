From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH] dm-crypt: Document new no_workqueue flags.
Date: Mon, 24 Aug 2020 01:15:41 +0000
Message-ID: <CY4PR04MB37518F3475AE21AB020B628DE7560@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200820174538.20837-1-gmazyland@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <gmazyland@gmail.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 2020/08/21 2:46, Milan Broz wrote:
> Patch 39d42fa96ba1b7d2544db3f8ed5da8fb0d5cb877 introduced new
> dm-crypt no_read_workqueue and no_write_workqueue flags.
> 
> This patch adds documentation to admin guide for them.
> 
> Signed-off-by: Milan Broz <gmazyland@gmail.com>
> ---
>  Documentation/admin-guide/device-mapper/dm-crypt.rst | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/Documentation/admin-guide/device-mapper/dm-crypt.rst b/Documentation/admin-guide/device-mapper/dm-crypt.rst
> index 8f4a3f889d43..94466921415d 100644
> --- a/Documentation/admin-guide/device-mapper/dm-crypt.rst
> +++ b/Documentation/admin-guide/device-mapper/dm-crypt.rst
> @@ -121,6 +121,12 @@ submit_from_crypt_cpus
>      thread because it benefits CFQ to have writes submitted using the
>      same context.
>  
> +no_read_workqueue
> +    Bypass dm-crypt internal workqueue and process read requests synchronously.
> +
> +no_write_workqueue
> +    Bypass dm-crypt internal workqueue and process write requests synchronously.

Could you add one more line here saying something like:

This option is automatically enabled for host-managed zoned block devices (e.g.
host-managed SMR hard-disks).

Thanks !

> +
>  integrity:<bytes>:<type>
>      The device requires additional <bytes> metadata per-sector stored
>      in per-bio integrity structure. This metadata must by provided
> 


-- 
Damien Le Moal
Western Digital Research
