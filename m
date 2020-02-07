From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: dm: expose dm_copy_name_and_uuid()
Date: Fri, 7 Feb 2020 01:42:29 +0000
Message-ID: <20200207014228.GC23327@agk-dp.fab.redhat.com>
References: <20200201005524.23405-1-jdorminy@redhat.com>
	<20200203165402.GA11874@redhat.com>
	<CAMeeMh82tS6TZCLzMwW7Kk+wdnMFW8WXrbe6-vLxaAvBzU1gBw@mail.gmail.com>
	<20200207012432.GA23327@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200207012432.GA23327@agk-dp.fab.redhat.com>
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

On Fri, Feb 07, 2020 at 01:24:33AM +0000, Alasdair G Kergon wrote:
> In other words, NEVER report name/uuid without ALSO still reporting
> dm_device_name alongside it.

The reason we only log dm_device_name() is because it is the minimum 
necessary to uniquely identify the device and tie together all
the messages relating to it.

Adding name/uuid to every message would make log messages unduly long.
We could offer an in-kernel option to log all setting and changing
of device names and uuids in the dm core, though I might argue that that
would just be covering up inadaquate logging in the userspace tools
making the changes.

Storage-logger offers a compromise that records it all from the
generated uevents.

Alasdair
