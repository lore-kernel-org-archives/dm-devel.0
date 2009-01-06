From: "Cheng Renquan" <crquan@gmail.com>
Subject: Re: Re: linux-next: Tree for January 5 (dm-target)
Date: Tue, 6 Jan 2009 11:45:24 +0800
Message-ID: <91b13c310901051945s50144a19q2915e2fd2c214620@mail.gmail.com>
References: <20090105173517.deeff918.sfr@canb.auug.org.au>
	<20090105094537.0718183d.randy.dunlap@oracle.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090105094537.0718183d.randy.dunlap@oracle.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Tue, Jan 6, 2009 at 1:45 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Mon, 5 Jan 2009 17:35:17 +1100 Stephen Rothwell wrote:
>
>> Hi all,
>>
>> This tree will not build a powerpc ppc4xx_defconfig due to a kvm problem.
>>
>> Changes since 20090102:
>>
>> Removed tree:
>>       rr_cpumask (served it purpose)
>>
>> Undropped tree:
>>       driver-core
>>       kvm
>>
>> Dropped trees (temporarily):
>>       usb (build problem)
>>       rr (complex conflicts)
>>       semaphore-removal (due to unfixed conflicts against Linus' tree)
>>       cpu_alloc (build problem)
>>       audit (difficult conflicts)
>>       staging (depends on usb)
>>
>> The device-mapper tree lost its conflict.
>
>
> When CONFIG_MODULE_UNLOAD=n (or CONFIG_MODULES=n):
>
> linux-next-20090105/drivers/md/dm-target.c:106: error: implicit declaration of function 'module_refcount'
>

This has been reported when linus was pulling,

http://lkml.org/lkml/2009/1/5/576

and will be fixed right once.

>
>
> ---
> ~Randy
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

-- 
Cheng Renquan, Shenzhen, China
Paula Poundstone  - "I don't have a bank account because I don't know
my mother's maiden name."
