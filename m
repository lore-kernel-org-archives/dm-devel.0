From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Problem booting linux 2.6.19-rc5, 2.6.19-rc5-git6,      2.6.19-rc5-mm2
 with md raid 1 over lvm root
Date: Mon, 20 Nov 2006 14:33:19 -0500
Message-ID: <456202FF.8060709@tmr.com>
References: <41884.81.64.156.37.1163631254.squirrel@rousalka.dyndns.org> <455BB01B.2080309@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <455BB01B.2080309@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Nicolas Mailhot <nicolas.mailhot@laposte.net>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, neilb@cse.unsw.edu.au, mingo@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

Tejun Heo wrote:
> Nicolas Mailhot wrote:
>> The failing kernels (I tried -rc5, -rc5-git6, -rc5-mm2 only print :
>>
>> %<----
>> device-mapper: ioctl: 4.7.0-ioctl (2006-06-24) initialised:
>> dm-devel@redhat.com
>> md: Autodetecting RAID arrays.
>> md: autorun ...
>> md: ... autorun DONE.
>> %<-----
>>
>> (I didn't bother copying the rest of the failing kernel dmesg, as sa=
ta
>> initialisation fills the first half of the screen, then dm is=20
>> initialised,
>> then you only get the logical consequences of failing to detect the =
/
>> volume. The sata part seems fine =E2=80=93 it prints the name of the=
 hard drives
>> we want to use)
>>
>> I'm attaching the dmesg for the working distro kernel (yes I know no=
t=20
>> 100%
>> distro kernel, but very close to one), distro config , and the confi=
g I
>> used in my test. If anyone could help me to figure what's wrong I'd =
be
>> grateful.
>
> Say 'y' not 'm' to SCSI disk support.
>
That will probably work, but just building a new initrd is probably a=20
lot easier. Although I thought the SCSI modules were included if built=20
and installed if present.

--=20
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979


