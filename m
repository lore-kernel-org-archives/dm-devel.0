From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 12/22] multipath -u: change output to
 environment/key format
Date: Mon, 16 Apr 2018 08:14:48 +0200
Message-ID: <20180416081448.18d2d065@pentland.suse.de>
References: <20180413220015.7032-1-mwilck@suse.com>
	<20180413220015.7032-13-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180413220015.7032-13-mwilck@suse.com>
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

On Sat, 14 Apr 2018 00:00:05 +0200
Martin Wilck <mwilck@suse.com> wrote:

> ... instead of free format. This provides more flexibility
> for udev rule processing for the future. Adapt code in
> multipath.rules. The exit status remains as usual. This affects
> "multipath -c", too.
> 
> The parameters "pathvec" and "conf" for print_cmd_valid are currently
> unused, but will be in follow-up patches.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipath/main.c          | 14 ++++++++------
>  multipath/multipath.rules |  6 +++---
>  2 files changed, 11 insertions(+), 9 deletions(-)
> 

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
