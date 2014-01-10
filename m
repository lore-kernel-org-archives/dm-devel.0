From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH for-3.14] dm cache: add total cache blocks to
 status output
Date: Fri, 10 Jan 2014 09:17:56 -0500
Message-ID: <20140110141756.GB10511@redhat.com>
References: <20140109210412.GA5288@redhat.com>
	<684DDE51-1D4E-44AB-8E85-CDD6F38B5D07@redhat.com>
	<20140110103258.GD20496@debian> <20140110104205.GE20496@debian>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20140110104205.GE20496@debian>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Brassow Jonathan <jbrassow@redhat.com>, device-mapper development <dm-devel@redhat.com>, ejt@redhat.com
List-Id: dm-devel.ids

On Fri, Jan 10 2014 at  5:42am -0500,
Joe Thornber <thornber@redhat.com> wrote:

> On Fri, Jan 10, 2014 at 10:32:59AM +0000, Joe Thornber wrote:
> > On Thu, Jan 09, 2014 at 03:28:13PM -0600, Brassow Jonathan wrote:
> > > Yes, that'd be nice if we could have this.
> 
> Also, don't be fooled into thinking these changes will make your life
> easier.  LVM will still have to support the current kernel interface.

LVM could easily require dm-cache >= 1.3.

Just because dm-cache was available with earlier versions doesn't mean
LVM _must_ support it.

dm-cache is EXPERIMENTAL, by definition it is subject to change.  One of
the big causes for change (as unfortunate as such changes are) is when
prominent tools like lvm2 finally get around to providing support.. when
that support is designed/implemented it can expose oversights in the
initial userspace interface provided by the kernel.  There is no hard
rule that EXPERIMENTAL dm targets must be supported by lvm2 and
conversely there is no requirement that such dm targets provide an
interface that is backwards compatible.
