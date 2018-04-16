From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 06/22] libmultipath: trigger path uevent
 only when necessary
Date: Mon, 16 Apr 2018 08:10:37 +0200
Message-ID: <20180416081037.27cf367f@pentland.suse.de>
References: <20180413220015.7032-1-mwilck@suse.com>
	<20180413220015.7032-7-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180413220015.7032-7-mwilck@suse.com>
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

On Fri, 13 Apr 2018 23:59:59 +0200
Martin Wilck <mwilck@suse.com> wrote:

> Paths that are already classified as DM_MULTIPATH_DEVICE_PATH don't
> need to be retriggered.
> 
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/configure.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
