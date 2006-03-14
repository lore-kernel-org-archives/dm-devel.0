From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 4/7] dm/md dependency tree in sysfs:
	bd_claim_by_disk
Date: Mon, 13 Mar 2006 18:29:43 -0800
Message-ID: <20060313182943.437c0d43.akpm@osdl.org>
References: <4415EC4B.4010003@ce.jp.nec.com> <4415EF35.2010402@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4415EF35.2010402@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, dm-devel@redhat.com, lmb@suse.de, agk@redhat.com
List-Id: dm-devel.ids

"Jun'ichi Nomura" <j-nomura@ce.jp.nec.com> wrote:
>
>  Variants of bd_claim_by_kobject which takes gendisk instead
>  of kobject and do kobject_{get,put}(&gendisk->slave_dir).
> 
>  Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> 
>   include/linux/genhd.h |   13 +++++++++++++
>   1 files changed, 13 insertions(+)
> 
>  --- linux-2.6.16-rc6.orig/include/linux/genhd.h	2006-03-11 17:12:55.000000000 -0500
>  +++ linux-2.6.16-rc6/include/linux/genhd.h	2006-03-13 11:24:13.000000000 -0500
>  @@ -421,6 +424,19 @@ static inline struct block_device *bdget
>   	return bdget(MKDEV(disk->major, disk->first_minor) + index);
>   }
>   
>  +static inline int bd_claim_by_disk(struct block_device *bdev,
>  +					void *holder, struct gendisk *disk)
>  +{
>  +	return bd_claim_by_kobject(bdev, holder, kobject_get(disk->slave_dir));
>  +}
>  +
>  +static inline void bd_release_from_disk(struct block_device *bdev,
>  +					struct gendisk *disk)
>  +{
>  +	bd_release_from_kobject(bdev, disk->slave_dir);
>  +	kobject_put(disk->slave_dir);
>  +}
>  +

genhd.h doesn't include kobject.h, so this only compiles due to luck.

An alternative to adding possibly risky nested header inclusions would be
to uninline these functions.
