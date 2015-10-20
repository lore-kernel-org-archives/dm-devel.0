From: Bogdan Vasiliev <bogdan.vasiliev@gmail.com>
Subject: Re: dm-cache: clean cache resyncs to origin on every boot
Date: Tue, 20 Oct 2015 23:06:07 +0500
Message-ID: <CAGRJ0wrPEo9m0kKeGy0U9BErKC=_GGUUgfgJn=NZm2cQpHnb3w@mail.gmail.com>
References: <CAGRJ0wqVAcNkEJsW5o2vYPFY3doL1Nt5oD8M78w3gvL+t2Xnsw@mail.gmail.com>
	<20151020143304.GA15948@rh-vpn>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
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

On 20 October 2015 at 19:33, Joe Thornber <thornber@redhat.com> wrote:
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
>
> If the cache is not taken down cleanly then dm-cache has to assume
> every block is dirty.  Make sure your shutdown scripts are removing
> the cache device.

How I do it:
# umount /dev/mapper/storage-data
# lvs  -o lv_name, cache_dirty_blocks
  LV   CacheDirtyBlocks
  data                0
# sync
# dmsetup remove_all
# vgchange -ay
  1 logical volume(s) in volume group "storage" now active
# lvs  -o lv_name, cache_dirty_blocks
  LV   CacheDirtyBlocks
  data           122657

Volume was clearly removed without dirty cahe blocks, re-initialized
and began full re-sync to the origin. Is this normal behavior?


>> My configuration details, if necessary:
>> storage-cache_cdata:0 41943040 linear
>> storage-cache_cmeta: 0 1048576 linear
>> storage-data: 0 1953513472 cache 8 989/131072 128 173945/327680 610488
>> 20046 574861 3817439 0 0 0 1 writeback 2 migration_threshold 2048 mq
>> 10 random_threshold 4 sequential_threshold 512
>> discard_promote_adjustment 1 read_promote_adjustment 4
>> write_promote_adjustment 8 rw -
>> storage-data_corig: 0 1953513472 linear
