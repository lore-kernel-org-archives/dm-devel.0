From: Tony Lapointe <tony.lapointe@connexim.ca>
Subject: Re: multipath-tools with STK FLEXLINE 380
Date: Tue, 21 Nov 2006 13:02:28 -0500
Message-ID: <1164132148.2066.19.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
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
Cc: tony.lapointe@connexim.ca, daniel.milani@connexim.ca
List-Id: dm-devel.ids

                Do not use 'rr_weight=3Dpriorities'. The priorities
                handling is currently buggered; or, put it the other way
                round, you will need at least my latest fix to get it
                working. Just remove that line and stay with the
                defaults. That should work.
               =20
                And as a sidenote: Using 'group_by_prio' and
                'rr_weight=3Dpriorities' is completely pointless, even if
                'rr_weight=3Dpriorities' should be working.'group_by_prio=
'
                will lump all devices with the same priority into one
                group. And 'rr_weight=3Dpriorities' will then modify the
                'minio' based on the priority. So you can as well
                directly modify the 'minio'
                parameter.'rr_weight=3Dpriorities' only makes sense if yo=
u
                have path with different priorities in one group, ie
                when using 'multibus' or 'group_by_serial'.
                Cheers,
               =20
                Hannes
                --
                Dr. Hannes Reinecke			hare suse de
                SuSE Linux Products GmbH		S390 & zSeries
                Maxfeldstra=DFe 5				+49 911 74053 688
                90409 N=FCrnberg				http://www.suse.de




Hi Hannes,

thanks for the reply.

I've tried without "rr_weight=3Dpriorities" in my multipath.conf but it d=
oes not work either.
The only difference it makes is that "multipath -v3" now output : "rr_wei=
ght =3D 1 (internal default)"
instead of "rr_weight =3D 2 (config file default)".

I was thinking that "group_by_prio" is use to group together devices with=
 differents
priorities, with the one with the highest priority first, is it wrong?

The output of "multipath -d -v2" seems to reflect this :

create: test1 (3600a0b8000119c20000002a445338779) STK,FLEXLINE 380
[size=3D100G][features=3D0][hwhandler=3D0]
\_ round-robin 0 [prio=3D3][undef]
 \_ 0:0:0:0 sda 8:0   [undef][ready]
\_ round-robin 0 [prio=3D0][undef]
 \_ 1:0:0:0 sdd 8:48  [undef][ready]
create: test2 (3600a0b8000119c20000002a945338e7f) STK,FLEXLINE 380
[size=3D100G][features=3D0][hwhandler=3D0]
\_ round-robin 0 [prio=3D3][undef]
 \_ 1:0:0:1 sde 8:64  [undef][ready]
\_ round-robin 0 [prio=3D0][undef]
 \_ 0:0:0:1 sdb 8:16  [undef][ready]
create: test1 (3600a0b8000119c20000002a445338779) STK,FLEXLINE 380
[size=3D100G][features=3D0][hwhandler=3D0]
\_ round-robin 0 [prio=3D3][undef]
 \_ 0:0:0:0 sda 8:0   [undef][ready]
\_ round-robin 0 [prio=3D0][undef]
 \_ 1:0:0:0 sdd 8:48  [undef][ready]
create: test2 (3600a0b8000119c20000002a945338e7f) STK,FLEXLINE 380
[size=3D100G][features=3D0][hwhandler=3D0]
\_ round-robin 0 [prio=3D3][undef]
 \_ 1:0:0:1 sde 8:64  [undef][ready]
\_ round-robin 0 [prio=3D0][undef]
 \_ 0:0:0:1 sdb 8:16  [undef][ready]


showing sda and sde (prio=3D3) always being first...

You're talking about your latest fix; is there a place where i can find n=
ew version of the
multipath-tools package for SLES 10?


Thanks again!


--=20
#################################################
#                                               #
# Tony Lapointe @ Connexim                      #
# Administrateur Systeme # System Administrator #
# RHCE # LPI                                    #
# phone -> 1-514-879-5951                       #
# page -> 1-514-851-2560                        #
# email -> tony.lapointe@connexim.ca            #
# epager -> 5148512560@pager.mobility.com       #
#                                               #
#################################################
#                                               #
# # mount --bind /bin/su /bin/login             #
#                                               #
#################################################
