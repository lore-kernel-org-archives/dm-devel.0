From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 01/10] libmultipath: add skip_kpartx option
Date: Sun, 30 Oct 2016 14:42:17 +0100
Message-ID: <641af5d1-89bb-532d-4bde-e4e2b30e41c0@suse.de>
References: <1477709726-5442-1-git-send-email-bmarzins@redhat.com>
	<1477709726-5442-2-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1477709726-5442-2-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 10/29/2016 04:55 AM, Benjamin Marzinski wrote:
> This option gives multipath the ability to stop kpartx from running. The
> previous idea, the "no_partitions" feature, was not accepted in the
> upstream kernel. This method uses one of the dm cookie subsystem flags
> DM_SUBSYSTEM_UDEV_FLAG1, which can be checked by udev to skip running
> kpartx when processing the event. This patch does most of the work
> necessary to make this work.  It doesn't change kpartx.rules, however.
>
> Also, if dm_suspend_and_flush_map fails, multipath doesn't know how the
> device is configured. so, it simply checks if the device has any
> partitions before attempting the remove, and if not, sets the
> DM_SUBSYSTEM_UDEV_FLAG1 on the resume after failure, so that no
> partitions will be generated.
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/config.c      |  2 ++
>  libmultipath/config.h      |  3 +++
>  libmultipath/configure.c   |  5 +++--
>  libmultipath/defaults.h    |  1 +
>  libmultipath/devmapper.c   | 45 +++++++++++++++++++++++++++++++---------=
-----
>  libmultipath/devmapper.h   |  8 +++++++-
>  libmultipath/dict.c        | 13 +++++++++++++
>  libmultipath/propsel.c     | 18 ++++++++++++++++++
>  libmultipath/propsel.h     |  1 +
>  libmultipath/structs.h     |  7 +++++++
>  multipath/multipath.conf.5 | 17 +++++++++++++++++
>  multipathd/cli_handlers.c  |  4 +++-
>  12 files changed, 106 insertions(+), 18 deletions(-)
>
Thank you for this.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
