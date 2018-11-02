From: Milan Broz <gmazyland@gmail.com>
Subject: Re: dm crypt: use unsigned long long instead of sector_t
 to store iv_offset
Date: Fri, 2 Nov 2018 08:36:56 +0100
Message-ID: <20a82f81-071e-e742-fc18-2088853efb0f@gmail.com>
References: <1541062439-55558-1-git-send-email-alios_sys_security@linux.alibaba.com>
	<20181101200642.GA29073@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181101200642.GA29073@redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>, AliOS system security <alios_sys_security@linux.alibaba.com>
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 01/11/2018 21:06, Mike Snitzer wrote:
> On Thu, Nov 01 2018 at  4:53am -0400,
> AliOS system security <alios_sys_security@linux.alibaba.com> wrote:
> 
>> The iv_offset in the mapping table of crypt target is a 64bit number
>> when iv mode is plain64 or plain64be. It will be assigned to iv_offset of
>> struct crypt_config, cc_sector of struct convert_context and iv_sector of
>> struct dm_crypt_request. These structures members are defined as a sector_t.
>> But sector_t is 32bit when CONFIG_LBDAF is not set in 32bit kernel. In this
>> situation sector_t is not big enough to store the 64bit iv_offset.
> 
> I really don't think this is needed.
> 
> cc->iv_offset can only address a the address space used to access the
> device.  Which is expressed in terms of sectors.  Therefore if
> CONFIG_LBDAF is not set in 32bit kernel then there is no need to address
> beyond that which 'sector_t' addresses.

Hi,

The iv_offset is Initialization Vector offset (for symmetric block cipher)
that is not in principle limited by the device size sector offset.
It is just an additional tweak to the cipher mode IV.

If we use 32bit only for 64bit IV, it is wrong and a patch is needed.

> Please show proof to the contrary if you still think this change is
> needed.

It is easy to reproduce, even it shows this causes data corruption:

# dd if=/dev/zero of=tst.img bs=1M count=1

On 32bit system (use IV offset value that overflows to 64bit; CONFIG_LBDAF if off)
(and note IV value overflow in table!!)

# echo "tst"|cryptsetup open --type plain -c aes-xts-plain64 --skip 500000000000000000 tst.img test

# sha256sum /dev/mapper/test
533e25c09176632b3794f35303488c4a8f3f965dffffa6ec2df347c168cb6c19  /dev/mapper/test

# dmsetup table test
0 2048 crypt aes-xts-plain64 0000000000000000000000000000000000000000000000000000000000000000 3551657984 7:0 0

On 64bit system (the same image):

# echo "tst"|cryptsetup open --type plain -c aes-xts-plain64 --skip 500000000000000000 tst.img test

# sha256sum /dev/mapper/test
5d16160f9d5f8c33d8051e65fdb4f003cc31cd652b5abb08f03aa6fce0df75fc  /dev/mapper/test

# dmsetup table test
0 2048 crypt aes-xts-plain64 0000000000000000000000000000000000000000000000000000000000000000 500000000000000000 7:0 0

This must be fixed, thanks for reporting it!

Unfortunately I still do not see the original patch in the list you are replying to.

Once it is on the list, I'll ack it.

Thanks,
Milan
