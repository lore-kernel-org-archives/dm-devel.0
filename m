From: Holger Smolinski <smolinski@de.ibm.com>
Subject: Re: IBM DS4300
Date: Thu, 1 Jun 2006 10:15:01 +0200
Message-ID: <OFB2DC3C68.165CC670-ONC1257180.002CC9D2-C1257180.002D51F4@de.ibm.com>
References: <200605291742.k4THgWWZ016415@relay2.fe.up.pt>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200605291742.k4THgWWZ016415@relay2.fe.up.pt>
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

Gil,

DS4300 has two modes:

AVT, which means only one path can be used at any point in time. Using an
alternate path will cause Automated Volume Transfer and add significant
latency.
RDAC, which means only one path can be used at any point in time. Using a=
n
alternate path will cause an I/O error unless the volume has been migrate=
d
manually or by a hardware_handler.

Best Regards
        Holger Smolinski
--
Dr. Holger Smolinski, Linux Technology Center, Linux on zSeries
Author of the '-t2'-Option
IBM Deutschland Entwicklung GmbH,Sch=F6naicher Str. 220, 71032 B=F6blinge=
n
FAX: +49-7031-16-3456, Tel. +49-7031-16-4652


                                                                         =
 =20
             "Gil"                                                       =
 =20
             <gils@fe.up.pt>                                             =
 =20
             Sent by:                                                   T=
o=20
             dm-devel-bounces@         <dm-devel@redhat.com>             =
 =20
             redhat.com                                                 c=
c=20
                                                                         =
 =20
                                                                   Subjec=
t=20
             29.05.2006 19:42          [dm-devel] IBM DS4300             =
 =20
                                                                         =
 =20
                                                                         =
 =20
             Please respond to                                           =
 =20
               device-mapper                                             =
 =20
                development                                              =
 =20
             <dm-devel@redhat.                                           =
 =20
                   com>                                                  =
 =20
                                                                         =
 =20
                                                                         =
 =20




Hi list,

I have the following SAN hardware, and would be very grateful for any hel=
p:

SAN:
IBM DS4300 Storage Server with Turbo Option

HBA:
Fast Host Bus Adapter FC-2

Switch:
2 IBM TotalStorage SAN Switch H08 (8-portas)

Does multipath-tools support this hardware? How should I configure it?

I have tried to use multipath with it, using default configuration, but I
am having performance problems. What I would like to figure out is if
multipath-tools has anything to do with it.

Best regards,
    Gil--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
