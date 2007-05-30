From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: [RFD] BIO_RW_BARRIER - what it means for devices,
	filesystems, and dm/md.
Date: Wed, 30 May 2007 11:41:15 +0100
Message-ID: <20070530104115.GO25091@agk.fab.redhat.com>
References: <18006.38689.818186.221707@notabene.brown>
	<18010.12472.209452.148229@notabene.brown>
	<20070528094358.GM25091@agk.fab.redhat.com>
	<5201e28f0705290225v14fdac44hb0382a4137a84d01@mail.gmail.com>
	<20070529220500.GA6513@agk.fab.redhat.com>
	<5201e28f0705300212g3be16464u5ee1a4c80db27a11@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <5201e28f0705300212g3be16464u5ee1a4c80db27a11@mail.gmail.com>
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
Cc: Tejun Heo <htejun@gmail.com>, Stefan Bader <sbader3@googlemail.com>, David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org, Andreas Dilger <adilger@clusterfs.com>
List-Id: dm-devel.ids

On Wed, May 30, 2007 at 11:12:37AM +0200, Stefan Bader wrote:
> it might be better to indicate -EOPNOTSUPP right from
> device-mapper.
 
Indeed we should.  For support, on receipt of a barrier, dm core should
send a zero-length barrier to all active underlying paths, and delay
mapping any further I/O.

Alasdair
-- 
agk@redhat.com
