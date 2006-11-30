From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC][PATCH] dm-cache: block level disk cache target
	for device mapper
Date: Thu, 30 Nov 2006 14:48:07 +0000
Message-ID: <20061130144807.GA16474@infradead.org>
References: <200611271826.kARIQYRi032717@hera.kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200611271826.kARIQYRi032717@hera.kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Eric Van Hensbergen <ericvh@hera.kernel.org>
Cc: dm-devel@redhat.com, ming@acis.ufl.edu, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Nov 27, 2006 at 06:26:34PM +0000, Eric Van Hensbergen wrote:
> This is the first cut of a device-mapper target which provides a write-back
> or write-through block cache.  It is intended to be used in conjunction with
> remote block devices such as iSCSI or ATA-over-Ethernet, particularly in
> cluster situations.
> 
> In performance tests with iSCSI, gave peformance improvements of 2-10x that
> of iSCSI alone when Postmark or Bonnie loads were applied from 8 clients to
> a single server.  Evidence suggests even greater differences on larger
> clusters.  A detailed performance analysis will be vailable shortly via a
> technical report on IBM's CyberDigest.
> 
> This module was developed during an intership at IBM Research by
> Ming Zhao.  Please direct comments to both Ming and myself.

I don't quite understand the need for this.  Do you need this module
because your iscsi target doesn't use the pagecache on the server?
