From: Spelic <spelic@shiftmail.org>
Subject: Thinp: how to enable discards?
Date: Fri, 15 Jun 2012 16:47:11 +0200
Message-ID: <4FDB4AEF.9090004@shiftmail.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello all
I have booted a kernel 3.4.2 and compiled latest LVM2 tools.
I have created a thin pool and a thin LV.

in dmesg it says:
[72244.278644] device-mapper: thin: Discard unsupported by data device 
(dm-1): Disabling discard passdown.

and in fact I cannot discard data on that volume. Not only the passdown 
doesn't work, but the unmapping doesn't work either.
How can I enable this?

Thank you
S.
