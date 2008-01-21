From: Stephen Mike <mike_stephen_jr@yahoo.com>
Subject: restart multipathd automatically
Date: Mon, 21 Jan 2008 15:54:02 +0100
Message-ID: <200801211454.m0LEs2p15801@tug.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
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

To restart multipathd automatically after it dies, is it ok to put, in
/etc/inittab, a line like this? 

# run multipathd at level 4 (restart)
mphd:4:respawn:/etc/rc.d/init.d/multipathd start

I am not sure whether the daemon has any dependencies to make it not OK
to start/restart this way.

Thanks
Mike
