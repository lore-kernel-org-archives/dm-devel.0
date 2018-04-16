From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 10/22] libmultipath: indicate wwid failure
 in dm_addmap_create()
Date: Mon, 16 Apr 2018 08:13:33 +0200
Message-ID: <20180416081333.45696553@pentland.suse.de>
References: <20180413220015.7032-1-mwilck@suse.com>
	<20180413220015.7032-11-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180413220015.7032-11-mwilck@suse.com>
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

On Sat, 14 Apr 2018 00:00:03 +0200
Martin Wilck <mwilck@suse.com> wrote:

> dm_addmap_create() is where we actually try to set up a new
> multipath map. Depending on the result, mark the wwid as
> failed (or not), and re-trigger an uevent if necessary.
> If a path changes from multipath to non-multipath, use an "add"
> event to make sure LVM2 rules pick it up. Increase log level
> of this event to 3.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/configure.c | 35 +++++++++++++++++++++++++++--------
>  libmultipath/configure.h |  2 +-
>  libmultipath/devmapper.c |  9 ++++++++-
>  libmultipath/structs.h   |  1 +
>  multipathd/main.c        |  2 +-
>  5 files changed, 38 insertions(+), 11 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
