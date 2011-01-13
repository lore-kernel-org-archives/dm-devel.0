From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: linux-next - WARNING: at fs/block_dev.c:824 bd_link_disk_holder+0x92/0x1ac()
Date: Thu, 13 Jan 2011 11:19:21 +0900
Message-ID: <4D2E6129.8000700@ce.jp.nec.com>
References: <16069.1294853673@localhost> <4D2E4611.90002@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4D2E4611.90002@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>, Tejun Heo <tj@kernel.org>
Cc: Valdis.Kletnieks@vt.edu, Alexander Viro <viro@zeniv.linux.org.uk>, Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 01/13/11 09:23, Milan Broz wrote:
> On 01/12/2011 06:34 PM, Valdis.Kletnieks@vt.edu wrote:
>> Seen in a boot of yesterday's linux-next.   The 'W' flag was due to the
>> already-reported 'WARNING: at kernel/workqueue.c:1202 worker_enter_idle'.
>> Not sure if it's a block_dev or dm/LVM issue, so I'm cc:'ing both groups.  I wonder
>> if the fact I still have 'CONFIG_DEVTMPFS=n' is involved (it's apparently ticking off
>> dracut before and after the warning).
>>
>> [   16.840333] dracut: Found volume group "vg_blackice" using metadata type lvm2
>> [   16.892282] dracut: The link /dev/vg_blackice/opt should had been created by udev but it was not found.  Falling back to direct link creation.
>> [   16.912627] ------------[ cut here ]------------
>> [   16.912635] WARNING: at fs/block_dev.c:824 bd_link_disk_holder+0x92/0x1ac()
> 
> That seems to be
> WARN_ON_ONCE(!bdev->bd_holder || bdev->bd_holder_disk);
> added in patch
> http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=e09b457bdb7e8d23fc54dcef0930ac697d8de895
> "block: simplify holder symlink handling"
> 
> dm linear just claims device in table constructor, I don't think it is bug in DM code.

The patch assumes only one holder disk for a claimed dev, which is not true.
E.g. if there are multiple LVs on a PV.

In addition to that, since claiming is done in table constructor,
there can be 2 claim instances for a slave/holder pair at a time
when you load a table while there's already an active one.
E.g. if you do lvresize.
We need consideration for this, too.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation
