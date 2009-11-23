From: malahal@us.ibm.com
Subject: Re: dm-raid1 barriers
Date: Sun, 22 Nov 2009 19:16:02 -0800
Message-ID: <20091123031602.GA26756@us.ibm.com>
References: <Pine.LNX.4.64.0911161136500.5769@hs20-bc2-1.build.redhat.com>
	<20091116184802.GD11886@agk-dp.fab.redhat.com>
	<Pine.LNX.4.64.0911170502370.4304@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0911170502370.4304@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Mikulas Patocka [mpatocka@redhat.com] wrote:
> > > If this flush fails, the bits in memory are already clean and we don't 
> > > know which regions may hold unwritten data in the disk cache and which 
> > 
> > Actually we do: the on-disk version of the log tells us.
> 
> Yes, it could be read into another buffer and anded.
> 
> > > not. So, we must set all regions as dirty.
> >  
> > Anyway, let's not try to handle these situations at the moment.
> > what I need for now, is a way to know whether or not this situation has
> > actually occurred when we get reports from users, so probably a kernel
> > log message, a dm event raised plus a failure indicator against the device in
> > the status line.

Agreed, we don't want to handle this error case with reading the entries
from the disk log and comparing them with the in memory buffer at this
point.  Why not just set all regions to dirty as Mikulas pointed as a
short term solution? Not optimal but it is a correct way to handle.

--Malahal.
