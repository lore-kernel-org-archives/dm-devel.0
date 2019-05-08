From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 08/10] dm-integrity: add a bitmap mode
Date: Wed, 8 May 2019 12:46:29 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1905081228270.29650@file01.intranet.prod.int.rdu2.redhat.com>
References: <20190429125746.036036640@debian-a64.vm>
	<20190507185154.GB24320@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190507185154.GB24320@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Ondrej Kozina <okozina@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids



On Tue, 7 May 2019, Mike Snitzer wrote:

> On Mon, Apr 29 2019 at  8:57am -0400,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > Add a new bitmap mode for dm-integrity.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> This patch header needs much more detail.
> 
> Can you please be as informative and detailed as possible about what
> this new bitmap mode is (what constraints it has, where it is expected
> to be useful, etc)?  Also, if you have them, provide some benchmarks
> that showcase its benefits.
> 
> Thanks,
> Mike

The patch adds the documentation to the file 
"Documentation/device-mapper/dm-integrity.txt", so it can be also used as 
a patch header. For example:

"This patch introduces an alternative mode of operation whete dm-integrity 
uses bitmap instead of a journal. If a bit in the bitmap is 1, the 
corresponding region's data and integrity tags are not synchronized - if 
the machine crashes, the unsynchronized regions will be recalculated. The 
bitmap mode is faster than the journal mode, because we don't have to 
write the data twice, but it is also less reliable, because if data 
corruption happens when the machine crashes, it may not be detected."

Benchmark - on an SSD connected to a SATA300 port, when doing large linear 
writes with dd.

buffered I/O:
	raw device throughput - 245MB/s
	dm-integrity with journaling - 120MB/s
	dm-integrity with bitmap - 238MB/s

direct I/O with 1MB block size:
	raw device throughput - 248MB/s
	dm-integrity with journaling - 123MB/s
	dm-integrity with bitmap - 223MB/s

Mikulas
