From: "goggin, edward" <egoggin@emc.com>
Subject: Proposed change to scsi_id parameter string in
	libmultipath/hwtab le.c for EMC Symmetrix
Date: Wed, 14 Sep 2005 21:36:43 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321AC9E@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
Cc: "'patman@aracnet.com'" <patman@aracnet.com>, christophe.varoqui@free.fr
List-Id: dm-devel.ids

Patrick Mansfield reminded me that if the libmultipath/hwtable.c
patch I submitted earlier is accepted, then multipath will have
a dependency (for EMC Symmetrix support only) on a version of
scsi_id which supports the "-ppre-spc3-83" scsi_id option.

This shouldn't be a problem for either Red Hat or SuSE
distributions going forward from now since scsi_id for
Red Hat 4 Update 2 already has the "-ppre-spc3-83" page
code support and SuSE SLES 9 SP 3 will when it is released.

This could be an issue for other distros though or if someone
attempts to run this patched version of multipath on an older
Red Hat 4 (Update 1) or SuSE SLES 9 (SP 2) version.
