From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 07/22] libmultipath: change
 find_multipaths option to multi-value
Date: Mon, 16 Apr 2018 08:11:28 +0200
Message-ID: <20180416081128.75dec05d@pentland.suse.de>
References: <20180413220015.7032-1-mwilck@suse.com>
	<20180413220015.7032-8-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180413220015.7032-8-mwilck@suse.com>
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

On Sat, 14 Apr 2018 00:00:00 +0200
Martin Wilck <mwilck@suse.com> wrote:

> Change the "find_multipaths" option from yes/no to multi-value. This
> option now covers the effects of "find_multipaths" as it used to be,
> plus the -i option to multipath (ignore_wwids) and the -n option to
> multipathd (ignore_new_devs), excluding such combinations of the
> former options that are dangerous or inconsistent.
> 
> The possible values for "find_multipaths" are now:
> 
>  - strict: strictly stick to the WWIDs file; never add new maps
> automatically (new default; upstream behaviour with with
> find_multipaths "yes" and commit 64e27ec "multipathd: imply -n if
> find_multipaths is set")
>  - off|no: multipath like "strict", multipathd like "greedy" (previous
>    upstream default)
>  - on|yes: set up multipath if >1 paths are seen (current Red
> Hat/Ubuntu behavior with find_multipaths "yes")
>  - greedy: set up multipath for all non-blacklisted devices (current
> SUSE default)
>  - smart: Like "yes", but try to avoid inconsistencies between udev
> processing and multipathd processing by waiting for path siblings to
>    appear (fully implemented in follow-up patches)
> 
> The default has been changed to "strict", because "no" may cause
> inconsistent behavior between "multipath -u" and multipathd. This is
> deliberately a conservative choice.
> 
> The patch also updates the related man pages.
> 
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/config.h      |  2 --
>  libmultipath/defaults.h    |  2 +-
>  libmultipath/dict.c        | 47
> ++++++++++++++++++++++++++++++++++++++++++++--
> libmultipath/structs.h     | 26 +++++++++++++++++++++++++
> libmultipath/wwids.c       |  4 ++-- multipath/main.c           |  9
> +++++---- multipath/multipath.8      |  9 ++++++++-
>  multipath/multipath.conf.5 | 46
> +++++++++++++++++++++++++--------------------
> multipathd/main.c          |  6 +----- multipathd/multipathd.8    |
> 8 +++++--- 10 files changed, 119 insertions(+), 40 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
