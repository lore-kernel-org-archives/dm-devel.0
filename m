From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems,
 and dm/md.
Date: Thu, 31 May 2007 14:31:21 -0400
Message-ID: <465F1479.70100@cfl.rr.com>
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown> <20070528024559.GA85884050@sgi.com> <465C871F.708@cfl.rr.com> <20070529234832.GT85884050@sgi.com> <Pine.LNX.4.64.0705291653230.31474@asgard.lang.hm> <20070530061723.GY85884050@sgi.com> <Pine.LNX.4.64.0705300946220.8246@asgard.lang.hm> <20070531002011.GC85884050@sgi.com> <20070531062644.GI32105@kernel.dk> <20070531070307.GK85884050@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070531070307.GK85884050@sgi.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, david@lang.hm, Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, Stefan Bader <Stefan.Bader@de.ibm.com>, Andreas Dilger <adilger@clusterfs.com>, Tejun Heo <htejun@gmail.com>
List-Id: dm-devel.ids

David Chinner wrote:
> That sounds like a good idea - we can leave the existing
> WRITE_BARRIER behaviour unchanged and introduce a new WRITE_ORDERED
> behaviour that only guarantees ordering. The filesystem can then
> choose which to use where appropriate....

So what if you want a synchronous write, but DON'T care about the order? 
   They need to be two completely different flags which you can choose 
to combine, or use individually.

