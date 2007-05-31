From: david@lang.hm
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices,
 filesystems, and dm/md.
Date: Thu, 31 May 2007 12:21:31 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0705311220080.17389@asgard.lang.hm>
References: <20070528024559.GA85884050@sgi.com> <465C871F.708@cfl.rr.com>
	<20070529234832.GT85884050@sgi.com>
	<Pine.LNX.4.64.0705291653230.31474@asgard.lang.hm>
	<20070530061723.GY85884050@sgi.com>
	<Pine.LNX.4.64.0705300946220.8246@asgard.lang.hm>
	<20070531002011.GC85884050@sgi.com> <20070531062644.GI32105@kernel.dk>
	<20070531070307.GK85884050@sgi.com> <465F1479.70100@cfl.rr.com>
	<20070531190013.GD32105@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070531190013.GD32105@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Tejun Heo <htejun@gmail.com>, David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, Andreas Dilger <adilger@clusterfs.com>
List-Id: dm-devel.ids

On Thu, 31 May 2007, Jens Axboe wrote:

> On Thu, May 31 2007, Phillip Susi wrote:
>> David Chinner wrote:
>>> That sounds like a good idea - we can leave the existing
>>> WRITE_BARRIER behaviour unchanged and introduce a new WRITE_ORDERED
>>> behaviour that only guarantees ordering. The filesystem can then
>>> choose which to use where appropriate....
>>
>> So what if you want a synchronous write, but DON'T care about the order?
>>   They need to be two completely different flags which you can choose
>> to combine, or use individually.
>
> If you have a use case for that, we can easily support it as well...
> Depending on the drive capabilities (FUA support or not), it may be
> nearly as slow as a "real" barrier write.

true, but a "real" barrier write could have significant side effects on 
other writes that wouldn't happen with a synchronous wrote (a sync wrote 
can have other, unrelated writes re-ordered around it, a barrier write 
can't)

David Lang
