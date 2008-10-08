From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: [PATCH 0/2] dm-ioband: I/O bandwidth controller
 v1.7.0: Introduction
Date: Wed, 08 Oct 2008 19:40:22 +0900 (JST)
Message-ID: <20081008.194022.226783199.ryov@valinux.co.jp>
References: <20081003.143749.193701570.ryov@valinux.co.jp>
	<2891419e0810080129sb6b35y11362f4bef71c174@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xensource.com>
In-Reply-To: <2891419e0810080129sb6b35y11362f4bef71c174@mail.gmail.com>
List-Unsubscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: baramsori72@gmail.com
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, agk@sourceware.org, balbir@linux.vnet.ibm.com, fernando@oss.ntt.co.jp, xemul@openvz.org
List-Id: dm-devel.ids

Hi Dong-Jae,

Thanks for being intersted in dm-ioband.

> I tested dm-ioband( the latest release, ver 1.7.0 ) IO controller, but
> I had a strange result from it.
> I have something wrong in test process?
> The test process and results are in attached file.
> Can you check my testing result and give me a helpful advices and comments?

There are some suggestions for you.

1. you have to specify a dm-ioband device at the command line to
   control bandwidth.

    # tiotest -R -d /dev/mapper/ioband1 -f 300

2. tiotest is not an appropriate tool to see how bandwith is shared
   among devices, becasue those three tiotests don't finish at the
   same time, a process which issues I/Os to a device with the highest
   weight finishes first, so you can't see how bandwidth is shared
   from the results of each tiotest.

   I use iostat to see the time variation of bandiwdth. The followings
   are the outputs of iostat just after starting three tiotests on the
   same setting as yours.

    # iostat -p dm-0 -p dm-1 -p dm-2 1
    Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
    dm-0           5430.00         0.00     10860.00          0      10860
    dm-1          16516.00         0.00     16516.00          0      16516
    dm-2          32246.00         0.00     32246.00          0      32246

    avg-cpu:  %user   %nice %system %iowait  %steal   %idle
               0.51    0.00   21.83   76.14    0.00    1.52
    
    Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
    dm-0           5720.00         0.00     11440.00          0      11440
    dm-1          16138.00         0.00     16138.00          0      16138
    dm-2          32734.00         0.00     32734.00          0      32734
    ...

> You can refer the testing tool, tiobench, in
> http://sourceforge.net/projects/tiobench/
> Originally, tiobench don't support the direct IO mode testing, so I
> added the O_DIRECT option to tiobench source code and recompile it to
> test the Direct IO cases

Could you give me the O_DIRECT patch?
 
Thanks,
Ryo Tsuruta
