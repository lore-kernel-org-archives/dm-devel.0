From: Maged Mokhtar <mmokhtar@petasan.org>
Subject: Re: dm-writecache: change config parameters using
	messages
Date: Thu, 7 Nov 2019 20:55:19 +0200
Message-ID: <5370f009-c324-1530-4400-adf1b59f0bbd@petasan.org>
References: <fa95f1f0-67d6-d02e-6999-ba1f90d70fe2@petasan.org>
	<8388b99a-a531-981e-9e36-8aeb3dffd18e@petasan.org>
	<20191106150831.GA27888@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191106150831.GA27888@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, mpatocka@redhat.com
List-Id: dm-devel.ids



On 06/11/2019 17:08, Mike Snitzer wrote:
> On Tue, Nov 05 2019 at  4:19pm -0500,
> Maged Mokhtar <mmokhtar@petasan.org> wrote:
> 
>> Gentle ping please.
>>
>> It could add flexibility in changing cache parameters after device creation.
> 
> I'm inclined to _not_ take this type of change.
> 
> Why isn't changing the config parameters via table reload viable for
> you?
> 


Hi Mike,

Thank you for your response. The main issue is to enable setting some 
config parameters while the device is mounted and running and avoid 
calling target ctr() by sending parameter changes via messages. A 
similar setup was used in dm-cache.

The reason is that tuning the write cache may require run time changes. 
If un-tuned we can observes periods of spikes and/or step like disk 
utilization on the slow device during writeback using iostat, and these 
spikes correspond to periods of increased client io latency. Utilization 
can be tuned by varying the number of active writeback jobs + the gap 
between high and low marks to achieve a smooth high utilization.  Such 
tuning is difficult to do when creating the cache device as it depends 
on the hardware and io workload. We are hoping to use some userspace 
monitoring and tuning tool to periodically adjust these values while the 
device is running.

/Maged
