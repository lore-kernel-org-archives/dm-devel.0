From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 10/15] libmultipath: change how the checker
	async is set
Date: Fri, 17 Jan 2020 17:02:27 +0000
Message-ID: <6f1d40b5dcaba49653c3221304248b13fccafd0d.camel@suse.com>
References: <1579227500-17196-1-git-send-email-bmarzins@redhat.com>
	<1579227500-17196-11-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1579227500-17196-11-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <58455056AC826649A7D2B75E2A775A68@namprd18.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, 2020-01-16 at 20:18 -0600, Benjamin Marzinski wrote:
> The way that the checkers async mode worked in multipathd didn't make
> much sense. When multipathd starts up, all checker classes are in the
> sync mode, and any pathinfo() calls on devices would run the checker
> in
> sync mode. However, the First time a checker class was used in
> checkerloop, it would set that checker class to async (assuming
> force_sync wasn't set).  After that, no matter when a checker from
> that
> class was called, it would always run in async mode.  Multipathd
> doesn't
> need to run checkers in sync mode at all, so don't.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmpathpersist/mpath_persist.c |  2 +-
>  libmultipath/discovery.c        | 10 ++++------
>  multipath/main.c                |  1 +
>  3 files changed, 6 insertions(+), 7 deletions(-)
> 

Reviewed-by: Martin Wilck <mwilck@suse.com>
