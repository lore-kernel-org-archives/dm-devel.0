From: "Stewart, Sean" <Sean.Stewart@netapp.com>
Subject: Research for possible new feature: Rescanning LUN
 mappings through multipath-tools
Date: Mon, 17 Jun 2013 14:31:42 +0000
Message-ID: <8255ED565A0EAA4A960625E27D49DBF236C39A34@SACEXCMBX04-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi all,

There have been a few requests within my organization to add more comprehen=
sive capabilities to rescan for new LUN mappings, remapped LUNs, and unmapp=
ed LUNs when running DM-MP, and I or someone from my group will begin worki=
ng on this soon.  I wanted to get some opinions from the community before w=
e began work.

Rescan-scsi-bus.sh currently provides some of this functionality, but it do=
es not handle every case.  =

- Case 1:  Newly mapped LUNs
Issue a scan on each SCSI host and look for new LUNs, then create new multi=
path devices for them.
- Case 2:  Remapped LUNs
Get the current WWID, if it is different than what the multipath device pre=
viously reported, the LUN was remapped.
A special case that provides special amount of grief is the case where the =
well-known LUN occupies LUN 0, then the user maps a volume in the same plac=
e.  We should be able to detect this by testing the WWID of each LUN 0 that=
 has no sd node.
- Case 3:  Unmapped LUNs
Get the current WWID, depending on the value (scsi_id reports 1 when I try =
this with NetApp E-Series storage) we should be able to know that the LUN w=
as unmapped.
- Case 4:  Detect LUN capacity changes
Should be easy enough to detect through sysfs, we just should have to reloa=
d the multipath device to reflect the change.

My rationale is that this should end up with multipath-tools, because it al=
ready stores information about the WWID of the LUN, and a method with which=
 to get the WWID, so we can detect that the LUN has been re-mapped/unmapped=
.  More specifically, I was wondering if anyone has strong opinions about w=
hether this should all be done in C (as to leverage a lot of the functional=
ity of multipath-tools, including the defined methods to get the WWID), or =
in a script.  Are there any concerns about including shell scripts with mul=
tipath-tools?

Comments are welcome :)

Thanks,

Sean Stewart
MTS SW
APG Linux Failover
NetApp
316.636.8032 Direct Phone
316.295.0116 Mobile Phone
Sean.Stewart@netapp.com=A0
