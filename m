From: Doug Dumitru <doug@easyco.com>
Subject: Re: Persistent memory interface
Date: Mon, 22 Jun 2015 15:17:23 -0700
Message-ID: <CAFx4rwR2aphz0mMdCaGFnhhbV5_+0j8B95uwMgeUY1mnEoLzgg@mail.gmail.com>
References: <alpine.LRH.2.02.1506191211480.30318@file01.intranet.prod.int.rdu2.redhat.com>
	<1434732620.32433.37.camel@intel.com>
	<CAFx4rwTag+bCJw3nmn9_W5nq1umVE5RXeVujwmQi46gkG7zENQ@mail.gmail.com>
	<1435008321.32433.79.camel@intel.com>
Reply-To: doug@easyco.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8855023706184023451=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1435008321.32433.79.camel@intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "Busch, Keith" <keith.busch@intel.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>, "luto@amacapital.net" <luto@amacapital.net>, "axboe@fb.com" <axboe@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "mpatocka@redhat.com" <mpatocka@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>, "bp@alien8.de" <bp@alien8.de>, "tglx@linutronix.de" <tglx@linutronix.de>, "hch@lst.de" <hch@lst.de>
List-Id: dm-devel.ids

--===============8855023706184023451==
Content-Type: multipart/alternative; boundary=001a1135fb385d9254051922a35a

--001a1135fb385d9254051922a35a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Mr. Verma,

I am used  to doing all of this strictly in DRAM, so my optimization
background has differing overhead points.

On Mon, Jun 22, 2015 at 2:25 PM, Verma, Vishal L <vishal.l.verma@intel.com>
wrote:

> On Mon, 2015-06-22 at 09:50 -0700, Doug Dumitru wrote:
> > I would like to comment on the BTT docs a bit.  There are some design
> > points you might want to consider.
> >
> Hi Doug,
> Thanks for the design review -
> >
> > First, real use cases will have no read/write collisions.  If you
> > think of a file system, the case of reading a block that is being
> > written or writing a single block twice just don't happen because the
> > data itself is non deterministic.  The driver still needs to handle
> > these cases, but optimizing it for this is not all that logical.
> >
> Agreed - we did try to keep this in mind, and I still have a list of
> experiments to try that might further reduce the impact of collision
> handling on normal IO.
> >
> > Lets start at the BTT table.  It would be useful if we could
> > distinguish between a stable block and one that is getting updated
> > now.  An option is to encode the TRIM/ERROR bits as four "states"
> > (stable, updating, trimmed, error) and just use the BTT entry as an
> > index.  This could probably point directly to the FLOG entry.  The BTT
> > table, at four bytes, has atomic updates without locks, so two threads
> > can simultaneously update it to point to the FLOG table and then after
> > the update, see if they won.  If they did not win, they can wait for
> > the first update to complete.  The FLOG table could also have a
> > parallel RAM based BTT2 table to store spinlocks or linked-lists to
> > handle collisions.  Then again, a simple spin or spin/sleep is
> > probably good enough.
>
> So first off, this made me realize the documentation was slightly dated
> w.r.t. the use of the 'E' and 'Z' flags - we currently (and the code
> reflects this) do use all four states from those two bits. (The next
> posting of this patchset should reflect this change).
>
> Bit      Description
> 31 - 30 : Error and Zero flags - Used in the following way:
>          Bit                  Description
>         31 30
>
> -----------------------------------------------------------------------
>          00     Initial state. Reads return zeroes; Premap =3D Postmap
>          01     Zero state: Reads return zeroes
>          10     Error state: Reads fail; Writes clear 'E' bit
>          11     Normal Block =E2=80=93 has valid postmap
>
> 29 - 0  : Mappings to internal 'postmap' blocks
>
> Apart from this, I didn't quite understand what you meant by:
> > ... and just use the BTT entry as an index.  This could probably point
> directly to the FLOG entry.
>
> Care to elaborate with an example maybe?
>

=E2=80=8BI am not sure how "committed" to binary region sizes here, but the=
 first
thing that sticks out is that all but the normal state don't really need an
index entry.  If you are willing to suffer some "non binary divide"
operations, you can increase the efficiency of your region by using these 4
bytes as:

0 - Initial state
1 - Zero/trim/discard block, but why not just '0' above
2 - Error
3-F - Future flags
10-FFFF - index into FLOG table
10000-FFFFFFFF - index directly into RAM store

=E2=80=8BThis pushes the region to just under 4B entries (2TB with 512 and =
16TB
with 4K).  If you must stay binary, consider a single bit.=E2=80=8B

0 - Initial state
1 - Zero
2 - Error
10-FFFF - index into FLOW table
8FFFFFFFF - FFFFFFFF - index directly into RAM store

=E2=80=8BThe FLOG table can have pre/post RAM store index (per your current
design), so a read on a write has to do a double lookup, but that might be
good anyway, and the double lookup is only on a collision anyway.

In terms of read overlaps, you could argue you can do this without a lock.
If you read a BTT entry and it is 1000-FFFFFFFF, and you deterministically
control how often a block gets re-used, it is safe to just read even if an
update starts half-way through.  If you want to be paranoid, setup an
atomic for updates that the read can use to protect itself.

read update ATOMIC
read BTT
if BTT is not an index into the FLOG table=E2=80=8B then read data
read update ATOMIC again
If ATOMIC has not moved more than the guaranteed blocks over commit number,
you know the read is valid data and the block has not been overwritten.

The write logic just increments the ATOMIC (and lets it wrap around)
whenever a new block is used.  As long as the avail block first-in
first-out list is slightly bigger than the advertised device capacity, you
can guarantee "N" updates before a read gets the rug pulled out from under
it.

>
> >
> > The same works for readers.  If you read a block, check the BTT table
> > after you finish the read.  If it is the same, your read was good.  If
> > it changed underneath you, or is pointing to a FLOG block, then you
> > need to wait or re-read.  Again, the real-world frequency of
> > collisions is very low.  This would let you eliminate the RTT table
> > entirely.
>
> There are a couple of issues I see with this -
> 1. This could, theoretically, suffer from the A-B-A problem - a writer
> could update the same mapping twice, ending up with an apparently
> untouched map entry, but the data has gone through churn while the
> reader was still reading it.
> 2. Writing/reading the RTT is cheap as it is entirely in DRAM memory,
> whereas another check on the map would mean NVDIMM IO, which could
> potentially be slow enough to offset any benefit from getting rid of the
> RTT.
>

=E2=80=8BIf the API read is expensive, then you are probably right.  Consid=
er an
ATOMIC DRAM counter as described above.  This requires you to keep a small
number of blocks "spare" so that reads complete before they can get
clobbered, but this lets reads run lock free.=E2=80=8B


>
> One of the pending tests I plan to do is to make the RTT a hash map
> instead of a list. i.e. Reader adds a refcount to rtt[postmap ABA], and
> writer checks just RTT[free-block]. This keeps things the same for the
> reader, but for writers, they are sapred from walking a list, at the
> cost of false hash collisions. Obviously, with this path we'd have to
> make the RTT a lot bigger than it currently is - and we'd need to figure
> out if the increased memory footprint, and hash collisions outweigh the
> cost of walking an in-memory list..
>

=E2=80=8BIf the BTT is a pointer to the FLOG, I think the RTT can go away e=
ntirely.=E2=80=8B


> >
> >
> > One final optimization would be to keep the BTT table both in standard
> > RAM as well as in NV RAM.  If standard RAM is faster, then reads could
> > lookup blocks without touching the NV driver.  For 512G, this is 1B
> > blocks or 4G of RAM.  Then again, if the NV RAM is just as fast, this
> > would not help.  Perhaps an option.
>
> We've thought about this, and while it could help, the added complexity
> of keeping the two in sync may make it debatable - we'll have to
> re-evaluate once NVDIMMs become more easily available :)
>

=E2=80=8BIt should just be a double update of the same four bytes to both p=
laces.
Update the RAM last but only ACK the write after both are written and
memory fenced.  If a read comes along and gets the RAM image out of sync
with the NV image, you are reading "during" a write so getting the previous
data is still "correct"=E2=80=8B

=E2=80=8Bas you started the read before the write ACKd.
=E2=80=8B

> >
> >
> > I have gotten into a lot of trouble optimizing for fio collisions when
> > these collisions don't really impact real-workload performance.  The
> > code has to be "correct" in the collision case, but it does not really
> > need to be fast.
> >
> >
> >
> > Doug Dumitru
> >
> > EasyCo LLC
> >
> >
> >
> >
> >
> > On Fri, Jun 19, 2015 at 9:50 AM, Verma, Vishal L
> > <vishal.l.verma@intel.com> wrote:
> >         On Fri, 2015-06-19 at 12:33 -0400, Mikulas Patocka wrote:
> >         > Hi
> >         >
> >         > I looked at the new the persistent memory block device
> >         driver
> >         > (drivers/block/pmem.c and arch/x86/kernel/pmem.c) and it
> >         seems that the
> >         > interface between them is incorrect.
> >         >
> >         > If I want to use persistent memory in another driver, for a
> >         different
> >         > purpose, how can I make sure that that drivers/block/pmem.c
> >         doesn't attach
> >         > to this piece of memory and export it? It seems not
> >         possible.
> >         > drivers/block/pmem.c attaches to everything without regard
> >         that there may
> >         > be other users of persistent memory.
> >         >
> >         > I think a correct solution would be to add a partition table
> >         at the
> >         > beginning of persistent memory area and this partition table
> >         would
> >         > describe which parts belong to which programs - so that
> >         different programs
> >         > could use persistent memory and not step over each other's
> >         data. Is there
> >         > some effort to standardize the partition table ongoing?
> >         >
> >         >
> >         > BTW. some journaling filesystems assume that 512-byte sector
> >         is written
> >         > atomically. drivers/block/pmem.c breaks this requirement.
> >         Persistent
> >         > memory only gurantees 8-byte atomic writes.
> >
> >
> >         Hi Mikulas,
> >
> >         I can answer this part - The idea is that file systems that
> >         need sector
> >         atomicity will use the "Block Translation Table" (BTT) [1]. It
> >         would be
> >         a stacked block device on top of a pmem device (or partition),
> >         and file
> >         systems would be able to use it either for the entire space to
> >         get
> >         atomicity for all blocks, or if they want to use DAX, make two
> >         partitions, and enable the BTT only on one partition, and use
> >         it as the
> >         logdev.
> >
> >                 -Vishal
> >
> >         [1]: https://lkml.org/lkml/2015/6/17/950
> >
> >         >
> >         > Mikulas
> >         > _______________________________________________
> >         > Linux-nvdimm mailing list
> >         > Linux-nvdimm@lists.01.org
> >         > https://lists.01.org/mailman/listinfo/linux-nvdimm
> >
> >
> >         --
> >         dm-devel mailing list
> >         dm-devel@redhat.com
> >         https://www.redhat.com/mailman/listinfo/dm-devel
> >
> >
> >
> >
> > --
> > Doug Dumitru
> > EasyCo LLC
> >
> > _______________________________________________
> > Linux-nvdimm mailing list
> > Linux-nvdimm@lists.01.org
> > https://lists.01.org/mailman/listinfo/linux-nvdimm
>
>
=E2=80=8BMy comment on block sizes was only 512/4K, but the code should be =
easy to
=E2=80=8Bsetup at anything binary.


--=20
Doug Dumitru
EasyCo LLC

--001a1135fb385d9254051922a35a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif;font-size:small">Mr. Verma,<br><br></div><div class=3D"g=
mail_default" style=3D"font-family:arial,helvetica,sans-serif;font-size:sma=
ll">I am used=C2=A0 to doing all of this strictly in DRAM, so my optimizati=
on background has differing overhead points.<br></div><div class=3D"gmail_e=
xtra"><br><div class=3D"gmail_quote">On Mon, Jun 22, 2015 at 2:25 PM, Verma=
, Vishal L <span dir=3D"ltr">&lt;<a href=3D"mailto:vishal.l.verma@intel.com=
" target=3D"_blank">vishal.l.verma@intel.com</a>&gt;</span> wrote:<br><bloc=
kquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #cc=
c solid;padding-left:1ex"><span class=3D"">On Mon, 2015-06-22 at 09:50 -070=
0, Doug Dumitru wrote:<br>
&gt; I would like to comment on the BTT docs a bit.=C2=A0 There are some de=
sign<br>
&gt; points you might want to consider.<br>
&gt;<br>
</span>Hi Doug,<br>
Thanks for the design review -<br>
<span class=3D"">&gt;<br>
&gt; First, real use cases will have no read/write collisions.=C2=A0 If you=
<br>
&gt; think of a file system, the case of reading a block that is being<br>
&gt; written or writing a single block twice just don&#39;t happen because =
the<br>
&gt; data itself is non deterministic.=C2=A0 The driver still needs to hand=
le<br>
&gt; these cases, but optimizing it for this is not all that logical.<br>
&gt;<br>
</span>Agreed - we did try to keep this in mind, and I still have a list of=
<br>
experiments to try that might further reduce the impact of collision<br>
handling on normal IO.<br>
<span class=3D"">&gt;<br>
&gt; Lets start at the BTT table.=C2=A0 It would be useful if we could<br>
&gt; distinguish between a stable block and one that is getting updated<br>
&gt; now.=C2=A0 An option is to encode the TRIM/ERROR bits as four &quot;st=
ates&quot;<br>
&gt; (stable, updating, trimmed, error) and just use the BTT entry as an<br=
>
&gt; index.=C2=A0 This could probably point directly to the FLOG entry.=C2=
=A0 The BTT<br>
&gt; table, at four bytes, has atomic updates without locks, so two threads=
<br>
&gt; can simultaneously update it to point to the FLOG table and then after=
<br>
&gt; the update, see if they won.=C2=A0 If they did not win, they can wait =
for<br>
&gt; the first update to complete.=C2=A0 The FLOG table could also have a<b=
r>
&gt; parallel RAM based BTT2 table to store spinlocks or linked-lists to<br=
>
&gt; handle collisions.=C2=A0 Then again, a simple spin or spin/sleep is<br=
>
&gt; probably good enough.<br>
<br>
</span>So first off, this made me realize the documentation was slightly da=
ted<br>
w.r.t. the use of the &#39;E&#39; and &#39;Z&#39; flags - we currently (and=
 the code<br>
reflects this) do use all four states from those two bits. (The next<br>
posting of this patchset should reflect this change).<br>
<br>
Bit=C2=A0 =C2=A0 =C2=A0 Description<br>
31 - 30 : Error and Zero flags - Used in the following way:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Bit=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 Description<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 31 30<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 -----------------------------------------------=
------------------------<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A000=C2=A0 =C2=A0 =C2=A0Initial state. Read=
s return zeroes; Premap =3D Postmap<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A001=C2=A0 =C2=A0 =C2=A0Zero state: Reads r=
eturn zeroes<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A010=C2=A0 =C2=A0 =C2=A0Error state: Reads =
fail; Writes clear &#39;E&#39; bit<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A011=C2=A0 =C2=A0 =C2=A0Normal Block =E2=80=
=93 has valid postmap<br>
<br>
29 - 0=C2=A0 : Mappings to internal &#39;postmap&#39; blocks<br>
<br>
Apart from this, I didn&#39;t quite understand what you meant by:<br>
&gt; ... and just use the BTT entry as an index.=C2=A0 This could probably =
point<br>
<span class=3D"">directly to the FLOG entry.<br>
<br>
</span>Care to elaborate with an example maybe?<br></blockquote><div><br><d=
iv class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;=
font-size:small;display:inline">=E2=80=8BI am not sure how &quot;committed&=
quot; to binary region sizes here, but the first thing that sticks out is t=
hat all but the normal state don&#39;t really need an index entry.=C2=A0 If=
 you are willing to suffer some &quot;non binary divide&quot; operations, y=
ou can increase the efficiency of your region by using these 4 bytes as:<br=
><br></div><div class=3D"gmail_default" style=3D"font-family:arial,helvetic=
a,sans-serif;font-size:small;display:inline">0 - Initial state<br></div><di=
v class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;f=
ont-size:small;display:inline">1 - Zero/trim/discard block, but why not jus=
t &#39;0&#39; above<br></div><div class=3D"gmail_default" style=3D"font-fam=
ily:arial,helvetica,sans-serif;font-size:small;display:inline">2 - Error<br=
></div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sa=
ns-serif;font-size:small;display:inline">3-F - Future flags<br></div><div c=
lass=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;font=
-size:small;display:inline">10-FFFF - index into FLOG table<br></div><div c=
lass=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;font=
-size:small;display:inline">10000-FFFFFFFF - index directly into RAM store<=
br><br></div><div class=3D"gmail_default" style=3D"font-family:arial,helvet=
ica,sans-serif;font-size:small">=E2=80=8BThis pushes the region to just und=
er 4B entries (2TB with 512 and 16TB with 4K).=C2=A0 If you must stay binar=
y, consider a single bit.=E2=80=8B<br><br></div><div class=3D"gmail_default=
" style=3D"font-family:arial,helvetica,sans-serif;font-size:small">0 - Init=
ial state<br></div><div class=3D"gmail_default" style=3D"font-family:arial,=
helvetica,sans-serif;font-size:small">1 - Zero<br></div><div class=3D"gmail=
_default" style=3D"font-family:arial,helvetica,sans-serif;font-size:small">=
2 - Error<br></div><div class=3D"gmail_default" style=3D"font-family:arial,=
helvetica,sans-serif;font-size:small">10-FFFF - index into FLOW table<br></=
div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-=
serif;font-size:small">8FFFFFFFF - FFFFFFFF - index directly into RAM store=
<br></div><br><div class=3D"gmail_default" style=3D"font-family:arial,helve=
tica,sans-serif;font-size:small;display:inline">=E2=80=8BThe FLOG table can=
 have pre/post RAM store index (per your current design), so a read on a wr=
ite has to do a double lookup, but that might be good anyway, and the doubl=
e lookup is only on a collision anyway.<br><br></div><div class=3D"gmail_de=
fault" style=3D"font-family:arial,helvetica,sans-serif;font-size:small;disp=
lay:inline">In terms of read overlaps, you could argue you can do this with=
out a lock.=C2=A0 If you read a BTT entry and it is 1000-FFFFFFFF, and you =
deterministically control how often a block gets re-used, it is safe to jus=
t read even if an update starts half-way through.=C2=A0 If you want to be p=
aranoid, setup an atomic for updates that the read can use to protect itsel=
f.<br><br></div><div class=3D"gmail_default" style=3D"font-family:arial,hel=
vetica,sans-serif;font-size:small;display:inline">read update ATOMIC<br></d=
iv><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-s=
erif;font-size:small;display:inline">read BTT<br></div><div class=3D"gmail_=
default" style=3D"font-family:arial,helvetica,sans-serif;font-size:small;di=
splay:inline">if BTT is not an index into the FLOG table=E2=80=8B then read=
 data<br></div><div class=3D"gmail_default" style=3D"font-family:arial,helv=
etica,sans-serif;font-size:small;display:inline">read update ATOMIC again<b=
r></div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,s=
ans-serif;font-size:small;display:inline">If ATOMIC has not moved more than=
 the guaranteed blocks over commit number, you know the read is valid data =
and the block has not been overwritten.<br><br></div><div class=3D"gmail_de=
fault" style=3D"font-family:arial,helvetica,sans-serif;font-size:small;disp=
lay:inline">The write logic just increments the ATOMIC (and lets it wrap ar=
ound) whenever a new block is used.=C2=A0 As long as the avail block first-=
in first-out list is slightly bigger than the advertised device capacity, y=
ou can guarantee &quot;N&quot; updates before a read gets the rug pulled ou=
t from under it.<br><br></div></div><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<span class=3D"">&gt;<br>
&gt;<br>
&gt; The same works for readers.=C2=A0 If you read a block, check the BTT t=
able<br>
&gt; after you finish the read.=C2=A0 If it is the same, your read was good=
.=C2=A0 If<br>
&gt; it changed underneath you, or is pointing to a FLOG block, then you<br=
>
&gt; need to wait or re-read.=C2=A0 Again, the real-world frequency of<br>
&gt; collisions is very low.=C2=A0 This would let you eliminate the RTT tab=
le<br>
&gt; entirely.<br>
<br>
</span>There are a couple of issues I see with this -<br>
1. This could, theoretically, suffer from the A-B-A problem - a writer<br>
could update the same mapping twice, ending up with an apparently<br>
untouched map entry, but the data has gone through churn while the<br>
reader was still reading it.<br>
2. Writing/reading the RTT is cheap as it is entirely in DRAM memory,<br>
whereas another check on the map would mean NVDIMM IO, which could<br>
potentially be slow enough to offset any benefit from getting rid of the<br=
>
RTT.<br></blockquote><div><br><div class=3D"gmail_default" style=3D"font-fa=
mily:arial,helvetica,sans-serif;font-size:small;display:inline">=E2=80=8BIf=
 the API read is expensive, then you are probably right.=C2=A0 Consider an =
ATOMIC DRAM counter as described above.=C2=A0 This requires you to keep a s=
mall number of blocks &quot;spare&quot; so that reads complete before they =
can get clobbered, but this lets reads run lock free.=E2=80=8B</div>=C2=A0<=
/div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-le=
ft:1px #ccc solid;padding-left:1ex">
<br>
One of the pending tests I plan to do is to make the RTT a hash map<br>
instead of a list. i.e. Reader adds a refcount to rtt[postmap ABA], and<br>
writer checks just RTT[free-block]. This keeps things the same for the<br>
reader, but for writers, they are sapred from walking a list, at the<br>
cost of false hash collisions. Obviously, with this path we&#39;d have to<b=
r>
make the RTT a lot bigger than it currently is - and we&#39;d need to figur=
e<br>
out if the increased memory footprint, and hash collisions outweigh the<br>
cost of walking an in-memory list..<br></blockquote><div><br><div class=3D"=
gmail_default" style=3D"font-family:arial,helvetica,sans-serif;font-size:sm=
all;display:inline">=E2=80=8BIf the BTT is a pointer to the FLOG, I think t=
he RTT can go away entirely.=E2=80=8B</div>=C2=A0</div><blockquote class=3D=
"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding=
-left:1ex">
<span class=3D"">&gt;<br>
&gt;<br>
&gt; One final optimization would be to keep the BTT table both in standard=
<br>
&gt; RAM as well as in NV RAM.=C2=A0 If standard RAM is faster, then reads =
could<br>
&gt; lookup blocks without touching the NV driver.=C2=A0 For 512G, this is =
1B<br>
&gt; blocks or 4G of RAM.=C2=A0 Then again, if the NV RAM is just as fast, =
this<br>
&gt; would not help.=C2=A0 Perhaps an option.<br>
<br>
</span>We&#39;ve thought about this, and while it could help, the added com=
plexity<br>
of keeping the two in sync may make it debatable - we&#39;ll have to<br>
re-evaluate once NVDIMMs become more easily available :)<br></blockquote><d=
iv><br><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sa=
ns-serif;font-size:small;display:inline">=E2=80=8BIt should just be a doubl=
e update of the same four bytes to both places.=C2=A0 Update the RAM last b=
ut only ACK the write after both are written and memory fenced.=C2=A0 If a =
read comes along and gets the RAM image out of sync with the NV image, you =
are reading &quot;during&quot; a write so getting the previous data is stil=
l &quot;correct&quot;=E2=80=8B</div>=C2=A0<div class=3D"gmail_default" styl=
e=3D"font-family:arial,helvetica,sans-serif;font-size:small;display:inline"=
>=E2=80=8Bas you started the read before the write ACKd.<br>=E2=80=8B</div>=
</div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-l=
eft:1px #ccc solid;padding-left:1ex">
<div class=3D"HOEnZb"><div class=3D"h5">&gt;<br>
&gt;<br>
&gt; I have gotten into a lot of trouble optimizing for fio collisions when=
<br>
&gt; these collisions don&#39;t really impact real-workload performance.=C2=
=A0 The<br>
&gt; code has to be &quot;correct&quot; in the collision case, but it does =
not really<br>
&gt; need to be fast.<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; Doug Dumitru<br>
&gt;<br>
&gt; EasyCo LLC<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; On Fri, Jun 19, 2015 at 9:50 AM, Verma, Vishal L<br>
&gt; &lt;<a href=3D"mailto:vishal.l.verma@intel.com">vishal.l.verma@intel.c=
om</a>&gt; wrote:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0On Fri, 2015-06-19 at 12:33 -0400, Mi=
kulas Patocka wrote:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&gt; Hi<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&gt; I looked at the new the persiste=
nt memory block device<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0driver<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&gt; (drivers/block/pmem.c and arch/x=
86/kernel/pmem.c) and it<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0seems that the<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&gt; interface between them is incorr=
ect.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&gt; If I want to use persistent memo=
ry in another driver, for a<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0different<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&gt; purpose, how can I make sure tha=
t that drivers/block/pmem.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0doesn&#39;t attach<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&gt; to this piece of memory and expo=
rt it? It seems not<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0possible.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&gt; drivers/block/pmem.c attaches to=
 everything without regard<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0that there may<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&gt; be other users of persistent mem=
ory.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&gt; I think a correct solution would=
 be to add a partition table<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0at the<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&gt; beginning of persistent memory a=
rea and this partition table<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0would<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&gt; describe which parts belong to w=
hich programs - so that<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0different programs<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&gt; could use persistent memory and =
not step over each other&#39;s<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0data. Is there<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&gt; some effort to standardize the p=
artition table ongoing?<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&gt; BTW. some journaling filesystems=
 assume that 512-byte sector<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0is written<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&gt; atomically. drivers/block/pmem.c=
 breaks this requirement.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Persistent<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&gt; memory only gurantees 8-byte ato=
mic writes.<br>
&gt;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Hi Mikulas,<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0I can answer this part - The idea is =
that file systems that<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0need sector<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0atomicity will use the &quot;Block Tr=
anslation Table&quot; (BTT) [1]. It<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0would be<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0a stacked block device on top of a pm=
em device (or partition),<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0and file<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0systems would be able to use it eithe=
r for the entire space to<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0get<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0atomicity for all blocks, or if they =
want to use DAX, make two<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0partitions, and enable the BTT only o=
n one partition, and use<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0it as the<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0logdev.<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0-Vishal<b=
r>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[1]: <a href=3D"https://lkml.org/lkml=
/2015/6/17/950" rel=3D"noreferrer" target=3D"_blank">https://lkml.org/lkml/=
2015/6/17/950</a><br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&gt; Mikulas<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&gt; ________________________________=
_______________<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&gt; Linux-nvdimm mailing list<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&gt; <a href=3D"mailto:Linux-nvdimm@l=
ists.01.org">Linux-nvdimm@lists.01.org</a><br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&gt; <a href=3D"https://lists.01.org/=
mailman/listinfo/linux-nvdimm" rel=3D"noreferrer" target=3D"_blank">https:/=
/lists.01.org/mailman/listinfo/linux-nvdimm</a><br>
&gt;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0--<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dm-devel mailing list<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0<a href=3D"mailto:dm-devel@redhat.com=
">dm-devel@redhat.com</a><br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0<a href=3D"https://www.redhat.com/mai=
lman/listinfo/dm-devel" rel=3D"noreferrer" target=3D"_blank">https://www.re=
dhat.com/mailman/listinfo/dm-devel</a><br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; --<br>
&gt; Doug Dumitru<br>
&gt; EasyCo LLC<br>
&gt;<br>
&gt; _______________________________________________<br>
&gt; Linux-nvdimm mailing list<br>
&gt; <a href=3D"mailto:Linux-nvdimm@lists.01.org">Linux-nvdimm@lists.01.org=
</a><br>
&gt; <a href=3D"https://lists.01.org/mailman/listinfo/linux-nvdimm" rel=3D"=
noreferrer" target=3D"_blank">https://lists.01.org/mailman/listinfo/linux-n=
vdimm</a><br>
<br>
</div></div></blockquote></div><br><div class=3D"gmail_default" style=3D"fo=
nt-family:arial,helvetica,sans-serif;font-size:small">=E2=80=8BMy comment o=
n block sizes was only 512/4K, but the code should be easy to =E2=80=8Bsetu=
p at anything binary.<br></div><br clear=3D"all"><br>-- <br><div class=3D"g=
mail_signature">Doug Dumitru<br>EasyCo LLC<br></div>
</div></div>

--001a1135fb385d9254051922a35a--


--===============8855023706184023451==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8855023706184023451==--
