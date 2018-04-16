From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 17/22] multipath -u: cleanup logic
Date: Mon, 16 Apr 2018 08:26:01 +0200
Message-ID: <20180416082601.1bc5b04a@pentland.suse.de>
References: <20180413220015.7032-1-mwilck@suse.com>
	<20180413220015.7032-18-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180413220015.7032-18-mwilck@suse.com>
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

On Sat, 14 Apr 2018 00:00:10 +0200
Martin Wilck <mwilck@suse.com> wrote:

> The CMD_VALID_PATH logic is complex and hard to read and understand.
> This patch cleans it up a bit (preparing for folluw-up patches).
> It doesn't change any logic.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipath/main.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
