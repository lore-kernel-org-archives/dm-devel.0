From: Piet Delaney <piet@bluelane.com>
Subject: object oriented programming vs debug oriented programing
	(Ex: debugging dm code with kgdb)
Date: Mon, 09 Oct 2006 17:25:09 -0700
Message-ID: <egep96$u07$1@sea.gmane.org>
Reply-To: piet@bluelane.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
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

Are the devlopers of the device mapping code awair
of how difficult they are making debugging of the
code with kgdb?

Doing object programing like style programming in
C has a major downside. Code that manages the
struct dm_table is in dm_table.c and thus code
in dm_ioctl.c can mess with the structure. 

Unfortunately when useing kgdb on the code you
can see the struct dm_table stuff via pointers
becasue struct dm_table has been declared as
an empty structure.

It would be very helpfull for kgdb users if the
declaration of dm_table was made in dm.h, at least
for KGDB kernels, just to make the code easier to
follow with kgdb.

-piet
