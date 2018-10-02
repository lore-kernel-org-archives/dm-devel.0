From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 0/2] multipath-tools: avoid error messages
	with NVMe
Date: Tue, 2 Oct 2018 12:36:58 -0500
Message-ID: <20181002173658.GU3172@octiron.msp.redhat.com>
References: <20181001184507.4162-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181001184507.4162-1-mwilck@suse.com>
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

On Mon, Oct 01, 2018 at 08:45:05PM +0200, Martin Wilck wrote:
> These two patches avoid useless error messages for NVMe devices.

ACK for the set

-Ben
> 
> Martin Wilck (2):
>   libmultipath: allow sysfs_pathinfo to return SKIPPED
>   multipathd: try SCSI persistent reservations for SCSI only
> 
>  libmultipath/discovery.c | 86 +++++++++++++++++++++-------------------
>  multipathd/main.c        |  3 ++
>  2 files changed, 48 insertions(+), 41 deletions(-)
> 
> -- 
> 2.19.0
