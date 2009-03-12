From: Thomas Witzel <witzel.thomas@gmail.com>
Subject: configure MD3000
Date: Thu, 12 Mar 2009 12:53:36 -0400
Message-ID: <d1392840903120953me7d9acdyee6ead49d880be0@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Hello all,

I have a Dell MD3000 attached to an NX1950. It seems the MD3000 is
connected through a SAS 5/E card and uses the mptsas driver. My kernel
version is 2.6.27.
multipath -ll gives me:

sdj: checker msg is "directio checker reports path is down"
360022190009773680000214a495047cedm-5 ,
[size=2.0T][features=0][hwhandler=0]
\_ round-robin 0 [prio=1][active]
 \_ #:#:#:# sdd 8:48  [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ #:#:#:# sdj 8:144 [failed][faulty]
360022190009773680000000000000000dm-0 ,
[size=20M][features=0][hwhandler=0]
\_ round-robin 0 [prio=1][enabled]
 \_ #:#:#:# sdg 8:96  [failed][ready]
sde: checker msg is "directio checker reports path is down"
3600221900096f27d00000ab449504839dm-4 ,
[size=2.0T][features=0][hwhandler=0]
\_ round-robin 0 [prio=1][active]
 \_ #:#:#:# sdk 8:160 [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ #:#:#:# sde 8:64  [failed][faulty]
sdc: checker msg is "directio checker reports path is down"
3600221900096f27d00000ab3495047fddm-2 ,
[size=2.0T][features=0][hwhandler=0]
\_ round-robin 0 [prio=1][active]
 \_ #:#:#:# sdi 8:128 [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ #:#:#:# sdc 8:32  [failed][faulty]
sdh: checker msg is "directio checker reports path is down"
360022190009773680000214749504780dm-6 ,
[size=2.0T][features=0][hwhandler=0]
\_ round-robin 0 [prio=1][active]
 \_ #:#:#:# sdb 8:16  [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ #:#:#:# sdh 8:112 [failed][faulty]
sdl: checker msg is "directio checker reports path is down"
360022190009773680000214c49504806dm-3 ,
[size=1.1T][features=0][hwhandler=0]
\_ round-robin 0 [prio=1][active]
 \_ #:#:#:# sdf 8:80  [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ #:#:#:# sdl 8:176 [failed][faulty]
3600221900096f27d0000000000000000dm-1 ,
[size=20M][features=0][hwhandler=0]
\_ round-robin 0 [prio=1][enabled]
 \_ #:#:#:# sdm 8:192 [failed][ready]


How do I configure this to work correctly ? I'm sorry if that is a
redundant question, but I googled for about 8 hours now and couldn't
find anything conclusive. Also is there a manual/tutorial for this
somewhere ?

Thank you,
Thomas
