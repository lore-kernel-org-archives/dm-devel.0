From: "Pradipmaya Maharana" <pradipmaya@gmail.com>
Subject: Re: Configuring multipath for root device
Date: Mon, 7 Jan 2008 12:19:00 -0800
Message-ID: <110b17190801071219k11749b81n45a7d1d5d35b9413@mail.gmail.com>
References: <110b17190712191302o60d521eaj693410c26d07c1ad@mail.gmail.com>
	<1198099093.26366.32.camel@linuxchandra>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1198099093.26366.32.camel@linuxchandra>
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

RHEL Steps worked perfectly for me but i have a question for SLES installation.

Question. While installing SLES on multipath devices, the second step says:

" 2. Complete the installation. Let the system boot up in multiuser mode.
Make sure the root device, swap device are all referenced by their by-id
device node entries instead of /dev/sd* type names. If they are not, fix
them first."

How do you check that root device and swap device are referenced by their by-id?
And if it is not referenced by the by-id, how do I fix it? Re-install?

Thanks and Regards,
Pradipmaya.


On Dec 19, 2007 1:18 PM, Chandra Seetharaman <sekharan@us.ibm.com> wrote:
> I am working on a multipath usage document. Attached is the installation
> section of that document.
>
> Note that it is written for RHEL5 U1 and SLES10 SP1.
>
> Good Luck,
>
> chandra
>
>
> On Wed, 2007-12-19 at 13:02 -0800, Pradipmaya Maharana wrote:
> > Hi All,
> >
> > Is there a process/document that talks about how to configure
> > root/boot device for multipath?
> >
> > Thanks and Regards,
> > Pradipmaya.
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
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
