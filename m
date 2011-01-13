From: Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-devel] linux-next - WARNING: at fs/block_dev.c:824 bd_link_disk_holder+0x92/0x1ac()
Date: Thu, 13 Jan 2011 12:26:14 +0100
Message-ID: <4D2EE156.1050006@redhat.com>
References: <16069.1294853673@localhost> <4D2E4611.90002@redhat.com>	<4D2E6129.8000700@ce.jp.nec.com> <20110113110640.GC30719@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110113110640.GC30719@htj.dyndns.org>
Sender: linux-raid-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Karel Zak <kzak@redhat.com>
List-Id: dm-devel.ids

On 01/13/2011 12:06 PM, Tejun Heo wrote:
> Urgh... gees, so there actually was a user using all that cruft.
> Sorry about the breakage, I'll see how multiple symlinks can be
> restored.  I'm curious why this was added at all tho.  What was the
> rationalization?  It's not like two subsystems can share the same
> block device so marking the currently owning subsystem should have
> been enough at the block layer.  There is no reason for block devices
> to present information which is of no use to itself.  All that's
> necessary is "this is taken by dm or md for more information, query
> those".  dm and md need their own conf/representation layer anyway.

I am not sure if I understand it correctly, but multiple holders/slaves
links are very useful in userspace to present device dependences.

We just implemented lsblk command in util-linux which simple prints
tree according to these links, so dependendes of DM/MD/whatever devices
can be printed without using any system specific callbacks, just using
sysfs. See http://karelzak.blogspot.com/2010/12/lsblk8.html

Whatever changes are needed, please keep this functionality, it can be useful.

Thanks,
Milan
