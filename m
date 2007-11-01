From: "Scott Moseman" <scmoseman@gmail.com>
Subject: Re: NIC and HBA based multipathing
Date: Thu, 1 Nov 2007 15:21:09 -0500
Message-ID: <342d47870711011321j1ff065c3jb54589988f3c499f@mail.gmail.com>
References: <342d47870710300956k3bde2d06j7a50acc6c8225fe5@mail.gmail.com>
	<5fb0f77b0710301040l4eeca0a7n2ccdc00b14285294@mail.gmail.com>
	<342d47870710301211y42200594u444b7af7ae870e7@mail.gmail.com>
	<472A2EA5.8050609@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <472A2EA5.8050609@cs.wisc.edu>
Content-Disposition: inline
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

On 11/1/07, Mike Christie <michaelc@cs.wisc.edu> wrote:
>
> Yeah, the iscsi bits looks fine. You will have a /dev/sdX for the nic
> and one of the HBA.
>
> When you start multipath, multipath should then create one multipath
> device from those two scsi ones.
>

That makes sense.  Thanks for the confirmation.

> >
> > I'm following the instructions on Red Hat's KB to setup the
> > multipath.conf file.  The modprobes were successful, the service
> > started, but...
> >
> > # multipath -v2
> > error calling out /sbin/scsi_id -g -u -s /block/sda
>
> So are you asking about the errors from /dev/sda being accessed by
> multipath, or are you looking for help on adding the iscsi disks to a
> multipath device or both :)
>

Both, I guess.  I'm following the Red Hat how-to and I'm getting that
error instead of getting a successful output.  If there's an answer for
why I'm getting the error, or an answer for how to fix my multipathd,
I'm open to either one at this point.  :)

I attempted to put sda in my blacklist (per the Red Hat instructions)
but still received the same error message about sda (the local disk).

Thanks,
Scott
