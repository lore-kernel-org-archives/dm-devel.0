From: "Stepan, Troy" <troy.stepan@unisys.com>
Subject: iostate and dm-multipath devices
Date: Fri, 18 Aug 2006 11:28:41 -0400
Message-ID: <94C8C9E8B25F564F95185BDA64AB05F6040C971C@USTR-EXCH5.na.uis.unisys.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
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

Hi.

How does the kernel collect I/O statistics for dm-multipath devices?  I
would expect it to sum up the stats from the underlying SCSI targets.
However, when using iostat, some values (like tps) don't compute.  Any
thoughts on this one?
