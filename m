From: "Stefan Bader" <Stefan.Bader@de.ibm.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices,
	filesystems, and dm/md.
Date: Wed, 30 May 2007 10:55:13 +0200
Message-ID: <5201e28f0705300155ue7ce985m3f318ff7ff1a1396@mail.gmail.com>
References: <18006.38689.818186.221707@notabene.brown>
	<18010.12472.209452.148229@notabene.brown>
	<20070528024559.GA85884050@sgi.com> <465C871F.708@cfl.rr.com>
	<20070529234832.GT85884050@sgi.com>
	<Pine.LNX.4.64.0705291653230.31474@asgard.lang.hm>
	<20070530061723.GY85884050@sgi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070530061723.GY85884050@sgi.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: David Chinner <dgc@sgi.com>
Cc: david@lang.hm, Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org, Andreas Dilger <adilger@clusterfs.com>
List-Id: dm-devel.ids

> The order that these are expected by the filesystem to hit stable
> storage are:
>
> 1. block 4 and 10 on stable storage in any order
> 2. barrier block X on stable storage
> 3. block 5 and 20 on stable storage in any order
>
> The point I'm trying to make is that in XFS,  block 5 and 20 cannot
> be allowed to hit the disk before the barrier block because they
> have strict order dependency on block X being stable before them,
> just like block X has strict order dependency that block 4 and 10
> must be stable before we start the barrier block write.
>

That would be the exactly how I understand Documentation/block/barrier.txt:

"In other words, I/O barrier requests have the following two properties.
1. Request ordering
...
2. Forced flushing to physical medium"

"So, I/O barriers need to guarantee that requests actually get written
to non-volatile medium in order."

Stefan
