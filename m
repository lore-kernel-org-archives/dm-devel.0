From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH RESEND 0/4] multipath-tools: fixes for path
 wwid detection and path change uevents
Date: Wed, 14 Mar 2018 12:40:13 -0500
Message-ID: <20180314174013.GF14513@octiron.msp.redhat.com>
References: <20180307232152.15538-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180307232152.15538-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Chongyun Wu <wu.chongyun@h3c.com>
List-Id: dm-devel.ids

On Thu, Mar 08, 2018 at 12:21:48AM +0100, Martin Wilck wrote:
> Hi Christophe,
> 
> this small series fixes some minor glitches I found in the current path
> discovery code, and attempts to implement the safe part of the functionality
> discussed in the thread "multipathd: update path's udev in uev_update_path"
> in January (based on an idea from Wu Chongyun).
> 
> Resending the series, unchanged, rebased on 0.7.5.
> 
> Regards,
> Martin
> 

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

for the set.

> Martin Wilck (4):
>   libmultipath: get_uid: check VPD pages for SCSI only
>   libmultipath: get_uid: don't quit prematurely without udev
>   libmultipath: uev_update_path: always warn if WWID changed
>   libmultipath: uev_update_path: update path properties
> 
>  libmultipath/discovery.c | 58 ++++++++++++++++++++++++++++--------------------
>  multipathd/main.c        | 29 +++++++++++++++++-------
>  2 files changed, 55 insertions(+), 32 deletions(-)
> 
> -- 
> 2.16.1
