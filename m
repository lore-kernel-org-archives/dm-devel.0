From: Eddie Williams <Eddie.Williams@steeleye.com>
Subject: how to flush device with no paths but no_path_retry=queue
Date: Fri, 02 Nov 2007 12:01:51 -0400
Message-ID: <1194019311.6006.23.camel@eddie-laptop.sc.steeleye.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


If you have a device configured with no_path_retry=queue but you can not
repair the connections is there any way to flush the IO's?  

I can not find a way to force the device offline so that it will
flush/fail all of the pending IO's so I can shutdown or clean up the
mess.

Is there a way?

Eddie
