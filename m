From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: [RFC] HP storageworks-like hwhandler
Date: Fri, 3 Jun 2005 20:29:06 +0200
Message-ID: <20050603182906.GB10178@averon.dyndns.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Hello,

I repackaged Dave Olien's scsi-start hwhandler to try to give it a wider audience.
It now compiles out-of-tree, and builds fine on RHEL4U1 kernel.

This hwhandler is targeted at a family of assymmetric arrays like HP StorageWorks and FSC FibreCat that take a START_STOP SCSI cmd as a sign of the host willing to initiate a LUN failover.

It would be good to have this code undusted and endorsed by HP ... before RHEL4U2 freezes.
Seems a good topic for the next conf call :/

You can find the tarball there :
http://christophe.varoqui.free.fr/multipath-tools/dm-scsi-start.tar.gz

Regards,
cvaroqui
