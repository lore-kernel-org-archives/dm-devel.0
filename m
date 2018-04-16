From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 13/22] multipath -u: treat failed wwids as
	invalid
Date: Mon, 16 Apr 2018 08:21:56 +0200
Message-ID: <20180416082156.308bdcc2@pentland.suse.de>
References: <20180413220015.7032-1-mwilck@suse.com>
	<20180413220015.7032-14-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180413220015.7032-14-mwilck@suse.com>
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

On Sat, 14 Apr 2018 00:00:06 +0200
Martin Wilck <mwilck@suse.com> wrote:

> If a WWID has been marked as "failed", don't treat it as "valid
> multipath device path" in multipath -c/-u. This is key to achieve
> consistency between multipathd and udev rule processing.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipath/main.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
