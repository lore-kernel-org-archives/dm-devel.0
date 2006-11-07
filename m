From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: [PATCH 2.6.19 5/5] fs: freeze_bdev with semaphore not
	mutex
Date: Tue, 7 Nov 2006 15:18:08 -0500
Message-ID: <170fa0d20611071218t3c145ef9i5413e432597d78a5@mail.gmail.com>
References: <20061107183459.GG6993@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20061107183459.GG6993@agk.surrey.redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, Eric Sandeen <sandeen@sandeen.net>, Srinivasa DS <srinivasa@in.ibm.com>
List-Id: dm-devel.ids

On 11/7/06, Alasdair G Kergon <agk@redhat.com> wrote:
> From: Srinivasa Ds <srinivasa@in.ibm.com>
>
> On debugging I found out that,"dmsetup suspend <device name>" calls
> "freeze_bdev()",which locks "bd_mount_mutex" to make sure that no new mounts
> happen on bdev until thaw_bdev() is called.  This "thaw_bdev()" is getting
> called when we resume the device through "dmsetup resume <device-name>".
> Hence we have 2 processes,one of which locks "bd_mount_mutex"(dmsetup
> suspend) and another(dmsetup resume) unlocks it.

Srinivasa's description of the patch just speaks to how freeze_bdev
and thaw_bdev are used by DM but completely skips justification for
switching from mutex to semaphore.  Why is it beneficial and/or
necessary to use a semaphore instead of a mutex here?

Mike
