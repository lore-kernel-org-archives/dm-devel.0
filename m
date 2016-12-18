From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: dm-cache: please check/repair metadata
Date: Sun, 18 Dec 2016 20:37:13 +0100
Message-ID: <de8f5ebd-6918-4785-71a1-89967406b0e3@redhat.com>
References: <o2adej$eaa$1@blaine.gmane.org>
	<2d776d72-744a-7aa7-a5ae-35192fe145d8@redhat.com>
	<efe12356-a132-c517-914d-4a4cf3a902fc@gmail.com>
	<o34lim$19u$1@blaine.gmane.org>
	<5a00ced3-0688-827a-f001-fd4677e46425@gmail.com>
	<a58b3198-90a3-124e-b8ee-464e3f150057@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <a58b3198-90a3-124e-b8ee-464e3f150057@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ian Pilcher <arequipeno@gmail.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Dne 18.12.2016 v 16:51 Ian Pilcher napsal(a):
>> I'm not exactly sure what are you doing, are you maintaining your own dm
>> cache volumes ?  (Writing your own volume manager and not using lvm2 -
>> what is lvm2 missing/doing wrong ?)
>
> Yup.  I've continuing to use my "zodcache" system for assembling
> dm-cache devices.
>
> As to what lvm2 is missing or doing wrong ... It's not that there's
> anything "wrong" with it.  It's just that I prefer to have a "simpler"
> setup with a cached PVs/VGs, rather than cached LVs.  I've also always
> found the fact that LVM cache puts both the fast and slow devices into
> the same VG to be counterintuitive.

It's not counterintuitive - lvm2 gives you FULL control where to place cache 
data and metadata...

ATM lvm2 has no notation what is 'slow' and what is 'fast'
For the 'cache'  both  data & metadata are supposed to be on 'fast'.

Please check 'man lvmcache' for full description.

> These are really matters of personal preference, though.  I want to be
> very, very clear that I don't think that there's anything wrong with
> LVM.  (To be perfectly honest, my preferences are probably colored by
> the fact that I first used bcache, so I'm used to its "model".)
>
>> Are you going to write also your own recovery support ?
>
> Until a few days ago I wasn't aware that such a thing might even be
> necessary.  :-)

Well errors do happen and having repair logic at hands is always useful.

There are also quite some types of failures - so I probably need to wish best 
luck with rediscovering all this.

Unless your  'zodcache' is meant to be used as quick 'experimental' sort of 
device where you do not care mostly about data being unusable.  In this case 
plain  activation of 'dm' device via couple ioctl  calls surely can't be 
beaten by lvm2 - but that's not where lvm2 usage is targeted.

Regards

Zdenek
