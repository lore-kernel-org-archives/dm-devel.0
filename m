From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH v2 0/4] misc multipath patches
Date: Fri, 13 Sep 2019 22:48:21 +0000
Message-ID: <c0e38dc7cbcf8f676868447828632cd7aadbfc96.camel@suse.com>
References: <1568412244-23982-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1568412244-23982-1-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <B228C6E1BB4D9F40961461E389ECBE6A@namprd18.prod.outlook.com>
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, 2019-09-13 at 17:04 -0500, Benjamin Marzinski wrote:
> These are a couple of disconnected multipath patches.
> 
> Changes in v2:
> 
> 0003: As Martin suggested, fail immediately on wrong number of prin
>       actions.
> 
> 0004: mp_init now is an optional symbol for checker DSOs, and is
> ignored
>       if it's missing, again at Martin's suggestion.
> 
> Benjamin Marzinski (4):
>   mpathpersist: remove broken/unused code
>   libmultipath: EMC PowerMax NVMe device config
>   mpathpersist: fix leaks
>   libmultipath: fix mpcontext initialization
> 
>  libmpathpersist/mpath_persist.c      | 16 ++++----------
>  libmultipath/checkers.c              | 27 +++++++++++++++++++++--
>  libmultipath/checkers.h              |  1 +
>  libmultipath/checkers/emc_clariion.c |  7 ++++++
>  libmultipath/discovery.c             |  2 ++
>  libmultipath/hwtable.c               |  6 +++++
>  mpathpersist/main.c                  | 33 ++++++++++++++++++------
> ----
>  7 files changed, 67 insertions(+), 25 deletions(-)
> 

For this v2 series:

Reviewed-by: Martin Wilck <mwilck@suse.com>
