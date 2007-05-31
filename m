From: David Chinner <dgc@sgi.com>
Subject: Re: Re: [RFD] BIO_RW_BARRIER - what it means for devices,
	filesystems, and dm/md.
Date: Thu, 31 May 2007 11:11:27 +1000
Message-ID: <20070531011127.GO86004887@sgi.com>
References: <18006.38689.818186.221707@notabene.brown>
	<18010.12472.209452.148229@notabene.brown>
	<20070528024559.GA85884050@sgi.com>
	<18010.17713.76863.245176@notabene.brown>
	<20070528042926.GC85884050@sgi.com>
	<18014.6860.989819.665778@notabene.brown>
	<20070531010739.GR25091@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070531010739.GR25091@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, David Chinner <dgc@sgi.com>, Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org, Andreas Dilger <adilger@clusterfs.com>
List-Id: dm-devel.ids

On Thu, May 31, 2007 at 02:07:39AM +0100, Alasdair G Kergon wrote:
> On Thu, May 31, 2007 at 10:46:04AM +1000, Neil Brown wrote:
> > If a filesystem cares, it could 'ask' as suggested above.
> > What would be a good interface for asking?
> 
> XFS already tests:
>   bd_disk->queue->ordered == QUEUE_ORDERED_NONE

The side effects of removing that check is what started
this whole discussion.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
