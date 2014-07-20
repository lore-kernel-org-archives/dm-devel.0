From: Spelic <spelic@shiftmail.org>
Subject: Does multipath require disabled write cache?
Date: Sun, 20 Jul 2014 23:20:07 +0200
Message-ID: <53CC3287.3010708@shiftmail.org>
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

Hello all,
I am wondering if multipath requires a disabled write cache at the 
remote disks.
We have some external SAS disks, for which the connection is flaky and 
sometimes is lost and then they are detected again. Multipath seems 
perfect for this situation.
However, when the disks are lost, I suppose resets are issued, which 
might clear the write cache so that data located there might not be 
committed (true? well at least on power loss this is true).
It would be great if multipath would issue a flush every N  writes, and 
then remember the last N  writes and resubmit them when the path is 
reestablished, so that there is again chance to flush them to stable 
storage. (similar to DRBD epochs) However I don't know if this smart 
mechanism is implemented.

Thanks for info
S.
