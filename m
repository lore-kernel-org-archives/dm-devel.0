From: Brem Belguebli <brem.belguebli@gmail.com>
Subject: Re: understanding of multipathing and speed
Date: Thu, 08 Jul 2010 00:06:39 +0200
Message-ID: <1278540399.3454.18.camel@newgen.localdomain>
References: <201007052037.39362.bart.coninckx@telenet.be>
	<201007060616.55657.bart.coninckx@telenet.be>
	<201007071918.48557.bart.coninckx@telenet.be>
	<201007072301.48042.bart.coninckx@telenet.be>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <201007072301.48042.bart.coninckx@telenet.be>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Hi,
On Wed, 2010-07-07 at 23:01 +0200, Bart Coninckx wrote:
> On Wednesday 07 July 2010 19:18:48 Bart Coninckx wrote:
> > On Tuesday 06 July 2010 06:16:55 Bart Coninckx wrote:
> > > On Monday 05 July 2010 20:58:30 Christophe Varoqui wrote:
> > > > On lun., 2010-07-05 at 20:37 +0200, Bart Coninckx wrote:
> > > > > Hi,
> > > > >
> > > > > I would like to run my ideas by this list about multipathing and the
> > > > > results as far as storage speed is concerned.
> > > > >
> > > > > I'm using multipathing to two iSCSI targets pointing to the same
> > > > > storage. It was my understanding that this provides for network path
> > > > > redundancy (and it does, I tested this) but also for added speed.
> > > > > I did some tests with Bonnie++ however while both paths were active
> > > > > and one path was down and the results are basically the same.
> > > > >
> > > > > Am I assuming wrong things? Or have I configured things wrong?
> > > >
> > > > can you also include a 'multipath -l' output and sketch the
> > > > hba/switch/controller physical connections ?
> > > >
> > > > thanks,
> > >
> > > Sure,
> > >
> > > xen3:~ # multipath -l
> > > lx03 (1494554000000000000000000010000000000000002000000) dm-3
> > >  IET,VIRTUAL-DISK [size=10G][features=1 queue_if_no_path][hwhandler=0]
> > > \_ round-robin 0 [prio=-2][active]
> > >  \_ 2:0:0:0 sdc 8:32  [active][undef]
> > >  \_ 1:0:0:0 sdb 8:16  [active][undef]
> > > ws033 (1494554000000000000000000010000000100000002000000) dm-2
> > > IET,VIRTUAL- DISK
> > > [size=15G][features=1 queue_if_no_path][hwhandler=0]
> > > \_ round-robin 0 [prio=-2][active]
> > >  \_ 2:0:0:1 sde 8:64  [active][undef]
> > >  \_ 1:0:0:1 sdd 8:48  [active][undef]
> > > ms01 (1494554000000000000000000010000000200000002000000) dm-1
> > >  IET,VIRTUAL-DISK [size=40G][features=1 queue_if_no_path][hwhandler=0]
> > > \_ round-robin 0 [prio=-2][active]
> > >  \_ 1:0:0:2 sdf 8:80  [active][undef]
> > >  \_ 2:0:0:2 sdg 8:96  [active][undef]
> > >
> > > I have two Gigabit NICs in this server each running over a separate
> > > switch to a separate gigabit NIC with a unique IP address on the storage
> > > IET iSCSI target.
> > >
> > > Is this sufficient info?
> > >
> > > Thx,
> > >
> > > Bart
> > >
> > > --
> > > dm-devel mailing list
> > > dm-devel@redhat.com
> > > https://www.redhat.com/mailman/listinfo/dm-devel
> > 
> > Hi all,
> > 
> > to show my point, these are the results of running bonnie++ locally on the
> > storage - the values I look at are Block values in K/sec in both sequential
> > output (writing) and sequential input (reading):
> > 
> > Version 1.03e       ------Sequential Output------ --Sequential Input- --
> > Random-
> >                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --
> > Seeks--
> > Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec
> > %CP
> > iscsi3           8G 69351  96 116112  32 41128  10 57874  82 107721  16
> >  418.2 0
> >                     ------Sequential Create------ --------Random
> > Create--------
> >                     -Create-- --Read--- -Delete-- -Create-- --Read--- -
> > Delete--
> >               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec
> > %CP
> >                  16  4533  99 +++++ +++ +++++ +++  4395  99 +++++ +++ 17122
> > 99
> > iscsi3,8G,69351,96,116112,32,41128,10,57874,82,107721,16,418.2,0,16,4533,99
> > , +++++,+++,+++++,+++,4395,99,+++++,+++,17122,99
> > 
> > 
> > 
> > So were are hitting roughly 110 MB/sec locally on the storage server.
> > 
> > Now these are the results do doing the same over multipath with two paths
> > enabled:
> > 
> > Version 1.03e       ------Sequential Output------ --Sequential Input- --
> > Random-
> >                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --
> > Seeks--
> > Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec
> > %CP
> > xen3             8G 63953  92 100525  26 26885   2 41957  55 68184   2
> >  357.9 0
> >                     ------Sequential Create------ --------Random
> > Create--------
> >                     -Create-- --Read--- -Delete-- -Create-- --Read--- -
> > Delete--
> >               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec
> > %CP
> >                  16  5326  98 +++++ +++ +++++ +++  5333  97 +++++ +++ 17179
> > 100
> > xen3,8G,63953,92,100525,26,26885,2,41957,55,68184,2,357.9,0,16,5326,98,++++
> > +, +++,+++++,+++,5333,97,+++++,+++,17179,100
> > 
> > You can see we hit somewhat less, probably due to TCP overhead (though this
> > should cut things with 30%). Now the same with one path down:
> > 
> > Version 1.03e       ------Sequential Output------ --Sequential Input- --
> > Random-
> >                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --
> > Seeks--
> > Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec
> > %CP
> > xen3             8G 33214  46 113811  29 27917   1 44474  58 68812   2
> >  362.8 0
> >                     ------Sequential Create------ --------Random
> > Create--------
> >                     -Create-- --Read--- -Delete-- -Create-- --Read--- -
> > Delete--
> >               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec
> > %CP
> >                  16  5294  98 +++++ +++ +++++ +++  5337  97 +++++ +++ 17183
> > 99
> > xen3,8G,33214,46,113811,29,27917,1,44474,58,68812,2,362.8,0,16,5294,98,++++
> > +, +++,+++++,+++,5337,97,+++++,+++,17183,99
> > 
> > As you can see, roughly the same K/sec for both output and input. Actually
> > writing is even faster with one path down!
> > Can anyone make sense of these values?
> > 
> > thx!
> > 
> > B.
> > 
> > 
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> > 
> 
> Maybe adding this one while doing a test with both paths active during "off 
> hours", so no other intrusive factors: 
> 
> Version 1.03e       ------Sequential Output------ --Sequential Input- --
> Random-
>                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --
> Seeks--
> Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec 
> %CP
> xen3             8G 66510  93 80841  21 26821   1 45368  58 72095   2 361.2   
> 0
>                     ------Sequential Create------ --------Random 
> Create--------
>                     -Create-- --Read--- -Delete-- -Create-- --Read--- -
> Delete--
>               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec 
> %CP
>                  16  5295  98 +++++ +++ +++++ +++  5318  98 +++++ +++ 17089 
> 100
> xen3,8G,66510,93,80841,21,26821,1,45368,58,72095,2,361.2,0,16,5295,98,+++++,
> +++,+++++,+++,5318,98,+++++,+++,17089,100
> 
> 
> it show that the speed is exactly 70% of the speed when doing tests locally. 
> So this might be the iSCSI TCP overhead. 
> 
> Should the speed of two round robin paths not compensate for this loss? Or is 
> my local storage just to slow to have multipath having any benefit speed wise?
> 
To calculate your theoretical TCP throughput, a simple formula can be
applied : TP= TCP Window size / RTT 

In addition to this generally, you can take advantage of path
load-balancing IO's to capable to multiplex IO's devices , such as SAN
arrays with cache frontend.
Trying to load-balance on a single physical device, won't be, IMHO, of
any help except for pure failover purposes.
   
> 
> thx!
> 
> B.
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
