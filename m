From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: NIC and HBA based multipathing
Date: Thu, 1 Nov 2007 14:57:27 -0700
Message-ID: <20071101215726.GB11002@linux.vnet.ibm.com>
References: <342d47870710300956k3bde2d06j7a50acc6c8225fe5@mail.gmail.com>
	<5fb0f77b0710301040l4eeca0a7n2ccdc00b14285294@mail.gmail.com>
	<342d47870710301211y42200594u444b7af7ae870e7@mail.gmail.com>
	<472A2EA5.8050609@cs.wisc.edu>
	<342d47870711011321j1ff065c3jb54589988f3c499f@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <342d47870711011321j1ff065c3jb54589988f3c499f@mail.gmail.com>
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

Scott Moseman <scmoseman@gmail.com> wrote:
> On 11/1/07, Mike Christie <michaelc@cs.wisc.edu> wrote:
> > >
> > > I'm following the instructions on Red Hat's KB to setup the
> > > multipath.conf file.  The modprobes were successful, the service
> > > started, but...
> > >
> > > # multipath -v2
> > > error calling out /sbin/scsi_id -g -u -s /block/sda
> >
> > So are you asking about the errors from /dev/sda being accessed by
> > multipath, or are you looking for help on adding the iscsi disks to a
> > multipath device or both :)
> >
> 
> Both, I guess.  I'm following the Red Hat how-to and I'm getting that
> error instead of getting a successful output.  If there's an answer for
> why I'm getting the error, or an answer for how to fix my multipathd,
> I'm open to either one at this point.  :)
> 
> I attempted to put sda in my blacklist (per the Red Hat instructions)
> but still received the same error message about sda (the local disk).


If you trying to blacklist a device and it is still showing or when you
run multipath -v 4 the device is not listed as blacklisted then there is
most likely a problem in /etc/multipath.conf

Are you using "devnode_blacklist" as indicated in the instructions.

I believe this is incorrect and you should use something like:

blacklist {
        devnode "sda"
}

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
