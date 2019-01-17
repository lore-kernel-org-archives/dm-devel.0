From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 0/3] multipath-tools: compilation fixes
Date: Wed, 16 Jan 2019 18:10:04 -0600
Message-ID: <20190117001004.GY11315@octiron.msp.redhat.com>
References: <20190108113246.5903-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190108113246.5903-1-mwilck@suse.com>
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

On Tue, Jan 08, 2019 at 12:32:43PM +0100, Martin Wilck wrote:
> Hi Christophe,
> 
> my late NVMe patch series broke compilatioin with older
> kernel headers. This series fixes that, and adds two other
> minor build-related fixes.
> 
> Regards,
> Martin

ACK for the set

-Ben

> 
> Martin Wilck (3):
>   libmultipath: fix compilation with older kernel headers
>   multipath: fix gcc 4.8 uninitialized variable warning
>   multipath_tools: remove ENABLE_RADOS
> 
>  Makefile.inc                         |  4 +-
>  libmultipath/Makefile                | 11 ++---
>  libmultipath/foreign/Makefile        |  7 ++-
>  libmultipath/nvme/linux/nvme_ioctl.h | 67 ++++++++++++++++++++++++++++
>  multipath/main.c                     |  9 +---
>  5 files changed, 76 insertions(+), 22 deletions(-)
>  create mode 100644 libmultipath/nvme/linux/nvme_ioctl.h
> 
> -- 
> 2.19.2
