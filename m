From: "Paul Cote" <paul.cote@incipient.com>
Subject: RE: CLARiiON failover modes and DM.
Date: Tue, 20 Nov 2007 13:59:42 -0500
Message-ID: <940B4FF1F5958E4F96FC83C055A2F2611B8C84@exch-2003.incipient.waltham>
References: <474290DD.2080004@linpro.no>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <474290DD.2080004@linpro.no>
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


Tore,

Thanks for all the info ... Setting the CX FO mode to 1 appears to have
clear up the mess. One thing I've noticed after doing a dynamic
discovery of newly provisioned CX LUNs in that path state is generally
wrong. It will come up as [active][faulty]and to correct that requires a
reboot of the server. Don't know if that's a bug or not ... But I'm not
opposed to a reboot.

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Tore Anderson
Sent: Tuesday, November 20, 2007 2:47 AM
To: device-mapper development
Subject: Re: [dm-devel] CLARiiON failover modes and DM.


* Paul Cote

> I have found the definitions of all CX failover modes. The SAN admin
> assigned failover mode 3. Will DM support option 3 assuming that I=20
> follow EMC's guidance wrt the appropriate settings for the CX in=20
> multipath.conf? ... Or should we reassign the failover mode to 1 per=20
> your email? It seems to me that the path state status will differ=20
> significantly based on the failover modes; specifically 1 or 3. We
> don't have FLARE 26 so ALUA mode is N/A.
>=20
> The failover definitions are:
> 1) Passive not ready; a command failure when I/O issued to non-owning=20
> SP.
> 2) quiet trespass on I/O to non-owning SP
> 3) passive always ready; some commands (TUR) return "passive always=20
> ready" status.

Mode 1 is what I've used on my CX so far (no support for ALUA yet).
You'll get lots of I/O failures when something wants to access the
passive paths (to scan for partition tables, PV signatures, and so on),
but they're harmless and can be disregarded.  You'll need path_checker
emc_clariion, hardware_handler emc, prio_callout mpath_prio_emc, and
path_grouping_policy group_by_prio  I think this is the default mode
multipath-tools is set up to handle, so unless you can invite EMC over
for a FLARE 26 upgrade party, I think this is the one you want.

Mode 2 you don't want unless you really know what you're doing.  This
will cause the I/O that failed in mode 1 to cause a volume trespass.  So
if you boot node 2 in a cluster, the data volumes will bounce around
wildly between SPs until it has finished booting, which'll affect I/O
from the production nodes in your cluster.  Same problem if you run
"vgdisplay", "fdisk -l", run HAL (maybe), and so on.

Mode 3 I never tried but it sounds like it's like mode 1, only that the
TEST UNIT READY will succeed.  If that's the case the only difference is
probably that you could use path_checker tur instead of path_checker
emc.

Regards
--=20
Tore Anderson

--
dm-devel mailing list
dm-devel@redhat.com https://www.redhat.com/mailman/listinfo/dm-devel
