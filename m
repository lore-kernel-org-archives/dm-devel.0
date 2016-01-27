From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-multipath low performance with blk-mq
Date: Tue, 26 Jan 2016 21:09:32 -0500
Message-ID: <20160127020932.GA26919@redhat.com>
References: <569E11EA.8000305@dev.mellanox.co.il>
	<20160119224512.GA10515@redhat.com>
	<20160125214016.GA10060@redhat.com>
	<20160126160324.GA24665@redhat.com>
	<20160126164437.GB15979@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160126164437.GB15979@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "keith.busch@intel.com" <keith.busch@intel.com>, Bart Van Assche <bart.vanassche@sandisk.com>, dm-devel@redhat.com, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: dm-devel.ids

On Tue, Jan 26 2016 at 11:44am -0500,
Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, Jan 26, 2016 at 11:03:24AM -0500, Mike Snitzer wrote:
> > Christoph, any chance you could rebase your 'nvme-loop.2' on v4.5-rc1?
> 
> Don't think I have time at the moment, sorry..

No problem, I pulled the latest DM changes ontop of 'nvme-loop.2', see:
http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=devel

I was able to use nvme-loop like was documented here:
http://git.infradead.org/users/hch/block.git/commit/47d8d5b1db270463b5bd7b6a68cd89bd8762840d

But I'm not too sure how Sagi used the resulting nvme device with
multipath.. maybe he just manually pushed down a DM multipath table?
And only used the single /dev/nvme0n1 device?  Sagi?
