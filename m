From: Marian Csontos <mcsontos@redhat.com>
Subject: Re: Balanced Striping
Date: Thu, 20 Feb 2014 13:10:19 +0100
Message-ID: <5305F0AB.7060100@redhat.com>
References: <CAEZ+n-gM_5w-HYrTC6h3ZrtS2EJuykiA1bym0p2jgOQnzO64Zw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAEZ+n-gM_5w-HYrTC6h3ZrtS2EJuykiA1bym0p2jgOQnzO64Zw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, heiligerstein@gmail.com
List-Id: dm-devel.ids

On 02/18/2014 08:34 PM, Leonardo Santos wrote:
> I'm trying to make a experimental balance striping between SSD and HDD
> based on some performance parameter (latency or throughput) gotten on the
> fly.
>
> I realized that when I increase the number of operations for SSD (e.g. 3x=
1,
> SSDxHDD) it doesn't give me the better of both.
>
> My HDD read sequentially at ~100MB/s and my SSD at ~400MB/s. My hope is
> throughput to be the sum of SSD and HDD, but this its not true for my tes=
ts.
>
> For instance, when I put operations in 1x1:
> SSD =3D ~100MB/s
> HDD =3D ~100MB/s
>
> When I put 3x1:
> SSD =3D ~150MB/s
> HDD =3D ~50MB/s (why its not 100MB/s?)

Not sure what you are trying to achieve and if you really need this or =

just want to misuse DM to fit your goals.

1. Let's answer the "Why?" question

Are you trying to implement kind of I/O shaping or throttling? =

(Otherwise I do not understand the need to cripple the SSD speed by =

using it in such a configuration, but anyway...)

2. Then we can either move to "How?"

Would cgroups work for you?


>
> For me its not parallel, but only distributes the operations in a
> proportional way.
>
> Questions:
> - Why isn't throughput equal to HDD + SSD in normal mode (1x1)?
> - Why HDD reduces proportionally?
> - Its not parallel? Where can I change it to make this parallel?

3. Or to your "Why?" questions.

For that I have no answers, just questions:

- How do you measure the throughput? (Exact command would be the best.)

- How are the disks connected? (Is this single SSD you divided into =

partitions and are now hitting it with 3x more IOPS while the reads are =

not sequential anymore which _should_ not have much effect)

- What's the throughput when using striped SSD(s) only?

- What does `dmsetup status` says?

- What are sector sizes? Chunk sizes? and Block sizes you read?

>
> I using this in my research and changed dm-stripe.c.
>
> Thanks a lot!
>
> *Leonardo Ant=F4nio dos Santos*
>
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
