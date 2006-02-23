From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: [PATCH] User-configurable HDIO_GETGEO for dm
	volumes
Date: Thu, 23 Feb 2006 13:56:39 +0000
Message-ID: <20060223135639.GK31641@agk.surrey.redhat.com>
References: <43F38D83.3040702@us.ibm.com>
	<20060217151650.GC12173@agk.surrey.redhat.com>
	<43F6718E.2000908@us.ibm.com>
	<20060222223240.GI31641@agk.surrey.redhat.com>
	<1140655617.3300.14.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1140655617.3300.14.camel@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Andrew Morton <akpm@osdl.org>, device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org, Chris McDermott <lcm@us.ibm.com>
List-Id: dm-devel.ids

On Wed, Feb 22, 2006 at 04:46:57PM -0800, Darrick J. Wong wrote:
> Looks good and tests ok, with one issue: I still have a preference for
> returning -ENOTTY over 0/0/0 when dm doesn't know the geometry.  That
> said, most programs will see the zero cylinder count and make a guess,
> so it probably doesn't matter.
 
My copy of the sd(4) man page says of that ioctl:

    The information returned in the parameter is the disk
    geometry of the drive as understood by DOS!   This geometry is not
    the physical geometry of the drive.  It is used when constructing the
    drive's partition table, however, and is needed for convenient
    operation of fdisk(1), efdisk(1), and lilo(1).  If the geometry
    information is not available, zero will be returned for all of the
    parameters.
 
Is there a preferred alternative specification?

Alasdair
-- 
agk@redhat.com
