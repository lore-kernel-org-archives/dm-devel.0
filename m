From: "Pradipmaya Maharana" <pradipmaya@gmail.com>
Subject: Re: SLES installation on dual controller subsystem
Date: Mon, 4 Feb 2008 21:46:34 -0800
Message-ID: <110b17190802042146o4a2c5fbcx315567ea73994d18@mail.gmail.com>
References: <110b17190802041558y6b30e000x5a3e530f4c717d4e@mail.gmail.com>
	<1202177454.13537.22.camel@linuxchandra>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1202177454.13537.22.camel@linuxchandra>
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

Thanks for your response.
RHEL works fine in same scenario; any explanation why? I mean what
does RHEL do different here?

Thanks and Regards,
Pradipmaya.


On Feb 4, 2008 6:10 PM, Chandra Seetharaman <sekharan@us.ibm.com> wrote:
>
> On Mon, 2008-02-04 at 15:58 -0800, Pradipmaya Maharana wrote:
> > Hi All,
> >
> > I am trying to install SLES 10.1 on my dual controller subsystem. The
> > subsystem is ALUA aware and hence shows me 2 LUNs for one while trying
> > to install SLES on it.
> >
> > If my LUN's preferred controller is 1 then everything goes fine, but
> > if the preferred controller of the LUN I am installing OS on is 2,
> > then installation goes fine but the boot fails.
> >
> > It throws some errors like root (hd1,1) could not found. When I modify
> > this to too(hd0,1) it boots fine.
> >
> > What am I missing here?
>
> >From what you explain, looks like the kernel doesn't boot at all. You
> are getting error from your BIOS/firmware.
>
> Your BIOS/firmware may not be multipath aware.
>
> >
> > Regards,
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
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
