From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: multipathd.init
Date: Tue, 05 Apr 2005 01:06:40 +0200
Message-ID: <1112656001.8118.144.camel@zezette>
References: <20050401204048.GI14307@agk.surrey.redhat.com>
	<1112389744.8118.26.camel@zezette>
	<20050401211902.GL14307@agk.surrey.redhat.com>
	<1112390705.8118.34.camel@zezette> <1112521418.8118.49.camel@zezette>
	<20050404211520.GB14307@agk.surrey.redhat.com>
	<1112652860.8118.129.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1112652860.8118.129.camel@zezette>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

I pushed 0.4.4-pre8 online.
It contains all fixes discussed here today and the day before.

I hope I'll have positive feedback to release 0.4.4 soon.

Remember the blacklist format changed to regex, as demonstrated in the
example config files in the tarball.

Regards,
cvaroqui

On mar, 2005-04-05 at 00:14 +0200, christophe varoqui wrote:
> On lun, 2005-04-04 at 22:15 +0100, Alasdair G Kergon wrote:
> > On Sun, Apr 03, 2005 at 11:43:37AM +0200, christophe varoqui wrote:
> > > I also would like to kick off the debate on libsysfs and libdevmapper
> > > klibc versions packaging, 
> > 
> > For Red Hat distributions, I intend to use glibc static builds for 
> > the multipath-tools, same as for lvm2 & dmsetup.
> > 
> > I don't want the worry of having to support more than one libc.
> > (All tests have to be done twice then, for starters, and you lose
> > use of glibc features the other libraries don't support.)
> > 
> > So much is getting pushed into the initrd these days, that there's 
> > even the prospect of shared object support being added one day.
> > 
> So be it, for now.
> 
> The place is cleaned from libsysfs/ and libdevmapper/ starting from
> 0.4.4-pre6.
> 
> I modified the Makefiles to still compile properly with BUILD=klibc on
> systems with /usr/lib/klibc/ properly stuffed with klibc-compiled
> versions of these libs. A little more work for people interested in this
> setup, but still fairly manageable.
> 
> Hope it eases the packaging for everyone.
> Please tell if some more work needs to be merged in this area.
> 
> Regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>
