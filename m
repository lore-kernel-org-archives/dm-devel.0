From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: Device-mapper-multipath RDAC
Date: Tue, 02 Oct 2007 10:13:34 -0700
Message-ID: <1191345214.5831.2.camel@linuxchandra>
References: <200709241706.26322.npf-mlists@eurotux.com>
	<46F8A29F.6060803@suse.de>  <200709250852.08464.npf@eurotux.com>
Reply-To: sekharan@us.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200709250852.08464.npf@eurotux.com>
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

On Tue, 2007-09-25 at 08:52 +0100, Nuno Fernandes wrote:
> On Tuesday 25 September 2007 06:54:39 Hannes Reinecke wrote:
> > Nuno Fernandes wrote:
> > > hello,
> > >
> > > Just a question:
> > >
> > > With recent support for rdac hardware handler in kernel 2.6.23-rc7, what
> > > configuration should be in storage DS4700? AVT (Automatic Volume
> > > transfer) turned on or off?
> >
> > Off. AVT is the acronym for 'Automated Volume Transfer', ie the array tries
> > to transfer the volumes from one controller to the other automatically.
> >
> > > When it's turned on, luns keep on jumping from controller to controller..
> >
> > Indeed. That's to be expected.
> >
> > As a rule:
> >
> > - With rdac hardware handler: AVT off
> I'm in the process of testing avt in the kernel.
> 
> > - Without hardware handler: AVT on
> With this situation i don't have any point of failure but the lun keeps on 
> jumping (because of the alive path check of multipathd) and the performance 
> is awfull.

Hmm... Did you have the configuration entries in multipath.conf (same as
that of the RDAC case - with the exception of the hardware handler) ?
> 
> Best regards
> Nuno Fernandes
> 
> >
> > Cheers,
> >
> > Hannes
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------
