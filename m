From: Nicolas Mailhot <nicolas.mailhot@laposte.net>
Subject: Re: Problem booting linux 2.6.19-rc5, 2.6.19-rc5-git6,     
	2.6.19-rc5-mm2 with md raid 1 over lvm root
Date: Mon, 20 Nov 2006 20:47:26 +0100
Message-ID: <1164052047.3004.25.camel@rousalka.dyndns.org>
References: <41884.81.64.156.37.1163631254.squirrel@rousalka.dyndns.org>
	 <455BB01B.2080309@gmail.com>  <456202FF.8060709@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <456202FF.8060709@tmr.com>
Sender: linux-ide-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, neilb@cse.unsw.edu.au, mingo@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

Le lundi 20 novembre 2006 =C3=A0 14:33 -0500, Bill Davidsen a =C3=A9cri=
t :
> Tejun Heo wrote:

> >> I'm attaching the dmesg for the working distro kernel (yes I know =
not=20
> >> 100%
> >> distro kernel, but very close to one), distro config , and the con=
fig I
> >> used in my test. If anyone could help me to figure what's wrong I'=
d be
> >> grateful.
> >
> > Say 'y' not 'm' to SCSI disk support.
> >
> That will probably work, but just building a new initrd is probably a=
=20
> lot easier. Although I thought the SCSI modules were included if buil=
t=20
> and installed if present.

Absolutely no idea why the inird-ing works on distro kernels but not
this one. Probably confused by the full-sata config

Regards,

--=20
Nicolas Mailhot
