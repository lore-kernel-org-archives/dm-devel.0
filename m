From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 1/3] sysfs representation of stacked devices
 (common) (rev.2)
Date: Wed, 22 Feb 2006 17:22:02 -0500
Message-ID: <43FCE40A.1010206@ce.jp.nec.com>
References: <43FC8C00.5020600@ce.jp.nec.com> <43FC8D8C.1060904@ce.jp.nec.com>
	<20060222184853.GB13638@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060222184853.GB13638@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Greg KH <gregkh@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, Lars Marowsky-Bree <lmb@suse.de>, Alasdair Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi Greg,

Thanks for comments.

Greg KH wrote:
>>+/* This is a mere directory in sysfs. No methods are needed. */
>>+static struct kobj_type bd_holder_ktype = {
>>+	.release	= NULL,
>>+	.sysfs_ops	= NULL,
>>+	.default_attrs	= NULL,
>>+};
> 
> That doesn't look right.  You always need a release function.

I'll move them out to gendisk/hd_struct creation with proper
release function.

I thought it's correct because NULL release function is
just ignored in kobject_cleanup() and it let outside function
to release the whole structure.
But it seems wrong to embed these additional kobjects in
the structures which are logically separate from them.

>>+static inline void del_holder_dir(struct block_device *bdev)
>>+{
>>+	/*
>>+	 * Don't kobject_unregister to avoid memory allocation
>>+	 * in kobject_hotplug.
>>+	 */
>>+	kobject_del(&bdev->bd_holder_dir);
>>+	kobject_put(&bdev->bd_holder_dir);
>>+}
> 
> No, do it correctly please.

OK, I'll change them to kobject_unregister() and do it
when gendisk/hd_struct is removed.
Then we can avoid possible memory allocation in dm's atomic
operation, too.

-- 
Jun'ichi Nomura, NEC Solutions (America), Inc.
