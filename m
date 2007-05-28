From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: [RFD] BIO_RW_BARRIER - what it means for devices,
	filesystems, and dm/md.
Date: Mon, 28 May 2007 10:43:58 +0100
Message-ID: <20070528094358.GM25091@agk.fab.redhat.com>
References: <18006.38689.818186.221707@notabene.brown>
	<18010.12472.209452.148229@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <18010.12472.209452.148229@notabene.brown>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, David Chinner <dgc@sgi.com>, Phillip Susi <psusi@cfl.rr.com>, Stefan Bader <Stefan.Bader@de.ibm.com>, Andreas Dilger <adilger@clusterfs.com>, Tejun Heo <htejun@gmail.com>
List-Id: dm-devel.ids

On Mon, May 28, 2007 at 11:30:32AM +1000, Neil Brown wrote:
> 1/ A BIO_RW_BARRIER request should never fail with -EOPNOTSUP.
 
The device-mapper position has always been that we require

>  a zero-length BIO_RW_BARRIER 

(i.e. containing no data to read or write - or emulated, possibly
device-specific)

before we can provide full barrier support.
  (Consider multiple active paths - each must see barrier.)

Until every device supports barriers -EOPNOTSUP support is required.
  (Consider reconfiguration of stacks of devices - barrier support is a
   dynamic block device property that can switch between available and
   unavailable at any time.)

Alasdair
-- 
agk@redhat.com
