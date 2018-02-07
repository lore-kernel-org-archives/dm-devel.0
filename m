From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 0/7] multipath-tools: uevent processing fixes
 and unit tests
Date: Wed, 7 Feb 2018 12:35:43 -0600
Message-ID: <20180207183543.GN14513@octiron.msp.redhat.com>
References: <20180117074939.7795-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180117074939.7795-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Ritika Srivastava <ritika.srivastava@oracle.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

On Wed, Jan 17, 2018 at 08:49:32AM +0100, Martin Wilck wrote:
> Hi Christophe,
> 
> The incentive for creating this series was Ritika's patch "multipath-tools:
> Skip CHANGE uevent for non-mpath devices" from October 2017, plus the
> observation that uevent.c contains a lot of code repetition.
> I've refactored and simplified the uevent_get_XXX code, and started to use
> "const" qualifiers in the part of the code which I touched in the process.
> 
> In order to avoid regressions in the process, I took this as a starting point
> for implementing a simple unit test framework. For now, it covers only the
> stuff that I changed in this series.
> 
> The series is based on my previous patch series ("Various 
> multipath-tools fixes"), v2. The first patch doesn't belong in the series
> logically, but I thought it may help you track the ordering if I include it
> here rather then posting separately or spamming the list with the big series
> again.
> 
> Regards,
> Martin

Looks good.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> 
> Martin Wilck (7):
>   assemble_map: no newline at end of params string
>   tests: cmocka-based unit test for uevent_get_XXX
>   libmultipath: refactor uevent_get_XXX
>   libmultipath: const qualifier for wwid and alias
>   libmultipath: move UUID_PREFIX to devmapper.h
>   libmultipath: add uevent_is_mpath
>   multipathd: ignore uevents for non-mpath devices
> 
>  .gitignore                 |   3 +
>  Makefile                   |   4 +
>  libmultipath/devmapper.c   |   3 -
>  libmultipath/devmapper.h   |   3 +
>  libmultipath/discovery.c   |   2 +-
>  libmultipath/discovery.h   |   2 +-
>  libmultipath/dmparser.c    |   1 -
>  libmultipath/memory.h      |   2 +-
>  libmultipath/structs.c     |   4 +-
>  libmultipath/structs.h     |   4 +-
>  libmultipath/structs_vec.c |   2 +-
>  libmultipath/structs_vec.h |   2 +-
>  libmultipath/uevent.c      | 183 +++++++++++++--------------
>  libmultipath/uevent.h      |  15 +--
>  multipathd/main.c          |  10 +-
>  multipathd/main.h          |   2 +-
>  tests/Makefile             |  23 ++++
>  tests/globals.c            |  17 +++
>  tests/uevent.c             | 304 +++++++++++++++++++++++++++++++++++++++++++++
>  19 files changed, 462 insertions(+), 124 deletions(-)
>  create mode 100644 tests/Makefile
>  create mode 100644 tests/globals.c
>  create mode 100644 tests/uevent.c
> 
> -- 
> 2.15.1
