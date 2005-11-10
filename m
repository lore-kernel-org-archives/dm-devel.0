From: Alasdair G Kergon <agk@redhat.com>
Subject: New LVM2/device-mapper development tarballs
Date: Thu, 10 Nov 2005 15:52:47 +0000
Message-ID: <20051110155247.GH26394@agk.surrey.redhat.com>
Reply-To: LVM general discussion and development <linux-lvm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-lvm-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-lvm>
List-Post: <mailto:linux-lvm@redhat.com>
List-Help: <mailto:linux-lvm-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=subscribe>
Sender: linux-lvm-bounces@redhat.com
Errors-To: linux-lvm-bounces@redhat.com
To: dm-devel@redhat.com, linux-lvm@redhat.com
List-Id: dm-devel.ids

I have just created new tarballs from CVS for testing
purposes:

  ftp://sources.redhat.com/pub/dm/device-mapper.1.02.00.tgz
  ftp://sources.redhat.com/pub/lvm2/LVM2.2.02.00.tgz

There are some significant extensions to libdevmapper and 
the code that activates logical volumes has been rewritten
to prepare for kernel patches to fix snapshot activation.
The new code will also make it possible to support more
complex device hierarchies in the future, such as snapshots 
of mirrors.

So far I've done some basic testing, but I expect there
are still plenty more bugs to be found: If you find any,
please report them to one of these lists!

(Note that you'll need to install the new device-mapper package
before the new LVM2 one.)

Alasdair
-- 
agk@redhat.com

_______________________________________________
linux-lvm mailing list
linux-lvm@redhat.com
https://www.redhat.com/mailman/listinfo/linux-lvm
read the LVM HOW-TO at http://tldp.org/HOWTO/LVM-HOWTO/
