From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH 00/16] multipath-tools: miscellaneous
	multipath patches
Date: Mon, 06 May 2013 21:45:31 +0200
Message-ID: <1367869531.5573.2.camel@lapoo.opensvc.com>
References: <1367531197-8987-1-git-send-email-bmarzins@redhat.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1367531197-8987-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On jeu., 2013-05-02 at 16:46 -0500, Benjamin Marzinski wrote:
> Here are the patches I've got since my last resync.
> 
> Please apply.
> 
The series is applied and pushed.

- 11v2/16 is merged in place of 11/16
- 05/16 is left out pending analysis of the solution suggested by Bart

Thanks,
Christophe Varoqui
www.opensvc.com

> Philipp Schmidt (1):
>   Make kpartx correctly handle non-512 byte GPT partitions
> 
> Benjamin Marzinski (15):
>   Make kpartx advise modprobe instead of insmod
>   Fix print_multipath_topology for large outputs
>   Don't print checker messages for ghost paths
>   Fix a couple of signal issues
>   Fix hardware entry matching code
>   Fix some socket issues
>   Avoid race between ueventloop and uevqloop
>   Add existing multipath devices to wwids file on configure
>   add wwids file cleanup options
>   Fix max path checker timing
>   Make set_multipath_wwid actually do something
>   Make multipathd deal better with uninitialized paths
>   Stop annoying prio_lookup warning messages
>   make multipathd disable queue_without_daemon by default
>   Use mapname to choose kpartx delimiter
> 
>  kpartx/gpt.c                      |   9 ++-
>  kpartx/kpartx.c                   |   2 +-
>  kpartx/lopart.c                   |   4 +-
>  libmpathpersist/mpath_updatepr.c  |   3 +-
>  libmultipath/config.c             |   2 +
>  libmultipath/dict.c               |  10 ++-
>  libmultipath/discovery.c          |   8 ++-
>  libmultipath/log_pthread.c        |   3 +
>  libmultipath/print.c              |  30 +++++++--
>  libmultipath/prio.c               |   5 +-
>  libmultipath/structs.h            |   2 +-
>  libmultipath/structs_vec.c        |   2 +-
>  libmultipath/uevent.c             |  12 ++--
>  libmultipath/uxsock.c             |   4 +-
>  libmultipath/wwids.c              | 130 ++++++++++++++++++++++++++++++++++++++
>  libmultipath/wwids.h              |   2 +
>  multipath/main.c                  |  51 +++++++++++++--
>  multipath/multipath.8             |   8 ++-
>  multipathd/cli.c                  |   3 +
>  multipathd/cli.h                  |   2 +
>  multipathd/cli_handlers.c         |  18 ++++++
>  multipathd/cli_handlers.h         |   2 +
>  multipathd/main.c                 |  41 ++++++++----
>  multipathd/multipathd.init.redhat |  14 ++--
>  24 files changed, 313 insertions(+), 54 deletions(-)
> 
