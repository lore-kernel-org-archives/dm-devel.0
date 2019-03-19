From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v3 00/10] multipath-tools: avoid I/O during
 uevent processing
Date: Tue, 19 Mar 2019 13:37:46 -0500
Message-ID: <20190319183746.GL13295@octiron.msp.redhat.com>
References: <20190318112445.6636-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190318112445.6636-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Mar 18, 2019 at 12:24:35PM +0100, Martin Wilck wrote:
> Hi Christophe, hi Ben,
> 
> the bulk of this series attempts to avoid unnecessary I/O for "multipath -u"
> calls from udev rules. I came up with it in a recent attempt to debug
> avoid "multipath -u" hangups during boot. I found that the detect_alua()
> call in the get_refwwid->pathinfo->scsi_ioctl_pathinfo call sequence would
> cause an sg ioctl to be sent for every "multipath -u" invocation. That's
> obvious nonsense, we don't need to detect ALUA capabilities to find out
> if a device is a potential multipath member.
> 
> So, rather than setting pp->tpgs in pathinfo, I resorted to a "lazy"
> approach where ALUA capabilities are probed when they are needed, no
> sooner. I also cleaned up the ALUA code a bit (still some more to go),
> and made it attempt to read INQUIRY data from sysfs.
> 
> Regards,
> Martin

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

for the set.
 
> Changes v2->v3:
> 
>  - added 8/10 "tidy up do_set_from_hwe() with statement expression"
>    (Hannes), renumber subsequent patches accordingly.
>  - 9/10: cleanup ugly macro usage; do retrieve VPD for "unknown"
>    SCSI storage devices
>  
> Changes v1->v2:
> 
>  - 6/9: remove one remaining direct access to pp->tpgs
>  - 9/9: use non-personal email address for maintainer
> 
> Martin Wilck (10):
>   libmultipath: add sysfs_get_inquiry()
>   libmultipath: alua: make API more consistent
>   libmultipath: alua: try to retrieve inquiry data from sysfs
>   libmultipath: constify sysfs_get_timeout()
>   libmultipath: detect_alua(): use system timeout
>   libmultipath: lazy tpgs probing
>   libmultipath: don't link alua_rtpg.o twice
>   libmultipath: tidy up do_set_from_hwe() with statement expression
>   libmultipath: check_rdac(): pre-check in hwtable
>   libmultipath: hwtable: add Lenovo DE series
> 
>  libmultipath/discovery.c              | 46 +++++++++++++++++-------
>  libmultipath/discovery.h              | 10 +++---
>  libmultipath/hwtable.c                | 20 +++++++++++
>  libmultipath/prioritizers/Makefile    |  3 --
>  libmultipath/prioritizers/alua.c      |  4 +--
>  libmultipath/prioritizers/alua_rtpg.c | 45 +++++++++++++++++------
>  libmultipath/prioritizers/alua_rtpg.h |  7 ++--
>  libmultipath/propsel.c                | 52 ++++++++++++++++++---------
>  multipathd/main.c                     |  7 ++--
>  9 files changed, 139 insertions(+), 55 deletions(-)
> 
> -- 
> 2.21.0
