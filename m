From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: Persistent memory interface
Date: Mon, 22 Jun 2015 21:35:47 +0000
Message-ID: <1435008947.32433.82.camel@intel.com>
References: <alpine.LRH.2.02.1506191211480.30318@file01.intranet.prod.int.rdu2.redhat.com>
	<1434732620.32433.37.camel@intel.com>
	<CAFx4rwTag+bCJw3nmn9_W5nq1umVE5RXeVujwmQi46gkG7zENQ@mail.gmail.com>
	<CAFx4rwRhmnpDKdhofZp5f7fXQYL1SwW_oQyB_V=M5Gm=W0xGbg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAFx4rwRhmnpDKdhofZp5f7fXQYL1SwW_oQyB_V=M5Gm=W0xGbg@mail.gmail.com>
Content-Language: en-US
Content-ID: <242292E1C0C9DB4BAF39B0B00D0A003F@intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "doug@easyco.com" <doug@easyco.com>
Cc: "Busch, Keith" <keith.busch@intel.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>, "luto@amacapital.net" <luto@amacapital.net>, "axboe@fb.com" <axboe@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "mpatocka@redhat.com" <mpatocka@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>, "bp@alien8.de" <bp@alien8.de>, "tglx@linutronix.de" <tglx@linutronix.de>, "hch@lst.de" <hch@lst.de>
List-Id: dm-devel.ids

On Mon, 2015-06-22 at 12:01 -0700, Doug Dumitru wrote:
> ... while you are at it, you should consider supporting other binary
> block sizes.
> 
Hm, what would be the use case? We do support a variety of metadata
sizes for protection information [1]. Apart from this, the standard
block sizes of 512 and 4096 are the only ones Linux can support, so I'm
not sure what you mean by other binary block sizes?

	-Vishal

[1]: https://lkml.org/lkml/2015/6/17/947
