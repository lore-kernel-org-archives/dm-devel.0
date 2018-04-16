From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 19/22] multipath -u: don't grab devices
 already passed to system
Date: Mon, 16 Apr 2018 08:30:45 +0200
Message-ID: <20180416083045.329d250e@pentland.suse.de>
References: <20180413220015.7032-1-mwilck@suse.com>
	<20180413220015.7032-20-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180413220015.7032-20-mwilck@suse.com>
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

On Sat, 14 Apr 2018 00:00:12 +0200
Martin Wilck <mwilck@suse.com> wrote:

> Setting SYSTEMD_READY=0 on a device that has previously been passed to
> systemd is dangerous - already mounted file systems might be
> unmounted by systemd.
> 
> Avoid that by checking for previously set DM_MULTIPATH_DEVICE_PATH
> environment variable.
> 
> This requires to change the exit status of multipath -u - it needs to
> exit with status 0 even if the path is not a multipath device path,
> otherwise udev doesn't import the printed key-value pairs. We do this
> only for "multipath -u"; legacy "multipath -c", which is more likely
> to be run in user scripts, still exits with 1 for non-multipath
> devices.
> 
> The condition ENV{DM_MULTIPATH_DEVICE_PATH}!="1" before the
> "multipath -u" statement in multipath.rules needs to be removed. This
> condition was pointless anyway, because until this patch,
> DM_MULTIPATH_DEVICE_PATH hadn't been imported from the db and thus
> was never set, and "multipath -u" was always invoked. We want to keep
> this behavior.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipath/main.c          | 46
> +++++++++++++++++++++++++++++++++++++++++++++-
> multipath/multipath.rules |  5 ++++- 2 files changed, 49
> insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
