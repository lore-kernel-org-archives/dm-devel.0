From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: dm: expose dm_copy_name_and_uuid()
Date: Fri, 7 Feb 2020 01:24:33 +0000
Message-ID: <20200207012432.GA23327@agk-dp.fab.redhat.com>
References: <20200201005524.23405-1-jdorminy@redhat.com>
	<20200203165402.GA11874@redhat.com>
	<CAMeeMh82tS6TZCLzMwW7Kk+wdnMFW8WXrbe6-vLxaAvBzU1gBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAMeeMh82tS6TZCLzMwW7Kk+wdnMFW8WXrbe6-vLxaAvBzU1gBw@mail.gmail.com>
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
To: John Dorminy <jdorminy@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Thu, Feb 06, 2020 at 07:28:04PM -0500, John Dorminy wrote:
> To be clear, I care more about getting the name in kernelspace than
> about getting the UUID in kernelspace. (253:0) is a unique name for

From the kernel's point of view, it is THE unique and definitive name
for the lifetime of the device.  It's the one thing userspace can rely
upon (without assuming additional 'good' userspace behaviour) to tie
together messages relating to the same device instance.

> test-test, and we can get that via dm_device_name() at the moment. But
> test-test is often a better name -- it's the name the user provided

It can be changed and so processing can't rely on it without trusting
both the userspace management code's self-imposed constraints and the
sysadmin not to have worked around them.

In other words, NEVER report name/uuid without ALSO still reporting
dm_device_name alongside it.

Also take a look at
  https://github.com/lvmteam/storage-logger
which tackles logging all the relevant device information.

Alasdair
