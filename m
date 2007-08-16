From: "S. J. van Harmelen" <svh@dds.nl>
Subject: Re: Multipath-tools errors
Date: Thu, 16 Aug 2007 21:21:08 +0200
Message-ID: <1187292068.5915.39.camel@sanderbal>
References: <1186757447.17449.24.camel@sanderbal>
	<1187285188.17399.255.camel@linuxchandra>
	<1187287105.5915.12.camel@sanderbal>
	<1187288613.17399.283.camel@linuxchandra>
	<1187289384.5915.22.camel@sanderbal>
	<1187291140.17399.295.camel@linuxchandra>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1187291140.17399.295.camel@linuxchandra>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@us.ibm.com
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

It's configured for RDAC as far as I know, and I'm not sure if I can
change this. This is another question for Dell I quess :)

So I'll just have to wait about a month or so...

Thanks very much for your help!!


On Thu, 2007-08-16 at 12:05 -0700, Chandra Seetharaman wrote:
> On Thu, 2007-08-16 at 20:36 +0200, S. J. van Harmelen wrote:
> > In my last lines I meant that it looked okay:
> > 
> > root@storage:~# multipath -ll
> > backup (360019b9000d7e1100000444b46be82c4) dm-0 DELL    ,MD3000        
> > [size=200G][features=0][hwhandler=0]
> > \_ round-robin 0 [prio=3][active]
> >  \_ 1:0:1:2 sdg 8:96  [active][ready]
> > \_ round-robin 0 [prio=0][enabled]
> >  \_ 1:0:0:2 sdd 8:48  [active][ghost]
> > vmware (360019b9000d7e1100000444846be81b6) dm-2 DELL    ,MD3000        
> > [size=200G][features=0][hwhandler=0]
> > \_ round-robin 0 [prio=3][active]
> >  \_ 1:0:0:0 sdb 8:16  [active][ready]
> > \_ round-robin 0 [prio=0][enabled]
> >  \_ 1:0:1:0 sde 8:64  [active][ghost]
> > data (360019b9000d7ddab0000493846be81e5) dm-1 DELL    ,MD3000        
> > [size=200G][features=0][hwhandler=0]
> > \_ round-robin 0 [prio=3][active]
> >  \_ 1:0:1:1 sdf 8:80  [active][ready]
> > \_ round-robin 0 [prio=0][enabled]
> >  \_ 1:0:0:1 sdc 8:32  [active][ghost]
> > 
> > As you can see it show's all paths correctly and also show's them as
> 
> Yes, they all look good.
> 
> > active/ready and active/ghost. Attached is my multipath.conf b.t.w.
> > 
> Your multipath.conf looks good too.
> 
> > But I understand path failover/failback will not work without without
> > the hardware handler :( I am planning this machine for a production
> 
> Your storage is configured in AVT mode or rdac mode ?
> 
> You wont need the handler if your storage is configured in AVT mode.
>  
> > environment, so I quess I have to wait till 2.6.23.1 comes out.
> 
> If you are using it in rdac mode, then you have to wait.
> 
> > 
> > Any idea when that should be? Or are there any kernel patches I could
> 
> Usually they are released within 2-3 months of the last release. 2.6.22
> was released on Jul 8th. So, it should be somewhere between Sep 8th and
> Oct 8th :)...
> 
> > use for 2.6.22.2? Or does it not work that way?
> 
> It would work, but I would not suggest it :), especially for a
> production system.
> 
> chandra
> > 
> > Thanks,
> > 
> > Sander
> > 
> > 
> > 
> > 
> > On Thu, 2007-08-16 at 11:23 -0700, Chandra Seetharaman wrote:
> > > On Thu, 2007-08-16 at 19:58 +0200, S. J. van Harmelen wrote:
> > > > Hi Chandra,
> > > > 
> > > > Thanks for your reply! As far as I know it does use a LSI Engenio. I
> > > > asked Dell if they can confirm this, but I didn't get any reply yet.
> > > > Will get back with the answer as soon as I get it.
> > > > 
> > > My reply below is based on the assumption that it does use LSI Engenio.
> > > 
> > > > Besides that it seems to be working now. I don't have any errors anymore
> > > > and it's not as slow as before. It's now doing something like 120M/sec,
> > > > but don't know if thats good or not (don't know how fast this device
> > > > should be)...
> > > > 
> > > > I did leave out the hardware_handler line because of the error it gives.
> > > > But I understand that is because of my kernel? I'm using the package
> > > > from Christophe's website version 0.4.8 on a Debian Etch 64bit machine
> > > > with a 2.6.22.2 kernel.
> > > 
> > > Yes, you need a 2.6.23-rc1 (or upwards) kernel to have the rdac hardware
> > > handler support.
> > > > 
> > > > I quess I need the hardware_handler to make it work as it should? Al
> > > 
> > > Yes, without the hardware handler, path failover/failback will not work.
> > > 
> > > > true it sees all paths and says that both active. Where one is
> > > > active/ready and the other is active/ghost. 
> > > > 
> > > > Anything I can do about this? 
> > > 
> > > I do not understand the problem you are mentioning here. Will be easier
> > > to follow if you can copy the o/p of "multipath -ll" and explain your
> > > issue w.r.t that.
> > > 
> > > Also, attaching your multipath.conf would also be useful.
> > > 
> > > chandra
> > > > 
> > > > Sander
> > > > 
> > > > 
> > > > 
> > > > 
> > > > 
> > > > 
> > > > On Thu, 2007-08-16 at 10:26 -0700, Chandra Seetharaman wrote:
> > > > > First off, the "mpath_prio_rdac" is the path checker for the lsi engenio
> > > > > controller. Is the Dell MD300 based on that controller ?
> > > > > 
> > > > > If it is _not_, then you should _not_ be using mpath_prio_rdac.
> > > > > 
> > > > > If it is, read on.
> > > > > 
> > > > > You need to use the hardware handler for the same controller, you can
> > > > > setup your multipath.conf to use the "rdac" hardware handler.
> > > > > 
> > > > > Here is how your multipath.conf should look like:
> > > > > -----------
> > > > > devices {
> > > > >         device {
> > > > >                 vendor                  "$vendor_name"
> > > > >                 product                 "$product_name"
> > > > >                 hardware_handler        "1 rdac"
> > > > >                 path_checker            rdac
> > > > >                 path_grouping_policy    group_by_prio
> > > > >                 prio_callout            "/sbin/mpath_prio_rdac /dev/%n"
> > > > >         }
> > > > > }
> > > > > -----------
> > > > > 
> > > > > Note: replace $vendor_name and $product_name with appropriate vendor and
> > > > > product information for the storage.
> > > > > 
> > > > > Hardware handler for rdac is available only in 2.6.23-rc1 and onwards
> > > > > (if you are not using this version, do let me know which version of the
> > > > > kernel you are using, even if it is in distro).
> > > > > 
> > > > > Where did you get the multipath-tools from ? From Christophe's website
> > > > > or any distro(RedHat/SuSE) ?
> > > > > 
> > > > > And, as Malahal pointed, make sure you have /sbin/mpath_prio_rdac
> > > > > available and is an executable.
> > > > > 
> > > > > Hope this helps,
> > > > > 
> > > > > chandra
> > > > > On Fri, 2007-08-10 at 16:50 +0200, S. J. van Harmelen wrote:
> > > > > > Oke, got a bit further...
> > > > > > 
> > > > > > I now understand how to use the disks. Only thing thats not going oke is
> > > > > > that I get these errors constantly (while formatting):
> > > > > > 
> > > > > > end_request: I/O error, dev sdf, sector 30408704
> > > > > > end_request: I/O error, dev sdf, sector 30670848
> > > > > > end_request: I/O error, dev sdf, sector 30932992
> > > > > > end_request: I/O error, dev sdf, sector 31195136
> > > > > > end_request: I/O error, dev sdf, sector 31457280
> > > > > > 
> > > > > > or (while editting a file):
> > > > > > 
> > > > > > end_request: I/O error, dev sdc, sector 966656
> > > > > > device-mapper: multipath: Failing path 8:32.
> > > > > > end_request: I/O error, dev sdc, sector 966720
> > > > > > device-mapper: multipath: Failing path 8:32.
> > > > > > end_request: I/O error, dev sdc, sector 96665
> > > > > > 
> > > > > > And the device seems very slow...
> > > > > > 
> > > > > > And also stil having this error: "error calling out mpath_prio_rdac"
> > > > > > 
> > > > > > Any tips, pointers?
> > > > > > 
> > > > > > Sander
> > > > > > 
> > > > > > -------- Forwarded Message --------
> > > > > > From: S. J. van Harmelen <svanharmelen@xillan.nl>
> > > > > > To: dm-devel@redhat.com
> > > > > > Subject: Re: Multipath-tools
> > > > > > Date: Fri, 10 Aug 2007 11:47:01 +0200
> > > > > > 
> > > > > > Hi again,
> > > > > > 
> > > > > > Seem to have found the solution for the first question. Got
> > > > > > multipath-tools up and running now :)
> > > > > > 
> > > > > > But please do answer the others questions if you have a minute to
> > > > > > spare...
> > > > > > 
> > > > > > Also I'm seeing "error calling out mpath_prio_rdac" when starting
> > > > > > multipathd?! Any word on that one?
> > > > > > 
> > > > > > Regards,
> > > > > > 
> > > > > > Sander
> > > > > > 
> > > > > > 
> > > > > > 
> > > > > > On Fri, 2007-08-10 at 10:27 +0200, S. J. van Harmelen wrote:
> > > > > > > Hey guys,
> > > > > > > 
> > > > > > > Sorry to bother you, but I have a question I think you can answer. I
> > > > > > > also send this message to Christophe, but I don't know how long he takes
> > > > > > > to respond. I'm trying to set up a Dell NX1950 which has an RDAC MD300
> > > > > > > array connected with linux.
> > > > > > > 
> > > > > > > Now I got all thinks working, but the RDAC driver. I'm trying to use the
> > > > > > > opensource multipath-tools (which I want to compile myself), but I have
> > > > > > > some questions about it:
> > > > > > > 
> > > > > > > 1) While compiling I get an error saying: "/usr/bin/ld: cannot find
> > > > > > > -ldevmapper" Can you tell me what I can do to fix this error?
> > > > > > > 
> > > > > > > 2) Can you tell me if there is a mailinglist for the multipath-tools?
> > > > > > > 
> > > > > > > 3) Can you point me to some documentation about configuring the
> > > > > > > multipath-tools with the new RDAC path checker?
> > > > > > > 
> > > > > > > Thanks very much for your time!
> > > > > > > 
> > > > > > > Kind regards,
> > > > > > > 
> > > > > > > Sander van Harmelen
> > > > > > 
> > > > > > --
> > > > > > dm-devel mailing list
> > > > > > dm-devel@redhat.com
> > > > > > https://www.redhat.com/mailman/listinfo/dm-devel
> > > > > -- 
> > > > > 
> > > > > ----------------------------------------------------------------------
> > > > >     Chandra Seetharaman               | Be careful what you choose....
> > > > >               - sekharan@us.ibm.com   |      .......you may get it.
> > > > > ----------------------------------------------------------------------
> > > > > 
> > > > > 
> > > > > --
> > > > > dm-devel mailing list
> > > > > dm-devel@redhat.com
> > > > > https://www.redhat.com/mailman/listinfo/dm-devel
> > > > 
