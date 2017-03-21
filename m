From: Stanislas Oger <stanislas.oger@gmail.com>
Subject: Re: Kernel BUG at dm-cache-policy-mq.c
Date: Tue, 21 Mar 2017 20:46:34 +0100
Message-ID: <6c417060-e6b6-97eb-8d01-e3f9ac3dc61f@gmail.com>
References: <2f3fa6fc-b425-bfa2-b25a-776b7dbdd477@gmail.com>
	<20170321162631.GA1299@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170321162631.GA1299@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Maza Benjamin <b.maza@nectardecode.com>
List-Id: dm-devel.ids

Thank you for your reply Mike.

The fast SSD cache is 426GB large and the slow HDD storage is 3.6TB large.

Thank you for pointing out the deprecation of the mq policy, we will try 
switch to smq and see what happen.

Regards.

On 21/03/2017 17:26, Mike Snitzer wrote:
> On Tue, Mar 21 2017 at  9:02am -0400,
> Stanislas Oger <stanislas.oger@gmail.com> wrote:
>
>> Hi,
>>
>> We currently encounter a critical issue on a Proxmox cluster we
>> operate, which seems to be triggered by a bug in dm-cache ("kernel
>> BUG at drivers/md/dm-cache-policy-mq.c:1079!", see syslog below).
>>
>>
>> 1/ Context
>>
>> The Proxmox cluster uses 4.4 kernel, the VM storage is a DRBD9
>> cluster on top of lvm with SSD caching. The underlaying disks are on
>> a MegaRAID hardware RAID.
>> The problem started to occur since we installed a VM (a mail server)
>> that performs many disk reads on many small files (~ 1 million),
>> with read lock using flock at each read. With the VM fully running,
>> the IO wait of the system is less than 1%.
>>
>>
>> 2/ The problem
>>
>> Randomly, without pre-fail signs, syslog reports a bug in
>> dm-cache-policy-mq.c (see below). A few minutes later all write
>> operations infinitely block. A few minutes after the node stopped to
>> perform write operations, the other DRBD9 nodes stop writing too. At
>> this point all the cluster is down. Reads can be done as usual, but
>> write operations are inifitinely blocking.
>>
>> The only way we figured out to overcome this situation is to perform
>> a hard reboot of the failing node. As soon as the failing node is
>> down, the other nodes resume to a normal activity. When the failing
>> node is up again, DRBD9 performs disk resynchronization and the
>> cluster resume normal activity, as if nothing happened.
>>
>> The bug occurred with both 4.4.35 and 4.4.40 kernels, with a
>> frequency of about once every 10 days.
> How large is your cache? (size of slow and fast device?)
>
> Have you tried the smq policy?  mq is no longer maintained (has been
> removed and made an alias of smq, see commit 9ed84698fdda ("dm cache:
> make the 'mq' policy an alias for 'smq'")).
>
> It should be noted that dm-cache is changing significantly in 4.12
> (already staged in linux-next), see:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-4.12
>
> The new smq code doesn't have the BUG_ON() in question.
