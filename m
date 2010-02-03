From: Mike Snitzer <snitzer@gmail.com>
Subject: Fwd: [PATCH 00/11] [RFC] 512K readahead size with
	thrashing safe readahead
Date: Wed, 3 Feb 2010 11:55:17 -0500
Message-ID: <170fa0d21002030855p333f3c88maf65ce762574a466@mail.gmail.com>
References: <20100202152835.683907822@intel.com>
	<20100202223803.GF3922@redhat.com> <20100203062756.GB22890@localhost>
	<20100203152454.GA17059@redhat.com>
	<20100203155845.GB17059@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100203155845.GB17059@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: fengguang.wu@intel.com, Vivek Goyal <vgoyal@redhat.com>
List-Id: dm-devel.ids

FYI, wanted to get this on our radar... seems latest DM isn't allowing
RFC readahead code to set a sane readahead default for DM devices?
get_capacity() is returning 0 for DM devices (not just multipath).
Vivek did share that fdisk -l does show the proper capacity for the DM
device.

I haven't had a chance to look at the relevant code yet.

I've asked Vivek to cc dm-devel on any further messages he might send
in response to this thread.

---------- Forwarded message ----------
From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, Feb 3, 2010 at 10:58 AM
Subject: Re: [PATCH 00/11] [RFC] 512K readahead size with thrashing
safe readahead
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe
<jens.axboe@oracle.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
Linux Memory Management List <linux-mm@kvack.org>,
"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, LKML
<linux-kernel@vger.kernel.org>


On Wed, Feb 03, 2010 at 10:24:54AM -0500, Vivek Goyal wrote:
> On Wed, Feb 03, 2010 at 02:27:56PM +0800, Wu Fengguang wrote:
> > Vivek,
> >
> > On Wed, Feb 03, 2010 at 06:38:03AM +0800, Vivek Goyal wrote:
> > > On Tue, Feb 02, 2010 at 11:28:35PM +0800, Wu Fengguang wrote:
> > > > Andrew,
> > > >
> > > > This is to lift default readahead size to 512KB, which I believe yi=
elds
> > > > more I/O throughput without noticeably increasing I/O latency for t=
oday's HDD.
> > > >
> > >
> > > Hi Fengguang,
> > >
> > > I was doing a quick test with the patches. I was using fio to run some
> > > sequential reader threads. I have got one access to one Lun from an HP
> > > EVA. In my case it looks like with the patches throughput has come do=
wn.
> >
> > Thank you for the quick testing!
> >
> > This patchset does 3 things:
> >
> > 1) 512K readahead size
> > 2) new readahead algorithms
> > 3) new readahead tracing/stats interfaces
> >
> > (1) will impact performance, while (2) _might_ impact performance in
> > case of bugs.
> >
> > Would you kindly retest the patchset with readahead size manually set
> > to 128KB? =A0That would help identify the root cause of the performance
> > drop:
> >
> > =A0 =A0 =A0 =A0 DEV=3Dsda
> > =A0 =A0 =A0 =A0 echo 128 > /sys/block/$DEV/queue/read_ahead_kb
> >
>
> I have got two paths to the HP EVA and got multipath device setup(dm-3). I
> noticed with vanilla kernel read_ahead_kb=3D128 after boot but with your =
patches
> applied it is set to 4. So looks like something went wrong with device
> size/capacity detection hence wrong defaults. Manually setting
> read_ahead_kb=3D512, got me better performance as compare to vanilla kern=
el.
>

I put a printk in add_disk and noticed that for multipath device
get_capacity() is returning 0 and that's why ra_pages is being set to
1.

Thanks
Vivek

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org. =A0For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
