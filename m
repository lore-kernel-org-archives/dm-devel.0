From: Martin Wilck <mwilck@suse.com>
Subject: Re: libmultipath: fix null dereference
Date: Wed, 05 Aug 2020 23:28:50 +0200
Message-ID: <9458f4d0a17f98b4791e21efc91e779335edfb6f.camel@suse.com>
References: <B8F26E5D3A1269458BE7CD6D60E9885F7A369633@dggemm531-mbx.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <B8F26E5D3A1269458BE7CD6D60E9885F7A369633@dggemm531-mbx.china.huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: lutianxiong <lutianxiong@huawei.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Liaoqingwei <liaoqingwei@huawei.com>
List-Id: dm-devel.ids

On Thu, 2020-07-23 at 01:11 +0000, lutianxiong wrote:
> Hi
> I got a multipath segfault while running iscsi login/logout and
> following scripts in parallel:
>  
> #!/bin/bash
> interval=1
> while true
> do
>               multipath -F &> /dev/null
>               multipath -r &> /dev/null
>               multipath -v2 &> /dev/null
>               multipath -ll &> /dev/null
>               sleep $interval
> done
>  
> This is the debuginfo:
> #0  0x00007f3805e4df58 in add (ctx=0x55d1569e4a00, ud=0x55d1569bafd0)
> at nvme.c:801
> 801              if (strcmp("disk", udev_device_get_devtype(ud)))
> (gdb) bt
> #0  0x00007f3805e4df58 in add (ctx=0x55d1569e4a00, ud=0x55d1569bafd0)
> at nvme.c:801
> #1  0x00007f3806687a44 in add_foreign (udev=0x55d1569bafd0) at
> foreign.c:299
> #2  0x00007f3806665abf in is_claimed_by_foreign (ud=<optimized out>)
> at foreign.h:316
> #3  pathinfo (pp=0x55d1569e9f50, conf=0x55d1569b92d0, mask=69) at
> discovery.c:2064
> #4  0x000055d154c91cbb in check_usable_paths (conf=0x55d1569b92d0,
> devpath=0x55d1569e3200 "dm-6", dev_type=<optimized out>) at
> main.c:368
> #5  0x000055d154c910a5 in main (argc=3, argv=<optimized out>) at
> main.c:1057
>  
> In add() at libmultipath/foreign/nvme.c, udev_device_get_devtype(ud)
> return a NULL pointer then dereferenced.
> Here, NULL check is needed.
>  
>  
>  
> Check if udev_device_get_devtype return NULL before dereferencing it.
>  
> Signed-off-by: lutianxiong <lutianxiong@huawei.com>

Thanks, this looks correct. But could you please resend in proper
format? The patch is corrupt, looks like mangled whitespace.

Martin
