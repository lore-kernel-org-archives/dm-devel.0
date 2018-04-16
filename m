From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 15/22] libmultipath: implement
 find_multipaths_timeout
Date: Mon, 16 Apr 2018 08:23:32 +0200
Message-ID: <20180416082332.16851559@pentland.suse.de>
References: <20180413220015.7032-1-mwilck@suse.com>
	<20180413220015.7032-16-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180413220015.7032-16-mwilck@suse.com>
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

On Sat, 14 Apr 2018 00:00:08 +0200
Martin Wilck <mwilck@suse.com> wrote:

> This makes the timeout for "find_multipaths smart" configurable.
> If the timeout has a negative value (default), it's applied only
> to "known" hardware which is either in the hwtable or in a "device"
> section in multipath.conf. For typical non-multipath hardware, which
> is not in the hwtable, a short timeout of 1s is used, so that boot
> delays caused by pointlessly waiting e.g. for SATA devices will be
> minimal.
> 
> It's expected that a "reasonable" timeout value depends less on the
> storage hardware itself but on other properties of the data center
> such as network latencies or distances. find_multipaths_timeout is
> therefore just a "defaults" section setting.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/config.h      |  1 +
>  libmultipath/defaults.h    |  2 ++
>  libmultipath/dict.c        |  7 +++++++
>  libmultipath/propsel.c     | 25 +++++++++++++++++++++++++
>  libmultipath/propsel.h     |  1 +
>  libmultipath/structs.h     |  1 +
>  multipath/multipath.conf.5 | 18 ++++++++++++++++++
>  7 files changed, 55 insertions(+)
> 

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
