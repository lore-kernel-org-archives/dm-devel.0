From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 08/13] dm: Verify suspend_locking assumptions
 at runtime
Date: Thu, 27 Apr 2017 07:50:21 +0200
Message-ID: <8be60091-8fe6-8f82-4e25-efc8124e7caf@suse.de>
References: <20170426183728.10821-1-bart.vanassche@sandisk.com>
	<20170426183728.10821-9-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170426183728.10821-9-bart.vanassche@sandisk.com>
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
> Ensure that the assumptions about the caller holding suspend_lock
> are checked at runtime if lockdep is enabled.
> =

> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/md/dm-table.c | 4 ++++
>  drivers/md/dm.c       | 9 ++++-----
>  2 files changed, 8 insertions(+), 5 deletions(-)
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
