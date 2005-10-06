From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] [RFC] persistent readable names
Date: Thu, 6 Oct 2005 08:54:31 -0700
Message-ID: <20051006155431.GA9285@us.ibm.com>
References: <4343DFDC.2020701@redhat.com> <20051005150923.GC6195@free.fr>
	<20051005180721.GA22387@us.ibm.com>
	<1128547659.6140.40.camel@zezette>
	<20051005223824.GA27219@us.ibm.com> <4344CD38.2030004@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4344CD38.2030004@redhat.com>
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

Hi Patrick :)

On Thu, Oct 06, 2005 at 08:07:36AM +0100, Patrick Caulfield wrote:
> Patrick Mansfield wrote:
> 
> > Here is some /dev, lsscsi and scsi_id output on a SLES9 system (rpm
> > udev-021-36.55). by-path is basically pci and scsi bus_id's; by-id is
> > basically scsi_id plus partition output. 
> > 

> Those are the names I'm trying to free people from.
> 
> OK, multipath1 - multipath5000 aren't exactly friendly (but how else are you
> going to name 5000 disks - there aren't that many Simpsons characters!) but
> they're are a /lot/ easier to deal with than those I can see there.

But we should not have a dm only solution.

For that many disks, I don't see how it helps much, you must still deal
with the specific id's at some level. I was thinking more about nice names
for a few disks, or splitting disks into groups with a common prefix (and
then still keep the long id portion).

Enumerating names in shared/cluster setups probably makes things worse,
though you could try to share or copy the file that maps wwid to the
enumeration, the same thing for a udev solution.

-- Patrick Mansfield
