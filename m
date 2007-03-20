From: Olaf Kirch <olaf.kirch@oracle.com>
Subject: [PATCH 0/3] Fix SMP races in dm-crypt
Date: Tue, 20 Mar 2007 20:54:48 +0100
Message-ID: <200703202054.49507.olaf.kirch@oracle.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
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

I investigated kernel Bug 5948 (Oops when accessing SATA with device mapper on
AMD 64 X2) to help cut down on the number of open bugs.

The problem reported in that bug seems to be caused by memory pressure
when writing - crypt_alloc_buffer can return less than the full number of
pages required. In that case, the bio is split, but we're keeping a pointer
to the first chunk of the request around in first_clone, and copy it. If the
first clone completes I/O while we're cloning it, we oops on garbage in
the bvec.

I was able to reproduce this on 2.6.20 - and the following patches
seem to fix it for me.

dm-crypt-clone_init-early
	We need to call clone_init early on, before we can conceivably
	ever call bio_put on the clone

dm-crypt-clone-race
	Do no access bios after generic_make_request

dm-crypt-drop-first_clone
	Drop the first_clone business, and always allocate a fresh bio.

Olaf
-- 
Olaf Kirch  |  --- o --- Nous sommes du soleil we love when we play
okir@lst.de |    / | \   sol.dhoop.naytheet.ah kin.ir.samse.qurax
