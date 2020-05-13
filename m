From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 0/2] dm-zoned: improve cache performance
Date: Wed, 13 May 2020 09:44:10 +0000
Message-ID: <BY5PR04MB6900A74251B571E454252F66E7BF0@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200513070729.71461-1-hare@suse.de>
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
To: Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 2020/05/13 16:07, Hannes Reinecke wrote:
> Hi all,
> 
> here are two patches to improve performance when a regular device
> is specified for dm-zoned.
> Damien noted that we have a performance drop after the zones on the
> regular device are used up, as then the random zones on the zoned
> device are being used, _and_ reclaim is running on the same disk.
> This slows down I/O whle using random zones, increasing again after
> the random zones are used up.
> This patchset fixes this by not allowing random zones for caching
> if a regular device is present.

Awesome ! I will run this overnight to see how it compares with the previous
results I sent.

And I need to send something to fix the setup warning I am seeing, but that is a
block or scsi patch I think. Had no time to dig.

> 
> Patch is relative to the dm-5.8 branch from
> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git
> 
> As usual, comments and reviews are welcome.
> 
> 
> Hannes Reinecke (2):
>   dm-zoned: invert zone check in dmz_reset_zone()
>   dm-zoned: split off random and cache zones
> 
>  .../admin-guide/device-mapper/dm-zoned.rst    |  17 +-
>  drivers/md/dm-zoned-metadata.c                | 157 +++++++++++++-----
>  drivers/md/dm-zoned-reclaim.c                 |  70 ++++----
>  drivers/md/dm-zoned-target.c                  |  19 ++-
>  drivers/md/dm-zoned.h                         |   7 +-
>  5 files changed, 189 insertions(+), 81 deletions(-)
> 


-- 
Damien Le Moal
Western Digital Research
