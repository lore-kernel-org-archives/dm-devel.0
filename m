From: Doug Dumitru <doug@easyco.com>
Subject: Re: Persistent memory interface
Date: Fri, 19 Jun 2015 09:53:40 -0700
Message-ID: <CAFx4rwS2Zsm9m2gxASVSnikz_sg5Ggit2NzbnOHMa4XENJJ_Ow@mail.gmail.com>
References: <alpine.LRH.2.02.1506191211480.30318@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: doug@easyco.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6309072459556405084=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1506191211480.30318@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: Boaz Harrosh <boaz@plexistor.com>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@fb.com>, linux-nvdimm@ml01.01.org, Andy Lutomirski <luto@amacapital.net>, Keith Busch <keith.busch@intel.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

--===============6309072459556405084==
Content-Type: multipart/alternative; boundary=bcaec548a30b1e52450518e1c470

--bcaec548a30b1e52450518e1c470
Content-Type: text/plain; charset=UTF-8

Mikulas,

Can you send me a link to this driver.  I need to implement a "real" and
"correct" driver for a PMC Sierra card, so I need to pay attention to the
atomic issue you described.

Doug Dumitru
EasyCo LLC


On Fri, Jun 19, 2015 at 9:33 AM, Mikulas Patocka <mpatocka@redhat.com>
wrote:

> Hi
>
> I looked at the new the persistent memory block device driver
> (drivers/block/pmem.c and arch/x86/kernel/pmem.c) and it seems that the
> interface between them is incorrect.
>
> If I want to use persistent memory in another driver, for a different
> purpose, how can I make sure that that drivers/block/pmem.c doesn't attach
> to this piece of memory and export it? It seems not possible.
> drivers/block/pmem.c attaches to everything without regard that there may
> be other users of persistent memory.
>
> I think a correct solution would be to add a partition table at the
> beginning of persistent memory area and this partition table would
> describe which parts belong to which programs - so that different programs
> could use persistent memory and not step over each other's data. Is there
> some effort to standardize the partition table ongoing?
>
>
> BTW. some journaling filesystems assume that 512-byte sector is written
> atomically. drivers/block/pmem.c breaks this requirement. Persistent
> memory only gurantees 8-byte atomic writes.
>
> Mikulas
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>



-- 
Doug Dumitru
EasyCo LLC

--bcaec548a30b1e52450518e1c470
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif;font-size:small">Mikulas,<br><br></div><div class=3D"gma=
il_default" style=3D"font-family:arial,helvetica,sans-serif;font-size:small=
">Can you send me a link to this driver.=C2=A0 I need to implement a &quot;=
real&quot; and &quot;correct&quot; driver for a PMC Sierra card, so I need =
to pay attention to the atomic issue you described.<br><br></div><div class=
=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;font-siz=
e:small">Doug Dumitru<br></div><div class=3D"gmail_default" style=3D"font-f=
amily:arial,helvetica,sans-serif;font-size:small">EasyCo LLC<br><br></div><=
/div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Fri, Jun =
19, 2015 at 9:33 AM, Mikulas Patocka <span dir=3D"ltr">&lt;<a href=3D"mailt=
o:mpatocka@redhat.com" target=3D"_blank">mpatocka@redhat.com</a>&gt;</span>=
 wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;bor=
der-left:1px #ccc solid;padding-left:1ex">Hi<br>
<br>
I looked at the new the persistent memory block device driver<br>
(drivers/block/pmem.c and arch/x86/kernel/pmem.c) and it seems that the<br>
interface between them is incorrect.<br>
<br>
If I want to use persistent memory in another driver, for a different<br>
purpose, how can I make sure that that drivers/block/pmem.c doesn&#39;t att=
ach<br>
to this piece of memory and export it? It seems not possible.<br>
drivers/block/pmem.c attaches to everything without regard that there may<b=
r>
be other users of persistent memory.<br>
<br>
I think a correct solution would be to add a partition table at the<br>
beginning of persistent memory area and this partition table would<br>
describe which parts belong to which programs - so that different programs<=
br>
could use persistent memory and not step over each other&#39;s data. Is the=
re<br>
some effort to standardize the partition table ongoing?<br>
<br>
<br>
BTW. some journaling filesystems assume that 512-byte sector is written<br>
atomically. drivers/block/pmem.c breaks this requirement. Persistent<br>
memory only gurantees 8-byte atomic writes.<br>
<br>
Mikulas<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a>=
<br>
</blockquote></div><br><br clear=3D"all"><br>-- <br><div class=3D"gmail_sig=
nature">Doug Dumitru<br>EasyCo LLC<br></div>
</div>

--bcaec548a30b1e52450518e1c470--


--===============6309072459556405084==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6309072459556405084==--
