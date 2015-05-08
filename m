From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH v2 4/4] dm-raid: remove bogus
	parse_raid_params() comment about devices_handle_discards_safely
Date: Fri, 8 May 2015 11:06:13 -0500
Message-ID: <2CF74109-EBD9-438E-93CA-ACB86DA47A41@redhat.com>
References: <1430308987-24703-5-git-send-email-heinzm@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1430308987-24703-5-git-send-email-heinzm@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids


> On Apr 29, 2015, at 7:03 AM, heinzm@redhat.com wrote:
> 
> From: Heinz Mauelshagen <heinzm@redhat.com>
> 
> This patch removes a bogus comment on parse_raid_params() claiming
> "devices_handle_discard_safely" being a table line argument when
> it actually is a module parameter.
> 
> Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
> 
> ---
> drivers/md/dm-raid.c | 2 --
> 1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index c541d5a..97e1651 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -479,8 +479,6 @@ too_many:
>  *                                      will form the "stripe"
>  *    [[no]sync]			Force or prevent recovery of the
>  *                                      entire array
> - *    [devices_handle_discard_safely]	Allow discards on RAID4/5/6; useful if RAID
> - *					member device(s) properly support TRIM/UNMAP
>  *    [rebuild <idx>]			Rebuild the drive indicated by the index
>  *    [daemon_sleep <ms>]		Time between bitmap daemon work to
>  *                                      clear bits
> -- 
> 2.1.0

Reviewed-by: Jonathan Brassow <jbrassow@redhat.com>

 brassow
