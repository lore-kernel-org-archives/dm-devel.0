From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 07/13] dm,
 persistence: Remove an unused argument from
 dm_block_manager_create()
Date: Thu, 27 Apr 2017 07:49:46 +0200
Message-ID: <6cd20c78-98a7-0dad-5d29-d77decbafbf7@suse.de>
References: <20170426183728.10821-1-bart.vanassche@sandisk.com>
	<20170426183728.10821-8-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170426183728.10821-8-bart.vanassche@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Hannes Reinecke <hare@suse.com>
List-Id: dm-devel.ids

On 04/26/2017 08:37 PM, Bart Van Assche wrote:
> The 'cache_size' argument of dm_block_manager_create() has never
> been used. Hence remove it and also the definitions of the constants
> passed as 'cache_size' argument.
> =

> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/md/dm-cache-metadata.c                | 3 ---
>  drivers/md/dm-era-target.c                    | 2 --
>  drivers/md/dm-thin-metadata.c                 | 2 --
>  drivers/md/persistent-data/dm-block-manager.c | 1 -
>  drivers/md/persistent-data/dm-block-manager.h | 2 +-
>  5 files changed, 1 insertion(+), 9 deletions(-)
> =

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
