From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH v2 00/14] multipath marginal pathgroups
Date: Fri, 30 Aug 2019 07:09:23 +0000
Message-ID: <b98ce7d0112b3b81f1c8ef52bee68f84760de9c1.camel@suse.com>
References: <1566582538-5979-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1566582538-5979-1-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <84EB5DE655A9F640B75EA7BB61EED43B@namprd18.prod.outlook.com>
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "mkumar@redhat.com" <mkumar@redhat.com>
List-Id: dm-devel.ids

On Fri, 2019-08-23 at 12:48 -0500, Benjamin Marzinski wrote:
> The first patch in this series is simply a resend of my previous
> patch
> to fix vector_foreach_slot_backwards(). The rest of the patches are
> related to adding support for an alternative way to deal with
> marginal
> paths. Instead of delaying their reinstatement, which can cause
> problems
> if multipath isn't set to queue IO when there are no usable paths,
> this
> patchset adds a marginal_pathgroups option. If this is set, marginal
> paths will be reinstated, but added to seperate marginal pathgroups.
> They will remain there until the time when they would normally be
> reinstated, at which point they will be returned to their regular
> pathgroups. Marginal pathgroups will have a priority lower than all
> regular pathgroups. This has the advantage of continuing to track
> marginal paths, even if all the other paths go down temporarily, so
> that
> multipath can switch back to the normal paths as soon as they come
> back
> up.  This code also allows users to manually move paths between
> marginal
> and regular pathgroups. This is especially important for Broadcom's
> Fiber Channel Transport Daemon, since it doesn't use the multipathd
> marginal path detectors, and thus will not automatically reinstate
> marginal paths when all other paths have failed.
> 
> https://www.mail-archive.com/dm-devel@redhat.com/msg12956.html
> 
> Changes in v2:
> - patch 04/14 is a combination of the old 04/16, 06/16, and 07/16
>   patches, based on Martin's suggestion. Since all the code is the
> same
>   as the previous patches, I have kept Martin's Reviewed-by
> 
> - old patch 09/16 has been moved up to 05/14 based on Martin's
>   suggestion. There are no code changes
> 
> - patch 09/14 (old patch 11/16) moves path_group_prio_update()
>   earlier in select_path_group() to make sure the pgp->marginal check
>   uses a current value.
> 
> - patch 12/14 (old patch 14/16) changes how delay_checks is selected,
>   to ignore the delay_checks values if any san_path_err options are
>   set, based on Martin's suggestions. It also changes the man page
>   wording.
> 
> Benjamin Marzinski (14):
>   libmultipath: make vector_foreach_slot_backwards work as expected
>   libmultipath: add marginal paths and groups infrastructure
>   tests: add path grouping policy unit tests.
>   libmultipath: add wrapper function around pgpolicyfn
>   tests: update pgpolicy tests to work with group_paths()
>   libmultipath: fix double free in pgpolicyfn error paths
>   libmultipath: consolidate group_by_* functions
>   libmultipath: make pgpolicyfn take a paths vector
>   libmultipath: make group_paths handle marginal paths
>   tests: add tests for grouping marginal paths.
>   libmultipath: add marginal_pathgroups config option
>   libmutipath: deprecate delay_*_checks
>   multipathd: use marginal_pathgroups
>   multipath: update man pages
> 
>  libmultipath/config.h      |    1 +
>  libmultipath/configure.c   |   23 +-
>  libmultipath/dict.c        |    3 +
>  libmultipath/pgpolicies.c  |  346 +++++-------
>  libmultipath/pgpolicies.h  |   12 +-
>  libmultipath/print.c       |   18 +
>  libmultipath/print.h       |    6 +-
>  libmultipath/propsel.c     |   89 +++-
>  libmultipath/propsel.h     |    3 +-
>  libmultipath/structs.c     |   16 +-
>  libmultipath/structs.h     |   15 +-
>  libmultipath/switchgroup.c |   15 +-
>  libmultipath/vector.h      |    2 +-
>  multipath/multipath.conf.5 |   74 ++-
>  multipathd/cli.c           |    5 +
>  multipathd/cli.h           |    4 +
>  multipathd/cli_handlers.c  |   91 ++++
>  multipathd/cli_handlers.h  |    3 +
>  multipathd/main.c          |   90 ++--
>  multipathd/multipathd.8    |   19 +
>  tests/Makefile             |    2 +-
>  tests/pgpolicy.c           | 1036
> ++++++++++++++++++++++++++++++++++++
>  22 files changed, 1523 insertions(+), 350 deletions(-)
>  create mode 100644 tests/pgpolicy.c
> 


For the entire set:

Reviewed-by: Martin Wilck <mwilck@suse.com>
