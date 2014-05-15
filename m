From: "Stewart, Sean" <Sean.Stewart@netapp.com>
Subject: Re: [PATCH] libmultipath: Use existing user friendly
 name if possible
Date: Thu, 15 May 2014 19:21:04 +0000
Message-ID: <1400181663.19394.17.camel@ict-vth-stewarts01.ict.englab.netapp.com>
References: <8255ED565A0EAA4A960625E27D49DBF24AC9EB61@SACEXCMBX04-PRD.hq.netapp.com>
	<20140411160338.GA17578@localhost.localdomain>
	<1397235706.29991.8.camel@ict-vth-stewarts01.ict.englab.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1397235706.29991.8.camel@ict-vth-stewarts01.ict.englab.netapp.com>
Content-Language: en-US
Content-ID: <24A22E07F5395F448844B049479A5F86@hq.netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Ping...  Any additional comments or suggestions for this patch?
Bumping in case it got lost in the backlog. :)

On Fri, 2014-04-11 at 17:01 +0000, Stewart, Sean wrote:
> On Fri, 2014-04-11 at 17:03 +0100, Bryn M. Reeves wrote:
> > On Fri, Mar 28, 2014 at 09:01:14PM +0000, Stewart, Sean wrote:
> > > When a system is booted to the SAN, a condition can occur where one
> > > user friendly name is given to a disk during boot, but multipathd tries
> > > to allocate a different one after boot. If the second alias is already
> > > used by another device, multipathd can't rename it. Multipathd then has
> > > incorrect information about the alias/wwid relationships, which can
> > > result in paths being added to the wrong map.
> > 
> > This should only happen if the initramfs and root file system have
> > inconsistent multipath configurations (either multipath.conf or bindings
> > / wwids file mismatched). That's not really a valid configuration for
> > the system to be in and leads to the type of problems you describe.
> 
> That is true that it only happens if they are out of sync.  We tried
> remaking the initramfs to fix the problem, but it didn't help.
> > 
> > > This patch works around this problem by first trying to use the alias
> > > already bound to a device during boot.  If the bindings file has that
> > > alias bound to a different device, it'll auto generate a new alias to
> > > rename it to.
> > 
> > To be honest I'd prefer to see this cause an error. These types of
> > configurations currently run the risk of silent data corruption - I'd
> > much rather deal with a system that refuses to boot due to an out of
> > date initramfs image than one that quietly remaps paths in unexpected
> > ways.
> 
> The issue, though, is that the system does not refuse to boot.  In the
> case we saw, it booted anyway, our QA engineer ran a test, and it ended
> with a data corruption.  A user could perform a fresh installation,
> map
> new luns, reboot, and without any way of realizing it have essentially a
> ticking time bomb on their hands, ready to go off as soon as there's a
> blip in the SAN.
