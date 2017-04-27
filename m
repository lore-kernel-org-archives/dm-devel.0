From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 13/13] dm,
 dm-mpath: Make it easier to detect unintended I/O request flushes
Date: Thu, 27 Apr 2017 08:41:04 +0200
Message-ID: <475b4d00-ba38-7406-5e33-b26e21e9f215@suse.de>
References: <20170426183728.10821-1-bart.vanassche@sandisk.com>
	<20170426183728.10821-14-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170426183728.10821-14-bart.vanassche@sandisk.com>
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
> I/O errors triggered by multipathd incorrectly not enabling the
> no-flush flag for DM_DEVICE_SUSPEND or DM_DEVICE_RESUME are hard to
> debug. Add more logging to make it easier to debug this.
> =

> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/md/dm-mpath.c | 25 +++++++++++++++++++++----
>  drivers/md/dm.c       |  3 +++
>  2 files changed, 24 insertions(+), 4 deletions(-)
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
