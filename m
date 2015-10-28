From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH 2/2] dm-raid: Fix minimal_devs for raid6
Date: Wed, 28 Oct 2015 20:17:22 +0100
Message-ID: <56311F42.9060905@redhat.com>
References: <1446058201-12628-1-git-send-email-agrover@redhat.com>
	<1446058201-12628-2-git-send-email-agrover@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1446058201-12628-2-git-send-email-agrover@redhat.com>
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


NACK

4 devs is actually the mandatory minimum for raid6;
minimum of 2 data stripes plus 2 devices for parity and q-syndrome.

FWIW: the 2 devices minimum for the raid4/5 layouts are correct too,
            because those personalities are able to drive 2 devices as raid1
            (i.e. allow for takeover from raid1 with 2 legs)
            in order to reshape them to 'real' raid4/5 by adding N>0 devices

Heinz

On 10/28/2015 07:50 PM, Andy Grover wrote:
> A raid6 device can be created from 3 devs. This previously didn't cause
> an error because minimal_devs was not being checked.
>
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>   drivers/md/dm-raid.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index 5941cfd..1ded052 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -90,9 +90,9 @@ static struct raid_type {
>   	{"raid5_ra", "RAID5 (right asymmetric)",	1, 2, 5, ALGORITHM_RIGHT_ASYMMETRIC},
>   	{"raid5_ls", "RAID5 (left symmetric)",		1, 2, 5, ALGORITHM_LEFT_SYMMETRIC},
>   	{"raid5_rs", "RAID5 (right symmetric)",		1, 2, 5, ALGORITHM_RIGHT_SYMMETRIC},
> -	{"raid6_zr", "RAID6 (zero restart)",		2, 4, 6, ALGORITHM_ROTATING_ZERO_RESTART},
> -	{"raid6_nr", "RAID6 (N restart)",		2, 4, 6, ALGORITHM_ROTATING_N_RESTART},
> -	{"raid6_nc", "RAID6 (N continue)",		2, 4, 6, ALGORITHM_ROTATING_N_CONTINUE}
> +	{"raid6_zr", "RAID6 (zero restart)",		2, 3, 6, ALGORITHM_ROTATING_ZERO_RESTART},
> +	{"raid6_nr", "RAID6 (N restart)",		2, 3, 6, ALGORITHM_ROTATING_N_RESTART},
> +	{"raid6_nc", "RAID6 (N continue)",		2, 3, 6, ALGORITHM_ROTATING_N_CONTINUE}
>   };
>   
>   static char *raid10_md_layout_to_format(int layout)
