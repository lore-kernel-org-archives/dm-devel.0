From: Eric Ren <zren@suse.com>
Subject: Re: [PATCH] dm mirror: fix crash caused by NULL-pointer
 dereference
Date: Mon, 26 Jun 2017 18:42:50 +0800
Message-ID: <78902530-99b6-0068-56da-221c98991ce9@suse.com>
References: <20170626090848.21585-1-zren@suse.com>
	<20170626091454.GA12767@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170626091454.GA12767@linux-x5ow.site>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: jtang@suse.com, dm-devel@redhat.com, snitzer@redhat.com, neilb@suse.com, agk@redhat.com
List-Id: dm-devel.ids

Hi,

On 06/26/2017 05:14 PM, Johannes Thumshirn wrote:
> On Mon, Jun 26, 2017 at 05:08:48PM +0800, Eric Ren wrote:
>> When the primary mirror device fails, activating a mirrored
>> LV will crash the kernel. It can be reproduced 100% with the
>> scripts below:
>>
>> """
>> dd if=/dev/zero of=file.raw bs=1G count=1
>> loopdev=$(losetup -f)
>> losetup $loopdev file.raw
>> dmsetup create pv1 --table "0 102399 linear $loopdev 0"
>> dmsetup create pv2 --table "0 102399 linear $loopdev 102400"
>> vgcreate vgtest /dev/mapper/pv1 /dev/mapper/pv2
>> lvcreate -l1 --type mirror -m1 -n mirror12 --mirrorlog core \
>>                   vgtest /dev/mapper/pv1 /dev/mapper/pv2
>> vgchange -an vgtest
>> echo 0 10000000 error | dmsetup load /dev/mapper/pv1
>> dmsetup resume /dev/mapper/pv1
>> vgchange -ay vgtest
>> """
> So as you have a reproducer, can you eventually write an blktest [1]
> regression test for it?
No problem, will do later on.

Thanks,
Eric

>
>
> Thanks,
> 	Johannes
>
> [1] https://github.com/osandov/blktests
>
