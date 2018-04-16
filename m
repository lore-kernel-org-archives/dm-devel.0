From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 16/22] multipath -u : set
 FIND_MULTIPATHS_WAIT_UNTIL from /dev/shm
Date: Mon, 16 Apr 2018 08:25:30 +0200
Message-ID: <20180416082530.1c058593@pentland.suse.de>
References: <20180413220015.7032-1-mwilck@suse.com>
	<20180413220015.7032-17-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180413220015.7032-17-mwilck@suse.com>
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

On Sat, 14 Apr 2018 00:00:09 +0200
Martin Wilck <mwilck@suse.com> wrote:

> In "find_multipaths smart" mode, use time stamps under
> /dev/shm/multipath/find_multipaths to track waiting for multipath
> siblings. When a path is first encountered and is "maybe" multipath,
> create a file under /dev/shm, set its modification time to the expiry
> time of the timer, and set the FIND_MULTIPATHS_WAIT_UNTIL variable.
> On later calls, also set FIND_MULTIPATHS_WAIT_UNTIL to the expiry
> time (but don't change the time stamp) if it's not expired yet, or 0
> if it is expired. Set FIND_MULTIPATHS_WAIT_UNTIL even if enough
> evidence becomes available to decide if the path needs to be
> multipathed - this enables the udev rules to detect that this is a
> device a timer has been started for, and stop it. By using /dev/shm,
> we share information about "smart" timers between initrd and root
> file system, and thus only calculate the timeout once.
> 
> Because we use major:minor to identify the devices in /dev/shm, and
> because a removed device might be replaced by a different one with
> the same major/minor number, add a rule to multipath.rules to remove
> the find_multipaths marker on remove uevents.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/file.c       |   2 +-
>  libmultipath/file.h       |   1 +
>  multipath/main.c          | 132
> ++++++++++++++++++++++++++++++++++++++++++++++
> multipath/multipath.rules |   4 +- 4 files changed, 137
> insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
