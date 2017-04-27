From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 10/13] dm: Introduce enum dm_queue_mode
Date: Thu, 27 Apr 2017 07:51:28 +0200
Message-ID: <4ec75dd3-71c6-2280-bc46-0198e8b58b30@suse.de>
References: <20170426183728.10821-1-bart.vanassche@sandisk.com>
	<20170426183728.10821-11-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170426183728.10821-11-bart.vanassche@sandisk.com>
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
> Introduce an enumeration type for the queue mode. This patch does
> not change any functionality but makes the dm code easier to read.
> =

> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/md/dm-core.h          |  2 +-
>  drivers/md/dm-ioctl.c         |  2 +-
>  drivers/md/dm-mpath.c         |  5 ++++-
>  drivers/md/dm-table.c         | 14 +++++++-------
>  drivers/md/dm.c               | 14 +++++++++-----
>  drivers/md/dm.h               | 12 +++++++-----
>  include/linux/device-mapper.h | 14 ++++++++------
>  7 files changed, 37 insertions(+), 26 deletions(-)
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
