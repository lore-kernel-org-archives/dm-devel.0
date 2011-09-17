From: Mikulas Patocka <mpatocka@redhat.com>
Subject: DM_BUFFER_FULL_FLAG
Date: Sat, 17 Sep 2011 13:53:33 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1109171344470.25719@hs20-bc2-1.build.redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

I did simulation of that DM_BUFFER_FULL_FLAG (I modified the kernel code 
to return this spuriously) and found out that there are no userspace 
problems with it.

The userspace code detects this flag in the function "dm_task_run", 
doubles the buffer size and jumps back to "repeat_ioctl:" label. A 
function "_do_dm_ioctl" is called from there, this function constructs 
"struct dm_ioctl *dmi" from scratch, so there is no possibility that 
returned content of the structure from the previous call leaks into the 
next call.

Do you want still to modify the kernel to accept multiple device 
designators if they refer to the same device? For handling 
DM_BUFFER_FULL_FLAG, it is not needed.

---

BTW. there is an unrelated feature of dmestup --- if you specify multiple 
device designators, it ignores the others --- for example, the command:

"dmsetup info vg1-thinp_pool -u 
LVM-L95tc8BLZ7tHTFc8uIZOdiR6usFzyHTOiAA3JkKgjH1DNw63WyzXHx9RbVftrgox -j 
254 -m 5"

actually passes only "vg1-thinp_pool" to the kernel driver, it ignores the 
uuid and major/minor numbers. Do you think it should be fixed?

Mikulas
