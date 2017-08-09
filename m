From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/7] Device mapper and dm-mpath fixes
Date: Wed, 9 Aug 2017 17:49:41 -0400
Message-ID: <20170809214941.GA29092@redhat.com>
References: <20170809183216.526-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170809183216.526-1-bart.vanassche@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On Wed, Aug 09 2017 at  2:32pm -0400,
Bart Van Assche <bart.vanassche@wdc.com> wrote:

> Hello Mike,
> 
> The patches in this series are what I came up with while analyzing the
> soft and hard lockups reported by Laurence Oberman. Please consider
> these patches for kernel v4.14.
> 
> Thank you,
> 
> Bart.
> 
> Bart Van Assche (7):
>   dm: Fix the second dec_pending() argument in __split_and_process_bio()
>   dm: Fix printk() rate limiting code
>   dm-mpath: Do not lock up a CPU with requeuing activity
>   dm-mpath: Avoid that building with W=1 causes gcc 7 to complain about
>     fall-through
>   dm-mpath: Complain about unsupported __multipath_map_bio() return
>     values
>   dm-mpath: Retry BLK_STS_RESOURCE errors
>   dm-mpath: Make the dm-sq requeuing behavior consistent with the dm-mq
>     behavior
> 
>  drivers/md/dm-mpath.c         |  8 ++++++--
>  drivers/md/dm-rq.c            |  9 +++++----
>  drivers/md/dm.c               | 12 +-----------
>  include/linux/device-mapper.h | 41 ++++++++++++-----------------------------
>  4 files changed, 24 insertions(+), 46 deletions(-)

Hey Bart,

Thanks for the patches.  I'm currently on a leave of absence to recover
from a nasty fall I had (broke my sacrum and dislocated my left thumb at
the wrist)... so: I won't be getting to these patches for a couple
weeks.

Mike
