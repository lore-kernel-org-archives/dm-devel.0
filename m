From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems,
 and dm/md.
Date: Fri, 01 Jun 2007 19:56:13 -0400
Message-ID: <4660B21D.9030801@tmr.com>
References: <20070528024559.GA85884050@sgi.com>	<465C871F.708@cfl.rr.com>	<20070529234832.GT85884050@sgi.com>	<Pine.LNX.4.64.0705291653230.31474@asgard.lang.hm>	<20070530061723.GY85884050@sgi.com>	<Pine.LNX.4.64.0705300946220.8246@asgard.lang.hm>	<20070531002011.GC85884050@sgi.com>	<20070531062644.GI32105@kernel.dk>	<20070531070307.GK85884050@sgi.com>	<465F1479.70100@cfl.rr.com>	<20070531233449.GT86004887@sgi.com> <18015.46551.209946.204238@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18015.46551.209946.204238@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: David Chinner <dgc@sgi.com>, Phillip Susi <psusi@cfl.rr.com>, Jens Axboe <jens.axboe@oracle.com>, david@lang.hm, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, Stefan Bader <Stefan.Bader@de.ibm.com>, Andreas Dilger <adilger@clusterfs.com>, Tejun Heo <htejun@gmail.com>
List-Id: dm-devel.ids

Neil Brown wrote:
> On Friday June 1, dgc@sgi.com wrote:
>   
>> On Thu, May 31, 2007 at 02:31:21PM -0400, Phillip Susi wrote:
>>     
>>> David Chinner wrote:
>>>       
>>>> That sounds like a good idea - we can leave the existing
>>>> WRITE_BARRIER behaviour unchanged and introduce a new WRITE_ORDERED
>>>> behaviour that only guarantees ordering. The filesystem can then
>>>> choose which to use where appropriate....
>>>>         
>>> So what if you want a synchronous write, but DON'T care about the order? 
>>>       
>> submit_bio(WRITE_SYNC, bio);
>>
>> Already there, already used by XFS, JFS and direct I/O.
>>     
>
> Are you sure?
>
> You seem to be saying that WRITE_SYNC causes the write to be safe on
> media before the request returns.  That isn't my understanding.
> I think (from comments near the definition and a quick grep through
> the code) that WRITE_SYNC expedites the delivery of the request
> through the elevator, but doesn't do anything special about getting it
> onto the media.

My impression is that the sync will return when the i/o has been 
delivered to the device, and will get special treatment by the elevator 
code (I looked quickly, more is needed). I'm sore someone will tell me 
if I misread this. ;-)

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

