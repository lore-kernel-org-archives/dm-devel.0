From: Ross Anderson <rosander@dsotm.net>
Subject: kpartx fails 4k block partition
Date: Wed, 12 Mar 2014 17:20:17 -0500
Message-ID: <5320DDA1.3060309@dsotm.net>
References: <531F3AFE.4070008@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <531F3AFE.4070008@gmail.com>
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

Greetings,


Under 0.50 multipath tools release, partitions are not being created for 
devices that are 4k Native.  This is under kernel 3.13.6, udev-208.

We've seen this behavior before.

kpartx errors with very little helpful code.

pastebin attached.

Thanks for your assistance.


http://pastebin.com/Nnd4Ym4W
