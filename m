From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [dm-devel] [PATCH 8/9] scsi: sd_zbc: Cleanup
 sd_zbc_alloc_report_buffer()
Date: Sat, 9 Nov 2019 02:54:58 +0000
Message-ID: <BYAPR04MB5816C442BE08F9973C2CDF15E77A0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20191108015702.233102-1-damien.lemoal@wdc.com>
 <20191108015702.233102-9-damien.lemoal@wdc.com>
 <6a1e0a08-d65c-b075-9bac-23519e9e91c3@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Bart Van Assche <bvanassche@acm.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K .
 Petersen" <martin.petersen@oracle.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "linux-f2fs-devel@lists.sourceforge.net" <linux-f2fs-devel@lists.sourceforge.net>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>
List-Id: dm-devel.ids

On 2019/11/09 4:06, Bart Van Assche wrote:
> On 11/7/19 5:57 PM, Damien Le Moal wrote:
>> -	buf = vzalloc(bufsize);
>> -	if (buf)
>> -		*buflen = bufsize;
>> +	while (bufsize >= SECTOR_SIZE) {
>> +		buf = vzalloc(bufsize);
>> +		if (buf) {
>> +			*buflen = bufsize;
>> +			return buf;
>> +		}
>> +		bufsize >>= 1;
>> +	}
> 
> Hi Damien,
> 
> Has it been considered to pass the __GFP_NORETRY flag to this vzalloc() 
> call?

Do you mean using

__vmalloc(bufsize,
	  GFP_KERNEL | __GFP_ZERO | __GFP_NORETRY, PAGE_KERNEL);

instead of vzalloc() ? (since we cannot pass GFP flags to vzalloc()...)

Note that this is called with GFP_NOIO set for the caller context in the
case of revalidate zones, and default to GFP_KERNEL for
blkdev_report_zones() unless the caller also tweaks the context memalloc
flags.

> 
> Thanks,
> 
> Bart.
> 


-- 
Damien Le Moal
Western Digital Research
