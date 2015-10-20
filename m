From: sbp <sbp@extio.de>
Subject: Re: dm-cache: clean cache resyncs to origin on every boot
Date: Tue, 20 Oct 2015 20:00:25 +0200
Message-ID: <56268139.9010901@extio.de>
References: <CAGRJ0wqVAcNkEJsW5o2vYPFY3doL1Nt5oD8M78w3gvL+t2Xnsw@mail.gmail.com>
	<20151020143304.GA15948@rh-vpn>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20151020143304.GA15948@rh-vpn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 10/20/2015 04:33 PM, Joe Thornber wrote:
> On Tue, Oct 20, 2015 at 11:51:07AM +0500, Bogdan Vasiliev wrote:
>> Hello,
>>
>> I have dm-cache configuraion with SSD in writeback mode. On every boot
>> an entire cache resyncs to an origin device, even if it was clean
>> before on shutdown. It takes time and full bandwidth of an origin
>> device.
>>
>> Is there reason for this behavior or is it a bug? Why we do not trust
>> a cache metadata?
> If the cache is not taken down cleanly then dm-cache has to assume
> every block is dirty.  Make sure your shutdown scripts are removing
> the cache device.

Hi,

I have the same problem, but also in writethrough mode. In principle the 
behavior is the same in writethrough and writeback modes: Cache is fully 
written back to disk every time the machine boots and sets the cache up.

I've posted a similar report to this list beginning of this month, but 
got no answer. There is my exact startup and shutdown script included, 
also some additional information about the setup. 
https://www.redhat.com/archives/dm-devel/2015-October/msg00012.html

>
>> My configuration details, if necessary:
>> storage-cache_cdata:0 41943040 linear
>> storage-cache_cmeta: 0 1048576 linear
>> storage-data: 0 1953513472 cache 8 989/131072 128 173945/327680 610488
>> 20046 574861 3817439 0 0 0 1 writeback 2 migration_threshold 2048 mq
>> 10 random_threshold 4 sequential_threshold 512
>> discard_promote_adjustment 1 read_promote_adjustment 4
>> write_promote_adjustment 8 rw -
>> storage-data_corig: 0 1953513472 linear
>>
>>
>> - Bogdan
>>
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
