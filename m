From: Keith Busch <keith.busch@intel.com>
Subject: Re: NVMeoF multi-path setup
Date: Thu, 30 Jun 2016 19:14:55 -0400
Message-ID: <20160630231454.GC18890@localhost.localdomain>
References: <CAF1ivSbe+NboO+nbiWfEijHFJPd-AgNa=4AvWT24-HjH8A_izw@mail.gmail.com>
	<1467323858.15863.3.camel@ssi> <20160630225207.GB22293@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160630225207.GB22293@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Ming Lin <mlin@kernel.org>, device-mapper development <dm-devel@redhat.com>, linux-nvme@lists.infradead.org
List-Id: dm-devel.ids

On Thu, Jun 30, 2016 at 06:52:07PM -0400, Mike Snitzer wrote:
> AFAIK, hch had Intel disable that by default in the hopes of avoiding
> people having dm-multipath "just work" with NVMeoF.  (Makes me wonder
> what other unpleasant unilateral decisions were made because some
> non-existant NVMe specific multipath capabilities would be forthcoming
> but I digress).

For the record, Intel was okay with making SCSI a separate config option,
but I was pretty clear about our wish to let it default to 'Y', which
didn't happen. :)

To be fair, NVMe's SCSI translation is a bit of a kludge, and we have
better ways to get device identification now. Specifically, the block
device provides 'ATTR{wwid}' available to all NVMe namespaces in existing
kernel releases.
