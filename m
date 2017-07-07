From: Milan Broz <gmazyland@gmail.com>
Subject: Re: dm-integrity
Date: Fri, 7 Jul 2017 12:47:47 +0200
Message-ID: <ce9f9bdb-cb04-097d-5628-4f4ea0155195@gmail.com>
References: <bbf2a91d-2eac-5b10-903d-50939acfb57a@yandex.ru>
	<4d2e0176-071a-1cb4-3eaa-3c3552a2ce09@gmail.com>
	<0d01c698-211e-a969-8c4a-e6bb4ab2cf9b@yandex.ru>
	<96314674-1b66-ce91-732e-17901d1f3236@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <96314674-1b66-ce91-732e-17901d1f3236@yandex.ru>
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
To: Renesanso <renesanso@yandex.ru>, mpatocka@redhat.com, dm-devel@redhat.com, dmitry.kasatkin@huawei.com
List-Id: dm-devel.ids

On 07/05/2017 06:45 PM, Renesanso wrote:
> 1. And in this ( 
> https://kernel.googlesource.com/pub/scm/linux/kernel/git/kasatkin/linux-digsig/+/2dfa67a1a4c049fd33fcc6abcb1c8ca57b17a268/Documentation/device-mapper/dm-integrity.txt 
> ) implementation gives variant to use external device for metadata and 
> journal. It really affect perfomance, I think. Do you plan do analogue 
> functions?

Not yet. The design was meant for authenticated extension and cryptsetup
has only one device as a backend (I really do not want to make it another volume manager :)
(It is not easy task to solve the situation when the separate devices are out of sync,
and security implications only complicates it more.)

But I can imagine that if there is some strong use case, it can be added there.

(As said, it was not means as straight replacement of the module mentioned above;
the name clash is just my stupid coincidence.)

> 2. And other question: in your implementation tags write rarery after 
> data (eg. data[512b], tag[32b], data [512b], tag[32b]) or data stores in 
> one "half" of disk and tags in another (in end of disk, example)? Second 
> variant gives VERY HUGE penalty on hdd's.

Tags are written into metadata sectors that are interleaved with normal
data sectors. (This allow us to resize the device later.)

There are multiple tags in one metadata sector and dm-integrity
provides all the infrastructure to perform atomic write of sector+metadata.

> 3. And can, as I see there many options (as journal, buffers and other). 
> Can you give me example of parameters configuration, that fully 
> correctly work in production (KVMs- VMs -> raw -> EXT4 -> LVM -> MD -> 
> multiple dm-integrity on multiple phisical disks )?

Sorry, I do not have any "good practices" or any configurations yet.
In fact, I am still curious what use cases people can find for it :)

There is a lot of things to fine-tune though. But the initial
penalty of using data journal will be always big.
(You can switch journalling off if it is already on higher layer.)

The whole integrity/crypt stack was meant for experiments with
authenticated encryption on the sector level (and with expected
performance penalty - security is the first class citizen here).

I will try to put some more info into some blog soon.

Thanks,
Milan
