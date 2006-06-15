From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Next set of device-mapper  patches
Date: Thu, 15 Jun 2006 16:20:26 +0100
Message-ID: <20060615152026.GK27639@agk.surrey.redhat.com>
References: <20060615145639.GJ27639@agk.surrey.redhat.com>
	<3EC60E80D9AA7C4E910ACC9DA2003AC305FEAF1B@BGEEXC02.asiapacific.cpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <3EC60E80D9AA7C4E910ACC9DA2003AC305FEAF1B@BGEEXC02.asiapacific.cpqcorp.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "P S, Suresh (STSD)" <suresh.pathamadai@hp.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Jun 15, 2006 at 08:42:59PM +0530, Singh, Santosh (STSD) wrote:
>  I am testing  the device-mapper ioctl support.
>   Which all the  patches required for this and can I I apply those
> patches on linux-2.6.16. 
 
Start from:

  ##############################################################################
  # Submitted upstream
  ##############################################################################
   
  dm-snapshot-unify-chunk_size.patch

...
and stop at:

  dm-export-blkdev_driver_ioctl.patch

Alasdair
-- 
agk@redhat.com
