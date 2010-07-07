From: Bart Coninckx <bart.coninckx@telenet.be>
Subject: Re: understanding of multipathing and speed
Date: Wed, 7 Jul 2010 19:18:48 +0200
Message-ID: <201007071918.48557.bart.coninckx@telenet.be>
References: <201007052037.39362.bart.coninckx@telenet.be>
	<1278356310.30539.606.camel@localhost>
	<201007060616.55657.bart.coninckx@telenet.be>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <201007060616.55657.bart.coninckx@telenet.be>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tuesday 06 July 2010 06:16:55 Bart Coninckx wrote:
> On Monday 05 July 2010 20:58:30 Christophe Varoqui wrote:
> > On lun., 2010-07-05 at 20:37 +0200, Bart Coninckx wrote:
> > > Hi,
> > >
> > > I would like to run my ideas by this list about multipathing and the
> > > results as far as storage speed is concerned.
> > >
> > > I'm using multipathing to two iSCSI targets pointing to the same
> > > storage. It was my understanding that this provides for network path
> > > redundancy (and it does, I tested this) but also for added speed.
> > > I did some tests with Bonnie++ however while both paths were active and
> > > one path was down and the results are basically the same.
> > >
> > > Am I assuming wrong things? Or have I configured things wrong?
> >
> > can you also include a 'multipath -l' output and sketch the
> > hba/switch/controller physical connections ?
> >
> > thanks,
> 
> Sure,
> 
> xen3:~ # multipath -l
> lx03 (1494554000000000000000000010000000000000002000000) dm-3
>  IET,VIRTUAL-DISK [size=10G][features=1 queue_if_no_path][hwhandler=0]
> \_ round-robin 0 [prio=-2][active]
>  \_ 2:0:0:0 sdc 8:32  [active][undef]
>  \_ 1:0:0:0 sdb 8:16  [active][undef]
> ws033 (1494554000000000000000000010000000100000002000000) dm-2 IET,VIRTUAL-
> DISK
> [size=15G][features=1 queue_if_no_path][hwhandler=0]
> \_ round-robin 0 [prio=-2][active]
>  \_ 2:0:0:1 sde 8:64  [active][undef]
>  \_ 1:0:0:1 sdd 8:48  [active][undef]
> ms01 (1494554000000000000000000010000000200000002000000) dm-1
>  IET,VIRTUAL-DISK [size=40G][features=1 queue_if_no_path][hwhandler=0]
> \_ round-robin 0 [prio=-2][active]
>  \_ 1:0:0:2 sdf 8:80  [active][undef]
>  \_ 2:0:0:2 sdg 8:96  [active][undef]
> 
> I have two Gigabit NICs in this server each running over a separate switch
>  to a separate gigabit NIC with a unique IP address on the storage IET
>  iSCSI target.
> 
> Is this sufficient info?
> 
> Thx,
> 
> Bart
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 

Hi all,

to show my point, these are the results of running bonnie++ locally on the 
storage - the values I look at are Block values in K/sec in both sequential 
output (writing) and sequential input (reading):

Version 1.03e       ------Sequential Output------ --Sequential Input- --
Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --
Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec 
%CP
iscsi3           8G 69351  96 116112  32 41128  10 57874  82 107721  16 418.2   
0
                    ------Sequential Create------ --------Random 
Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read--- -
Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec 
%CP
                 16  4533  99 +++++ +++ +++++ +++  4395  99 +++++ +++ 17122  
99
iscsi3,8G,69351,96,116112,32,41128,10,57874,82,107721,16,418.2,0,16,4533,99,
+++++,+++,+++++,+++,4395,99,+++++,+++,17122,99



So were are hitting roughly 110 MB/sec locally on the storage server.

Now these are the results do doing the same over multipath with two paths 
enabled:

Version 1.03e       ------Sequential Output------ --Sequential Input- --
Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --
Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec 
%CP
xen3             8G 63953  92 100525  26 26885   2 41957  55 68184   2 357.9   
0
                    ------Sequential Create------ --------Random 
Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read--- -
Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec 
%CP
                 16  5326  98 +++++ +++ +++++ +++  5333  97 +++++ +++ 17179 
100
xen3,8G,63953,92,100525,26,26885,2,41957,55,68184,2,357.9,0,16,5326,98,+++++,
+++,+++++,+++,5333,97,+++++,+++,17179,100

You can see we hit somewhat less, probably due to TCP overhead (though this 
should cut things with 30%). Now the same with one path down:

Version 1.03e       ------Sequential Output------ --Sequential Input- --
Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --
Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec 
%CP
xen3             8G 33214  46 113811  29 27917   1 44474  58 68812   2 362.8   
0
                    ------Sequential Create------ --------Random 
Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read--- -
Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec 
%CP
                 16  5294  98 +++++ +++ +++++ +++  5337  97 +++++ +++ 17183  
99
xen3,8G,33214,46,113811,29,27917,1,44474,58,68812,2,362.8,0,16,5294,98,+++++,
+++,+++++,+++,5337,97,+++++,+++,17183,99

As you can see, roughly the same K/sec for both output and input. Actually 
writing is even faster with one path down!
Can anyone make sense of these values?

thx!

B.
 
