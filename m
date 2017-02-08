From: Mike Galbraith <efault@gmx.de>
Subject: Re: v4.9, 4.4-final: 28 bioset threads on small notebook,
 36 threads on cellphone
Date: Wed, 08 Feb 2017 07:57:04 +0100
Message-ID: <1486537024.4387.4.camel@gmx.de>
References: <20151211104937.GA23165@amd> <20151211140841.GA22873@redhat.com>
	<20160220174035.GA16459@amd> <20160220184258.GA3753@amd>
	<20160220195136.GA27149@redhat.com> <20160220200432.GB22120@amd>
	<20170206125309.GA29395@amd>
	<20170207014724.74tb37jj7u66lww3@moria.home.lan>
	<20170207024906.4oswyuvxfnqkvbhr@moria.home.lan>
	<20170207203911.GA16980@amd>
	<20170207204510.qr2l2rg42ez2hobh@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170207204510.qr2l2rg42ez2hobh@moria.home.lan>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kent Overstreet <kent.overstreet@gmail.com>, Pavel Machek <pavel@ucw.cz>
Cc: oleg.drokin@intel.com, ming.l@ssi.samsung.com, andreas.dilger@intel.com, Mike Snitzer <snitzer@redhat.com>, martin.petersen@oracle.com, minchan@kernel.org, jkosina@suse.cz, ming.lei@canonical.com, kernel list <linux-kernel@vger.kernel.org>, jim@jtan.com, pjk1939@linux.vnet.ibm.com, axboe@fb.com, geoff@infradead.org, dm-devel@redhat.com, dpark@posteo.net, ngupta@vflare.org, hch@lst.de, agk@redhat.com
List-Id: dm-devel.ids

On Tue, 2017-02-07 at 19:58 -0900, Kent Overstreet wrote:
> On Tue, Feb 07, 2017 at 09:39:11PM +0100, Pavel Machek wrote:
> > On Mon 2017-02-06 17:49:06, Kent Overstreet wrote:
> > > On Mon, Feb 06, 2017 at 04:47:24PM -0900, Kent Overstreet wrote:
> > > > On Mon, Feb 06, 2017 at 01:53:09PM +0100, Pavel Machek wrote:
> > > > > Still there on v4.9, 36 threads on nokia n900 cellphone.
> > > > > 
> > > > > So.. what needs to be done there?
> > > 
> > > > But, I just got an idea for how to handle this that might be halfway sane, maybe
> > > > I'll try and come up with a patch...
> > > 
> > > Ok, here's such a patch, only lightly tested:
> > 
> > I guess it would be nice for me to test it... but what it is against?
> > I tried after v4.10-rc5 and linux-next, but got rejects in both cases.
> 
> Sorry, I forgot I had a few other patches in my branch that touch
> mempool/biosets code.
> 
> Also, after thinking about it more and looking at the relevant code, I'm pretty
> sure we don't need rescuer threads for block devices that just split bios - i.e.
> most of them, so I changed my patch to do that.
> 
> Tested it by ripping out the current->bio_list checks/workarounds from the
> bcache code, appears to work:

Patch killed every last one of them, but..

homer:/root # dmesg|grep WARNING
[   11.701447] WARNING: CPU: 4 PID: 801 at block/bio.c:388 bio_alloc_bioset+0x1a7/0x240
[   11.711027] WARNING: CPU: 4 PID: 801 at block/blk-core.c:2013 generic_make_request+0x191/0x1f0
[   19.728989] WARNING: CPU: 0 PID: 717 at block/bio.c:388 bio_alloc_bioset+0x1a7/0x240
[   19.737020] WARNING: CPU: 0 PID: 717 at block/blk-core.c:2013 generic_make_request+0x191/0x1f0
[   19.746173] WARNING: CPU: 0 PID: 717 at block/bio.c:388 bio_alloc_bioset+0x1a7/0x240
[   19.755260] WARNING: CPU: 0 PID: 717 at block/blk-core.c:2013 generic_make_request+0x191/0x1f0
[   19.763837] WARNING: CPU: 0 PID: 717 at block/bio.c:388 bio_alloc_bioset+0x1a7/0x240
[   19.772526] WARNING: CPU: 0 PID: 717 at block/blk-core.c:2013 generic_make_request+0x191/0x1f0
