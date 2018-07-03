From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [dm-crypt] dm-integrity standalone - lack of metadata
Date: Tue, 3 Jul 2018 17:02:57 +0200
Message-ID: <056a42e5-d673-1a91-49e7-18fe9ce2ef7c@gmail.com>
References: <20180624095348.GA819@nn.nn>
	<c2d97932-69f0-20aa-e66a-fd6be5b5eda3@gmail.com>
	<alpine.LRH.2.02.1806251403500.26995@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1806251403500.26995@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-crypt@saout.de, Harald Braumann <harry@unheit.net>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 06/25/2018 08:05 PM, Mikulas Patocka wrote:
> On Sun, 24 Jun 2018, Milan Broz wrote:
> 
>> (added cc to dm-devel annd Mikulas)
>>
>> Hi,
>>
>> On 06/24/2018 11:53 AM, Harald Braumann wrote:
>>> Hi!
>>>
>>> I'm using the dm-integrity target standalone with crc32c for component
>>> devices of a RAID. I don't use journaling, because the perfomance hit
>>> is too big and I don't really need it in that case.
>>>
>>> I want to automatically activate these targets using udev
>>> rules (see below). However, the superblock lacks some crucial
>>> information:
>>
>>
>> yes, I agree. The reason is that dm-integrity was in the first
>> place designed for authenticated encryption (to store auth tags).
>> Then additional metadata ia stored in LUKS2 header.
>>
>> For the rest I just I have not enough energy (and real-world use cases)
>> to convince Mikulas that we need attributes below in superblock (as the dm-integrity
>> code is written mostly by him).
> 
> You can write whatever you want to the end of the superblock. If 
> kernelspace allocates superblock entries from the beginning and userspace 
> allocates them from the end, they won't cross each other.

This is really hackish solution :)

I think the superblock should be either maintained inside kernel or in userspace.

Or at least kernel superblock should define area reserved for userspace
(IOW the area that kernel guarantees to be never overwritten by kernel driver).

I really do not want to define any userspace-only attributes until there
is some plan how (and if) to integrate plain dm-integrity devices.

Milan
