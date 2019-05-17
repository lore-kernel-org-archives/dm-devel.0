From: Martin Wilck <mwilck@suse.de>
Subject: Re: [PATCH 0/4] Coverity fixes
Date: Fri, 17 May 2019 23:56:45 +0200
Message-ID: <2e9ce7711685308366025c55b34abb565034e202.camel@suse.de>
References: <1558109650-21179-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1558109650-21179-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, 2019-05-17 at 11:14 -0500, Benjamin Marzinski wrote:
> These are fixes to some issues that coverity pointed out.
> 
> Benjamin Marzinski (4):
>   libmultipath: handle clock_gettime failures in tur checker
>   kpartx: fail if dup() of dasd file descriptor fails
>   multipathd: fix REALLOC_REPLY with max length reply
>   multipathd: handle NULL return from genhelp_handler
> 
>  kpartx/dasd.c               |  2 ++
>  libmultipath/checkers/tur.c | 19 +++++++++++++++----
>  multipathd/cli.c            |  6 +++++-
>  multipathd/cli.h            | 17 +++++++++--------
>  4 files changed, 31 insertions(+), 13 deletions(-)
> 

ACK for the series, except 1/4.

Martin
