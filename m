From: "Bombardier, Pascal" <pascal.bombardier@sap.com>
Subject: LVM Snapshot Feature
Date: Fri, 1 Aug 2008 09:35:35 +0200
Message-ID: <4DE0C34D8B0DA64C9585DC45C36EA03BAB0788@dewdfe1g.wdf.sap.corp>
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

Hi,

In your opinion, does it make sense to be able to create non-persistent
snapshots ?
In the case of a filesystem backup, a non-persistent snapshot would be a
snapshot that we agree to lose in case of failure or reboot. If anything
happens, a server administrator would have to recreate a new snapshot
and then restart the backup.
In this case, I think metadata could be stored in memory instead of on
disk, which should improve LVM snapshot performance.

Is this theory wrong, and is this something which can be implemented
easily in the current LVM code ?

Pascal
