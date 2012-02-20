From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Benchmarking dm-crypt with different block size,
 request number and scheduler
Date: Mon, 20 Feb 2012 16:22:32 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1202201619340.21269@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1202201201330.10690@hs20-bc2-1.build.redhat.com>
	<20120220211740.GB9564@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120220211740.GB9564@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids



On Mon, 20 Feb 2012, Alasdair G Kergon wrote:

> Were these tests all using that 'worst case' alignment you mentioned?
> - If so, people with such alignment could be advised to use deadline with
>   huge queue depth?
> 
> Alasdair

Some tests are with 512-byte block size, other with 4096-byte block size.

Alignment of partition start doesn't matter, because they were done on a 
SCSI disk with 512-byte hardware sector size. Only alignment of partition 
size does matter (if the partition has odd number of sectors, the kernel 
uses 512-byte block size for this partition).

Mikulas
