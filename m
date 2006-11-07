From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [dm-devel] [PATCH 2.6.19 5/5] fs: freeze_bdev with semaphore
 not mutex
Date: Tue, 07 Nov 2006 14:22:58 -0600
Message-ID: <4550EB22.9060805@redhat.com>
References: <20061107183459.GG6993@agk.surrey.redhat.com> <170fa0d20611071218t3c145ef9i5413e432597d78a5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753084AbWKGUXT@vger.kernel.org>
In-Reply-To: <170fa0d20611071218t3c145ef9i5413e432597d78a5@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, Srinivasa DS <srinivasa@in.ibm.com>
List-Id: dm-devel.ids

Mike Snitzer wrote:
> On 11/7/06, Alasdair G Kergon <agk@redhat.com> wrote:
>> From: Srinivasa Ds <srinivasa@in.ibm.com>
>>
>> On debugging I found out that,"dmsetup suspend <device name>" calls
>> "freeze_bdev()",which locks "bd_mount_mutex" to make sure that no new mounts
>> happen on bdev until thaw_bdev() is called.  This "thaw_bdev()" is getting
>> called when we resume the device through "dmsetup resume <device-name>".
>> Hence we have 2 processes,one of which locks "bd_mount_mutex"(dmsetup
>> suspend) and another(dmsetup resume) unlocks it.
> 
> Srinivasa's description of the patch just speaks to how freeze_bdev
> and thaw_bdev are used by DM but completely skips justification for
> switching from mutex to semaphore.  Why is it beneficial and/or
> necessary to use a semaphore instead of a mutex here?

Because mutexes are not supposed to be released by anything other than
the thread that took them, as enforced by the various checking code and
noted in the docs...

"The stricter mutex API means you cannot use mutexes the same way you
can use semaphores: e.g. they cannot be used from an interrupt context,
nor can they be unlocked from a different context that which acquired
it."

this particular resource can sometimes be locked & unlocked from 2
different userspace threads.

-Eric
