From: Tejun Heo <tj@kernel.org>
Subject: Re: [dm-devel] linux-next - WARNING: at fs/block_dev.c:824
 bd_link_disk_holder+0x92/0x1ac()
Date: Thu, 13 Jan 2011 14:52:10 +0100
Message-ID: <20110113135210.GH30719@htj.dyndns.org>
References: <16069.1294853673@localhost>
 <4D2E4611.90002@redhat.com>
 <4D2E6129.8000700@ce.jp.nec.com>
 <20110113110640.GC30719@htj.dyndns.org>
 <4D2EE156.1050006@redhat.com>
 <20110113122701.GG16523@nb.net.home>
 <20110113131216.GF30719@htj.dyndns.org>
 <20110113132637.GH16523@nb.net.home>
 <20110113133722.GG30719@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110113133722.GG30719@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Karel Zak <kzak@redhat.com>
Cc: Milan Broz <mbroz@redhat.com>, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
List-Id: dm-devel.ids

On Thu, Jan 13, 2011 at 02:37:22PM +0100, Tejun Heo wrote:
> >  It seems that dependencies (holders/slaves) between devices is pretty
> >  generic thing. Why do you think that we need claimer-specific method?
> >  The /sys filesystem is better that ictls in many ways.

Also, one more thing.  In btrfs, there's no block device for the
master device.  You can add the slaves directory somewhere and your
choice would be as good as any other's but it just will not be generic
while being superflous exactly the same way it's superflous for md and
dm devices.

Thanks.

-- 
tejun
