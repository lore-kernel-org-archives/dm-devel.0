From: Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-devel] linux-next - WARNING: at fs/block_dev.c:824 bd_link_disk_holder+0x92/0x1ac()
Date: Thu, 13 Jan 2011 15:25:46 +0100
Message-ID: <4D2F0B6A.6010201@redhat.com>
References: <16069.1294853673@localhost> <4D2E4611.90002@redhat.com> <4D2E6129.8000700@ce.jp.nec.com> <20110113110640.GC30719@htj.dyndns.org> <4D2EE156.1050006@redhat.com> <20110113122701.GG16523@nb.net.home> <20110113131216.GF30719@htj.dyndns.org> <20110113132637.GH16523@nb.net.home> <20110113133722.GG30719@htj.dyndns.org> <4D2F04FF.1070309@redhat.com> <20110113141107.GI30719@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110113141107.GI30719@htj.dyndns.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Karel Zak <kzak@redhat.com>, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
List-Id: dm-devel.ids

On 01/13/2011 03:11 PM, Tejun Heo wrote:

> So, as a general rule, when in doubt, just create an attribute.  Let's
> refrain from custom symlinkery in sysfs, please.  In this case too, a
> holder attribute containing strings like ext[3|4], md, dm or whatnot
> would have been _much_ simpler and actually more useful.

Maybe, but this was not invented in DM/MD camp:-)
Probably Kay or Greg can answer why it was done this way?

For DM it just added links to be proper user of it, see
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=f165921df46a977e3561f1bd9f13a348441486d1

Anyway, it is /sys/block - so it represents block devices.

If btrfs internally creates some virtual _block_ device for its pool, it should
present it here too with slaves/holders. If not, why it should create any links there?

Milan
