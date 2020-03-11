From: maiski@maiski.net
Subject: probable lvm thin_pool exhaustion
Date: Wed, 11 Mar 2020 18:24:33 +0100
Message-ID: <20200311182433.Horde.h5NgeQO8h7MdvZTOX37pPw2@webmail.df.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="Yes"
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
Content-Disposition: inline
To: dm-devel@redhat.com
List-Id: dm-devel.ids


Hello all,

i am a total newbie besides the general knowledge of lvm.
With this disclaimer written I have the following problem,
which may def need some expert knowledge of lvm, because i couldn't
find solutions online for now :/

I am booting my system (in my case is Qubes, but I suppose that does  
not matter at this point)
and after entering my luks password get to the dracut emergency shell.
"Check for pool qubes-dom/pool00 failed (status:1). Manual repair required!"
The only aclive lv is qubes_dom0/swap.
All the others are inactive.

step 1:
lvm vgscan vgchange -ay
lvm lvconvert --repair qubes_dom0/pool00
Result:
using default stripesize 64.00 KiB.
Terminate called after throwing an instance of 'std::runtime_error'
what(): transaction_manager::new_block() couldn't allocate new block
Child 7212 exited abnormally
Repair of thin metadata volume of thin pool qubes_dom0/pool00 failed  
(status:1). Manual repair required!

step 2:
since i suspect that my lvm is full (though it does mark 15 g as free)
i tried the following changes in the /etc/lvm/lvm.conf
thin_pool_autoextend_threshold = 80
thin_pool_autoextend_percent = 2 (Since my the pvs output gives PSize:  
465.56g Pfree 15.78g, I set this to 2% to be overly cautious not to  
extend beyond the 15 G marked as free, since idk)
auto_activation_volume_list = to hold the group, root, pool00, swap  
and a vm that would like to delete to free some space
volume_list = the same as auto_activation_volume_list

and tried step 1 again, did not work, got the same result as above  
with qubes_swap as active only

step 3 tried
lvextend -L+1G qubes_dom0/pool00_tmeta
Result:
metadata reference count differ for block xxxxxx, expected 0, but got 1 ...
Check for pool qubes-dom/pool00 failed (status:1). Manual repair required!


Since I do not know my way around lvm, what do you think, would be the  
best way out of this?
Adding another external PV? migrating to a bigger PV?
I did not play with backup or achive out of fear to loose any  
unbackuped data which happens to be a bit :|
Any help will be highly appreciated!

Thanks in advance,
m
