From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 12/21] libmultipath/checkers: support
	unsupported paths
Date: Thu, 25 Oct 2018 16:33:15 -0500
Message-ID: <20181025213315.GU7100@octiron.msp.redhat.com>
References: <20181011222707.3631-1-mwilck@suse.com>
	<20181011222707.3631-13-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181011222707.3631-13-mwilck@suse.com>
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

On Fri, Oct 12, 2018 at 12:26:58AM +0200, Martin Wilck wrote:
> We should be able to distinguish the case where a checker
> determines a path to be positively down from the case where
> the checker fails to obtain necessary information, e.g.
> because of a configuration problem (wrong checker).
> Use PATH_WILD for the latter case, as it's hardly used now.
> 
> Provide a generic message for the situation that a path
> checker can't handle a certain path.
> 

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/checkers.c | 1 +
>  libmultipath/checkers.h | 7 +++++--
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
> index 359791ff..19c8ad58 100644
> --- a/libmultipath/checkers.c
> +++ b/libmultipath/checkers.c
> @@ -279,6 +279,7 @@ static const char *generic_msg[CHECKER_LAST_GENERIC_MSGID] = {
>  	[CHECKER_MSGID_UP] = " reports path is up",
>  	[CHECKER_MSGID_DOWN] = " reports path is down",
>  	[CHECKER_MSGID_GHOST] = " reports path is ghost",
> +	[CHECKER_MSGID_UNSUPPORTED] = " doesn't support this device",
>  };
>  
>  static const char *_checker_message(const struct checker *c)
> diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
> index b48f4dc2..98fec2c4 100644
> --- a/libmultipath/checkers.h
> +++ b/libmultipath/checkers.h
> @@ -10,8 +10,10 @@
>   * Userspace (multipath/multipathd) path states
>   *
>   * PATH_WILD:
> - * - Use: None of the checkers (returned if we don't have an fd)
> - * - Description: Corner case where "fd < 0" for path fd (see checker_check())
> + * - Use: Any checker
> + * - Description: Corner case where "fd < 0" for path fd (see checker_check()),
> + *   or where a checker detects an unsupported device
> + *   (e.g. wrong checker configured for a given device).
>   *
>   * PATH_UNCHECKED:
>   * - Use: Only in directio checker
> @@ -108,6 +110,7 @@ enum {
>  	CHECKER_MSGID_UP,
>  	CHECKER_MSGID_DOWN,
>  	CHECKER_MSGID_GHOST,
> +	CHECKER_MSGID_UNSUPPORTED,
>  	CHECKER_LAST_GENERIC_MSGID,
>  	CHECKER_FIRST_MSGID = 100,	/* lowest msgid for checkers */
>  	CHECKER_MSGTABLE_SIZE = 100,	/* max msg table size for checkers */
> -- 
> 2.19.0
