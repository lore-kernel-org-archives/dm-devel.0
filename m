From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 0/4] multipathd: decrease log verbosity
Date: Thu, 12 Apr 2018 14:51:05 -0500
Message-ID: <20180412195105.GX3103@octiron.msp.redhat.com>
References: <20180404162200.6518-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180404162200.6518-1-mwilck@suse.com>
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

On Wed, Apr 04, 2018 at 06:21:56PM +0200, Martin Wilck wrote:
> This patch set decreases the log level of some messages that we see often
> time and that aren't usually helpful for debugging.
> 

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

for the set.

> Martin Wilck (4):
>   multipathd: decrease log level of "spurious uevent" message
>   libmultipath: decrease log level of uevent filter/merge messages
>   multipathd: decrease log level of waiter thread start/stop msgs
>   libmpathpersist: decrease log level of various messages
> 
>  libmpathpersist/mpath_persist.c  |  2 +-
>  libmpathpersist/mpath_pr_ioctl.c | 32 ++++++++++++++++----------------
>  libmultipath/uevent.c            |  4 ++--
>  multipathd/main.c                |  2 +-
>  multipathd/waiter.c              |  4 ++--
>  5 files changed, 22 insertions(+), 22 deletions(-)
> 
> -- 
> 2.16.1
