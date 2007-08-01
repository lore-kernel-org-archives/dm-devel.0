From: chris <chris@parallelsw.com>
Subject: encrypted filesystem not encrypted?
Date: Tue, 31 Jul 2007 19:08:56 -0600
Message-ID: <46AFDD28.40203@parallelsw.com>
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
To: dm-devel@redhat.com, redhat-list@redhat.com
List-Id: dm-devel.ids

Hi all,

I was not sure which list to send this to, so I choose a couple that 
looked like decent fits, please advise if there is one more specific to 
the encryption.

I am currently working on a project where we are converting some of our 
filesystems to an encrypted fs using LVM2.  We are running RHEL:  
"2.6.9-55.0.2.ELsmp #1 SMP Tue Jun 12 17:59:08 EDT 2007 i686 i686 i386 
GNU/Linux"

We setup an encrypted filesystem using one of the open partitions on the 
physical hard drive using "cryptsetup create /dev/sda3"  We have 
verified this using the cryptsetup status, This shows the filesystem as 
being encrypted as aes_plain 256 bit key.  We then created an LVM and 
mounted the filesystem using the LVM.

All seems to be well, except when our testers ran the following command:
head -c 5000 /dev/sda3

They got some output that includes clear text and obviously not 
encrypted data (along with encrypted data).  Some things are date 
formatted strings like 20050912 which appears quite a few times in the 
mounted filesystem, and in the raw device (/dev/sda3).

I can post the exact commands that were used to create the filesystem, 
but they are basically
create partition ...sda3
cryptsetup create /dev/sda3 (prompts for passphrase)
pvcreate
vgcreate
lvcreate
mount

(TIA) any help (or light shed on this) is greatly appreciated!

-chris
