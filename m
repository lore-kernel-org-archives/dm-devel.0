From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Subject: Re: [PATCH 05/11] block: get rid of the trace rq insert wrapper
Date: Fri, 3 Jul 2020 23:29:25 +0000
Message-ID: <BYAPR04MB4965DFE805071F971DC8C71C866A0@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20200629234314.10509-1-chaitanya.kulkarni@wdc.com>
 <20200629234314.10509-6-chaitanya.kulkarni@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "jack@suse.czi" <jack@suse.czi>, "rdunlap@infradead.org" <rdunlap@infradead.org>, "sagi@grimberg.me" <sagi@grimberg.me>, "mingo@redhat.com" <mingo@redhat.com>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "agk@redhat.com" <agk@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "paolo.valente@linaro.org" <paolo.valente@linaro.org>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "bvanassche@acm.org" <bvanassche@acm.org>, "fangguoju@gmail.com" <fangguoju@gmail.com>, "colyli@suse.de" <colyli@suse.de>
List-Id: dm-devel.ids

Christoph,=0A=
=0A=
On 6/29/20 4:44 PM, Chaitanya Kulkarni wrote:=0A=
> Get rid of the wrapper for trace_block_rq_insert() and call the function=
=0A=
> directly.=0A=
> =0A=
> Signed-off-by: Chaitanya Kulkarni<chaitanya.kulkarni@wdc.com>=0A=
> ---=0A=
=0A=
Can we re-consider adding this patch ? here are couple of reasons:-=0A=
=0A=
1. Increase in the size of the text region of the object file:-=0A=
=0A=
    By adding the trace header #include <trace/events/block.h>=0A=
    in io-scheduler where it is calling trace_block_rq_insert()=0A=
    increases the size of the text region of the object file=0A=
    kyber(+215) & bfq (+317) [1].=0A=
=0A=
2. Mandatory io-sched built-in kernel compilation:-=0A=
=0A=
    When testing with a different io-sched KConfig options ("*" vs "M"),=0A=
    when kyber and bfq compilation option set to "M" having this patch=0A=
    reports error[2].=0A=
=0A=
If I've not missed something here then can we drop this patch ?=0A=
=0A=
In case we really want to do this change it will need to have KConfig=0A=
separate patch such that if tracing is selected it will force * =0A=
selection (built-in KConfig) for schedulers in question and etc.=0A=
=0A=
Do we want to do this ?=0A=
=0A=
Regards,=0A=
Chaitanya=0A=
=0A=
=0A=
[1] Scheduler IO object size comparison :-=0A=
=0A=
    Without this patch :-=0A=
    ---------------------=0A=
    # size block/bfq-iosched.o=0A=
     text	   data	    bss	    dec	    hex	filename=0A=
    62204	   1011	     32	  63247	   f70f	block/bfq-iosched.o=0A=
    # size block/kyber-iosched.o=0A=
     text	   data	    bss	    dec	    hex	filename=0A=
    14808	   2699	     48	  17555	   4493	block/kyber-iosched.o=0A=
    With this patch :-=0A=
    ------------------=0A=
    # size block/bfq-iosched.o=0A=
     text	   data	    bss	    dec	    hex	filename=0A=
    62521	   1028	     32	  63581	   f85d	block/bfq-iosched.o=0A=
    # size block/kyber-iosched.o=0A=
     text	   data	    bss	    dec	    hex	filename=0A=
    15023	   2716	     48	  17787	   457b	block/kyber-iosched.o=0A=
=0A=
[2] Error with selecting M for io-sched kyber & bfq :-=0A=
=0A=
ERROR: modpost: "__tracepoint_block_rq_insert" [block/bfq.ko] undefined!=0A=
ERROR: modpost: "__tracepoint_block_rq_insert" [block/kyber-iosched.ko] =0A=
undefined!=0A=
make[2]: *** [Module.symvers] Error 1=0A=
make[2]: *** Deleting file `Module.symvers'=0A=
make[1]: *** [modules] Error 2=0A=
make[1]: *** Waiting for unfinished jobs....=0A=
arch/x86/tools/insn_decoder_test: success: Decoded and checked 4932572 =0A=
instructions=0A=
   TEST    posttest=0A=
   arch/x86/tools/insn_sanity: Success: decoded and checked 1000000 =0A=
random instructions with 0 errors (seed:0x4c6e1a40)=0A=
	CC      arch/x86/boot/version.o=0A=
	VOFFSET arch/x86/boot/compressed/../voffset.h=0A=
	OBJCOPY arch/x86/boot/compressed/vmlinux.bin=0A=
	RELOCS  arch/x86/boot/compressed/vmlinux.relocs=0A=
	CC      arch/x86/boot/compressed/kaslr.o=0A=
	CC      arch/x86/boot/compressed/misc.o=0A=
	GZIP    arch/x86/boot/compressed/vmlinux.bin.gz=0A=
	MKPIGGY arch/x86/boot/compressed/piggy.S=0A=
	AS      arch/x86/boot/compressed/piggy.o=0A=
	LD      arch/x86/boot/compressed/vmlinux=0A=
	ZOFFSET arch/x86/boot/zoffset.h=0A=
	OBJCOPY arch/x86/boot/vmlinux.bin=0A=
	AS      arch/x86/boot/header.o=0A=
	LD      arch/x86/boot/setup.elf=0A=
	OBJCOPY arch/x86/boot/setup.bin=0A=
	BUILD   arch/x86/boot/bzImage=0A=
	Setup is 15132 bytes (padded to 15360 bytes).=0A=
	System is 8951 kB=0A=
	CRC ff6eac72=0A=
Kernel: arch/x86/boot/bzImage is ready  (#59)=0A=
	make: *** [__sub-make] Error 2=0A=
