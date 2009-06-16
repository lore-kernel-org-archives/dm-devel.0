From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/6] dm raid45 target: export region hash
	functions and add a needed one
Date: Tue, 16 Jun 2009 12:48:36 -0700
Message-ID: <e9c3a7c20906161248n75f88e5bk752d3a40c858e81e@mail.gmail.com>
References: <4a368301.KBrCZcokAm87BF/S%heinzm@redhat.com>
	<20090616140914.GA3348@infradead.org> <1245163906.28257.113.camel@o>
	<e9c3a7c20906161055g6434ffd8uc7fc1ca53950556@mail.gmail.com>
	<1245179467.4278.11.camel@o>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1245179467.4278.11.camel@o>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ed Ciechanowski <ed.ciechanowski@intel.com>
List-Id: dm-devel.ids

On Tue, Jun 16, 2009 at 12:11 PM, Heinz Mauelshagen<heinzm@redhat.com> wr=
ote:
> dmraid supports 11 different metadata formats for various ATARAID vendo=
r
> specific solutions plus DDF1:
>
> asr =A0 =A0 : Adaptec HostRAID ASR (0,1,10)
> ddf1 =A0 =A0: SNIA DDF1 (0,1,4,5,linear)
> hpt37x =A0: Highpoint HPT37X (S,0,1,10,01)
> hpt45x =A0: Highpoint HPT45X (S,0,1,10)
> isw =A0 =A0 : Intel Software RAID (0,1,5,01)
> jmicron : JMicron ATARAID (S,0,1)
> lsi =A0 =A0 : LSI Logic MegaRAID (0,1,10)
> nvidia =A0: NVidia RAID (S,0,1,10,5)
> pdc =A0 =A0 : Promise FastTrack (S,0,1,10)
> sil =A0 =A0 : Silicon Image(tm) Medley(tm) (0,1,10)
> via =A0 =A0 : VIA Software RAID (S,0,1,10)
>
> 9 of those still need porting/testing/... to/with MD external metadata
> support after the Intel IMSM MD port has settled, hence Red Hat is goin=
g
> to continue to support dmraid.

What I am personally interested in is a way for the dmraid userspace
to reuse time proven md kernel infrastructure where it makes sense.
Yes, there are benefits to porting the metadata formats to mdadm, but
the point is that there is no immediate need, or even eventual need,
to to do this work.  dmraid already knows how to convert all these
formats into a common dmsetup table format, and md already has knobs
for userspace to create raid arrays from the same information.

Can we not meet in the middle to allow at least dm-raid5 arrays to use md=
-raid5?

Put another way do we need ~5000 new lines of kernel code to support
all the functionality that dmraid requires?  What happens when one of
these formats wants to add raid6, more code duplication?  Can we
incrementally extend md-raid to cover the unmet needs of dmraid, what
extensions are required?

> That being said: once the future work on a unified virtual block device
> infrastructure is production ready, we're open to use that.

That is the end game, but there are more cooperation opportunities
along the way.
