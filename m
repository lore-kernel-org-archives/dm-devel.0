From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 21/22] libmultipath: enable
	find_multipaths "smart"
Date: Mon, 16 Apr 2018 08:40:15 +0200
Message-ID: <20180416084015.5ffdcf09@pentland.suse.de>
References: <20180413220015.7032-1-mwilck@suse.com>
	<20180413220015.7032-22-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180413220015.7032-22-mwilck@suse.com>
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

On Sat, 14 Apr 2018 00:00:14 +0200
Martin Wilck <mwilck@suse.com> wrote:

> This activates "smart" path detection. This is similar to
> "find_multipaths yes", but doesn't generally ignore single paths
> that are not listed in the WWIDs file. Rather, such paths are
> temporarily treated like multipath members. If no additional paths
> are detected after a certain time, the paths are re-added to the
> system as non-multipath. This needs support by the udev rules, to
> be added in a follow-up patch.
> 
> If a multipath map is successfully successfully created, and paths are
> in waiting state, trigger path uevents to update their status.
> 
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/configure.c   | 15 ++++++++++++---
>  libmultipath/dict.c        |  1 +
>  multipath/multipath.conf.5 | 13 +++++++++++++
>  3 files changed, 26 insertions(+), 3 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
