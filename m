From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC] IO scheduler based IO controller V6
Date: Mon, 27 Jul 2009 23:27:12 -0400
Message-ID: <20090728032712.GC3620@redhat.com>
References: <1246564917-19603-1-git-send-email-vgoyal@redhat.com>
	<4A6D0C9A.3080600@cn.fujitsu.com>
	<20090727125503.GA24449@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090727125503.GA24449@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: dhaval@linux.vnet.ibm.com, snitzer@redhat.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, akpm@linux-foundation.org, jbaron@redhat.com, linux-kernel@vger.kernel.org, s-uchida@ap.jp.nec.com, righi.andrea@gmail.com, containers@lists.linux-foundation.org
List-Id: dm-devel.ids

On Mon, Jul 27, 2009 at 08:55:03AM -0400, Vivek Goyal wrote:
> On Mon, Jul 27, 2009 at 10:10:34AM +0800, Gui Jianfeng wrote:
> > Hi=EF=BC=8C
> >=20
> > Here are some fio test results for IO Controller V6 built and not bui=
lt.
> > Iozone test results are also attached.
> >=20
>=20
> Hi Gui,
>=20
> Thanks a lot for some performance numbers. It seems to be a mixed chart=
.
> Performance gains at some places and loss at others. I am curious about
> that -7.0% for normal writes. Not sure what can contribute to that.
>=20

Gui, can you also try with CONFIG_TRACK_ASYNC_CONTEXT=3Dn and see if it i=
mproves
buffered write performance.

Thanks
Vivek

> What was the value of "fairness" parameter when you ran those tests? Ca=
n you
> please set fairness =3D 0 and re-run the tests (if you have already not=
 done so).
>=20
> By default fairness is set to 1 in V6. With fairness =3D 0, we should b=
e very
> close to existing CFQ behavior. If not, then we need to dive deeper and
> see why variations are happening.
>=20
> Is it also possible to run the same tests with V7.=20
>=20
> Thanks
> Vivek
>=20
> > Arch: X86
> > Mem:  1G
> > Disk: 320G
> > IO Scheduler: CFQ
> >=20
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > By normal read and write syscall.
> >=20
> > Block Size:32K
> > File Size: 1G * 10
> >=20
> > Mode                    Normal read   |   Random read   |   Normal wr=
ite   |   Random write | Direct read | Direct write
> >=20
> > 2.6.31-rc1              47,932KiB/s       3,566KiB/s        45,693KiB=
/s        8,501KiB/s     50,088KiB/s   43,473KiB/s
> >=20
> > 2.6.31-rc1-Vivek-V6     47,231KiB/s       3,411KiB/s        42,451KiB=
/s        8,714KiB/s     51,284KiB/s   42,341KiB/s
> >=20
> > Performance             -1.5%             -4.4%             -7.0%    =
          +2.5%          +2.4%         -2.6%
> >=20
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >=20
> > By mmap.
> >=20
> > Block Size:32K
> > File Size: 500M
> >=20
> > Mode                    Normal read   |   Random read   |   Normal wr=
ite   |   Random write
> >=20
> > 2.6.31-rc1              49,951KiB/s       3,245KiB/s        21,950KiB=
/s        2,771KiB/s
> >=20
> > 2.6.31-rc1-Vivek-V6     49,951KiB/s       3,154KiB/s        22,593KiB=
/s        2,648KiB/s
> >=20
> > Performance             0%                -2.8%             +2.9%    =
          -4.4%
> >=20
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > =20
> > By libaio calls
> >=20
> > Block Size:32K
> > File Size: 500M
> >=20
> > Mode                    Normal read   |  Random read   |   Normal wri=
te   |   Random write
> >=20
> > 2.6.31-rc1              49,447KiB/s       3,296KiB/s        57,519KiB=
/s        21,093KiB/s
> >=20
> > 2.6.31-rc1-Vivek-V6     50,142KiB/s       3,238KiB/s        57,791KiB=
/s        21,283KiB/s
> >=20
> > Performance             +1.4%             -1.8%             0%       =
          +0.1%
> >=20
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >=20
> >=20
> >=20
> >=20
> >=20
> >=20
> >=20
> >=20
> >=20
> >=20
> >=20
>=20
>=20
>=20
