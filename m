From: Scott Bauer <scott.bauer@intel.com>
Subject: Re: [PATCH v2 2/2] dm unstripe: Add documentation for unstripe target
Date: Tue, 12 Dec 2017 12:02:51 -0700
Message-ID: <20171212190250.y2wxdyfcb2kgr32d@sbauer-Z170X-UD5>
References: <20171211160019.20518-1-scott.bauer@intel.com>
 <20171211160019.20518-3-scott.bauer@intel.com>
 <20171212181012.GA31127@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171212181012.GA31127@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, agk@redhat.com, linux-kernel@vger.kernel.org, keith.busch@intel.com, jonathan.derrick@intel.com
List-Id: dm-devel.ids

On Tue, Dec 12, 2017 at 01:10:13PM -0500, Mike Snitzer wrote:
> On Mon, Dec 11 2017 at 11:00am -0500,
> Scott Bauer <scott.bauer@intel.com> wrote:
> 
> OK, but I'm left wondering: why doesn't the user avoid striping across
> the cores?
> 
> Do the Intel NVMe drives not provide the ability to present 1 device per
> NVMe core?
> 
> This DM target seems like a pretty nasty workaround for what should be
> fixed in the NVMe drive's firmware.
> 
> Mainly because there is no opportunity to use both striped and unstriped
> access to the same NVMe drive.  So why impose striped on the user in the
> first place?
> 
> Mike

Unfortunately, the NVMe drives do not currently support exposing each core
as seperate drives or namespaces. While it would be preferable if the
controllers did expose such features, firmware development informed us there
are sufficient reasons why it isn't possible for the existing generation of
drives.

The NVMe working group just finalized a standard that presents isolated storage
sets for users who wish to use them. As the standard was just recently finalized
the use case was created well after the targeted drives were created. The Intel
drives just so happen to have independent back-ends that align with the isolated
storage sets use case. We would like to provide a way to exploit the independent
back-ends to expose isolated storage in a way that is generic across all the Intel
NVMe drive familes. The implementation is generic enough that it can be applied
to  any storage that has physical seperation at known block boundaries.
