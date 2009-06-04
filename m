From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: Re: ANNOUNCE: mdadm 3.0 - A tool for managing Soft
	RAID under Linux
Date: Thu, 04 Jun 2009 18:38:56 +0200
Message-ID: <1244133536.5541.48.camel@o>
References: <18980.48553.328662.80987@notabene.brown>
	<4A25876A.1010901@garzik.org>
	<18981.62579.171350.910761@notabene.brown>
	<1244040123.6938.19.camel@o>
	<e9c3a7c20906031026s49a5a694hb91db40dc05a2580@mail.gmail.com>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <e9c3a7c20906031026s49a5a694hb91db40dc05a2580@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>, Jacek Danecki <jacek.danecki@intel.com>, LKML <linux-kernel@vger.kernel.org>, Ed Ciechanowski <ed.ciechanowski@intel.com>, linux-raid@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Arjan van de Ven <arjan@infradead.org>
List-Id: dm-devel.ids

On Wed, 2009-06-03 at 10:26 -0700, Dan Williams wrote:
> On Wed, Jun 3, 2009 at 7:42 AM, Heinz Mauelshagen <heinzm@redhat.com> wrote:
> > On Wed, 2009-06-03 at 13:56 +1000, Neil Brown wrote:
> >> As for integrating the two code bases.... people have been suggesting
> >> that for years, but I suspect few of them have looked deeply at the
> >> practicalities.  Apparently it was suggested at the recent "storage
> >> summit".  However as the primary md and dm developers were absent, I
> >> have doubts about how truly well-informed that conversation could have
> >> been.
> >
> > Agreed, we'd need face-time and talk issues through in order to come up
> > with any such plan for md+dm integration.
> >
> 
> What are your general impressions of dmraid using md kernel
> infrastructure for raid level support?

At the time of the dmraid project start, we already had libdevmapper
which was suitable to handle in-kernel device manipulation with no
adequate on the MD side so it was the appropriate interface to use.

Cheers,
Heinz

> 
> Thanks,
> Dan
