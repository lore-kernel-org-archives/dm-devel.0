From: Bram Gillemon <bram@x-plose.be>
Subject: lvm + dmmapper on a 2.6.32.10 kernel
Date: Thu, 13 May 2010 23:56:40 +0200
Message-ID: <A5E3A8B9-248E-4A6D-AAB9-6374E35058EF@x-plose.be>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset="us-ascii"
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,

I'm having some problems with lvm + dmmapper on my own compiled 2.6.32.10 kernel, I'm not sure if the problem is with dmmapper or with my kernel, so i hope someone can help me or point me into the right direction.

When I try to create a lvm volume i recieve the following error:

bram-PC:~# lvcreate -L 10485760k -n test5-root xendomains
  device-mapper: table ioctl failed: No such device or address
  Aborting. Failed to activate new LV to wipe the start of it.

Sometimes it works to create a lvm volume, but when i try to create a mapper on the device i recieve errors like this:

bram-PC:~# echo "0 $( blockdev --getsize /dev/xendomains/test-root ) linear /dev/xendomains/test-root 0" | dmsetup create test-root-dm
/dev/xendomains/test-root: No such file or directory
Invalid format on line 1 of table on stdin
Command failed


and dmesg tells me:

[29955.397572] device-mapper: ioctl: device doesn't appear to be in the dev hash table.
 

The reason i build my own kernel is i want to run xen 4.0, my config is available on pastebin:

http://pastebin.com/T6ntfKme


I compiled dmmapper as a module or built-in i always have these errors.

I know i don't have much info to post here cause i don't have any idea what you need to know, just ask and i'll post it :)

Can someone help me to find a solution to this problem, or help me to build a bug report (if it's a bug ;) )

Kr,
Bram
