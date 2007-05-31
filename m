From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: [RFD] BIO_RW_BARRIER - what it means for devices,
	filesystems, and dm/md.
Date: Thu, 31 May 2007 01:57:37 +0100
Message-ID: <20070531005737.GQ25091@agk.fab.redhat.com>
References: <18006.38689.818186.221707@notabene.brown>
	<18010.12472.209452.148229@notabene.brown>
	<20070528024559.GA85884050@sgi.com>
	<18010.17713.76863.245176@notabene.brown>
	<20070528042926.GC85884050@sgi.com>
	<18014.6860.989819.665778@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <18014.6860.989819.665778@notabene.brown>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Tejun Heo <htejun@gmail.com>, David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org, Andreas Dilger <adilger@clusterfs.com>
List-Id: dm-devel.ids

On Thu, May 31, 2007 at 10:46:04AM +1000, Neil Brown wrote:
> What if the truth changes (as can happen with md or dm)?

You get notified in endio() that the barrier had to be emulated?
 
Alasdair
-- 
agk@redhat.com
