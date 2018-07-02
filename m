From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re:
 =?utf-8?b?562U5aSNOiDnrZTlpI06IOetlOWkjTogIHdoeSBjb21t?=
 =?utf-8?q?and_of_multipath_send_reinstate_message_to_all_dm=27s_paths?=
Date: Mon, 2 Jul 2018 07:48:49 -0700
Message-ID: <d39a6f9b-e195-6ae7-2284-b00d4bebb7c5@wdc.com>
References: <F0921BF66894AB498DE908B06C95871AB06F952B@nkgeml513-mbx.china.huawei.com>
	<e2b2de951f0db73aaf188b12c34f7cf0a9a34aa7.camel@suse.com>
	<F0921BF66894AB498DE908B06C95871AB06F9785@nkgeml513-mbx.china.huawei.com>
	<86cd2783019e5a6fa8c97a13716273146fd9e434.camel@suse.com>
	<F0921BF66894AB498DE908B06C95871AB06F9ADE@nkgeml513-mbx.china.huawei.com>
	<276102574789d2f0db0a7985e6586780029e27ca.camel@suse.com>
	<F0921BF66894AB498DE908B06C95871AB06F9BDB@nkgeml513-mbx.china.huawei.com>
	<e259203417d9b904ebbc0b4b14c072b1b92fdba7.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <e259203417d9b904ebbc0b4b14c072b1b92fdba7.camel@suse.com>
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
To: Martin Wilck <mwilck@suse.com>, Jiaojianbing <jiaojianbing@huawei.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>, Douglas Gilbert <dgilbert@interlog.com>
Cc: gaowanlong <gaowanlong@huawei.com>, "Wencongyang (UVP)" <wencongyang2@huawei.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "Yangjie (S)" <yangjieyj.yang@huawei.com>, "Zhangyanfei (UVP)" <yanfei.zhang@huawei.com>
List-Id: dm-devel.ids

On 07/02/18 02:20, Martin Wilck wrote:
> On Mon, 2018-07-02 at 08:53 +0000, Jiaojianbing wrote:
>> [ ... ]
>> and one of D process's stack:
>> # cat /proc/3659 /stack
>> [<ffffffff8118e784>] __lock_page+0x74/0x90
>> [<ffffffff811a0564>] truncate_inode_pages_range+0x704/0x740
>> [<ffffffff811a05b5>] truncate_inode_pages+0x15/0x20
>> [<ffffffff812519af>] kill_bdev+0x2f/0x40
>> [<ffffffff81253464>] __blkdev_put+0x64/0x1a0
>> [<ffffffff81253eee>] blkdev_put+0x4e/0x140
>> [<ffffffff81254095>] blkdev_close+0x25/0x30
>> [<ffffffff8121796c>] __fput+0xec/0x260
>> [<ffffffff81217c1e>] ____fput+0xe/0x10
>> [<ffffffff810b6867>] task_work_run+0xc7/0xe0
>> [<ffffffff81095010>] do_exit+0x2e0/0xa50
>> [<ffffffff810957ff>] do_group_exit+0x3f/0xa0
>> [<ffffffff810a6d60>] get_signal_to_deliver+0x1d0/0x6e0
>> [<ffffffff8102a527>] do_signal+0x57/0x6b0
>> [<ffffffff8102abdf>] do_notify_resume+0x5f/0xb0
>> [<ffffffff816c264f>] int_signal+0x12/0x17
>> [<ffffffffffffffff>] 0xffffffffffffffff
> 
> 
> Hmm, that stack reminds me of two situations Bart has reported earlier:
> 
> https://patchwork.kernel.org/patch/9261609/
> https://patchwork.kernel.org/patch/9202331/
> 
> It doesn't seem to me that there has been agreement on Bart's proposed
> fixes so far, but I may have missed it. Maybe Bart can comment on that.

Hello Martin,

The above call stack means that a block layer request got stuck. The two 
patches I posted before are not the right approach to fix this. As you 
maybe know rescan-scsi-bus.sh uses the sysfs "delete" attribute and 
writing into that attribute can trigger a deadlock. Have you noticed 
patch "Avoid that SCSI device removal through sysfs triggers a deadlock" 
(https://www.mail-archive.com/linux-scsi@vger.kernel.org/msg74500.html)? 
If the above lockup is reproducible with a kernel v4.17 or later and 
with that patch applied, it would help if a dump of the attributes under 
/sys/kernel/debug/block could be provided.

Bart.
