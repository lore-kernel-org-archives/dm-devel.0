From: Martin Wilck <mwilck@suse.de>
Subject: Re: [PATCH 0/4] Marginal Path Fixes and cleanups
Date: Fri, 01 Feb 2019 15:47:30 +0100
Message-ID: <58c0a545f1eac527579b45ca2891b451e3fc7a78.camel@suse.de>
References: <1548886387-23381-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1548886387-23381-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, device-mapper development <dm-devel@redhat.com>
Cc: Muneendra <muneendra.kumar@broadcom.com>, Guan Junxiong <guanjunxiong@huawei.com>
List-Id: dm-devel.ids

On Wed, 2019-01-30 at 16:13 -0600, Benjamin Marzinski wrote:
> I've been playing around with the marginal path code, and I've run
> into
> a couple of things that could be cleaned up. The one important issue
> is
> that the marginal paths code tries to enqueue the path for IO error
> checking when it is down.  To enqueue the path, it needs to open the
> device, which can fail because the path is down.  Instead, it should
> wait for the path to come back up before it queues it, and starts the
> IO
> error checking. This is fixed in patch 0003. The other patches are
> mostly cleanups. The issues they fix aren't actually breaking
> things. 
> 
> Benjamin Marzinski (4):
>   libmultipath: handle existing paths in marginal_path enqueue
>   multipathd: cleanup marginal paths checking timers
>   libmultipath: fix marginal paths queueing errors
>   libmultipath: fix marginal_paths nr_active check
> 
>  libmultipath/io_err_stat.c | 71 +++++++++++++++---------------------
> --
>  libmultipath/io_err_stat.h |  2 +-
>  multipathd/main.c          |  3 +-
>  3 files changed, 31 insertions(+), 45 deletions(-)
> 

For the set:

Reviewed-by: Martin Wilck <mwilck@suse.com
