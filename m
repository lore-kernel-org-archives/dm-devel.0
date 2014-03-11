From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 0/2] multipath: Stop extra scans on stacked
 devices
Date: Tue, 11 Mar 2014 17:34:06 +0100
Message-ID: <531F3AFE.4070008@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, device-mapper development <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
List-Id: dm-devel.ids

On 02/12/2014 Benjamin Marzinski wrote:

> Whenever there is a DM_DEVICE_RESUME ioctl, a uevent is generated. Right now,
> when multipath is reloading existing devices do to paths going or coming,
> lvmetad will rescan those devices. This is unnecessary, and can cause a lot
> of overhead. Also, multipath devices with no working paths will get scanned.
> These patches make multipath set a new flag, DM_SUBSYSTEM_UDEV_FLAG0, when it
> is reloading devices due to path changes, and lvmetad can safely ignore it.
> They also add a new udev rules file, 11-dm-mpath.rules, to disable scanning
> when it would not be useful.
> 
> Benjamin Marzinski (2):
>   New udev rules to deal with stacked devices
>   Mark reloads with udev flag
> 
>  Makefile.inc                |  1 +
>  kpartx/devmapper.c          |  4 ++--
>  kpartx/devmapper.h          |  8 +++++++-
>  kpartx/kpartx.c             |  8 ++++----
>  libmultipath/configure.c    |  4 ++--
>  libmultipath/devmapper.c    | 26 ++++++++++++++------------
>  libmultipath/devmapper.h    | 10 ++++++++--
>  multipath/11-dm-mpath.rules | 34 ++++++++++++++++++++++++++++++++++
>  multipath/Makefile          |  3 +++
>  multipathd/cli_handlers.c   |  4 ++--
>  10 files changed, 77 insertions(+), 25 deletions(-)
>  create mode 100644 multipath/11-dm-mpath.rules

This set is missing in git.
