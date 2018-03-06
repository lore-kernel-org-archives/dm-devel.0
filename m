From: "=?ISO-8859-1?B?V2FuZyBTaGVuZy1IdWk=?=" <shhuiw@foxmail.com>
Subject: confusion about multipath_prepare_ioctl
Date: Tue, 6 Mar 2018 11:35:37 +0800
Message-ID: <tencent_16F29DEA1877E6C6D13CB47D4E3B41358508@qq.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: =?ISO-8859-1?B?aGNo?= <hch@lst.de>, =?ISO-8859-1?B?c25pdHplcg==?= <snitzer@redhat.com>
Cc: =?ISO-8859-1?B?ZG0tZGV2ZWw=?= <dm-devel@redhat.com>
List-Id: dm-devel.ids

Dear,

Sorry to trouble you.

I noticed some code in dm-*.c like:
"
static int multipath_prepare_ioctl(struct dm_target *ti,
		struct block_device **bdev, fmode_t *mode)
{
...
	/*
	 * Only pass ioctls through if the device sizes match exactly.
	 */
	if (!r && ti->len != i_size_read((*bdev)->bd_inode) >> SECTOR_SHIFT)
		return 1;
...
}
"
Here, return value 1 means 
"ioctl is being issued against a subset of the parent bdev; require extra privileges."
(comment in dm_blk_ioctl)

I'm confused by the comment and '!=' test for multipath. 
In which cases, the size of low level single device is not equal to the parent 
size of multipath device?


Regards,
shenghui
