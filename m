From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-thin: Why is DATA_DEV_BLOCK_SIZE_MIN_SECTORS set
 to 64k?
Date: Tue, 12 Jun 2018 16:34:03 +0100
Message-ID: <20180612153403.bjsv5uzdk2vctc66@reti>
References: <alpine.LRH.2.11.1805172332520.20870@mail.ewheeler.net>
	<8bde7e8c-d2c1-c67d-f0ca-5b121053b34f@redhat.com>
	<alpine.LRH.2.11.1806091847540.28960@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1806091847540.28960@mail.ewheeler.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Eric Wheeler <dm-devel@lists.ewheeler.net>
Cc: dm-devel@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Sat, Jun 09, 2018 at 07:31:54PM +0000, Eric Wheeler wrote:
> I understand the choice.  What I am asking is this: would it be safe to 
> let others make their own choice about block size provided they are warned 
> about the metadata-chunk-size/pool-size limit tradeoff?
> 
> If it is safe, can we relax the restriction?  For example, 16k chunks 
> still enables ~4TB pools, but with 1/4th of the CoW IO overhead on heavily 
> snapshotted environments.

Yes, it would be safe.  There are downsides though; all io gets split
on block size boundaries, so dropping to 16k or smaller could
seriously increase the cpu usage.  Smaller blocks also means more
mappings, more metadata, more kernel memory consumption.

- Joe
