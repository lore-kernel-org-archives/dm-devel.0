From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: dm-multipath low performance with blk-mq
Date: Mon, 25 Jan 2016 19:49:00 -0600
Message-ID: <20160126014900.GR24960@octiron.msp.redhat.com>
References: <569E11EA.8000305@dev.mellanox.co.il>
	<20160119224512.GA10515@redhat.com>
	<20160125214016.GA10060@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160125214016.GA10060@redhat.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, "keith.busch@intel.com" <keith.busch@intel.com>, Bart Van Assche <bart.vanassche@sandisk.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>
List-Id: dm-devel.ids

On Mon, Jan 25, 2016 at 04:40:16PM -0500, Mike Snitzer wrote:
> On Tue, Jan 19 2016 at  5:45P -0500,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > On Mon, Jan 18 2016 at  7:04am -0500,
> > Sagi Grimberg <sagig@dev.mellanox.co.il> wrote:
> 
> Would still appreciate answers to my 2 questions above (did you modify
> md->tag_set.nr_hw_queues and can you share your fio job?)

The number of CPUs (if it's not obvious from the fio job) and any
relevant information about the memory architecture (is this a NUMA
system? How many nodes?) might also help reproducing this.

-Ben
