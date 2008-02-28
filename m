From: "Pradipmaya Maharana" <pradipmaya@gmail.com>
Subject: Re: Installing RHEL with single controller
Date: Thu, 28 Feb 2008 13:43:05 -0800
Message-ID: <110b17190802281343p76655c2fk29c07c4571ba8ac@mail.gmail.com>
References: <110b17190802281008u6e5eeef4vccfb509be7ad4198@mail.gmail.com>
	<20080228192135.GA13340@us.ibm.com>
	<110b17190802281136k7f303322y28f9952c82366a0c@mail.gmail.com>
	<20080228201122.GA13566@us.ibm.com>
	<1204234581.4963.89.camel@linuxchandra>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1204234581.4963.89.camel@linuxchandra>
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
To: sekharan@us.ibm.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Thanks Malahal/Chandra. I will try this and let you know.

Thanks again,
Pradipmaya.


On Thu, Feb 28, 2008 at 1:36 PM, Chandra Seetharaman
<sekharan@us.ibm.com> wrote:
> On Thu, 2008-02-28 at 12:11 -0800, malahal@us.ibm.com wrote:
> > Pradipmaya Maharana [pradipmaya@gmail.com] wrote:
> > > Multipath is getting loaded, if that is what you are wondering about.
> > > After reboot I check for multipathd status, and smod for the modules
> > > loaded, everything looks fine.
> >
> > No, I am asking if initrd image contains multipath commands. You need to
> > use cpio to extract the initrd image and see the source code to check
> > it!
> >
> > multipath has to be loaded and *run* before mounting your real root. If
> > it gets loaded after  mounting your real root, it is too late to have
> > multipath on root disk! Looks like you need to regenerate initrd with
> > multpath support.
>
> Yes, Malahal is right. You need to create initrd with multipath tools.
> You can do this by running mkinitrd with "--with=dm-multipath"
> (Follow the SLES10 installation instructions in my documentation
> http://sources.redhat.com/lvm2/wiki/MultipathUsageGuide )
>
>
> > --Malahal.
> >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> --
>
> ----------------------------------------------------------------------
>    Chandra Seetharaman               | Be careful what you choose....
>              - sekharan@us.ibm.com   |      .......you may get it.
> ----------------------------------------------------------------------
>
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
