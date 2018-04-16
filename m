From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 09/22] libmultipath: functions to indicate
 mapping failure in /dev/shm
Date: Mon, 16 Apr 2018 08:12:54 +0200
Message-ID: <20180416081254.668ffa38@pentland.suse.de>
References: <20180413220015.7032-1-mwilck@suse.com>
	<20180413220015.7032-10-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180413220015.7032-10-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Sat, 14 Apr 2018 00:00:02 +0200
Martin Wilck <mwilck@suse.com> wrote:

> Create a simple API that indicates failure to create a map for a
> certain WWID. This will allow multipathd to indicate to other tools
> (in particular, "multipath -u" during udev processing) that
> an attempt to create a map for a certain wwid failed.
> 
> The indicator is simply the existence of a file under
> /dev/shm/multipath/failed_wwids. This has been chosen because it
> "survives" during pivot-root between initrd and root file system.
> 
> The exact semantics of /dev/shm/multipath/failed_wwids/$WWID is:
> "multipath or multipathd has tried to create this map from its
> members with a DM_DEVICE_CREATE call, and failed on the latest,
> or only, attempt to do so".
> 
> In particular, the existence of the file proves that here was at
> least one unsuccessful attempt to create the map since the last
> reboot. On the contrary, the non-existence of this file does not
> indicate a successful attempt - perhaps multipathd never tried to
> set up the map.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/defaults.h |   1 +
>  libmultipath/wwids.c    | 110
> ++++++++++++++++++++++++++++++++++++++++++++++++
> libmultipath/wwids.h    |  11 +++++ 3 files changed, 122 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
