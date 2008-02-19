From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: multipath errors on first set-up
Date: Tue, 19 Feb 2008 13:23:17 -0600
Message-ID: <20080219192317.GI15608@ether.msp.redhat.com>
References: <20080215201930.GG15608@ether.msp.redhat.com>
	<DFB2D7E03264FB4392B70A38BFF9FC7101FFBE5B@BRBSEVS20000.s2.ms.unilever.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <DFB2D7E03264FB4392B70A38BFF9FC7101FFBE5B@BRBSEVS20000.s2.ms.unilever.com>
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

On Mon, Feb 18, 2008 at 04:42:27PM -0000, Rogan, Julian wrote:
> Hi,
> Thanks for the reply.
> 
> I have fixed the invaliud messages output by installed the 64 bit
> version of multipath. 
> I have re-tried the build stage but the mpathX device file is still not
> being created.
> 
> Here is the output:
> 
> output from multipath -v4
> 
> 
> cciss!c0d0 blacklisted
> dm-0 blacklisted
> dm-1 blacklisted
> dm-2 blacklisted
> dm-3 blacklisted
> dm-4 blacklisted
> dm-5 blacklisted
> fd0 blacklisted
> hda blacklisted
> md0 blacklisted
> ram0 blacklisted
> ram10 blacklisted
> ram11 blacklisted
> ram12 blacklisted
> ram13 blacklisted
> ram14 blacklisted
> ram15 blacklisted
> ram1 blacklisted
> ram2 blacklisted
> ram3 blacklisted
> ram4 blacklisted
> ram5 blacklisted
> ram6 blacklisted
> ram7 blacklisted
> ram8 blacklisted
> ram9 blacklisted
> path sda not found in pathvec
> 
> ===== path sda =====
> bus = 1
> dev_t = 8:0
> size = 3906810493
> vendor = HP
> product = MSA VOLUME
> rev = 6.86
> h:b:t:l = 0:0:0:1
> tgt_node_name = 0x500508b300930230
> serial = PB9840PX3TF0C0
> path checker = readsector0 (internal default) state = 2 getprio = (null)
> (internal default) prio = 1 getuid = /sbin/scsi_id -g -u -s /block/%n
> (internal default) uid = 3600508b300930230a7495ae1b9500074 (callout)
> path sdb not found in pathvec
> 
> ===== path sdb =====
> bus = 1
> dev_t = 8:16
> size = 3906810493
> vendor = HP
> product = MSA VOLUME
> rev = 6.86
> h:b:t:l = 1:0:0:1
> tgt_node_name = 0x500508b300930230
> serial = PB9840PX3TJ0FU
> path checker = readsector0 (internal default) state = 2 getprio = (null)
> (internal default) prio = 1 getuid = /sbin/scsi_id -g -u -s /block/%n
> (internal default) uid = 3600508b300930230a7495ae1b9500074 (callout)
> path sdc not found in pathvec
> 
> ===== path sdc =====
> bus = 1
> dev_t = 8:32
> size = 3906810493
> vendor = HP
> product = MSA VOLUME
> rev = 6.86
> h:b:t:l = 2:0:0:1
> tgt_node_name = 0x500508b300930230
> serial = PB9840PX3TF0C0
> path checker = readsector0 (internal default) state = 2 getprio = (null)
> (internal default) prio = 1 getuid = /sbin/scsi_id -g -u -s /block/%n
> (internal default) uid = 3600508b300930230a7495ae1b9500074 (callout)
> path sdd not found in pathvec
> 
> ===== path sdd =====
> bus = 1
> dev_t = 8:48
> size = 3906810493
> vendor = HP
> product = MSA VOLUME
> rev = 6.86
> h:b:t:l = 3:0:0:1
> tgt_node_name = 0x500508b300930230
> serial = PB9840PX3TJ0FU
> path checker = readsector0 (internal default) state = 2 getprio = (null)
> (internal default) prio = 1 getuid = /sbin/scsi_id -g -u -s /block/%n
> (internal default) uid = 3600508b300930230a7495ae1b9500074 (callout) # #
> all paths :
> #
> 3600508b300930230a7495ae1b9500074 0:0:0:1 sda  8:0     [MSA VOLUME
> ]
> 3600508b300930230a7495ae1b9500074 1:0:0:1 sdb  8:16    [MSA VOLUME
> ]
> 3600508b300930230a7495ae1b9500074 2:0:0:1 sdc  8:32    [MSA VOLUME
> ]
> 3600508b300930230a7495ae1b9500074 3:0:0:1 sdd  8:48    [MSA VOLUME
> ]
> pgpolicy = failover (internal default)
> selector = round-robin 0 (internal default) features = 0 (internal
> default) hwhandler = 0 (internal default) 0 3906810493 multipath 0 0 4 1
> round-robin 0 1 1 8:0 1000 round-robin 0 1 1 8:16 1000 round-robin 0 1 1
> 8:32 1000 round-robin 0 1 1 8:48 1000 action preset to 0 action set to 4
> create: 3600508b300930230a7495ae1b9500074
> [size=1 TB][features="0"][hwhandler="0"] \_ round-robin 0
>   \_ 0:0:0:1 sda  8:0
> \_ round-robin 0
>   \_ 1:0:0:1 sdb  8:16
> \_ round-robin 0
>   \_ 2:0:0:1 sdc  8:32
> \_ round-robin 0
>   \_ 3:0:0:1 sdd  8:48
> 
> message 3600508b300930230a7495ae1b9500074 0 switch_group 1
> 
>  
> messages in /var/adm/messages:
> 
> Feb 18 16:32:18 brli036a multipathd: path checkers start up
> Feb 18 16:32:18 brli036a multipathd: multipathd startup succeeded
> Feb 18 16:32:38 brli036a multipathd: 3600508b300930230a7495ae1b9500074:
> event checker started
> Feb 18 16:32:38 brli036a multipathd: add
> 3600508b300930230a7495ae1b9500074 devmap
> Feb 18 16:32:39 brli036a multipathd: 8:0: readsector0 checker reports
> path is up
> Feb 18 16:32:39 brli036a multipathd: 8:0: reinstated
> Feb 18 16:32:39 brli036a multipathd: 8:16: readsector0 checker reports
> path is up
> Feb 18 16:32:39 brli036a multipathd: 8:16: reinstated
> Feb 18 16:32:39 brli036a multipathd: 8:32: readsector0 checker reports
> path is up
> Feb 18 16:32:39 brli036a multipathd: 8:32: reinstated
> 
> 
> I did comment out all of /etc/modules.conf as you suggested before I
> restarted,

Can you run

# multipath -l

It looks like a multipath map was created.  It's possible that the
device nodes weren't created correctly. 

-Ben

 
> Is there a problem with RHEL 4 QU2?
> 
> with regards,
>                   Julian
> Name: Julian Rogan
> Role: Unix Server Analyst
> Department: Enterprise Hosting
> Regional Group: Unilever Europe IT Services
> Telephone : +44 (0) 1244 50 1356
> Mobile: +44 (0) 7876 390715
> Office Base: Unity House, St Davids Park, Ewloe, UK. CH5 3XT
> Unilever U.K. Central Resources Limited
> Registered in England & Wales; Company No 29140
> Registered Office: Unilever House, Blackfriars, London, EC4P 4BQ 
> 
> 
> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
> On Behalf Of Benjamin Marzinski
> Sent: Friday, February 15, 2008 8:20 PM
> To: device-mapper development
> Subject: Re: [dm-devel] multipath errors on first set-up
> 
> On Fri, Feb 15, 2008 at 04:22:07PM -0000, Rogan, Julian wrote:
> >    Hi,
> >    I am using multipath for the first time with little joy.
> 
> <snip>
>  
> >    based on some other documents I made the following changes to
> >    /etc/multipath.conf
> 
> You can probably leave the entire /etc/multipath.conf commented out.
> Everything should just autodetect correctly.
>  
> >    I ran
> >    multipath -v3 to recreate I get the following:
> 
> <snip>
> 
> >    device-mapper ioctl cmd 14 failed: Invalid argument
> >    message 3600508b300930230a7495ae1b9500074 0 switch_group 1
> >    failed
> > 
> >    Note sure if "path sdX not found in pathvec" relevant
> 
> No, that's supposed to be there.
>  
> >    anyway no mpaths have been created.
> > 
> >    I hope there is someone out there who can give me some help with
> this.
> 
> No chance you can update to a more recent version of RHEL4?
> 
> The device-mapper message means the command you send to device-mapper
> didn't work.  However, it looks completely sensible.  What version of
> device-mapper are you using?
> 
> # rpm -q device-mapper
> 
> I'm guessing that you will see something like
> device-mapper-1.01.04-1.0.RHEL4
> 
> device-mapper-multipath-0.4.5-6.0.RHEL4 needs
> device-mapper-1.02.*
> 
> Look at things from my side, it definitely seems like RHEL 4.2 says it
> uses device-mapper-1.01, which doesn't make any sense, since
> device-mapper-multipath-0.4.5-6.0.RHEL4 was definitely compiled against
> device-mapper-1.02, and I don't believe that the can both 1.01 and 1.02
> can coexist on a system.
> 
> The easy solution is to upgrade to at least RHEL 4.3
> 
> If that's impossible, you can try to upgrade device-mapper to
> device-mapper-1.02.02-1.0.RHEL4 or later.  This might cause all sorts of
> dependancy issues. It may be easier to downgrade device-mapper-multipath
> to device-mapper-multipath-0.4.5-5.2.RHEL4
> 
> I'm not sure why this incompatibility exists now, since it obviously
> didn't when RHEL 4.2 was originally released. My best guess is that
> device-mapper-multipath-0.4.5-6.0.RHEL4 didn't really get released until
> RHEL 4.3, but that's just a guess.
> 
> Of course, if you already have device-mapper-1.02.* on your system, and
> are still seeing these issues, then something else is going on.
> 
> -Ben
> 
> >    with regards,
> >    Julian Rogan
> 
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
