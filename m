From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/1] dm-zoned: Zoned block device target
Date: Thu, 9 Feb 2017 10:27:45 -0500
Message-ID: <20170209152745.GA10638@redhat.com>
References: <20170209041849.30964-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170209041849.30964-1-damien.lemoal@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On Wed, Feb 08 2017 at 11:18pm -0500,
Damien Le Moal <damien.lemoal@wdc.com> wrote:

> The dm-zoned device mapper target provides transparent write access
> to zoned block devices (ZBC and ZAC compliant block devices).
> dm-zoned hides to the device user (a file system or an application
> doing raw block device accesses) any constraint imposed on write
> requests by the device. Write requests are processed using a
> combination of on-disk buffering using the device conventional zones,
> allowing any random write access to be safely executed, or direct in-place
> processing for requests aligned on a zone sequential write pointer position.
> A background reclaim process ensures that some conventional zones are always
> available for executing unaligned write requests. The reclaim process
> overhead is minimized by managing buffer zones in a least-recently-written
> order and first targeting the oldest buffer zones. Doing so, blocks under
> regular write access (such as metadata blocks of an FS) remain stored in
> conventional zones, resulting in no apparent write overhead.
> 
> dm-zoned implementation focus on simplicity and on minimizing overhead
> (CPU, memory and storage overhead). For a 10TB host-managed disk with
> 256 MB zones, dm-zoned memory usage per disk instance is at most 4.5 MB
> and as little as 5 zones will be used internally for storing metadata
> and performing buffer zone reclaim operations. This is achieved using
> zone level indirection rather than a full block indirection system for
> managing block movement between zones.
> 
> dm-zoned primary target is host-managed zoned block devices but it can also
> be used with host-aware device models to mitigate potential device-side
> performance degradation due to excessive random writing.
> 
> dm-zoned backend devices can be formatted and checked using the dmzadm
> utility available at:
> 
> https://github.com/hgst/dm-zoned-tools
> 
> This patch applies on top of 4.10-rc7 tree.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>

Looks like this work has come a long way.  While I am _still_ not
hearing from any customers (or partners) that SMR is a priority I do
acknowledge that that obviously isn't the case for WDC and others.

So, I'll sign up for reviewing this DM target, with a focus on DM
interface and implementation details, _after_ I get some technical
review (e.g. Reviewed-by) from people like Hannes and others more
invested in the SMR technologies.  Basically I don't know enough about
the constraints of these devices to fully appreciate and catch some
issue in the particulars of the algorithms used to mitigate SMR's
quirks.

I'd also like to understand how invested WDC is in maintaining this DM
target for years and years if/when I were to merge this DM target into
mainline.

Thanks,
Mike
