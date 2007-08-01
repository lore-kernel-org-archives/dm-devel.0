From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: encrypted filesystem not encrypted?
Date: Wed, 1 Aug 2007 09:42:38 -0500
Message-ID: <D81D2AFC-1275-4AC7-911A-CB73D314170A@redhat.com>
References: <46AFDD28.40203@parallelsw.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <46AFDD28.40203@parallelsw.com>
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

I'm guessing that you are bypassing your crypt device.  Depends on  
what your arguments are to the LVM commands.

cryptsetup will create a new device that sits on top of sda3 - you  
should use that one.  Do not use sda3 directly.

  brassow

On Jul 31, 2007, at 8:08 PM, chris wrote:

> Hi all,
>
> I was not sure which list to send this to, so I choose a couple  
> that looked like decent fits, please advise if there is one more  
> specific to the encryption.
>
> I am currently working on a project where we are converting some of  
> our filesystems to an encrypted fs using LVM2.  We are running  
> RHEL:  "2.6.9-55.0.2.ELsmp #1 SMP Tue Jun 12 17:59:08 EDT 2007 i686  
> i686 i386 GNU/Linux"
>
> We setup an encrypted filesystem using one of the open partitions  
> on the physical hard drive using "cryptsetup create /dev/sda3"  We  
> have verified this using the cryptsetup status, This shows the  
> filesystem as being encrypted as aes_plain 256 bit key.  We then  
> created an LVM and mounted the filesystem using the LVM.
>
> All seems to be well, except when our testers ran the following  
> command:
> head -c 5000 /dev/sda3
>
> They got some output that includes clear text and obviously not  
> encrypted data (along with encrypted data).  Some things are date  
> formatted strings like 20050912 which appears quite a few times in  
> the mounted filesystem, and in the raw device (/dev/sda3).
>
> I can post the exact commands that were used to create the  
> filesystem, but they are basically
> create partition ...sda3
> cryptsetup create /dev/sda3 (prompts for passphrase)
> pvcreate
> vgcreate
> lvcreate
> mount
>
> (TIA) any help (or light shed on this) is greatly appreciated!
>
> -chris
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
