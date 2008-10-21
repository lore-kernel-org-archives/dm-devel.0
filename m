From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [stable] [git pull] Additional device-mapper patches
	for 2.6.28
Date: Tue, 21 Oct 2008 13:12:49 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0810211311320.13319@hs20-bc2-1.build.redhat.com>
References: <20081021165901.GO5098@agk.fab.redhat.com>
	<20081021170436.GA25030@kroah.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20081021170436.GA25030@kroah.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Greg KH <greg@kroah.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Heinz Mauelshagen <mauelshagen@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids



On Tue, 21 Oct 2008, Greg KH wrote:

> On Tue, Oct 21, 2008 at 05:59:01PM +0100, Alasdair G Kergon wrote:
> > Please pull from:
> > 
> >   master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git
> >  
> > to get the following additional device-mapper patches for 2.6.28:
> 
> Hm, as you copied stable@kernel.org, does that mean that some of these
> are applicable to -stable releases?
> 
> thanks,
> 
> greg k-h

That "fix primary_pe race" should be considered for -stable.

Mikulas
