From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: Queuing of dm-raid1 resyncs to the same underlying
 block devices
Date: Thu, 1 Oct 2015 12:09:44 +0200
Message-ID: <560D0668.50300@redhat.com>
References: <20150926154902.GA2964@alpha.arachsys.com>
	<64020C6E-98B1-4139-A88C-0EC65493CCF9@redhat.com>
	<560BEB14.3060701@redhat.com> <87si5vk0rz.fsf@notabene.neil.brown.name>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <87si5vk0rz.fsf@notabene.neil.brown.name>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Neil Brown <neilb@suse.de>, Brassow Jonathan <jbrassow@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids



On 10/01/2015 12:20 AM, Neil Brown wrote:
> Heinz Mauelshagen <heinzm@redhat.com> writes:
>> BTW:
>> When you create a raid1/4/5/6/10 LVs _and_ never read what you have not
>> written,
>> "--nosync" can be used anyway in order to avoid the initial
>> resynchronization load
>> on the devices. Any data written in that case will update all
>> mirrors/raid redundancy data.
>>
> While this is true for RAID1 and RAID10, and (I think) for the current
> implementation of RAID6, it is definitely not true for RAID4/5.

Thanks for the clarification.

I find that to be really bad situation.


>
> For RAID4/5 a single-block write will be handled by reading
> old-data/parity, subtracting the old data from the parity and adding the
> new data, then writing out new data/parity.

Obviously for optimization reasons.

> So if the parity was wrong before, it will be wrong afterwards.

So even overwriting complete stripes in raid4/5/(6)
would not ensure correct parity, thus always requiring
initial sync.

We should think about a solution to avoid it in lieu
of growing disk/array sizes.


Heinz


>
> If the device that new data was written to then fails, the data on it is
> lost.
>
> So do this for RAID1/10 if you like, but not for other levels.
>
> NeilBrown
