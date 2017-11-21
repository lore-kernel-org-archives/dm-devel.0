From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] multipath-tools: add README.alua with
 instructions to enable ALUA
Date: Tue, 21 Nov 2017 19:50:20 +0100
Message-ID: <91541216-2c8f-9c50-e645-391442912e24@gmail.com>
References: <20171120185315.3026-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20171120185315.3026-1-xose.vazquez@gmail.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 11/20/2017 07:53 PM, Xose Vazquez Perez wrote:
> ALUA is supported in some storage devices, but usually it's disabled by default.

Christophe, please drop this one. v2 is on the way.

> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  README.alua | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>  create mode 100644 README.alua
> 
> diff --git a/README.alua b/README.alua
> new file mode 100644
> index 0000000..134696a
> --- /dev/null
> +++ b/README.alua
> @@ -0,0 +1,14 @@
> +This is a rough guide, consult your storage device manufacturer documentation.
> +
> +ALUA is supported in some devices, but usually it's disabled by default.
> +To enable ALUA, the following options should be changed:
> +
> +- EMC CLARiiON/VNX:
> +   "Failover Mode" should be changed to "4".
> +
> +- HPE 3PAR:
> +   "Host:" should be changed to "Generic-ALUA Persona 2 (UARepLun, SESLun, ALUA)".
> +
> +- Promise VTrak/Vess:
> +   "LUN Affinity" and "ALUA" should be changed to "Enable", "Redundancy Type"
> +   must be "Active-Active".
> 
