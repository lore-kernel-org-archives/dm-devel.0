From: Corrado Zoccolo <czoccolo@gmail.com>
Subject: Re: IO scheduler based IO controller V10
Date: Sat, 3 Oct 2009 00:14:28 +0200
Message-ID: <4e5e476b0910021514i1b461229t667bed94fd67f140@mail.gmail.com>
References: <200910021255.27689.czoccolo@gmail.com>
	<20091002124921.GA4494@redhat.com>
	<4e5e476b0910020827s23e827b1n847c64e355999d4a@mail.gmail.com>
	<1254497520.10392.11.camel@marge.simson.net>
	<20091002154020.GC4494@redhat.com>
	<12774.1254502217@turing-police.cc.vt.edu>
	<20091002195815.GE4494@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091002195815.GE4494@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, Jens Axboe <jens.axboe@oracle.com>, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, fernando@oss.ntt.co.jp, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, mikew@google.com, jmoyer@redhat.com, nauman@google.com, Ingo Molnar <mingo@elte.hu>, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, Valdis.Kletnieks@vt.edu, containers@lists.linux-foundation.org, Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

On Fri, Oct 2, 2009 at 9:58 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Fri, Oct 02, 2009 at 12:50:17PM -0400, Valdis.Kletnieks@vt.edu wrote=
:
>> On Fri, 02 Oct 2009 11:40:20 EDT, Vivek Goyal said:
>>
>> Umm... I got petabytes of hardware RAID across the hall that very defi=
nitely
>> *is* rotating. =C2=A0Did you mean "SSD and disk systems with big honki=
ng caches
>> that cover up the rotation"? =C2=A0Because "RAID" and "big honking cac=
hes" are
>> not *quite* the same thing, and I can just see that corner case coming=
 out
>> to bite somebody on the ass...
>>
>
> I guess both. The systems which have big caches and cover up for rotati=
on,
> we probably need not idle for seeky process. An in case of big hardware
> RAID, having multiple rotating disks, instead of idling and keeping res=
t
> of the disks free, we probably are better off dispatching requests from
> next queue (hoping it is going to a different disk altogether).

In fact I think that the 'rotating' flag name is misleading.
All the checks we are doing are actually checking if the device truly
supports multiple parallel operations, and this feature is shared by
hardware raids and NCQ enabled SSDs, but not by cheap SSDs or single
NCQ-enabled SATA disk.

If we really wanted a "seek is cheap" flag, we could measure seek time
in the io-scheduler itself, but in the current code base we don't have
it used in this meaning anywhere.

Thanks,
Corrado

>
> Thanks
> Vivek
>



--=20
_________________________________________________________________________=
_

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
-------------------------------------------------------------------------=
-
The self-confidence of a warrior is not the self-confidence of the averag=
e
man. The average man seeks certainty in the eyes of the onlooker and call=
s
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
                               Tales of Power - C. Castaneda
