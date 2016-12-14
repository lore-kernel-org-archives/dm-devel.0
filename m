From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v4 0/3] multipathd: skip spurious event
 message for blacklisted paths
Date: Wed, 14 Dec 2016 09:59:29 -0600
Message-ID: <20161214155929.GD19659@octiron.msp.redhat.com>
References: <1481720731-22503-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1481720731-22503-1-git-send-email-mauricfo@linux.vnet.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

ACK for the set.

-Ben

On Wed, Dec 14, 2016 at 11:05:28AM -0200, Mauricio Faria de Oliveira wrote:
> This patch-set prevents this error message on 'change'
> uevents of paths that are blacklisted:
> 
>     sdb: spurious uevent, path not found
> 
> And in that case, replaces it with this _debug_ message
> (so it's not logged by default; only when requested):
> 
>     sdb: spurious uevent, path is blacklisted
> 
> Patch 1/3 fixes a potential leak observed while doing that.
> Patch 2/3 minor refactors two blacklist/filter checks into
>           pathinfo() to clean-up a bit and fix a couple of
>           bugs (reported by Ben and Hannes)
> Patch 3/3 finally does what the patch-set is supposed to.
> 
> Changelog:
>  - v2: switch approach from using path_discover() to using
>        alloc_path_with_pathinfo() (Benjamin Marzinski).
>  - v3: drop calls to udev_device_ref/unref() (Benjamin Marzinski)
>        move filter_property() into pathinfo() (Benjamin Marzinski)
>  - v4: move filter_devnode() into pathinfo() (Hannes Reinecke)
>        ensure equivalency between path_discover() and pathinfo()
>        for multipathd behavior.
> 
> Mauricio Faria de Oliveira (3):
>   libmultipath: prevent memory leak in alloc_path_with_pathinfo() if
>     pp_ptr is NULL
>   libmultipath: move filter_property|devnode() from path_discover() into
>     pathinfo()
>   multipathd: skip spurious event message for blacklisted paths
> 
>  libmultipath/blacklist.c |  4 ++++
>  libmultipath/discovery.c | 23 +++++++++++++++--------
>  multipathd/main.c        | 17 ++++++++++++++++-
>  3 files changed, 35 insertions(+), 9 deletions(-)
> 
> -- 
> 1.8.3.1
