From: Doug Dumitru <doug@easyco.com>
Subject: Re: Persistent memory interface
Date: Mon, 22 Jun 2015 09:50:39 -0700
Message-ID: <CAFx4rwTag+bCJw3nmn9_W5nq1umVE5RXeVujwmQi46gkG7zENQ@mail.gmail.com>
References: <alpine.LRH.2.02.1506191211480.30318@file01.intranet.prod.int.rdu2.redhat.com>
	<1434732620.32433.37.camel@intel.com>
Reply-To: doug@easyco.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2370018687240964900=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1434732620.32433.37.camel@intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: "axboe@fb.com" <axboe@fb.com>, "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>, "hch@lst.de" <hch@lst.de>, "luto@amacapital.net" <luto@amacapital.net>, "Busch,
	Keith" <keith.busch@intel.com>, "mpatocka@redhat.com" <mpatocka@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>, "bp@alien8.de" <bp@alien8.de>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>
List-Id: dm-devel.ids

--===============2370018687240964900==
Content-Type: multipart/alternative; boundary=20cf307ca0a8d85ba305191e12a7

--20cf307ca0a8d85ba305191e12a7
Content-Type: text/plain; charset=UTF-8

I would like to comment on the BTT docs a bit.  There are some design
points you might want to consider.

First, real use cases will have no read/write collisions.  If you think of
a file system, the case of reading a block that is being written or writing
a single block twice just don't happen because the data itself is non
deterministic.  The driver still needs to handle these cases, but
optimizing it for this is not all that logical.

Lets start at the BTT table.  It would be useful if we could distinguish
between a stable block and one that is getting updated now.  An option is
to encode the TRIM/ERROR bits as four "states"  (stable, updating, trimmed,
error) and just use the BTT entry as an index.  This could probably point
directly to the FLOG entry.  The BTT table, at four bytes, has atomic
updates without locks, so two threads can simultaneously update it to point
to the FLOG table and then after the update, see if they won.  If they did
not win, they can wait for the first update to complete.  The FLOG table
could also have a parallel RAM based BTT2 table to store spinlocks or
linked-lists to handle collisions.  Then again, a simple spin or spin/sleep
is probably good enough.

The same works for readers.  If you read a block, check the BTT table after
you finish the read.  If it is the same, your read was good.  If it changed
underneath you, or is pointing to a FLOG block, then you need to wait or
re-read.  Again, the real-world frequency of collisions is very low.  This
would let you eliminate the RTT table entirely.

One final optimization would be to keep the BTT table both in standard RAM
as well as in NV RAM.  If standard RAM is faster, then reads could lookup
blocks without touching the NV driver.  For 512G, this is 1B blocks or 4G
of RAM.  Then again, if the NV RAM is just as fast, this would not help.
Perhaps an option.

I have gotten into a lot of trouble optimizing for fio collisions when
these collisions don't really impact real-workload performance.  The code
has to be "correct" in the collision case, but it does not really need to
be fast.

Doug Dumitru
EasyCo LLC



On Fri, Jun 19, 2015 at 9:50 AM, Verma, Vishal L <vishal.l.verma@intel.com>
wrote:

> On Fri, 2015-06-19 at 12:33 -0400, Mikulas Patocka wrote:
> > Hi
> >
> > I looked at the new the persistent memory block device driver
> > (drivers/block/pmem.c and arch/x86/kernel/pmem.c) and it seems that the
> > interface between them is incorrect.
> >
> > If I want to use persistent memory in another driver, for a different
> > purpose, how can I make sure that that drivers/block/pmem.c doesn't
> attach
> > to this piece of memory and export it? It seems not possible.
> > drivers/block/pmem.c attaches to everything without regard that there may
> > be other users of persistent memory.
> >
> > I think a correct solution would be to add a partition table at the
> > beginning of persistent memory area and this partition table would
> > describe which parts belong to which programs - so that different
> programs
> > could use persistent memory and not step over each other's data. Is there
> > some effort to standardize the partition table ongoing?
> >
> >
> > BTW. some journaling filesystems assume that 512-byte sector is written
> > atomically. drivers/block/pmem.c breaks this requirement. Persistent
> > memory only gurantees 8-byte atomic writes.
>
> Hi Mikulas,
>
> I can answer this part - The idea is that file systems that need sector
> atomicity will use the "Block Translation Table" (BTT) [1]. It would be
> a stacked block device on top of a pmem device (or partition), and file
> systems would be able to use it either for the entire space to get
> atomicity for all blocks, or if they want to use DAX, make two
> partitions, and enable the BTT only on one partition, and use it as the
> logdev.
>
>         -Vishal
>
> [1]: https://lkml.org/lkml/2015/6/17/950
>
> >
> > Mikulas
> > _______________________________________________
> > Linux-nvdimm mailing list
> > Linux-nvdimm@lists.01.org
> > https://lists.01.org/mailman/listinfo/linux-nvdimm
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>



-- 
Doug Dumitru
EasyCo LLC

--20cf307ca0a8d85ba305191e12a7
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif;font-size:small">I would like to comment on the BTT docs=
 a bit.=C2=A0 There are some design points you might want to consider.<br><=
br></div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,=
sans-serif;font-size:small">First, real use cases will have no read/write c=
ollisions.=C2=A0 If you think of a file system, the case of reading a block=
 that is being written or writing a single block twice just don&#39;t happe=
n because the data itself is non deterministic.=C2=A0 The driver still need=
s to handle these cases, but optimizing it for this is not all that logical=
.<br><br></div><div class=3D"gmail_default" style=3D"font-family:arial,helv=
etica,sans-serif;font-size:small">Lets start at the BTT table.=C2=A0 It wou=
ld be useful if we could distinguish between a stable block and one that is=
 getting updated now.=C2=A0 An option is to encode the TRIM/ERROR bits as f=
our &quot;states&quot;=C2=A0 (stable, updating, trimmed, error) and just us=
e the BTT entry as an index.=C2=A0 This could probably point directly to th=
e FLOG entry.=C2=A0 The BTT table, at four bytes, has atomic updates withou=
t locks, so two threads can simultaneously update it to point to the FLOG t=
able and then after the update, see if they won.=C2=A0 If they did not win,=
 they can wait for the first update to complete.=C2=A0 The FLOG table could=
 also have a parallel RAM based BTT2 table to store spinlocks or linked-lis=
ts to handle collisions.=C2=A0 Then again, a simple spin or spin/sleep is p=
robably good enough.<br><br></div><div class=3D"gmail_default" style=3D"fon=
t-family:arial,helvetica,sans-serif;font-size:small">The same works for rea=
ders.=C2=A0 If you read a block, check the BTT table after you finish the r=
ead.=C2=A0 If it is the same, your read was good.=C2=A0 If it changed under=
neath you, or is pointing to a FLOG block, then you need to wait or re-read=
.=C2=A0 Again, the real-world frequency of collisions is very low.=C2=A0 Th=
is would let you eliminate the RTT table entirely.<br><br></div><div class=
=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;font-siz=
e:small">One final optimization would be to keep the BTT table both in stan=
dard RAM as well as in NV RAM.=C2=A0 If standard RAM is faster, then reads =
could lookup blocks without touching the NV driver.=C2=A0 For 512G, this is=
 1B blocks or 4G of RAM.=C2=A0 Then again, if the NV RAM is just as fast, t=
his would not help.=C2=A0 Perhaps an option.<br><br></div><div class=3D"gma=
il_default" style=3D"font-family:arial,helvetica,sans-serif;font-size:small=
">I have gotten into a lot of trouble optimizing for fio collisions when th=
ese collisions don&#39;t really impact real-workload performance.=C2=A0 The=
 code has to be &quot;correct&quot; in the collision case, but it does not =
really need to be fast.<br></div><div class=3D"gmail_default" style=3D"font=
-family:arial,helvetica,sans-serif;font-size:small"><br></div><div class=3D=
"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;font-size:s=
mall">Doug Dumitru<br></div><div class=3D"gmail_default" style=3D"font-fami=
ly:arial,helvetica,sans-serif;font-size:small">EasyCo LLC<br></div><div cla=
ss=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;font-s=
ize:small"><br><br></div></div><div class=3D"gmail_extra"><br><div class=3D=
"gmail_quote">On Fri, Jun 19, 2015 at 9:50 AM, Verma, Vishal L <span dir=3D=
"ltr">&lt;<a href=3D"mailto:vishal.l.verma@intel.com" target=3D"_blank">vis=
hal.l.verma@intel.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_q=
uote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1e=
x"><div class=3D"HOEnZb"><div class=3D"h5">On Fri, 2015-06-19 at 12:33 -040=
0, Mikulas Patocka wrote:<br>
&gt; Hi<br>
&gt;<br>
&gt; I looked at the new the persistent memory block device driver<br>
&gt; (drivers/block/pmem.c and arch/x86/kernel/pmem.c) and it seems that th=
e<br>
&gt; interface between them is incorrect.<br>
&gt;<br>
&gt; If I want to use persistent memory in another driver, for a different<=
br>
&gt; purpose, how can I make sure that that drivers/block/pmem.c doesn&#39;=
t attach<br>
&gt; to this piece of memory and export it? It seems not possible.<br>
&gt; drivers/block/pmem.c attaches to everything without regard that there =
may<br>
&gt; be other users of persistent memory.<br>
&gt;<br>
&gt; I think a correct solution would be to add a partition table at the<br=
>
&gt; beginning of persistent memory area and this partition table would<br>
&gt; describe which parts belong to which programs - so that different prog=
rams<br>
&gt; could use persistent memory and not step over each other&#39;s data. I=
s there<br>
&gt; some effort to standardize the partition table ongoing?<br>
&gt;<br>
&gt;<br>
&gt; BTW. some journaling filesystems assume that 512-byte sector is writte=
n<br>
&gt; atomically. drivers/block/pmem.c breaks this requirement. Persistent<b=
r>
&gt; memory only gurantees 8-byte atomic writes.<br>
<br>
</div></div>Hi Mikulas,<br>
<br>
I can answer this part - The idea is that file systems that need sector<br>
atomicity will use the &quot;Block Translation Table&quot; (BTT) [1]. It wo=
uld be<br>
a stacked block device on top of a pmem device (or partition), and file<br>
systems would be able to use it either for the entire space to get<br>
atomicity for all blocks, or if they want to use DAX, make two<br>
partitions, and enable the BTT only on one partition, and use it as the<br>
logdev.<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 -Vishal<br>
<br>
[1]: <a href=3D"https://lkml.org/lkml/2015/6/17/950" rel=3D"noreferrer" tar=
get=3D"_blank">https://lkml.org/lkml/2015/6/17/950</a><br>
<br>
&gt;<br>
&gt; Mikulas<br>
&gt; _______________________________________________<br>
&gt; Linux-nvdimm mailing list<br>
&gt; <a href=3D"mailto:Linux-nvdimm@lists.01.org">Linux-nvdimm@lists.01.org=
</a><br>
&gt; <a href=3D"https://lists.01.org/mailman/listinfo/linux-nvdimm" rel=3D"=
noreferrer" target=3D"_blank">https://lists.01.org/mailman/listinfo/linux-n=
vdimm</a><br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a>=
<br>
</div></div></blockquote></div><br><br clear=3D"all"><br>-- <br><div class=
=3D"gmail_signature">Doug Dumitru<br>EasyCo LLC<br></div>
</div>

--20cf307ca0a8d85ba305191e12a7--


--===============2370018687240964900==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2370018687240964900==--
