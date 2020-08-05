From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH] libmultipath: fix null dereference in add
Date: Wed, 05 Aug 2020 23:36:38 +0200
Message-ID: <7b6403a39da1a6fd6f2297884fed957414c4e55d.camel@suse.com>
References: <9f10e135-348d-d11a-85cb-797522ba5210@huawei.com>
	<20200803173535.GF19233@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200803173535.GF19233@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, lixiaokeng <lixiaokeng@huawei.com>
Cc: linfeilong@huawei.com, dm-devel@redhat.com, liuzhiqiang26@huawei.com, lutianxiong@huawei.com
List-Id: dm-devel.ids

On Mon, 2020-08-03 at 12:35 -0500, Benjamin Marzinski wrote:
> On Mon, Aug 03, 2020 at 07:57:01PM +0800, lixiaokeng wrote:
> > I got a multipath segfault while running iscsi login/logout and
> > following scripts in parallel:
> > 
> > #!/bin/bash
> > interval=1
> > while true
> > do
> >               multipath -F &> /dev/null
> >               multipath -r &> /dev/null
> >               multipath -v2 &> /dev/null
> >               multipath -ll &> /dev/null
> >               sleep $interval
> > done
> > 
> > This is the debuginfo:
> > #0  0x00007f3805e4df58 in add (ctx=0x55d1569e4a00,
> > ud=0x55d1569bafd0) at nvme.c:801
> > 801              if (strcmp("disk", udev_device_get_devtype(ud)))
> > (gdb) bt
> > #0  0x00007f3805e4df58 in add (ctx=0x55d1569e4a00,
> > ud=0x55d1569bafd0) at nvme.c:801
> > #1  0x00007f3806687a44 in add_foreign (udev=0x55d1569bafd0) at
> > foreign.c:299
> > #2  0x00007f3806665abf in is_claimed_by_foreign (ud=<optimized
> > out>) at foreign.h:316
> > #3  pathinfo (pp=0x55d1569e9f50, conf=0x55d1569b92d0, mask=69) at
> > discovery.c:2064
> > #4  0x000055d154c91cbb in check_usable_paths (conf=0x55d1569b92d0,
> > devpath=0x55d1569e3200 "dm-6", dev_type=<optimized out>) at
> > main.c:368
> > #5  0x000055d154c910a5 in main (argc=3, argv=<optimized out>) at
> > main.c:1057
> > In add() at libmultipath/foreign/nvme.c,
> > udev_device_get_devtype(ud) return a NULL pointer then
> > dereferenced.
> > Here, NULL check is needed.
> > Check if udev_device_get_devtype return NULL before dereferencing
> > it.
> 
> This patch looks fine. However, it has pointed out a larger problem
> with
> the udev_device_get_* functions. This is not the only instance where
> we
> aren't checking the return value of these functions before
> dereferencing
> it.

Right. libudev/libsystemd seem to follow a "lazy" approach for certain 
properties, fetching them only when requested. If such a function call
returns NULL, I guess we have to assume that fetching the respective
property from sysfs failed, and thus the udev_device has become non-
existent / invalid. OTOH, this is probably "better" than libudev
fetching other properties from the cache and NOT making us realize that
the device is long gone.

Next pending code audit :-/

Martin
