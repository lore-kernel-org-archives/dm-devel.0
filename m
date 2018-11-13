From: Keith Busch <keith.busch@intel.com>
Subject: Re: multipath-tools: add ANA support for NVMe device
Date: Tue, 13 Nov 2018 09:18:38 -0700
Message-ID: <20181113161838.GC9827@localhost.localdomain>
References: <1541657381-7452-1-git-send-email-lijie34@huawei.com>
	<2691abf6733f791fb16b86d96446440e4aaff99f.camel@suse.com>
	<20181112215323.GA7983@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181112215323.GA7983@redhat.com>
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
Cc: lijie <lijie34@huawei.com>, xose.vazquez@gmail.com, chengjike.cheng@huawei.com, shenhong09@huawei.com, dm-devel@redhat.com, wangzhoumengjian@huawei.com, linux-nvme@lists.infradead.org, Martin Wilck <mwilck@suse.com>, sschremm@netapp.com
List-Id: dm-devel.ids

On Mon, Nov 12, 2018 at 04:53:23PM -0500, Mike Snitzer wrote:
> On Mon, Nov 12 2018 at 11:23am -0500,
> Martin Wilck <mwilck@suse.com> wrote:
> 
> > Hello Lijie,
> > 
> > On Thu, 2018-11-08 at 14:09 +0800, lijie wrote:
> > > Add support for Asynchronous Namespace Access as specified in NVMe
> > > 1.3
> > > TP 4004. The states are updated through reading the ANA log page.
> > > 
> > > By default, the native nvme multipath takes over the nvme device.
> > > We can pass a false to the parameter 'multipath' of the nvme-core.ko
> > > module,when we want to use multipath-tools.
> > 
> > Thank you for the patch. It looks quite good to me. I've tested it with
> > a Linux target and found no problems so far.
> > 
> > I have a few questions and comments inline below.
> > 
> > I suggest you also have a look at detect_prio(); it seems to make sense
> > to use the ana prioritizer for NVMe paths automatically if ANA is
> > supported (with your patch, "detect_prio no" and "prio ana" have to be
> > configured explicitly). But that can be done in a later patch.
> 
> I (and others) think it makes sense to at least triple check with the
> NVMe developers (now cc'd) to see if we could get agreement on the nvme
> driver providing the ANA state via sysfs (when modparam
> nvme_core.multipath=N is set), like Hannes proposed here:
> http://lists.infradead.org/pipermail/linux-nvme/2018-November/020765.html
> 
> Then the userspace multipath-tools ANA support could just read sysfs
> rather than reinvent harvesting the ANA state via ioctl.

I'd prefer not duplicating the log page parsing. Maybe nvme's shouldn't
even be tied to CONFIG_NVME_MULTIPATH so that the 'multipath' param
isn't even an issue.
 
> But if we continue to hit a wall on that type of sharing of the nvme
> driver's state then I'm fine with reinventing ANA state inquiry and
> tracking like has been proposed here.
> 
> Mike
> 
> p.s. thanks for your review Martin, we really need to determine the way
> forward for full multipath-tools support of NVMe with ANA.
