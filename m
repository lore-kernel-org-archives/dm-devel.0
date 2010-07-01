From: "Allen, Jack" <Jack.Allen@mckesson.com>
Subject: Re: Rescan for new LUNs
Date: Thu, 1 Jul 2010 13:38:07 -0400
Message-ID: <230ED15F81AFD3409345FFA4E565F0E50B8B588B@NDHV3000.na.corp.mckesson.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: Produced By Microsoft Exchange V6.5
In-Reply-To: Produced By Microsoft Exchange V6.5
References: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
In-Reply-To: <20100701010738.GA24883@us.ibm.com>
References: <230ED15F81AFD3409345FFA4E565F0E50B83D8E1@NDHV3000.na.corp.mckesson.com>
	<20100701010738.GA24883@us.ibm.com>
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

 =


-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On B=
ehalf Of Malahal Naineni
Sent: Wednesday, June 30, 2010 9:08 PM
To: dm-devel@redhat.com
Subject: Re: [dm-devel] Rescan for new LUNs

Allen, Jack [Jack.Allen@mckesson.com] wrote:
>    Hello:
>    =A0=A0=A0=A0=A0=A0=A0 What is the best way to cause the system to resc=
an for new LUNs,
>    other than rebooting?

Writing something to some files in sysfs. If none of the LUNs are in
use, "modprobe -r <module>" followed by "modprobe <module>" will also
work.

Thanks, Malahal.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Something to some file is not very helpful. And the other LUNs are in use. =
I am just trying to keep from having to reboot if I really do not need to.

----
Jack Allen
