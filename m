From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [RFC] IO scheduler based IO controller V6
Date: Tue, 28 Jul 2009 19:36:31 +0800
Message-ID: <4A6EE2BF.9040803@cn.fujitsu.com>
References: <1246564917-19603-1-git-send-email-vgoyal@redhat.com> <4A6D0C9A.3080600@cn.fujitsu.com> <20090727125503.GA24449@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753051AbZG1Lh5@vger.kernel.org>
In-Reply-To: <20090727125503.GA24449@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com, agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
List-Id: dm-devel.ids

Vivek Goyal wrote:
> On Mon, Jul 27, 2009 at 10:10:34AM +0800, Gui Jianfeng wrote:
>> Hi=EF=BC=8C
>>
>> Here are some fio test results for IO Controller V6 built and not bu=
ilt.
>> Iozone test results are also attached.
>>
>=20
> Hi Gui,
>=20
> Thanks a lot for some performance numbers. It seems to be a mixed cha=
rt.
> Performance gains at some places and loss at others. I am curious abo=
ut
> that -7.0% for normal writes. Not sure what can contribute to that.
>=20
> What was the value of "fairness" parameter when you ran those tests? =
Can you
> please set fairness =3D 0 and re-run the tests (if you have already n=
ot done so).
>=20
> By default fairness is set to 1 in V6. With fairness =3D 0, we should=
 be very
> close to existing CFQ behavior. If not, then we need to dive deeper a=
nd
> see why variations are happening.

  Hi Vivek,

  I tested with default fairness value, i'll re-test it when fairness i=
s set to 0.

>=20
> Is it also possible to run the same tests with V7.=20

  Sure.

--=20
Regards
Gui Jianfeng
