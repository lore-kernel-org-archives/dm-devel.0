From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH 1/2] Don't blacklist nvme
Date: Tue, 14 Feb 2017 18:00:23 -0500
Message-ID: <20170214230023.GA1148@localhost.localdomain>
References: <1487107154-24883-1-git-send-email-keith.busch@intel.com>
	<941dc20e-47ba-5b9d-5082-a87ff1530cb6@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <941dc20e-47ba-5b9d-5082-a87ff1530cb6@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Feb 14, 2017 at 01:35:45PM -0800, Bart Van Assche wrote:
> On 02/14/2017 01:19 PM, Keith Busch wrote:
> > These devices are mulitpath capable, and have been able to stack with
> > dm-mpath since kernel 4.2.
> > 
> > -	str = STRDUP("^(ram|raw|loop|fd|md|dm-|sr|scd|st|dcssblk|nvme)[0-9]");
> > +	str = STRDUP("^(ram|raw|loop|fd|md|dm-|sr|scd|st|dcssblk)[0-9]");
> 
> Have you checked whether dm-mpath works properly with nvme? Last time I
> tried that dm-mpath crashed when it called scsi_dh_attach() because that
> last function assumes that it is passed a SCSI device queue instead of
> checking whether or not the queue passed to that function is a SCSI
> device queue.

Good point. I was unknowingly running with CONFIG_SCSI_DH disabled,
and blissfully unaware of its existence! After enabling that option,
I see what you mean.

If we don't want to mess with the kernel, I can change the multipath-tools
to get around that by appending the following to NVMe hwentry in the
second patch in this series:

	.retain_hwhandler = RETAIN_HWHANDLER_OFF,

And the problem goes away.

I'm not sure yet what the other implications are of setting that (I will
look into it, but I'm out of time today).
