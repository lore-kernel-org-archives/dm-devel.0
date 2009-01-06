From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [git pull] device-mapper patches for 2.6.29
Date: Tue, 06 Jan 2009 12:59:40 +0100
Message-ID: <496347AC.5000203@s5r6.in-berlin.de>
References: <20081010125159.GK5098@agk.fab.redhat.com>	 <20090105191824.GP5098@agk.fab.redhat.com>	 <alpine.LFD.2.00.0901051843570.3057@localhost.localdomain>	 <91b13c310901051915i38e05125tb89b3335922d274e@mail.gmail.com>	 <20090106032118.GC3512@agk.fab.redhat.com> <91b13c310901051932p1343f9eei1db5534e6e10d238@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752346AbZAFMAk@vger.kernel.org>
In-Reply-To: <91b13c310901051932p1343f9eei1db5534e6e10d238@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?B?IkNoZW5nIFJlbnF1YW4gKOeoi+S7u+WFqCki?= <crquan@gmail.com>
Cc: Alasdair G Kergon <agk@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Jonathan Brassow <jbrassow@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <mbroz@redhat.com>, Andi Kleen <ak@suse.de>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Takahiro Yasui <tyasui@redhat.com>
List-Id: dm-devel.ids

Cheng Renquan (=E7=A8=8B=E4=BB=BB=E5=85=A8) wrote:
> On Tue, Jan 6, 2009 at 11:21 AM, Alasdair G Kergon <agk@redhat.com> w=
rote:
>> On Tue, Jan 06, 2009 at 11:15:58AM +0800, Cheng Renquan (=E7=A8=8B=E4=
=BB=BB=E5=85=A8) wrote:
>>> So now maybe we can add a null macro to module_refcount if
>>> CONFIG_MODULE_UNLOAD undefined?
>>
>> Do we even need the test at all?
>=20
> So you mean add "#ifdef CONFIG_MODULE_UNLOAD ..." to dm-target.c? I
> can do that, but I really don't know a better solution without
> conditional compiling?

The fact that module_refcount may be undefined is an indicator that thi=
s
is not an API for general use.

Why are you wanting to peek into the reference count of a module?
Shouldn't you have everything covered by properly recounting all your
data objects?  (Preferably via the kref API.)
--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D=3D--=3D ---=3D --=3D=3D-
http://arcgraph.de/sr/
