From: "Pradipmaya Maharana" <pradipmaya@gmail.com>
Subject: Re: Configuring multipath for root device
Date: Thu, 20 Dec 2007 08:46:41 -0800
Message-ID: <110b17190712200846l50e4c4d8h51456b852f0c851d@mail.gmail.com>
References: <110b17190712191302o60d521eaj693410c26d07c1ad@mail.gmail.com>
	<1198099093.26366.32.camel@linuxchandra>
	<110b17190712191326x5d3a99e9gdf30e95716acd0e@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <110b17190712191326x5d3a99e9gdf30e95716acd0e@mail.gmail.com>
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

Hi,

Pardon my knowledge on Linux, but in your article did you mean that
the /boot should be on a local disk and /root, swap can be on
multipath device.

I am trying to install /boot, /root and swap all on one multipath
device and try to boot from it. It does not boot, no error just blank
screen. My equirement is to install everything on multipath device; so
is it possible at all? I mean can I have the boot device (/boot) too
on a multipath device.

Following is what I tried on RHEL
 - selected "linux mpath"
 - I could see one local disk and 3 multipath devices
 - I chose custom partition type
 - instead of going for LVM, I selected one single multipath device
and installed everything on it (/boot, / and swap).
 - Tried rebooting, it won't boot :(

What am I missing here?

Thanks and Regards,
Pradipmaya.


On 12/19/07, Pradipmaya Maharana <pradipmaya@gmail.com> wrote:
> Hi Chandra,
>
> Thanks. I will givei it a try.
>
> Regards,
> Pradipmaya.
>
> On 12/19/07, Chandra Seetharaman <sekharan@us.ibm.com> wrote:
> > I am working on a multipath usage document. Attached is the installation
> > section of that document.
> >
> > Note that it is written for RHEL5 U1 and SLES10 SP1.
> >
> > Good Luck,
> >
> > chandra
> >
> > On Wed, 2007-12-19 at 13:02 -0800, Pradipmaya Maharana wrote:
> > > Hi All,
> > >
> > > Is there a process/document that talks about how to configure
> > > root/boot device for multipath?
> > >
> > > Thanks and Regards,
> > > Pradipmaya.
> > >
> > > --
> > > dm-devel mailing list
> > > dm-devel@redhat.com
> > > https://www.redhat.com/mailman/listinfo/dm-devel
> > --
> >
> > ----------------------------------------------------------------------
> >    Chandra Seetharaman               | Be careful what you choose....
> >              - sekharan@us.ibm.com   |      .......you may get it.
> > ----------------------------------------------------------------------
> >
> >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> >
> >
>
