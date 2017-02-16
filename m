From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/2] Don't blacklist nvme
Date: Wed, 15 Feb 2017 21:01:47 -0500
Message-ID: <20170216020146.GA9078@redhat.com>
References: <1487107154-24883-1-git-send-email-keith.busch@intel.com>
	<941dc20e-47ba-5b9d-5082-a87ff1530cb6@sandisk.com>
	<20170214230023.GA1148@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170214230023.GA1148@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Keith Busch <keith.busch@intel.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Feb 14 2017 at  6:00pm -0500,
Keith Busch <keith.busch@intel.com> wrote:

> On Tue, Feb 14, 2017 at 01:35:45PM -0800, Bart Van Assche wrote:
> > On 02/14/2017 01:19 PM, Keith Busch wrote:
> > > These devices are mulitpath capable, and have been able to stack with
> > > dm-mpath since kernel 4.2.
> > > 
> > > -	str = STRDUP("^(ram|raw|loop|fd|md|dm-|sr|scd|st|dcssblk|nvme)[0-9]");
> > > +	str = STRDUP("^(ram|raw|loop|fd|md|dm-|sr|scd|st|dcssblk)[0-9]");
> > 
> > Have you checked whether dm-mpath works properly with nvme? Last time I
> > tried that dm-mpath crashed when it called scsi_dh_attach() because that
> > last function assumes that it is passed a SCSI device queue instead of
> > checking whether or not the queue passed to that function is a SCSI
> > device queue.
> 
> Good point. I was unknowingly running with CONFIG_SCSI_DH disabled,
> and blissfully unaware of its existence! After enabling that option,
> I see what you mean.
> 
> If we don't want to mess with the kernel, I can change the multipath-tools
> to get around that by appending the following to NVMe hwentry in the
> second patch in this series:
> 
> 	.retain_hwhandler = RETAIN_HWHANDLER_OFF,
> 
> And the problem goes away.

That gives me a clue, I'll take a look.
