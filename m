From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 5/7] dm core: reject I/O violating new queue
	limits
Date: Tue, 23 Jun 2009 14:46:58 +0900
Message-ID: <4A406C52.4090304@ct.jp.nec.com>
References: <49F17409.4060201@ct.jp.nec.com>
	<49F17510.7010805@ct.jp.nec.com>	<49F17F74.6010307@suse.de>
	<49F6B509.4000708@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49F6B509.4000708@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Hannes,

I'm very sorry for the huge delay, but please see below.

On 2009/04/28 16:49 +0900, Kiyoshi Ueda wrote:
> Hi Hannes,
> 
> On 2009/04/24 17:59 +0900, Hannes Reinecke wrote:
>> Hi Kiyoshi,
>>
>> Kiyoshi Ueda wrote:
>>> This patch detects requests violating the queue limitations
>>> and rejects them.
>>>
>>> The same limitation checks are done when requests are submitted
>>> to the queue by blk_insert_cloned_request().
>>> However, such violation can happen if a table is swapped and
>>> the queue limitations are shrunk while some requests are
>>> in the queue.
>>>
>>> Since struct request is a reliable one in the block layer and
>>> device drivers, dispatching such requests is pretty dangerous.
>>> (e.g. it may cause kernel panic easily.)
>>> So avoid to dispatch such problematic requests in request-based dm.
>>>
>> This patch actually triggers accidentally during a no-paths scenario;
>> multipathing seems to flush all device details once all paths are gone,
>> so it'll fall back to the system defaults.
>> And then this check will trigger and kill all queued I/Os. Not good.
>>
>> So either we fix device-mapper to keep the device details even for
>> the all-paths down scenario (basically we'd have to copy the device
>> details into the target_io structures and use that for comparison)
>> or we should rather not check here.
> 
> Thank you for your review and the comment.
> I haven't understood the problem correctly yet.
> (e.g. Who flush the device details and how?  Restrictions are
>  changed when the table is swapped, but no table swapping should happen
>  even if the last path is gone while the device is in use.)

I tried to understand/reproduce your scenario, but I can't.
I found a bug (http://marc.info/?l=dm-devel&m=124572577028515&w=2)
during my testing (which lets all paths down at once), but it is
an user-space bug, not a kernel bug.

Could you elaborate your problem related to the patch, if you have
detailed analisys?
(e.g. I can't see the code-path which flushes device details
      on an all-paths down scenario.)

Thanks,
Kiyoshi Ueda
