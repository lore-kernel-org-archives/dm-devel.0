From: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Subject: Re: [PATCH 1/2] md/raid0: Introduce new array state
 'broken' for raid0
Date: Tue, 30 Jul 2019 09:18:54 -0300
Message-ID: <000c20fe-3bcd-2dff-a5ab-9a294bdc7746@canonical.com>
References: <20190729203135.12934-1-gpiccoli@canonical.com>
	<20190729203135.12934-2-gpiccoli@canonical.com>
	<d730c417-a328-3df3-1e31-32b6df48b6ad@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <d730c417-a328-3df3-1e31-32b6df48b6ad@oracle.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bob Liu <bob.liu@oracle.com>, linux-raid@vger.kernel.org
Cc: linux-block@vger.kernel.org, jay.vosburgh@canonical.com, dm-devel@redhat.com, songliubraving@fb.com, neilb@suse.com
List-Id: dm-devel.ids

On 30/07/2019 03:20, Bob Liu wrote:
> [...]
>> + * broken
>> + *     RAID0-only: same as clean, but array is missing a member.
>> + *     It's useful because RAID0 mounted-arrays aren't stopped
>> + *     when a member is gone, so this state will at least alert
>> + *     the user that something is wrong.
> 
> 
> Curious why only raid0 has this issue? 
> 
> Thanks, -Bob

Hi Bob, I understand that all other levels have fault-tolerance logic,
while raid0 is just a "bypass" driver that selects the correct
underlying device to send the BIO and blindly sends it. It's known to be
a performance-only /lightweight solution whereas the other levels aim to
be reliable.

I've quickly tested raid5 and rai10, and see messages like this on
kernel log when removing a device (in raid5):

[35.764975] md/raid:md0: Disk failure on nvme1n1, disabling device.
md/raid:md0: Operation continuing on 1 devices.

The message seen in raid10 is basically the same. As a (cheap)
comparison of the complexity among levels, look that:

<...>/linux-mainline/drivers/md# cat raid5* | wc -l
14191

<...>/linux-mainline/drivers/md# cat raid10* | wc -l
5135

<...>/linux-mainline/drivers/md# cat raid0* | wc -l
820

Cheers,


Guilherme
