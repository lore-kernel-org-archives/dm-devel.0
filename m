From: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Subject: locking optimization
Date: Thu, 06 Jun 2013 17:20:07 +0200
Message-ID: <1370532007.4392.19.camel@br9vgx5g.de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

A few month ago a lock-to-RCU conversion patch was posted:

http://www.spinics.net/lists/dm-devel/msg19111.html

Any chances that it will make it into mainline?

We did some measurements and love it :-)

Without that optimization dm_get_live_table() stands out as the most
expensive dm-mod function. With that optimization the CPU cycles
consumed by dm_get_live_table() are reduced dramatically.

Cheers,
Martin
