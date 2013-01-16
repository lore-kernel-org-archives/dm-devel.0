From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH 00/13] More patches from SLES
Date: Wed, 16 Jan 2013 22:06:13 +0100
Message-ID: <1358370373.8351.12.camel@lapoo.opensvc.com>
References: <1358338456-1234-1-git-send-email-hare@suse.de>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1358338456-1234-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On mer., 2013-01-16 at 13:14 +0100, Hannes Reinecke wrote:
> Hi Christophe,
> 
> here are some more patches from SLES.
> Most are missing patches from the initial resync;
> however, the transport id stuff is a rework from
> the SLES sources and has been enhanced to cover SAS.
> 
> Please apply.
> 
Nice indeed.
Applied.

Christophe Varoqui
www.opensvc.com

> Hannes Reinecke (13):
>   Fixup .gitignore
>   Check for !SUSPENDED in kpartx rules
>   kpartx.rules: Check for accessible device-mapper device
>   Correct persistent symlink for cciss
>   Add hardware entry for Intel Multi-Flex
>   Add Datacore SANSymphony to hwtable
>   Add SUN STK6580 to hardware table
>   Remove unused structures
>   Use transport identifiers when detecting devices
>   Discover target ids for ATA
>   Set recovery_tmo for iSCSI devices
>   Set I_T_nexus_loss_timeout on SAS devices
>   Rename variables in sysfs_get_tgt_nodename
> 
>  .gitignore               |    8 +-
>  kpartx/kpartx.rules      |    4 +-
>  kpartx/kpartx_id         |    3 +
>  libmultipath/discovery.c |  190 ++++++++++++++++++++++++++++++++++++---------
>  libmultipath/hwtable.c   |   39 ++++++++++
>  libmultipath/structs.h   |   26 +++---
>  6 files changed, 215 insertions(+), 55 deletions(-)
> 
