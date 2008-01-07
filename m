From: "Urs Golla" <urs.golla@gmail.com>
Subject: Re: boot from san & lvm
Date: Mon, 7 Jan 2008 17:02:39 +0100
Message-ID: <64e30f320801070802r46105cb1y107c2be17fdcc445@mail.gmail.com>
References: <64e30f320801070736o62ec8b42q9db45f616f076a17@mail.gmail.com>
	<20080107154418.GA29532@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080107154418.GA29532@us.ibm.com>
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

Hi

Thank you for your reply!

Using "mapper" instead of mpath did it!

hm... i think the partition (mpath0p1) is just "/boot" and mpath0p2 is
the rest. this would mean, everything is ok now?

cheers



On 1/7/08, malahal@us.ibm.com <malahal@us.ibm.com> wrote:
> Urs Golla [urs.golla@gmail.com] wrote:
> > Hi
> >
> > I would like to boot RHEL5 from SAN. If I install with the "mpath"
> > parameter I can see the mapper/mpath0 device and the installation
> > completes without any errors.
> >
> > It boots from SAN and everything looks ok (well, lets say its
> > working). If i add this lines to /etc/lvm/lvm.conf
> >
> > types = [ "device-mapper", 1]
> > "filter = [ "a/dev/mpath/.*/", "r/.*/" ]"
>
> Try "mapper" instead of "mpath" above to handle partitions on your
> devices.
>
> > and remove the blacklist lines from /etc/multipath.conf as described
> > in the "Native Multipath Failover Based on DM-MPIO for v2.6.x Linux
> > Kernel and EMC(R) Storage Arrays" manual the pvscan command returns
> > with " No matching physical volumes found". Why?
> >
> > If I remove the filter line from lvm.conf the pvscan & pvdisplay
> > command returns:
> >
> > (...)
> > PV Name               /dev/mapper/mpath0p2
> > (...)
> >
> > Why is it using mpath0p2 and not mpath0? /dev/mapper/mpath0 does exist
> > and points to the right disks, because "multipath -ll" gives me
> > something like that:
>
> You must be having partitions on your disk (either you did or the
> installer did for you).
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
