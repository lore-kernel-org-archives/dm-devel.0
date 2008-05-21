From: "Craig Simpson" <csimpson@visto.com>
Subject: RE: Round Robin vs Active/Passive
Date: Wed, 21 May 2008 08:32:25 -0700
Message-ID: <ABFD05FF09D13E4883B757E75603624D011E95BB@ex-sea1.vistocorp.com>
References: <8a6b34b03e0524aa66c862534fee9b7a@www3.mail.volny.cz><18484.2693.62883.535755@notabene.brown>
	<ABFD05FF09D13E4883B757E75603624D011E95B6@ex-sea1.vistocorp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <ABFD05FF09D13E4883B757E75603624D011E95B6@ex-sea1.vistocorp.com>
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
Cc: Michael Denney <mdenney@visto.com>
List-Id: dm-devel.ids



My Hitachi AMS200 is an Active/Passive array says Hitachi.=20
By looking at asm13 I see all my paths active. Did use the
"path_grouping_policy    multibus" when creating that alias.=20

The LUNs that are picked up and not aliased in /etc/multipath.conf seem
to show an active/passive setup.=20

Wondering "How" the [active] or [active] [enables] setup is figured out
by multipath.


(this is a different machine, but with no alias I [active] & [enabled]
path.=20
mpath5 (1HITACHI_D60090910036) dm-10 HITACHI,DF600F
[size=3D5.5G][features=3D0][hwhandler=3D0]
\_ round-robin 0 [prio=3D0][active]
 \_ 0:0:1:36 sdq 65:0  [active][undef]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:0:36 sdf 8:80  [active][undef]


This one was aliased with below settings in /etc/multipath.conf
Multipath -l
asm13 (1HITACHI_730600240012) dm-53 HITACHI,DF600F
[size=3D64G][features=3D0][hwhandler=3D0]
\_ round-robin 0 [prio=3D0][active]
 \_ 0:0:1:12 sdba 67:64   [active][undef]
 \_ 1:0:0:12 sdco 69:192  [active][undef]
 \_ 1:0:1:12 sdec 128:64  [active][undef]
 \_ 0:0:0:12 sdm  8:192   [active][undef]




From /etc/multipath.conf:
        multipath {
                wwid                    1HITACHI_730600240012
                alias                   asm13
                path_grouping_policy    multibus
                path_checker            readsector0
                path_selector           "round-robin 0"
                failback                immediate
        }




From /etc/multipath.conf:
defaults {
        udev_dir                /dev
        polling_interval        10
        selector                "round-robin 0"
        path_grouping_policy    multibus
        getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
        prio_callout            /bin/true
        path_checker            readsector0
        rr_min_io               100
        rr_weight               priorities
        failback                immediate
        no_path_retry           fail
        user_friendly_name      yes
}






Craig




-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Craig Simpson
Sent: Wednesday, May 21, 2008 7:48 AM
To: device-mapper development
Subject: [dm-devel] Round Robin vs Active/Passive



For multipathd and dm is round-robin the only mode for multipathing? The
array we have as a newer Hitachi AMS200 and Active/Passive says the
documentation.=20

Using round-robin seems to work fine with it. Have 4 paths and they are
all sharing 1/4 of the load.=20

Are there other options that can be set in /etc/multipath.conf? I only
know of round-robin.=20

Craig =20

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
