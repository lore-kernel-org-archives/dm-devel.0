From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Re: 2.6.24-rc4-mm1
Date: Fri, 07 Dec 2007 00:24:04 +0100
Message-ID: <1196983444.2829.38.camel@lov.site>
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
	<3941.1196941764@turing-police.cc.vt.edu>
	<20071206040420.6c89c675.akpm@linux-foundation.org>
	<4374.1196968688@turing-police.cc.vt.edu>
	<20071206193843.GA25125@kroah.com>
	<3ae72650712061404w170fc434nb1172e048216e139@mail.gmail.com>
	<2955.1196982750@turing-police.cc.vt.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2955.1196982750@turing-police.cc.vt.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Valdis.Kletnieks@vt.edu
Cc: device-mapper development <dm-devel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Thu, 2007-12-06 at 18:12 -0500, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 06 Dec 2007 23:04:12 +0100, Kay Sievers said:
> 
> > What's the value of SYSFS_DEPRECATED? Care to set it to yes, if it isn't,
> > and try again?
> 
> I *knew* there was a D'Oh! error in here. ;)
> 
> Bisection is fast closing in on gregkh-driver-block-device.patch, which broke
> my LVM almost the exact same way the *last* time it showed up in -mm ;)

Oh, it must not, if SYSFS_DEPRECATED=y is set. I hope we fixed all
issues. Please let us know if it does not work, then we will need to
look into it.

> > A fix for LVM to handle symlinks instead of directories is in the LVM
> > CVS tree, but there wasn't a release since August.
> 
> I seem to recall it was 'nash' rather than LVM that had the indigestion the
> last time around.

I think that a recent nash should work, even with SYSFS_DEPRECATED=n.
Anyway, nothing should change when SYSFS_DEPRECATED set, nash works fine
here, with that.

Kay
