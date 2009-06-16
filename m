From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH 1/6] dm raid45 target: export region hash
	functions and add a needed one
Date: Tue, 16 Jun 2009 21:11:07 +0200
Message-ID: <1245179467.4278.11.camel@o>
References: <4a368301.KBrCZcokAm87BF/S%heinzm@redhat.com>
	<20090616140914.GA3348@infradead.org> <1245163906.28257.113.camel@o>
	<e9c3a7c20906161055g6434ffd8uc7fc1ca53950556@mail.gmail.com>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <e9c3a7c20906161055g6434ffd8uc7fc1ca53950556@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>
List-Id: dm-devel.ids

On Tue, 2009-06-16 at 10:55 -0700, Dan Williams wrote:
> On Tue, Jun 16, 2009 at 7:51 AM, Heinz Mauelshagen<heinzm@redhat.com> wrote:
> > On Tue, 2009-06-16 at 10:09 -0400, Christoph Hellwig wrote:
> >> On Mon, Jun 15, 2009 at 07:21:05PM +0200, heinzm@redhat.com wrote:
> >> > Hi,
> >> >
> >> > this patch series introduces the raid45 target.
> >> > Please include upstream.
> >>
> >> NACK, no need for another raid target, especially if it happens to be
> >> as broken as the raid1 one.
> >
> > You didn't review it it seems ?
> 
> Will you be allowing time for review?  This seems a bit late for
> 2.6.31, as your "Please include upstream" implies.

Your help is appreciated, thanks.

As you surely know, your colleagues (in particular in Poland) are
familiar with these patches already, which will help quick review.

> 
> >>   Please help on making the md raid4/5 code
> >> more useful for your purposes (whatever that may be).
> >
> > Supporting various ATARAID raid5 mappings via dmraid long before md got
> > external metadata suport added.
> 
> This is an opportunity to investigate what technical hurdles remain to
> allow dmraid to use md infrastructure [1] (or as Neil proposed [2] a
> new unified virtual block device infrastructure) for activating
> external metadata raid5 arrays.  The libata/ide situation shows that
> there is precedence for duplicate functionality in the kernel, but my
> personal opinion is that we exhaust the code reuse discussion before
> heading down that path.

dmraid supports 11 different metadata formats for various ATARAID vendor
specific solutions plus DDF1:

asr     : Adaptec HostRAID ASR (0,1,10)
ddf1    : SNIA DDF1 (0,1,4,5,linear)
hpt37x  : Highpoint HPT37X (S,0,1,10,01)
hpt45x  : Highpoint HPT45X (S,0,1,10)
isw     : Intel Software RAID (0,1,5,01)
jmicron : JMicron ATARAID (S,0,1)
lsi     : LSI Logic MegaRAID (0,1,10)
nvidia  : NVidia RAID (S,0,1,10,5)
pdc     : Promise FastTrack (S,0,1,10)
sil     : Silicon Image(tm) Medley(tm) (0,1,10)
via     : VIA Software RAID (S,0,1,10)

9 of those still need porting/testing/... to/with MD external metadata
support after the Intel IMSM MD port has settled, hence Red Hat is going
to continue to support dmraid.

That being said: once the future work on a unified virtual block device
infrastructure is production ready, we're open to use that.

Regards,
Heinz

> 
> Regards,
> Dan
> 
> [1] http://marc.info/?l=linux-raid&m=123300614013042&w=2
> [2] http://marc.info/?l=linux-fsdevel&m=124450400028660&w=2
