From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH 00/11] Final round of SLES resync patches
Date: Fri, 18 Jan 2013 20:20:34 +0100
Message-ID: <1358536834.4199.4.camel@lapoo.opensvc.com>
References: <1358434773-2002-1-git-send-email-hare@suse.de>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1358434773-2002-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On jeu., 2013-01-17 at 15:59 +0100, Hannes Reinecke wrote:
> Hi Christophe,
> 
> and this is now the final round of SLES resync patches.
> Mostly cleanup and minor fixes, except from the abstract
> socket patch for CLI commands.
> I _thought_ I had send this early, but apparently not.
> Please apply.
> 
> Note that I've removed the rules file as it shouldn't
> be necessary anymore; we're using libudev directly.
> 
Applied.

Best regards,
Christophe Varoqui
www.opensvc.com

> Hannes Reinecke (10):
>   Cleanup whitespaces
>   Provide correct persistent symlinks for user_friendly_names
>   kpartx_id: Generate persistent symlinks for 'wwn'
>   kpartx: Fix DASD name in kpartx_id
>   Break out loop in factorize_hwtable()
>   multipathd: switch to abstract sockets for CLI commands
>   multipathd: log message when check interval has changed
>   multipathd: call 'reconfigure' during startup
>   multipath: do not install rules file
>   kpartx: Deinstall kpartx_id
> 
> Petr Uzel (1):
>   Fix inconsistent entries after merging hwtable with user's config
> 
>  kpartx/Makefile                 |    1 +
>  kpartx/kpartx.rules             |    8 ++++++++
>  kpartx/kpartx_id                |   11 +++++++++--
>  libmultipath/config.c           |   25 +++++++++++++++++++------
>  libmultipath/defaults.h         |    2 +-
>  libmultipath/uxsock.c           |   27 ++++++++++++++-------------
>  multipath/Makefile              |    3 ---
>  multipath/multipath.rules       |    7 -------
>  multipathd/main.c               |   26 ++++++++++++++------------
>  multipathd/multipathd.init.suse |    2 +-
>  multipathd/uxlsnr.c             |    6 +++---
>  11 files changed, 70 insertions(+), 48 deletions(-)
>  delete mode 100644 multipath/multipath.rules
> 
