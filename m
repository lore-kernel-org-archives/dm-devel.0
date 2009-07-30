From: Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH] dm-ioband-v1.12.2: I/O bandwidth controller
Date: Thu, 30 Jul 2009 15:42:10 +1000
Message-ID: <20090730054204.GA11291@verge.net.au>
References: <20090730.115454.226775179.ryov@valinux.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <xen-devel-bounces@lists.xensource.com>
Content-Disposition: inline
In-Reply-To: <20090730.115454.226775179.ryov@valinux.co.jp>
List-Unsubscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Thu, Jul 30, 2009 at 11:54:54AM +0900, Ryo Tsuruta wrote:
> Hi Alasdair,
> 
> This is dm-ioband v1.12.2 release that is a minor update to fit the
> current dm-devel tree.
>   
> Could you please replace dm-add-ioband.patch in your tree with this
> patch? And I would appreciate it if you would let me know your
> thoughts about merging dm-ioband to upstream.
> 
> Thanks,
> Ryo Tsuruta
> 
> About dm-ioband:
> dm-ioband is an I/O bandwidth controller implemented as a
> device-mapper driver and can control bandwidth on per partition, per
> user, per process, per virtual machine (such as KVM or Xen) basis.
> Please visit our website for further information.
> http://sourceforge.net/apps/trac/ioband/
> 
> Signed-off-by: Ryo Tsuruta <ryov@valinux.co.jp>
> Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>

Hi Tsuruta-san,

have you run sparse over this code? There seem to be a few interesting
warnings generated (and some at the top noise too).

$ make C=1 CF="-D__CHECK_ENDIAN__"
[snip]
include/trace/events/dm-ioband.h:9:1: warning: symbol 'ftrace_raw_output_ioband_hold_urgent_bio' was not declared. Should it be static?
include/trace/events/dm-ioband.h:44:1: warning: symbol 'ftrace_raw_output_ioband_hold_bio' was not declared. Should it be static?
include/trace/events/dm-ioband.h:79:1: warning: symbol 'ftrace_raw_output_ioband_make_pback_list' was not declared. Should it be static?
include/trace/events/dm-ioband.h:114:1: warning: symbol 'ftrace_raw_output_ioband_make_issue_list' was not declared. Should it be static?
include/trace/events/dm-ioband.h:149:1: warning: symbol 'ftrace_raw_output_ioband_release_urgent_bios' was not declared. Should it be static?
include/trace/events/dm-ioband.h:180:1: warning: symbol 'ftrace_raw_output_ioband_make_request' was not declared. Should it be static?
include/trace/events/dm-ioband.h:210:1: warning: symbol 'ftrace_raw_output_ioband_pushback_bio' was not declared. Should it be static?
include/trace/events/dm-ioband.h:9:1: warning: symbol 'ftrace_define_fields_ioband_hold_urgent_bio' was not declared. Should it be static?
include/trace/events/dm-ioband.h:44:1: warning: symbol 'ftrace_define_fields_ioband_hold_bio' was not declared. Should it be static?
include/trace/events/dm-ioband.h:79:1: warning: symbol 'ftrace_define_fields_ioband_make_pback_list' was not declared. Should it be static?
include/trace/events/dm-ioband.h:114:1: warning: symbol 'ftrace_define_fields_ioband_make_issue_list' was not declared. Should it be static?
include/trace/events/dm-ioband.h:149:1: warning: symbol 'ftrace_define_fields_ioband_release_urgent_bios' was not declared. Should it be static?
include/trace/events/dm-ioband.h:180:1: warning: symbol 'ftrace_define_fields_ioband_make_request' was not declared. Should it be static?
include/trace/events/dm-ioband.h:210:1: warning: symbol 'ftrace_define_fields_ioband_pushback_bio' was not declared. Should it be static?
drivers/md/dm-ioband-ctl.c:178:2: warning: context problem in 'suspend_ioband_device': '_spin_unlock_irqrestore' expected different context
drivers/md/dm-ioband-ctl.c:178:2:    context 'lock': wanted >= 1, got 0
drivers/md/dm-ioband-ctl.c:600:3: warning: context imbalance in 'prevent_burst_bios': unexpected unlock
drivers/md/dm-ioband-ctl.c:600:3:    context '<noident>': wanted 0, got -1
drivers/md/dm-ioband-ctl.c:816:3: warning: context imbalance in 'ioband_map': __context__ statement expected different context
drivers/md/dm-ioband-ctl.c:816:3:    context '<noident>': wanted >= 0, got -1
  CC [M]  drivers/md/dm-ioband-ctl.o
  CHECK   drivers/md/dm-ioband-policy.c
  CC [M]  drivers/md/dm-ioband-policy.o
  CHECK   drivers/md/dm-ioband-rangebw.c
drivers/md/dm-ioband-rangebw.c:592:6: warning: symbol 'range_bw_timeover' was not declared. Should it be static?
drivers/md/dm-ioband-rangebw.c:287:4: warning: context imbalance in 'range_bw_queue_full': __context__ statement expected different context
drivers/md/dm-ioband-rangebw.c:287:4:    context '<noident>': wanted >= 0, got -1
  CC [M]  drivers/md/dm-ioband-rangebw.o
drivers/md/dm-ioband-rangebw.c: In function 'range_bw_prepare_token':
drivers/md/dm-ioband-rangebw.c:210: warning: 'io_mode' may be used uninitialized in this function
