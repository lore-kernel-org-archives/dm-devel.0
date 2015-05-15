From: Atom2 <ariel.atom2@web2web.at>
Subject: Re: snapshot-origin freezes system - what am I doing
	wrong?
Date: Fri, 15 May 2015 21:23:52 +0200
Message-ID: <555647C8.5030708@web2web.at>
References: <5555CE5D.3030404@web2web.at>	<5555E25A.2040106@redhat.com>	<55562315.4060707@web2web.at>	<555633DE.9060002@redhat.com>	<55563F98.3070809@web2web.at>
	<5556414F.5030102@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5556414F.5030102@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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


Am 15.05.15 um 20:56 schrieb Zdenek Kabelac:
> Dne 15.5.2015 v 20:48 Atom2 napsal(a):
>> Am 15.05.15 um 19:58 schrieb Zdenek Kabelac:
>>> Dne 15.5.2015 v 18:47 Atom2 napsal(a):
>>>> Am 15.05.15 um 14:11 schrieb Zdenek Kabelac:
>>>>> Dne 15.5.2015 v 12:45 Atom2 napsal(a):
[snip]
> I'm not saying  lvm2 solves your original problem - which I still 
> don't seem to understand -  I'm just saying you need to look at how 
> lvm2 is ordering ioctls with loads & resumes of targets when making 
> snapshot.
Thanks for bearing with me - and appologies that I have not been able to 
phrase my problem so that it was easy to understand. I'll try again in 
the hope that I am clearer this time:

Consider that I do have a vm-host which hosts a number of virtual 
machines (VMs). Many of those VMs are similar and thus share a common 
template root-file system based on ext4 (let's call that master.ROOT). 
master.ROOT is an LVM2 logical volume sized at 8GB. There's only one VM 
that (from time to time) has r/w access to that LV and this VM is 
responsible for doing updates to the template (i.e. its then r/w root 
file system).

master.ROOT is mounted r/o in all other VMs. Probably not relevant here, 
but those other VMs have a presistent r/w layer on top of master.ROOT (a 
dedicated overlayfs for each and every VM) to allow r/w access to their 
root file-system. All that is working already with no hicups.

Now consider that I need to update master.ROOT. Currently that would 
require stopping all VMs using that template, then start the template 
VM, make the required changes, stop the template VM and then restart 
every VM based on the updated master.ROOT image.

This is where my idea comes in: What if every VM didn't use master.ROOT 
directly but rather used a snapshot of the master.ROOT image that keeps 
consistent even when the underlying master.ROOT is changed. This, 
according to my understanding, could be solved by the snapshot-origin 
target combined with a snapshot: From the documentation that you linked 
to (and that I based my idea upon):

*) snapshot-origin <origin>

which will normally have one or more snapshots based on it.
Reads will be mapped directly to the backing device. For each write, the
original data will be saved in the <COW device> of each snapshot to keep
its visible content unchanged, at least until the <COW device> fills up.

This approach would ensure that the snapshot that every VM sees stays 
the same and restarts of the VM could be done at any point in time. The 
master.ROOT image could also be updated at any point in time. Running 
VMs would clearly still be based on the old version of master.ROOT until 
such time they are restarted: When a VM is restarted, it would simply be 
connected to the latest version of the snapshot. Old version of 
snapshots - provided they are no longer in use by any VM - could be 
cleaned up/purged when a VM is stopped.

I hope that clarifies my approach.
>
> IMHO old snapshot is quite complicated and maybe you should take a 
> look at this provisioning support - especially if you think in terms 
> of having lots of snapshot of single master volume - usage of 
> old-snapshot target is pretty much dead road....
>
What the heck is an old-snapshot target?

Thansk again, Atom2

P.S. I am available in IRC (freenode) atm if you want to join to 
exchange some ideas.
