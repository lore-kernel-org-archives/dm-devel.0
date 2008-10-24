From: Kit Westneat <kwestneat@datadirectnet.com>
Subject: Buffer I/O error
Date: Fri, 24 Oct 2008 15:22:32 -0400
Message-ID: <49022078.6010700@datadirectnet.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi dm-devel,

I'm running into an issue with dm-multipath 
(device-mapper-multipath-0.4.5-27.el4_6.3) that has me confused and I 
was hoping I could get some guidance.

Here are the relevant dmesg messages:
device-mapper: dm-multipath: Failing path 8:48.
device-mapper: dm-multipath: Failing path 8:48.
device-mapper: dm-multipath: Failing path 8:48.
device-mapper: dm-multipath: Failing path 65:80.
printk: 1004 messages suppressed.
Buffer I/O error on device dm-13, logical block 1192525829
lost page write due to I/O error on dm-13

Normally when I have seen Buffer I/O errors in the past, they have been 
accompanied by SCSI errors as well, but in this case I am not getting 
anything. One odd thing is that the filesystem reported extremely slow 
writes before the buffer I/O errors occurred. I have checked and 
double-checked the storage array and everything seems fine. I am using 
directio as my path checker if that makes a difference.

I have been able to reproduce the problem consistently by attempting an 
fsck on dm-13. However, I am now doing an fsck on the underlying sd 
device and it hasn't bombed out yet with the buffer I/O errors.

Has anyone encountered these seemingly inexplicable buffer I/O errors 
before? Any advice on how to debug it?

Thanks,
Kit Westneat
