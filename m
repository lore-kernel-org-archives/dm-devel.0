From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH] block: restore multiple bd_link_disk_holder() support
Date: Fri, 14 Jan 2011 16:31:57 +0900
Message-ID: <4D2FFBED.6010406@ce.jp.nec.com>
References: <16069.1294853673@localhost> <4D2E4611.90002@redhat.com> <4D2E6129.8000700@ce.jp.nec.com> <20110113172133.GE14096@htj.dyndns.org> <4D2F4799.5030901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D2F4799.5030901@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>, Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Valdis.Kletnieks@vt.edu, Alexander Viro <viro@zeniv.linux.org.uk>, Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Kay Sievers <kay.sievers@vrfy.org>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi,

On 01/14/11 03:42, Milan Broz wrote:
>> Milan, Jun, can you guys please verify this works correctly for the
>> multi holder dm case?  Thank you.
> 
> Hi,
> 
> unfortunately not. And the problem is much worse,
> it breaks lvm resize operation completely.

For quick testing, try this:
("/dev/sdf" can be other block device.
 "testA" and "testB" can be other dm names which aren't used in
 your machine.)

# echo "0 10 linear /dev/sdf 0" | dmsetup create testA
# echo "0 10 linear /dev/sdf 10" | dmsetup create testB
(at this point, /dev/sdf has multiple holders)
# echo "0 20 linear /dev/sdf 10" | dmsetup load testB
(at this point, /dev/mapper/testB has 2 claims on /dev/sdf)
# dmsetup resume testB
(/dev/mapper/testB has 1 claim on /dev/sdf)
# dmsetup remove testA
# dmsetup remove testB


Thanks,
-- 
Jun'ichi Nomura, NEC Corporation
