From: Shiva <shivaramakrishnan740@gmail.com>
Subject: dm-verity usage understanding
Date: Fri, 4 Apr 2014 19:00:32 +0000 (UTC)
Message-ID: <loom.20140404T205439-317@post.gmane.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
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

Hello ,
I am new to dm-verity and I am finding it hard to use it.

This is my setup.

On one VM running Ubuntu-12.04,I have a nfs-share partition.
I have virtual disk image files of other vm's in this share.
I want to perform the integrity 
check on these files/nfs-share at block level.
My nfs-share partition size is 10GB.

From the documentation,I see the numbers. 

4096,4096,52224,1,root_hash and salt.

I know the doc says

4096 = datablock

4096 = hashblock

52224 = number of blocks

1 = hash offset

SIZE=$(blockdev --getsz /dev/sdb)

dmsetup create name -r --table "0 $SIZE verity 1 

/dev/sdb /dev/sdc 4096 


4096 52224 1 sha256 <root_hash> <salt>"

But my question how do I get these values for my setup? How do I know 

the size

 of data block /hashblock in my case?How I calculate the number of

 blocks and 

root hash and salt to feed into the command.

Can you please let me

 know the 

process to get these values?       

Also it mentions to use verity setup command for this purpose.

Can you let me k

now the arguments or an example here?
