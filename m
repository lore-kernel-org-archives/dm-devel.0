From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH] dm-zoned: Fix overflow when converting zone
	ID to sectors
Date: Tue, 11 Jul 2017 10:52:15 +0900
Message-ID: <922ccc89-9e70-a4bc-ad60-0dd34e8fbabf@wdc.com>
References: <20170703064458.8091-1-damien.lemoal@wdc.com>
	<1499703955.3555.11.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1499703955.3555.11.camel@wdc.com>
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
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "agk@redhat.com" <agk@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>
List-Id: dm-devel.ids

Bart,

On 7/11/17 01:25, Bart Van Assche wrote:
> On Mon, 2017-07-03 at 15:44 +0900, Damien Le Moal wrote:
>> A zone ID is a 32 bits unsigned int which can overflow when doing the
>> bit shifts calculations in dmz_start_sect(). With a 256 MB zone size
>> drive, the overflow happens for a zone ID >= 8192.
> 
> Does the data from this example apply to a sector size of 512 bytes only?
> Should this be mentioned in the patch description?

This is with BIO level 512B sectors addressing unit, which is used even
with 4K LBA drives. So I did not mention it. I should have to be clear.

Best regards.

-- 
Damien Le Moal,
Western Digital
