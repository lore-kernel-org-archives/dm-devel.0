From: Martin Wilck <mwilck@suse.de>
Subject: Re: [PATCH] multipath: call store_pathinfo with
	DI_BLACKLIST
Date: Tue, 04 Jun 2019 10:28:40 +0200
Message-ID: <08ca2be01374765276f4c41b0cdc4f4fed121c01.camel@suse.de>
References: <1559590156-26394-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1559590156-26394-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Hannes Reinecke <hare@suse.com>
List-Id: dm-devel.ids

On Mon, 2019-06-03 at 14:29 -0500, Benjamin Marzinski wrote:
> Commit ca19f865f moved adding DI_BLACKLIST to the pathinfo flags out
> of
> store_pathinfo(), but it didn't add it to all of the necessary
> callers.
> Without this, store_pathinfo() callers can do unnecessary extra work,
> including running the path checker on blacklisted devices. Also,
> running
> 
> multipathd add path <blacklisted_path_device>
> 
> will add a blacklisted path.
> 
> Fixes: ca19f865f "libmultipath: add 'cmd' as argument for
> get_refwwid()"
> Cc: Hannes Reinecke <hare@suse.com>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/discovery.c  | 3 ++-
>  multipathd/cli_handlers.c | 2 +-
>  2 files changed, 3 insertions(+), 2 deletions(-)

Reviewed-by: Martin Wilck <mwilck@suse.com>
