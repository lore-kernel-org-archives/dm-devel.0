From: Phillip Susi <psusi@cfl.rr.com>
Subject: dm targets with spaces in the name
Date: Wed, 3 Dec 2008 12:03:02 -0500
Message-ID: <4936BBC6.7000800@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
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

Is this allowed?  It looks like you can create a target with a space in 
the name, but then you can not refer to it in a rule of another target. 
  Specifically I am seeing a user with a dmraid setup with raid volumes 
using spaces in the name, and dmraid manages to create the stripe target 
( /dev/mapper/foo bar ), but then can not create the linear mapping on 
top of it for the partition, because the table looks like it has too 
many arguments due to the space.

So should you just avoid doing this, or should the kernel be fixed to 
understand quotes or backslash escapes or something to allow spaces in 
the target device file name?
