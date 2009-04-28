From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 5/7] dm core: reject I/O violating new queue
	limits
Date: Tue, 28 Apr 2009 16:49:29 +0900
Message-ID: <49F6B509.4000708@ct.jp.nec.com>
References: <49F17409.4060201@ct.jp.nec.com> <49F17510.7010805@ct.jp.nec.com>
	<49F17F74.6010307@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49F17F74.6010307@suse.de>
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
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Hannes,

On 2009/04/24 17:59 +0900, Hannes Reinecke wrote:
> Hi Kiyoshi,
> 
> Kiyoshi Ueda wrote:
>> This patch detects requests violating the queue limitations
>> and rejects them.
>>
>> The same limitation checks are done when requests are submitted
>> to the queue by blk_insert_cloned_request().
>> However, such violation can happen if a table is swapped and
>> the queue limitations are shrunk while some requests are
>> in the queue.
>>
>> Since struct request is a reliable one in the block layer and
>> device drivers, dispatching such requests is pretty dangerous.
>> (e.g. it may cause kernel panic easily.)
>> So avoid to dispatch such problematic requests in request-based dm.
>>
> This patch actually triggers accidentally during a no-paths scenario;
> multipathing seems to flush all device details once all paths are gone,
> so it'll fall back to the system defaults.
> And then this check will trigger and kill all queued I/Os. Not good.
> 
> So either we fix device-mapper to keep the device details even for
> the all-paths down scenario (basically we'd have to copy the device
> details into the target_io structures and use that for comparison)
> or we should rather not check here.

Thank you for your review and the comment.
I haven't understood the problem correctly yet.
(e.g. Who flush the device details and how?  Restrictions are
 changed when the table is swapped, but no table swapping should happen
 even if the last path is gone while the device is in use.)

Unfortunately, I can't read/send e-mail from Apr 29th throught May 7th
because of long national holidays in Japan.
I'll look at it after the holidays.

> Cheers,
> 
> Hannes

Thanks,
Kiyoshi Ueda
