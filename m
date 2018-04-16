From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 05/22] libmultipath: trigger change uevent
 on new device creation
Date: Mon, 16 Apr 2018 08:10:09 +0200
Message-ID: <20180416081009.180464a2@pentland.suse.de>
References: <20180413220015.7032-1-mwilck@suse.com>
	<20180413220015.7032-6-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180413220015.7032-6-mwilck@suse.com>
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

On Fri, 13 Apr 2018 23:59:58 +0200
Martin Wilck <mwilck@suse.com> wrote:

> From: Benjamin Marzinski <bmarzins@redhat.com>
> 
> When multipath first sees a path device with find_multipaths
> enabled, it can't know if the device should be multipathed. This means
> that it will not claim the device in udev.  If the device is
> eventually multipathed, multipath should trigger a change uevent to
> update the udev database to claim the device.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> Reviewed-by: Martin Wilck <mwilck@suse.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/configure.c | 26 ++++++++++++++++++++++++--
>  libmultipath/configure.h |  1 +
>  libmultipath/wwids.c     |  2 +-
>  multipath/main.c         |  2 +-
>  multipathd/main.c        |  3 ++-
>  5 files changed, 29 insertions(+), 5 deletions(-)
> 

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
