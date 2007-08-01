From: Phillip Susi <psusi@cfl.rr.com>
Subject: LVM on dmraid breakage
Date: Wed, 01 Aug 2007 16:19:59 -0400
Message-ID: <46B0EAEF.6090305@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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
To: device-mapper development <dm-devel@redhat.com>, "ATARAID (eg, Promise Fasttrak,  Highpoint 370) related discussions" <ataraid-list@redhat.com>
List-Id: dm-devel.ids

I am investigating a bug report involving the combination of lvm and 
dmraid, and it seems to me that the problem is that lvm is detecting the 
underlying partition on the primary disk and accessing it directly 
rather than going through the raid device made by dmraid.  I think that 
the problem is there is no facility for dmraid to "claim" the physical 
disk so that lvm does not look at it, and also to have lvm scan the raid 
device for physical volumes.

Does anyone have any thoughts on how this might be accomplished?
