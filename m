From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 18/22] multipath -u: quick check if path
 is multipathed
Date: Mon, 16 Apr 2018 08:29:31 +0200
Message-ID: <20180416082931.6d33bfbb@pentland.suse.de>
References: <20180413220015.7032-1-mwilck@suse.com>
	<20180413220015.7032-19-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180413220015.7032-19-mwilck@suse.com>
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

On Sat, 14 Apr 2018 00:00:11 +0200
Martin Wilck <mwilck@suse.com> wrote:

> With "find_multipaths smart", we accept paths as valid if they are
> already part of a multipath map. This patch avoids doing a full path
> and device-mapper map scan for this case, speeding up "multipath -u"
> considerably.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/sysfs.c | 66
> ++++++++++++++++++++++++++++++++++++++++++++++++++++
> libmultipath/sysfs.h |  2 ++ multipath/main.c     |  9 +++++++
>  3 files changed, 77 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
