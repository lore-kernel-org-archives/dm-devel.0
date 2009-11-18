From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 0/7] patches: fix dm-raid1 race, bug 502927
Date: Wed, 18 Nov 2009 07:09:50 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0911180703410.21358@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

Here is the serie of 7 patches to hold write bios on dm-raid1 until 
dmeventd does its job. It fixes bug 
https://bugzilla.redhat.com/show_bug.cgi?id=502927 . The first 6 patches 
are preparatory, they just move the code around, the last patch does the 
fix.

I tested the thing, I managed to reproduce the bug (by manually stopping 
dmeventd with STOP signal, failing primary mirror leg and writing to the 
device) and I also verified that the patches fix the bug.

For non-dmeventd operation, the current behavior is wrong and I just keep 
it as wrong as it was. There is no easy fix. It is just assume that if the 
user doesn't use dmeventd, he can't activate failed disks again.

Mikulas
