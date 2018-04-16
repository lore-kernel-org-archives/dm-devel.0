From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 03/22] libmultipath: should_multipath:
 keep existing maps
Date: Mon, 16 Apr 2018 08:08:55 +0200
Message-ID: <20180416080855.17b90c5d@pentland.suse.de>
References: <20180413220015.7032-1-mwilck@suse.com>
	<20180413220015.7032-4-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180413220015.7032-4-mwilck@suse.com>
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

On Fri, 13 Apr 2018 23:59:56 +0200
Martin Wilck <mwilck@suse.com> wrote:

> with find_multipaths "yes" and without the "-n" option to multipathd,
> if a path is already multipathed, keep it. The same logic is applied
> by "multipath -u -i".
> 
> To do this, we need to add a "mpvec" parameter to should_multipath().
> 
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/configure.c |  2 +-
>  libmultipath/wwids.c     | 12 +++++++++++-
>  libmultipath/wwids.h     |  2 +-
>  multipathd/main.c        |  2 +-
>  4 files changed, 14 insertions(+), 4 deletions(-)
> 

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
