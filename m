From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: multipathd.init
Date: Mon, 4 Apr 2005 22:15:20 +0100
Message-ID: <20050404211520.GB14307@agk.surrey.redhat.com>
References: <20050401204048.GI14307@agk.surrey.redhat.com>
	<1112389744.8118.26.camel@zezette>
	<20050401211902.GL14307@agk.surrey.redhat.com>
	<1112390705.8118.34.camel@zezette>
	<1112521418.8118.49.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1112521418.8118.49.camel@zezette>
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

On Sun, Apr 03, 2005 at 11:43:37AM +0200, christophe varoqui wrote:
> I also would like to kick off the debate on libsysfs and libdevmapper
> klibc versions packaging, 

For Red Hat distributions, I intend to use glibc static builds for 
the multipath-tools, same as for lvm2 & dmsetup.

I don't want the worry of having to support more than one libc.
(All tests have to be done twice then, for starters, and you lose
use of glibc features the other libraries don't support.)

So much is getting pushed into the initrd these days, that there's 
even the prospect of shared object support being added one day.

Alasdair
-- 
agk@redhat.com
