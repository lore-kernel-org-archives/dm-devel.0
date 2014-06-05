From: Christoph Hellwig <hch@infradead.org>
Subject: Re: good dm-mpath test setup?
Date: Thu, 5 Jun 2014 05:20:38 -0700
Message-ID: <20140605122038.GA13185@infradead.org>
References: <20140605115011.GA816@infradead.org>
 <53905FC6.5030006@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <53905FC6.5030006@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Jun 05, 2014 at 02:17:10PM +0200, Hannes Reinecke wrote:
> On a complete different footing, I've whipped together some patches
> to simplify the request/bio cloning when using multipath;
> basically do _not_ clone the bios, but just modify the rq_end_io
> handler.
> 
> You mentioned something at LSF that the current way of handling is
> quite insane, and looking at it I tend to agree.
> 
> So if you'd be interested I'll be posting them.

Please do - that's something mostly orthogonal to my patches, but with
the bio cloning removed and my conversion to blk-mq dm-mpath will become
really lean and simple.
