From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: fedora/rh: is hp_tur checker still needed?
Date: Wed, 17 Aug 2016 15:12:21 +0200
Message-ID: <859fb60d-10ee-00e8-b4d9-53ff237c2336@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Benjamin,

Doc says:
On some storage devices, if a LUN is deleted from an existing multipathd
device, and a new LUN is presented to the host, it may end up with the
same LUN ID and name as the old LUN. In this case, multipath will assume
that this is the old LUN and belongs to the existing multipath device.
This cause cause corruption. A new path checker "hp_tur" has been added
that verifies the WWID of the LUN when it checks the path, to avoid this
problem.
Code: http://pkgs.fedoraproject.org/cgit/rpms/device-mapper-multipath.git/plain/0007-RH-add-hp_tur-checker.patch
