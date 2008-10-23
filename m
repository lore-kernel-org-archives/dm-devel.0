From: sriharsha y d <srihashin@yahoo.co.in>
Subject: mulitipath -ll & multiapth -v3 ouput
Date: Thu, 23 Oct 2008 15:56:15 +0530 (IST)
Message-ID: <213666.28497.qm@web94812.mail.in2.yahoo.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
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
List-Id: dm-devel.ids

Hi,

Not sure why there is a difference between the  mulitipath -ll & multiapt=
h -v3 ouput ,for  IO queuing features disply,

i.e=20
multipath  -v3=20
asm1: pgfailback =3D -2 (controller setting)=20
asm1: pgpolicy =3D multibus (controller setting)=20
asm1: selector =3D round-robin 0 (internal default)=20
asm1: features =3D 0 (internal default)=20
asm1: hwhandler =3D 0 (internal default)=20
asm1: rr_weight =3D 2 (config file default)=20
asm1: minio =3D 100 (config file default)=20
asm1: no_path_retry =3D 5 (config file default)=20
pg_timeout =3D NONE (internal default)=20
asm1: set ACT_NOTHING (map unchanged)

=20
multiapth -ll=20

asm1 (1HITACHI_770100720007) dm-9 HITACHI,DF600F=20
[size=3D65G][features=3D1 queue_if_no_path][hwhandler=3D0]=20
\_ round-robin 0 [prio=3D0][active]=20
 \_ 0:0:0:7 sdh 8:112 [active][ready]=20
 \_ 1:0:0:7 sdp 8:240 [active][ready]


So if we look at the features part , v3 output displays the correct info =
since in the config file  I have disabled queuing, but where as in -ll ou=
put it says queuing is enabled !!

Can some one provide more info on this ....



      Add more friends to your messenger and enjoy! Go to http://messenge=
r.yahoo.com/invite/
