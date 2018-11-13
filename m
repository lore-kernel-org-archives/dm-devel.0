From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH] dm integrity: Document size and format of
 superblock fields
Date: Tue, 13 Nov 2018 19:29:43 +0100
Message-ID: <b9d37d1b-dad5-9473-fe77-fa75c50b6283@gmail.com>
References: <20181109202157.5565-1-agrover@redhat.com>
	<67a4e5bb-b826-3799-34ad-66466c93a253@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <67a4e5bb-b826-3799-34ad-66466c93a253@redhat.com>
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
To: Andy Grover <agrover@redhat.com>, dm-devel@redhat.com, snitzer@redhat.com
Cc: mpatocka@redhat.com
List-Id: dm-devel.ids

On 13/11/2018 01:23, Andy Grover wrote:
> On 11/9/18 12:21 PM, Andy Grover wrote:
>> As mentioned elsewhere in dm-integrity.txt, creating a new integrity
>> device requires creating a small integrity device on top of the base
>> device that formats the base device, reading the provided data sectors
>> out of the superblock, and then recreating the integrity device with the
>> correct size. For this, userspace must know the offset, length, and
>> endianness of the provided_data_sectors field in the superblock.
>>
>> Document all fields mentioned in the txt to include this, based on struct
>> superblock in dm-integrity.c. Extra fields in struct superblock not
>> already mentioned in the txt remain undocumented.> 
> In 4.19 I just noticed provided_data_sectors is now included in dm 
> status. I'm assuming that is now the preferred way for userspace to 
> discover this value? Thus making reading it from the on-disk superblock 
> unnecessary, and thus *documenting* the superblock format unnecessary. 
> Sounds good.

Yes, I think Mikulas added this for this reason. We still read
superblock in integritysetup to be compatible with the older targets,
but you should not need it with 4.19+.

> So please disregard this patch, although some different documentation 
> changes are probably now needed.
Actually, meta_device option is not documented at all, and new status
line is undocumented as well (I can send patch for this later).

Anyway,  I have another page that describes dm-integrity options
(maintaining this while adding options to integritysetup, similar page
exists for DMcrypt and DMverity)
https://gitlab.com/cryptsetup/cryptsetup/wikis/DMIntegrity

m.
