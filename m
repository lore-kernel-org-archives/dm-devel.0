From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: shutting down logical volumes once an underlying
	device fails?
Date: Wed, 26 Sep 2012 16:11:17 -0400
Message-ID: <20120926201116.GD7882@redhat.com>
References: <20120926161106.GA12653@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120926161106.GA12653@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Sep 26 2012 at 12:11pm -0400,
Christoph Hellwig <hch@infradead.org> wrote:

> A coworker has been testing failure scenarious using lvm, and noticed
> that when a PV fail a filesystem on a logical volume that spans multiple
> PVs only fails once it accesses the actually failed physical device.
> 
> At least for system using higher level error detection and replication
> behaviour that fails a LV as soon as one of the underlying devices fails
> would be much more helpful.  Is the current LVM behaviour intention and
> should we work around this using userspace monitoring, or would be
> patches to introduce a shutdown state similar to what we have in XFS for
> example be welcome?

Don't think any shutdown should be initiated by the kernel.

But events that userspace could respond to by deactivating (an
arbitrarily complex) lvm device would be the way forward IMHO.

Could this tie back to needing better UA handling/notification between
kernel<->userspace?
