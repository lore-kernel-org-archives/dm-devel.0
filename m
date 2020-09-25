From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 00/11] multipath-tools: add linker version
	scripts
Date: Thu, 24 Sep 2020 21:09:55 -0500
Message-ID: <20200925020955.GM11108@octiron.msp.redhat.com>
References: <20200924133644.14034-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200924133644.14034-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: mwilck@suse.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Sep 24, 2020 at 03:36:33PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Hi Christophe, hi Ben,
> 
> Patch 1-5 are small fixes, the first two resent from an earlier
> submission. Patch 6ff. add version scripts for the linker to
> libmultipath, libmpathpersist, and libmpathcmd.
> 
> Is it useful to do this for libmultipath? We have always said that this is
> not a public, stable ABI. However, I still believe it has merits. First of
> all, it's a description of the ABI we use. It turns out that it cuts the
> size of the exported symbol list of libmultipath roughly in half, which is
> better than I'd expected. It leads to ld.so-time failure rather than weird
> crashes in the unlikely case that non-matching binaries are used
> together. It allows packaging scripts to check compatibility of binaries
> and libraries without resorting to version and release. It will help us
> stabilize the ABI, albeit only in the long run. Finally, it's a step
> towards modernizing our code base in general.
> 
> To avoid misunderstanding, my intention is not to provide a stable or even
> backward-compatible ABI in libmultipath.so.0. We're still allowed to make
> changes to globally visible data structures like "struct config", and to
> remove symbols from the ABI, like no serious shared library would do.
> We just need to bump the ABI version when we do so.
> 

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
For this patchset, except for 0002 and 0008

> Regards,
> Martin
> 
> Martin Wilck (11):
>   libmultipath: find_mpe(): don't match with empty WWID
>   libmultipath: copy mpp->hwe from pp->hwe
>   libmultipath: dm_map_present_by_uuid(): fix dm_task_create() call
>   libdmmp tests: fix compilation
>   libmultipath: prio: constify some function parameters
>   libmultipath: checkers/prio: allow non-lazy .so loading
>   multipath-tools Makefiles: separate rules for .so and man pages
>   libmultipath: create separate .so for unit tests
>   libmultipath: add linker version script
>   libmpathpersist: add linker version script
>   libmpathcmd: add linker version script
> 
>  libdmmp/test/libdmmp_speed_test.c       |   2 +-
>  libdmmp/test/libdmmp_test.c             |   2 +-
>  libmpathcmd/Makefile                    |  14 +-
>  libmpathcmd/libmpathcmd.version         |  13 ++
>  libmpathpersist/Makefile                |  16 +-
>  libmpathpersist/libmpathpersist.version |  20 +++
>  libmultipath/Makefile                   |  22 ++-
>  libmultipath/checkers.c                 |  17 ++
>  libmultipath/config.c                   |   2 +-
>  libmultipath/configure.c                |   7 +
>  libmultipath/devmapper.c                |   2 +-
>  libmultipath/libmultipath.version       | 215 ++++++++++++++++++++++++
>  libmultipath/prio.c                     |  26 ++-
>  libmultipath/prio.h                     |   4 +-
>  libmultipath/propsel.c                  |   4 +-
>  libmultipath/structs.c                  |  15 ++
>  libmultipath/structs.h                  |   1 +
>  libmultipath/structs_vec.c              |  54 +++---
>  multipathd/main.c                       |  10 --
>  tests/Makefile                          |  10 +-
>  20 files changed, 384 insertions(+), 72 deletions(-)
>  create mode 100644 libmpathcmd/libmpathcmd.version
>  create mode 100644 libmpathpersist/libmpathpersist.version
>  create mode 100644 libmultipath/libmultipath.version
> 
> -- 
> 2.28.0
