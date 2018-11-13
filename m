From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH] dm integrity: Document size and format of
 superblock fields
Date: Mon, 12 Nov 2018 16:23:25 -0800
Message-ID: <67a4e5bb-b826-3799-34ad-66466c93a253@redhat.com>
References: <20181109202157.5565-1-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181109202157.5565-1-agrover@redhat.com>
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
To: dm-devel@redhat.com, snitzer@redhat.com
Cc: mpatocka@redhat.com
List-Id: dm-devel.ids

On 11/9/18 12:21 PM, Andy Grover wrote:
> As mentioned elsewhere in dm-integrity.txt, creating a new integrity
> device requires creating a small integrity device on top of the base
> device that formats the base device, reading the provided data sectors
> out of the superblock, and then recreating the integrity device with the
> correct size. For this, userspace must know the offset, length, and
> endianness of the provided_data_sectors field in the superblock.
> 
> Document all fields mentioned in the txt to include this, based on struct
> superblock in dm-integrity.c. Extra fields in struct superblock not
> already mentioned in the txt remain undocumented.

In 4.19 I just noticed provided_data_sectors is now included in dm 
status. I'm assuming that is now the preferred way for userspace to 
discover this value? Thus making reading it from the on-disk superblock 
unnecessary, and thus *documenting* the superblock format unnecessary. 
Sounds good.

So please disregard this patch, although some different documentation 
changes are probably now needed.

Thanks -- Regards -- Andy

p.s. I'd just run across an issue where creating an integrity device on 
a loopback device would result in the superblock still reading as all 
zeroes. Another reason to do it the new way :)
