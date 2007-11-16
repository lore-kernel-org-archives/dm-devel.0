From: "Domenico Viggiani" <dviggiani@tiscali.it>
Subject: RE: LVM2, Multipath & iSCSI Volumes
Date: Fri, 16 Nov 2007 14:23:00 +0100
Message-ID: <000201c82853$cf63cd00$cf42e3c1@pitagora.it>
References: <loom.20071116T082815-74@post.gmane.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <loom.20071116T082815-74@post.gmane.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: 'device-mapper development' <dm-devel@redhat.com>
List-Id: dm-devel.ids

> -----Original Message-----
> From: dm-devel-bounces@redhat.com 
> [mailto:dm-devel-bounces@redhat.com] On Behalf Of Dushyanth
> Sent: Friday, November 16, 2007 9:41 AM
> ...
> There are three LUNs exposed via both ports and I can see 
> disks from sdb to sdg.
> After start iscsi initiator i created a primary partition 
> (type set to LVM) using parted on sdb, sdc and sde.
> ...
I strongly suggest to avoid partitioning and using directly LVM2 on top of
whole disk.
This even if you could use 'kpartx' to syncronize partitions with multipath.

--
DV
