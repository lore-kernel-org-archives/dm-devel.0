From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH] Track block device users that created
 dirty pages
Date: Fri, 6 Jan 2012 09:41:34 -0500
Message-ID: <20120106144134.GA17498@infradead.org>
References: <1325632496-5524-1-git-send-email-snitzer@redhat.com>
	<Pine.LNX.4.64.1201051954160.31587@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1201051954160.31587@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, Edward Thornber <thornber@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Thu, Jan 05, 2012 at 07:58:34PM -0500, Mikulas Patocka wrote:
> Hi
> 
> This is the patch for selective flushing on block devices. Only processes 
> that created some dirty data in the pagecache flush the pagecache when 
> closing the device. The processes that didn't create any dirty data (for 
> example lvm, when using direct io) don't flush the cache when closing the 
> device.
> 
> Mikulas
> 
> ---
> 
> Track block device users that created dirty pages
> 
> This patch adds a new field f_driver_flags to struct file. The field may
> be used by the driver for any purpose.

Please use file->private for that kind of usage.
