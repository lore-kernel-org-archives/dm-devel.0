From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [dm-devel] [RFC PATCH 0/1] dm-crypt excessive overhead
Date: Wed, 24 Jun 2020 04:54:18 +0000
Message-ID: <CY4PR04MB3751EB316BFD5600AFAA6796E7950@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200619164132.1648-1-ignat@cloudflare.com>
 <20200619165548.GA24779@redhat.com>
 <CY4PR04MB3751F148CCFAAC99A7F05CF7E7970@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200623150118.GA19657@redhat.com>
 <CALrw=nHNJTX3kzv2Q=dc6hYr=d8S2=gT0VHkWigS1pmwr9ps5Q@mail.gmail.com>
 <20200623152235.GB19657@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Ignat Korchagin <ignat@cloudflare.com>
Cc: "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>, "dm-crypt@saout.de" <dm-crypt@saout.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, "agk@redhat.com" <agk@redhat.com>
List-Id: dm-devel.ids

On 2020/06/24 0:23, Mike Snitzer wrote:=0A=
> On Tue, Jun 23 2020 at 11:07am -0400,=0A=
> Ignat Korchagin <ignat@cloudflare.com> wrote:=0A=
> =0A=
>> Do you think it may be better to break it in two flags: one for read=0A=
>> path and one for write? So, depending on the needs and workflow these=0A=
>> could be enabled independently?=0A=
> =0A=
> If there is a need to split, then sure.  But I think Damien had a hard=0A=
> requirement that writes had to be inlined but that reads didn't _need_=0A=
> to be for his dm-zoned usecase.  Damien may not yet have assessed the=0A=
> performance implications, of not have reads inlined, as much as you=0A=
> have.=0A=
=0A=
We did do performance testing :)=0A=
The results are mixed and performance differences between inline vs workque=
ues=0A=
depend on the workload (IO size, IO queue depth and number of drives being =
used=0A=
mostly). In many cases, inlining everything does really improve performance=
 as=0A=
Ignat reported.=0A=
=0A=
In our testing, we used hard drives and so focused mostly on throughput rat=
her=0A=
than command latency. The added workqueue context switch overhead and crypt=
o=0A=
work latency compared to typical HDD IO times is small, and significant onl=
y if=0A=
the backend storage as short IO times.=0A=
=0A=
In the case of HDDs, especially for large IO sizes, inlining crypto work do=
es=0A=
not shine as it prevents an efficient use of CPU resources. This is especia=
lly=0A=
true with reads on a large system with many drives connected to a single HB=
A:=0A=
the softirq context decryption work does not lend itself well to using othe=
r=0A=
CPUs that did not receive the HBA IRQ signaling command completions. The te=
st=0A=
results clearly show much higher throughputs using dm-crypt as is.=0A=
=0A=
On the other hand, inlining crypto work significantly improves workloads of=
=0A=
small random IOs, even for a large number of disks: removing the overhead o=
f=0A=
context switches allows faster completions, allowing sending more requests =
to=0A=
the drives more quickly, keeping them busy.=0A=
=0A=
For SMR, the inlining of write requests is *mandatory* to preserve the issu=
er=0A=
write sequence, but encryption work being done in the issuer context (write=
s to=0A=
SMR drives can only be O_DIRECT writes), efficient CPU resource usage can b=
e=0A=
achieved by simply using multiple writer thread/processes, working on diffe=
rent=0A=
zones of different disks. This is a very reasonable model for SMR as writes=
 into=0A=
a single zone have to be done under mutual exclusion to ensure sequentialit=
y.=0A=
=0A=
For reads, SMR drives are essentially exactly the same as regular disks, so=
=0A=
as-is or inline are both OK. Based on our performance results, allowing the=
 user=0A=
to have the choice of inlining or not reads based on the target workload wo=
uld=0A=
be great.=0A=
=0A=
Of note is that zone append writes (emulated in SCSI, native with NVMe) are=
 not=0A=
subject to the sequential write constraint, so they can also be executed ei=
ther=0A=
inline or asynchronously.=0A=
=0A=
> So let's see how Damien's work goes and if he trully doesn't need/want=0A=
> reads to be inlined then 2 flags can be created.=0A=
=0A=
For SMR, I do not need inline reads, but I do want the user to have the=0A=
possibility of using this setup as that can provide better performance for =
some=0A=
workloads. I think that splitting the inline flag in 2 is exactly what we w=
ant:=0A=
=0A=
1) For SMR, the write-inline flag can be automatically turned on when the t=
arget=0A=
device is created if the backend device used is a host-managed zoned drive =
(scsi=0A=
or NVMe ZNS). For reads, it would be the user choice, based on the target w=
orkload.=0A=
2) For regular block devices, write-inline only, read-inline only or both w=
ould=0A=
be the user choice, to optimize for their target workload.=0A=
=0A=
With the split into 2 flags, my SMR support patch becomes very simple.=0A=
=0A=
> =0A=
> Mike=0A=
> =0A=
> --=0A=
> dm-devel mailing list=0A=
> dm-devel@redhat.com=0A=
> https://www.redhat.com/mailman/listinfo/dm-devel=0A=
> =0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
