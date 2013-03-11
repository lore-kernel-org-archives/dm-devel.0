From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: How to use dm-cache-target?
Date: Mon, 11 Mar 2013 18:11:07 +0100
Message-ID: <513E102B.6010906@redhat.com>
References: <513D4137.5090503@gmail.com> <20130311103152.GA5038@raspberrypi>
	<20130311170417.GB6528@blackbox.djwong.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130311170417.GB6528@blackbox.djwong.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Dne 11.3.2013 18:04, Darrick J. Wong napsal(a):
> On Mon, Mar 11, 2013 at 10:31:53AM +0000, thornber@redhat.com wrote:
>> On Mon, Mar 11, 2013 at 10:28:07AM +0800, majianpeng wrote:
>>> Hi all,
>>>      I am trying to use dm-cache-target on raid5.But i met a question.
>>>
>>>   Supposed: /dev/sdb1(5GB) is metadata; /dev/sdb2(20GB) is cache;/dev/md0 is raid5.
>>>
>>> 1:sutup my_cache
>>> dmsetup create my_cache --table '0 41943040 cache /dev/sdb1 /dev/sdb2 /dev/md0 131072 1 writethrough default 0'
>>
>> 41943040 - This is 20G, you should use the size of /dev/md0 in sectors
>>
>> Also I think your block size is way too big, try 2048 rather tha 131072.
>>
>>> BTW, for dm-cache is it support plug-and-play?
>>
>> No idea what you mean.
>
> I suspect the poster's asking if dmcaches will automatically reassemble
> themselves.
>
> I've been wondering myself what's the status of the lvm-tools integration? :)
>

On-going - will be integrated within some months.

Zdenek
