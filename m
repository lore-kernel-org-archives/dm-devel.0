From: "xinhui.pan" <xinhuix.pan@intel.com>
Subject: Re: [dm-devel] [PATCH] md/dm-ioctl.c: optimize memory allocation
 in copy_params
Date: Wed, 09 Jul 2014 11:37:52 +0800
Message-ID: <53BCB910.4070709@intel.com>
References: <53B68068.2060102@intel.com> <alpine.LRH.2.02.1407081831510.27831@file01.intranet.prod.int.rdu2.redhat.com> <53BCA278.5050205@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <53BCA278.5050205@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, "Liu, ShuoX" <shuox.liu@intel.com>
List-Id: dm-devel.ids



=E4=BA=8E 2014=E5=B9=B407=E6=9C=8809=E6=97=A5 10:01, Zhang, Yanmin =E5=86=
=99=E9=81=93:
> On 2014/7/9 6:39, Mikulas Patocka wrote:
>=20
>> Hi
>=20
> Mikulas,
>=20
> Thanks for your kind comments.
>=20
>> I don't really know what is the purpose of this patch. In existing d=
evice
>> mapper code, if kmalloc fails, the allocation is retried with __vmal=
loc.
>> So there is no need to avoid kmalloc aritifically.
>>
>> kmalloc doesn't cause memory fragmentation. If the memory is too
>> fragmented, kmalloc fails. If it isn't, it succeeds. But it doesn't =
cause
>> memory being fragmented.
>=20
> I agree with you. The patch's original description is not appropriate=
=2E
> Basically, memory fragmentation is not caused by this kmalloc.
>=20
> The right description is: When memory is fragmented and most memory i=
s used up,
> kmalloc a big memory might cause lots of OutOFMemory and system might=
 kill
> lots of processes. Then, system might hang.
>=20
> We are enabling Android on mobiles and tablets. We hit OOM often at
> Monkey and other stress testing. Sometimes, kernel prints big memory =
allocation
> warning.
>=20
> Theoretically, it's a good idea to call kmalloc firstly. If it fails,=
 use vmalloc.
> However, kernel assumes drivers do the right thing. When drivers call=
 kmalloc to
> allocate a big memory, memory management would do the best to fulfill=
 it. When memory
> is fragmented and most memory is used up, such allocation would cause=
 big memory
> recollection. Some processes might be killed. The worse scenario is a=
fter a process
> is killed, it is restarted and allocates memory again. That causes sy=
stem hang,
> or mobile users feel a big stall. We did fix a similar issue in one o=
f our drivers.
>=20
> Usually, kernel and drivers can allocate big continuous memory at boo=
ting or
> initialization stage. After that, they need allocate small order memo=
ry. The best
> is to just allocate order-0 memory.
>=20
>=20
>>
>> If you have some other driver that fails because of large kmalloc fa=
ilure,
>> you should fix it to use scatter-gather DMA or (if the hardware can'=
t do
>> it) preallocate the memory when the driver is loaded.
>=20
> I agree with you. Here the patch fixes the issue, where dm might allo=
cate
> big continuous memory after booting. Monkey testing triggers it by op=
erating
> menu Setting=3D>Security=3D>InstallfromSDcard.
>=20

hi, Yanmin && Mikulas
	Thanks for your nice comments. And sorry for confusing you as my comme=
nt is not clear enough.
In android, there is a command "dumpstate", it run many other commands =
to collect information. In our scenario,
it run command "vdc dump", and vdc uses socket to pass some parameters =
to "vold", then vold generates ioctl.=20

thanks.
> We are catching all places in kernel where big memory allocation happ=
ens.
> This patch is just to fix one case.
>=20
> Thanks,
> Yanmin
>=20
>>
>> Mikulas
>>
>>
>>
>> On Fri, 4 Jul 2014, xinhui.pan wrote:
>>
>>> KMALLOC_MAX_SIZE is too big, it easily cause memory fragmented and =
low memory when param_kernel->data_size
>>> is also big. That's not nice. So use vmalloc instead of kmalloc whe=
n size is larger than (PAGE_SIZE << 2).
>>> There are other drivers using kmalloc to gain a big size memory. An=
d that cause our devices to hit hang and
>>> many worse issues. We don't benefit much when using kmalloc in such=
 scenario.
>>>
>>> Signed-off-by: xinhui.pan <xinhuiX.pan@intel.com>
>>> Signed-off-by: yanmin.zhang <yanmin_zhang@linux.intel.com>
>>> ---
>>>   drivers/md/dm-ioctl.c |    2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
>>> index 5152142..31c3af9 100644
>>> --- a/drivers/md/dm-ioctl.c
>>> +++ b/drivers/md/dm-ioctl.c
>>> @@ -1709,7 +1709,7 @@ static int copy_params(struct dm_ioctl __user=
 *user, struct dm_ioctl *param_kern
>>>           * Use kmalloc() rather than vmalloc() when we can.
>>>           */
>>>          dmi =3D NULL;
>>> -       if (param_kernel->data_size <=3D KMALLOC_MAX_SIZE) {
>>> +       if (param_kernel->data_size <=3D (PAGE_SIZE << 2)) {
>>>                  dmi =3D kmalloc(param_kernel->data_size, GFP_NOIO =
| __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
>>>                  if (dmi)
>>>                          *param_flags |=3D DM_PARAMS_KMALLOC;
>>> --=20
>>> 1.7.9.5
>>>
>>> --=20
>>> dm-devel mailing list
>>> dm-devel@redhat.com
>>> https://www.redhat.com/mailman/listinfo/dm-devel
>>>
>=20
