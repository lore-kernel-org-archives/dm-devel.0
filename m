From: =?ISO-8859-1?Q?Fran=E7ois_Figarola?=
	<francois.figarola@i-consult.fr>
Subject: Re: [dm-devel] [BUG] kernel 2.6.32.x hangs during boot process
Date: Fri, 29 Jan 2010 08:06:29 +0100
Message-ID: <4B6288F5.7060508@i-consult.fr>
References: <d2deb3241001160158r4baed1e1t7e8f6642de018b4c@mail.gmail.com>	<20100122160740.6c16c22d.akpm@linux-foundation.org> <20100128134205.352044bd@notabene> <4B612F89.7020503@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932334Ab0A2HGm@vger.kernel.org>
In-Reply-To: <4B612F89.7020503@ce.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: hch@infradead.org, device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
List-Id: dm-devel.ids

Jun'ichi Nomura a =E9crit :
>>> On Sat, 16 Jan 2010 10:58:30 +0100
>>> Fran__ois Figarola  <francois.figarola@i-consult.fr> wrote:
>>>      =20
>>>> Since I've tried to boot 2.6.32.x kernel, my system hangs during t=
he
>>>> boot process, and I think it could be related to the problem repor=
ted
>>>> earlier by Megastorage (http://lkml.org/lkml/2010/1/10/92).
>>>>
>>>> The hardware is a Dell PowerEdge 2950 which runs fine with the
>>>> 2.6.31.x kernel series (actually running with the latest 2.6.31.11=
),
>>>> and the system is debian etch.
>>>>
>>>> Here is the trace of the bug I've got (using netconsole) with a
>>>> 2.6.32.3 kernel :
>>>>
>>>> BUG: Dentry ffff880667690000{i=3D41a46,n=3Dsleep} still in use (8)
>>>> [unmount of ext3 dm-4]
>>>> ------------[ cut here ]------------
>>>> kernel BUG at fs/dcache.c:670!
>>>>        =20
>
> I can reproduce this when suspend/resume read-only mounted dm device.
>
> When MS_RDONLY, both freeze_bdev and thaw_bdev call deactivate_locked=
_super,
> which seems wrong. The change was introduced with the commit below:
>
>   commit 4504230a71566785a05d3e6b53fa1ee071b864eb
>   Author: Christoph Hellwig <hch@lst.de>
>   Date:   Mon Aug 3 23:28:35 2009 +0200
>
>   freeze_bdev: grab active reference to frozen superblocks
>
> With the attached patch, both remount-ro and remount-rw are
> rejected as EBUSY on freezed device as expected.
>
> Christoph, do you think this is the right fix?
>
>  =20
With the fix from Jun'ichi Nomura, a 2.6.32.5 kernel
boots now correctly.

Thanks.
