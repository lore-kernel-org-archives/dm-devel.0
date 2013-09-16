From: Mikulas Patocka <mpatocka@redhat.com>
Subject: ANNOUNCE: remove device on close
Date: Mon, 16 Sep 2013 15:41:55 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1309161535340.9077@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: LVM2 development <lvm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <lvm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/lvm-devel>
List-Post: <mailto:lvm-devel@redhat.com>
List-Help: <mailto:lvm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=subscribe>
Sender: lvm-devel-bounces@redhat.com
Errors-To: lvm-devel-bounces@redhat.com
To: "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com, lvm-devel@redhat.com
List-Id: dm-devel.ids

Hi

I placed the patches for deferred removal at 
http://people.redhat.com/mpatocka/patches/kernel/deferred-remove/

Use the command:
dmsetup remove --deferred <device_name>

If the device is closed, it is deleted as usual. If the device is open, it 
is flagged to be deleted on close. When the last process that keeps the 
device open closes it, the device is deleted.

The state of deferred-remove flag can be queried with dmstup info - there 
is "(DEFERRED REMOVE)" if the device is flagged to be deleted.

The request to delete a device can be cancelled with message:
dmsetup message <device_name> 0 @cancel_deferred_remove

Mikulas

--
lvm-devel mailing list
lvm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/lvm-devel
