From: Andy Grover <agrover@redhat.com>
Subject: Re: How big should raid metadata device be?
Date: Tue, 3 Nov 2015 09:29:44 -0800
Message-ID: <5638EF08.9050907@redhat.com>
References: <5637BFBF.3010603@redhat.com> <5638075F.90602@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5638075F.90602@redhat.com>
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

On 11/02/2015 05:01 PM, Heinz Mauelshagen wrote:
> On 11/02/2015 08:55 PM, Andy Grover wrote:
>> Hi all,
>>
>> In looking at md-raid one question I had was exactly how large does
>> the metadata device need to be in comparison to the data device? It
>> contains a padded-to-4Kbyte sized raid metadata struct, and then also
>> a write intent bitmap that is sized based upon the number of stripes,
>> with 16 bits per stripe.
>
> There is no direct relationship between stripes and bitmap size, because
> the
> bitmap holds a bit per region.

Ah ok. I was confused because what dm-raid calls a chunk, mdraid calls a 
stripe, and what dm-raid calls a region, bitmap.c calls a chunk :-)

<snip example md size calculation>

I added some explanation to your size calculation and formatted it to be 
suitable to add to Documentation/device-mapper/dm-raid.txt:

The Metadata Device
-------------------
While users of dm-raid need not parse or access the contents of the
metadata device, they must still ensure it is of a certain minimum
size. Fixed-size metadata consumes 8KiB, and then one extra bit must
be allocated for each region in the raid device.

For example:

With a 64KiB region size and 1TiB raid1 set size (1TiB*Bit / 64 KiB =
16777216 Bit; 16777216 Bit / (8 Bit/Byte) / (1024 Byte/KiB) = 2048 KiB

      8 KiB fixed-size metadata
+ 2048 KiB region bitmap
-------------------------
   2056 KiB total

A device must contain fewer than 2^21 regions. With the default region
size of 4MiB this limit is reached at 8TiB. Therefore, raid devices
larger than that will need to use a larger region size, set with the
"region_size" parameter.

(end)

What do you think?

Anything else to add or change in dm-raid.txt while we're at it?

Thanks -- Regards -- Andy
