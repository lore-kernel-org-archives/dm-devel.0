From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v3 2/2] dm unstripe: Add documentation for unstripe target
Date: Wed, 13 Dec 2017 16:18:06 -0800
Message-ID: <808cd141-3c0a-d0ae-5b9d-efc19ab9f0fb@infradead.org>
References: <20171213213332.2914-1-scott.bauer@intel.com>
 <20171213213332.2914-3-scott.bauer@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171213213332.2914-3-scott.bauer@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Scott Bauer <scott.bauer@intel.com>, dm-devel@redhat.com
Cc: snitzer@redhat.com, agk@redhat.com, linux-kernel@vger.kernel.org, keith.busch@intel.com, jonathan.derrick@intel.com
List-Id: dm-devel.ids

On 12/13/2017 01:33 PM, Scott Bauer wrote:
> Signed-off-by: Scott Bauer <scott.bauer@intel.com>
> ---
>  Documentation/device-mapper/dm-unstripe.txt | 130 ++++++++++++++++++++++++++++
>  1 file changed, 130 insertions(+)
>  create mode 100644 Documentation/device-mapper/dm-unstripe.txt
> 
> diff --git a/Documentation/device-mapper/dm-unstripe.txt b/Documentation/device-mapper/dm-unstripe.txt
> new file mode 100644
> index 000000000000..01d7194b9075
> --- /dev/null
> +++ b/Documentation/device-mapper/dm-unstripe.txt
> @@ -0,0 +1,130 @@
> +Device-Mapper Unstripe
> +=====================
> +

[snip]

> +==============
> +
> +
> +    Another example:
> +
> +    Intel NVMe drives contain two cores on the physical device.
> +    Each core of the drive has segregated access to its LBA range.
> +    The current LBA model has a RAID 0 128k chunk on each core, resulting
> +    in a 256k stripe across the two cores:
> +
> +       Core 0:                Core 1:
> +      __________            __________
> +      | LBA 512|            | LBA 768|
> +      | LBA 0  |            | LBA 256|
> +      ⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻            ⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻

Use ASCII characters ___ or ---,  not whatever those bottom block characters are.

> +
> +    The purpose of this unstriping is to provide better QoS in noisy
> +    neighbor environments. When two partitions are created on the
> +    aggregate drive without this unstriping, reads on one partition
> +    can affect writes on another partition. This is because the partitions
> +    are striped across the two cores. When we unstripe this hardware RAID 0
> +    and make partitions on each new exposed device the two partitions are now
> +    physically separated.
> +
> +    With the module we were able to segregate a fio script that has read and
> +    write jobs that are independent of each other. Compared to when we run
> +    the test on a combined drive with partitions, we were able to get a 92%
> +    reduction in five-9ths read latency using this device mapper target.

	            5/9ths
although I can't quite parse that sentence.


-- 
~Randy
