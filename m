From: Hannes Reinecke <hare@suse.de>
Subject: Re: Regression in 3.15 on POWER8 with multipath SCSI
Date: Tue, 01 Jul 2014 07:57:55 +0200
Message-ID: <53B24DE3.9050108@suse.de>
References: <20140630103058.GA17747@iris.ozlabs.ibm.com> <53B1416D.8020305@suse.de> <20140630110202.GB17747@iris.ozlabs.ibm.com> <53B14B78.4010500@suse.de> <20140630212801.GB20819@iris.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140630212801.GB20819@iris.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Mackerras <paulus@samba.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, Vladimir Davydov <vdavydov@parallels.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Kay Sievers <kay.sievers@vrfy.org>
List-Id: dm-devel.ids

On 06/30/2014 11:28 PM, Paul Mackerras wrote:
> On Mon, Jun 30, 2014 at 01:35:20PM +0200, Hannes Reinecke wrote:
>> On 06/30/2014 01:02 PM, Paul Mackerras wrote:
[ .. ]
>>>
>>> No, I'm not using LVM, and in fact I deleted all the physical volum=
es
>>> that were on any of the disks (they were installations of other
>>> distros), so there are no physical or logical volumes anywhere on a=
ny
>>> disk.  I haven't tried disabling the LVM service completely, though=
=2E
>>> What would it mean if disabling the LVM service made a difference?
>>>
>> Yes. LVM integration with systemd is a science unto itself.
>> I'm reasonably confident with multipath, but not LVM.
>> Plus the fact the the LVM service apparently is waiting for somethin=
g sort
>> of points into that direction.
>>
>> So please do disable the lvm service.
>
> I disabled the LVM service, and it's still bad.  Unmodified 3.15
> booted successfully in only 18 out of 50 attempts with LVM disabled.
>
> So it's not LVM.  In any case LVM was fine with a 3.14 kernel.
>
Right, that was just a cross-check to eliminate any variables.

I'll be checking here at my end.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
