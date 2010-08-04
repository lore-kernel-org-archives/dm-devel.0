From: Christoph Hellwig <hch@infradead.org>
Subject: Re: How to track down abysmal performance ata - raid1 -
 crypto - vg/lv - xfs
Date: Wed, 4 Aug 2010 07:18:03 -0400
Message-ID: <20100804111803.GA32643__9219.36217132515$1280920826$gmane$org@infradead.org>
References: <20100804073546.GA7494@comet.dominikbrodowski.net>
	<20100804085039.GA11671@infradead.org>
	<20100804091317.GA27779@isilmar-3.linta.de>
	<20100804092122.GA2998@infradead.org>
	<20100804073546.GA7494@comet.dominikbrodowski.net>
	<201008041116.09822@zmi.at>
	<20100804102526.GB13766@isilmar-3.linta.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20100804102526.GB13766@isilmar-3.linta.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dominik Brodowski <linux@dominikbrodowski.net>, Michael Monnerie <michael.monnerie@is.it-management.at>, Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Aug 04, 2010 at 12:25:26PM +0200, Dominik Brodowski wrote:
> Hey,
> 
> many thanks for your feedback. It seems the crypto step is the culprit:
> 
> Reading 1.1 GB with dd, iflag=direct, bs=8k:
> 
> /dev/sd*                35.3 MB/s       ( 90 %)
> /dev/md*                39.1 MB/s       (100 %)
> /dev/mapper/md*_crypt    3.9 MB/s       ( 10 %)
> /dev/mapper/vg1-*        3.9 MB/s       ( 10 %)
> 
> The "good" news: it also happens on my notebook, even though it has a
> different setup (no raid, disk -> lv/vg -> crypt). On my notebook, I'm
> more than happy to test out different kernel versions, patches etc.
> 
> /dev/sd*                17.7 MB/s       (100 %)
> /dev/mapper/vg1-*       16.2 MB/s       ( 92 %)
> /dev/mapper/*_crypt      3.1 MB/s       ( 18 %)

The good news is that you have it tracked down, the bad news is that
I know very little about dm-crypt.  Maybe the issue is the single
threaded decryption in dm-crypt?  Can you check how much CPU time
the dm crypt kernel thread uses?
