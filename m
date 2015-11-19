From: Shehbaz Jaffer <shehbazjaffer007@gmail.com>
Subject: Adding new resiliency type to LVM
Date: Thu, 19 Nov 2015 16:25:44 -0500
Message-ID: <CAPLK-i8-Agg+LOjw5w5G9epu1yGyUaGeY1Jv1rGV9Zp3rpXjDw@mail.gmail.com>
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

Hi,

I am trying to add a new resiliency type to LVM, which I call dyre -
dynamic reliability. As a first step, I plan to create a simple
striped volume, similar to what we can get using the below command:

lvcreate -i 2 -I 8 -L 30M -n root vol_vg

this will create a volume "root' in volume group "vol_vg" of size 30MB
with 2 stripes and stripesize of 8KB.

I have added relevant code in lvm so that the command gives the same
results as above:

lvcreate --type dyre --stripes  --stripesize 8 -L 30M -n root vol_vg

However, I notice that in first case, when lvm creates the volume
named root, it creates a soft link to /dev/dm-0 :

$ ls -alrt /dev/vol_vg/root
lrwxrwxrwx 1 root root 23 Nov 19 15:35 /dev/vol_vg/root ->
/dev/mapper/vol_vg-root
$ ls -alrt /dev/mapper/vol_vg-root
lrwxrwxrwx 1 root root 9 Nov 19 15:36 /dev/mapper/vol_vg-root -> /dev/dm-0

If I run my command (the second command with my new defined resiliency
type) using gdb, place a breakpoint before the function -
dev_cache_get() and in a new terminal check for file /dev/vol_vg/root
file, it exists but only as an archive file (i.e., there is no link
between /dev/mapper/vol_vg-root and /dev/dm-0).
Since there is no actual device linked to the file, functions like
stat() that are used in dev_cache_get() code return error - no such
file or directory which results in unsuccessful volume creation. I
also noticed that the temporary file is deleted by lvm.

I think the part of code that does this linking is in device mapper
code, but I am not sure where this is being done.

Furthermore, when I create a link artifically by using the command

ln -s /dev/dm-0 /dev/mapper/vol_vg-root

and resume from breakpoint, my volume gets created.

I need some help regarding which code in lvm does this linking of
archive (temporary?) file to /dev/dm-0.

Thanks,

-- 
Shehbaz Jaffer
First Year Graduate Student
Sir Edward S Rogers Sr Department of Electrical and Computer Engineering
University of Toronto
