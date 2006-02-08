From: Shahsandeep Bhavana <sbhavana@cs.ubc.ca>
Subject: Device Probing at boot time
Date: Tue, 7 Feb 2006 22:03:45 -0800 (PST)
Message-ID: <Pine.LNX.4.60.0602072156140.10940@okanagan.cs.ubc.ca>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids


Hi,

  I want know how the device mapper knows about the various logical volume 
devices and their mapping tables at boot time.

Actually, I have implemented a new disk-allocation policy in LVM2 called 
snap-aware. Now, whenever I create a logical volume  using this allocation 
policy, it is visible and available for use until I reboot the machine. On 
reboot, LVM is able to read information about this logical volume from the 
metadata , but the device mapper loses all information about it including 
the path entries in /dev.

However, when I keep the allocation algorithm same and only change the 
name of the allocation policy to Contiguous, everything works fine.

So, I am wondering how can the name of an allocation policy effect the 
device mapper on reboot.

Bhavana
