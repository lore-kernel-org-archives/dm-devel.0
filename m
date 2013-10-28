From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] New userspace statistics patch
Date: Sun, 27 Oct 2013 20:54:16 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1310272051430.16136@file01.intranet.prod.int.rdu2.redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
Cc: dm-devel@redhat.com, lvm-devel@redhat.com
List-Id: dm-devel.ids

Hi

I announce a new version of userspace statistics patch. I put it here: 
http://people.redhat.com/~mpatocka/patches/userspace/statistics/lvstats.patch

A difference from the previous version: you can create statistics with 
arbitrary starting and ending sector. In the previous version you could 
only subdivide existing range.

Mikulas

--
lvm-devel mailing list
lvm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/lvm-devel
