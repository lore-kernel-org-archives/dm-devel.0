From: Phillip Susi <psusi@cfl.rr.com>
Subject: Snapshots
Date: Tue, 18 Dec 2007 14:57:36 -0500
Message-ID: <47682630.5060803@cfl.rr.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

I have been playing around with the snapshot target with dmsetup, and I 
can set up a snapshot that diverts writes to a backing file, so that 
modifications to the snapshot device are discarded when I remove the 
snapshot device and go back to using the origin device.  What I can't 
figure out is how to keep the origin device mounted and have the 
snapshot device appear to contain the origin's data at the time it was 
created, even though the origin continues to be modified.

I thought one of the main ideas of the snapshot was to be able to backup 
a consistent filesystem image even though the filesystem continues to be 
written to, but it seems that having the origin device mounted gets an 
exclusive lock on it so that the snapshot device can not be targeted at 
it, so how do you do this?
