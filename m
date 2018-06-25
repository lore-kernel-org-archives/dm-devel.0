From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v3 00/10] libmpathpersist fixes and some more
Date: Mon, 25 Jun 2018 17:32:15 -0500
Message-ID: <20180625223215.GR3103@octiron.msp.redhat.com>
References: <20180624190944.27158-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180624190944.27158-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Bart Van Assche <Bart.VanAssche@sandisk.com>
List-Id: dm-devel.ids

On Sun, Jun 24, 2018 at 09:09:34PM +0200, Martin Wilck wrote:
> Hi Christophe,
> 
> this is v3 of my small set of libmpathpersist fixes. It's based
> on your latest push. Sorry again for missing that.
> 
> Changes wrt v2:
>  - rebased to latest upstream (39ad8dc8)
>  - added another gcc 8.1 fix, and another small patch I hadn't
>    submitted yet
> 
> Changes wrt v1:
>  - introduce and use get_unaligned_be64 (Bart van Assche)
>  - add test for (get|put)_unaligned_bexx functions
> 
> Note: we have both the "unaligned" and the "beXY_to_cpu" APIs
> now, for essentially the same purpose. I wonder if we should
> settle on a single API instead. I am unsure if beXY_to_cpu() has
> alignment issues on some architectures (I don't think there are
> issues on our current main target platforms). If yes, I believe that
> we'd be on the safe side using the "unaligned" API.
> Anyway, that could be done in a follow-up patch.
> 
> Thanks,
> Martin

ACK for the set.

-Ben

> 
> Martin Wilck (10):
>   libmpathpersist: remove duplicate test in readfullstatus
>   libmpathpersist: fix typo in mpath_format_readfullstatus
>   libmpathpersist: fix stack overflow in mpath_format_readfullstatus()
>   libmultipath: add (get|put)_unaligned_be64
>   multipath-tools/tests: add tests for get_unaligned_beXX
>   libmpathpersist: fix byte swapping for big endian systems
>   (lib)mpathpersist: use O_RDONLY file descriptors
>   libmultipath: fix gcc 8.1 "truncated output" warnings
>   multipathd: fix buffer size in cli_getprkey()
>   libmultipath: avoid error messages from RDAC check
> 
>  libmpathpersist/mpath_persist.c  |  8 +--
>  libmpathpersist/mpath_pr_ioctl.c | 75 +++++++++----------------
>  libmultipath/propsel.c           |  2 +
>  libmultipath/sysfs.c             |  4 +-
>  libmultipath/unaligned.h         | 16 ++++++
>  libmultipath/util.c              |  4 +-
>  mpathpersist/main.c              |  2 +-
>  multipathd/cli_handlers.c        |  4 +-
>  tests/Makefile                   |  2 +-
>  tests/unaligned.c                | 96 ++++++++++++++++++++++++++++++++
>  10 files changed, 150 insertions(+), 63 deletions(-)
>  create mode 100644 tests/unaligned.c
> 
> -- 
> 2.17.1
