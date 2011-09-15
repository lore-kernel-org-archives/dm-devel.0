From: NEVEU Stephane <stephane.neveu@thalesgroup.com>
Subject: Re: multipathd & EMC Clariion CX-4
Date: Thu, 15 Sep 2011 16:49:26 +0200
Message-ID: <24128_1316098167_4E721077_24128_6521_1_EEF700FCD1A35041BF2C750B4EDDCA310138F9C4A949@THSONEA01CMS03P.one.grp>
References: <21739_1315994330_4E707ADA_21739_7623_1_EEF700FCD1A35041BF2C750B4EDDCA310138F9C49D3A@THSONEA01CMS03P.one.grp>
	<4E709273.8000901@suse.de>
	<22404_1316001614_4E70974E_22404_18469_1_EEF700FCD1A35041BF2C750B4EDDCA310138F9C49E5E@THSONEA01CMS03P.one.grp>
	<13419_1316090807_4E71F3B7_13419_13681_2_EEF700FCD1A35041BF2C750B4EDDCA310138F9C4A755@THSONEA01CMS03P.one.grp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <13419_1316090807_4E71F3B7_13419_13681_2_EEF700FCD1A35041BF2C750B4EDDCA310138F9C4A755@THSONEA01CMS03P.one.grp>
Content-Language: fr-FR
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

Ok, solved by a update-initramfs.

Cordialement,

[@@THALES GROUP RESTRICTED@@]
--
St=E9phane Neveu
Ing=E9nieur Opensource / RedHat Technical Manager
THALES - Critical Information Systems
DIVISION Security Solutions & Services / Server Mgmt
T=E9l 01 73 17 03 15
--


-----Message d'origine-----
De=A0: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] De =
la part de NEVEU Stephane
Envoy=E9=A0: jeudi 15 septembre 2011 14:47
=C0=A0: device-mapper development
Objet=A0: Re: [dm-devel] multipathd & EMC Clariion CX-4

Hi all,

Actually it works on only one server (I'm actually running a cluster..), th=
e second node is not showing anything when trying multipath -ll.
I tried to remove / reboot / reinstall multipath-tools but I still see this=
 error message in dmesg :
device-mapper: ioctl: error adding target to table
device-mapper: table: 251:13: multipath: error getting table
.
.
.
many times.
There is no linked wwn created in /dev/mapper of course whereas everything'=
s working find on the first node..
Any idea ?

Thank you by avance,


-----Message d'origine-----
De=A0: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] De =
la part de NEVEU Stephane
Envoy=E9=A0: mercredi 14 septembre 2011 14:00
=C0=A0: device-mapper development
Objet=A0: Re: [dm-devel] multipathd & EMC Clariion CX-4

Dear Hannes,

You are right ! many thanks ! I moved away multipath.conf from the etc fold=
er and restarted multipath-tools and everything works fine :

NDO (36006016017402600f2ed610b62cde011) dm-8 DGC     ,RAID 5        =

[size=3D50G][features=3D1 queue_if_no_path][hwhandler=3D1 emc]
\_ round-robin 0 [prio=3D2][active]
 \_ 2:0:0:1 sdd 8:48  [active][ready] =

 \_ 5:0:0:1 sdj 8:144 [active][ready] =

\_ round-robin 0 [prio=3D0][enabled]
 \_ 2:0:1:1 sdg 8:96  [active][ready] =

 \_ 5:0:1:1 sdm 8:192 [active][ready] =

NAGIOS (360060160174026000c984cc67acde011) dm-6 DGC     ,RAID 5        =

[size=3D40G][features=3D1 queue_if_no_path][hwhandler=3D1 emc]
\_ round-robin 0 [prio=3D2][active]
 \_ 2:0:1:2 sdh 8:112 [active][ready] =

 \_ 5:0:1:2 sdn 8:208 [active][ready] =

\_ round-robin 0 [prio=3D0][enabled]
 \_ 2:0:0:2 sde 8:64  [active][ready] =

 \_ 5:0:0:2 sdk 8:160 [active][ready] =

NPCD (360060160174026008cf8cef961cde011) dm-7 DGC     ,RAID 5        =

[size=3D100G][features=3D1 queue_if_no_path][hwhandler=3D1 emc]
\_ round-robin 0 [prio=3D2][active]
 \_ 2:0:1:0 sdf 8:80  [active][ready] =

 \_ 5:0:1:0 sdl 8:176 [active][ready] =

\_ round-robin 0 [prio=3D0][enabled]
 \_ 2:0:0:0 sdc 8:32  [active][ready] =

 \_ 5:0:0:0 sdi 8:128 [active][ready]

Does it automatically recognize symbolic links (pointing to /dev/dm-*) in /=
dev/mapper/ folder ? =


--
St=E9phane Neveu
Ing=E9nieur Opensource / RedHat Technical Manager
THALES - Critical Information Systems
DIVISION Security Solutions & Services / Server Mgmt
T=E9l 01 73 17 03 15
--


-----Message d'origine-----
De=A0: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] De =
la part de Hannes Reinecke
Envoy=E9=A0: mercredi 14 septembre 2011 13:40
=C0=A0: device-mapper development
Objet=A0: Re: [dm-devel] multipathd & EMC Clariion CX-4

On 09/14/2011 11:58 AM, NEVEU Stephane wrote:
> Hi all,
>
> I'm experiencing problems trying to set up a multipathd config with
> a EMC Clariion CX-4 Storage.
>
> It seems that the CX4 is actually active/passive regarding SPs. My
> server  has QLogic Fiber Cards. My multipath-tools version is 0.4.8.
>
> Here is my multipath.conf :
>
> ##
>
> ## This is a template multipath-tools configuration file
>
> ## Uncomment the lines relevent to your environment
>
> ##
>
> defaults {
>
>                  user_friendly_names   yes
>
> }
>
> blacklist {
>
>                  #devnode "*"
>
>                  devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
>
>                  devnode "^hd[a-z][[0-9]*]"
>
>                  devnode "^cciss!c[0-9]d[0-9]*[p[0-9]*]"
>
> }
>
> devices {
>
>                  device {
>
>                                 vendor "DGC "
>
>                                 product "*"
>
That is wrong. The configuration file doesn't allow for regular =

expressions or wildcards. Please use the correct name ('RAID 5') here.
And 'directio' is most certainly wrong here.

What's wrong with the default setting? It should work out of the box =

without configuration file at all ...

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
