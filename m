From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [RFC 0/3] dm: add path uevents
Date: Wed, 15 Aug 2007 00:58:34 +0200
Message-ID: <1187132314.4312.47.camel@lov.localdomain>
References: <20070814200544.963756967@us.ibm.com>>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070814200544.963756967@us.ibm.com>>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Anderson <andmike@us.ibm.com>
Cc: Greg KH <greg@kroah.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, 2007-08-14 at 13:05 -0700, Mike Anderson wrote:
> This patch series enables device mapper (dm) to send kobject uevents for
> dm events. Currently only two new events are sent related to path state
> changes.

Sounds fine.

> DM_ACTION=PATH_FAILED
> DM_SEQNUM=1
> DM_PATH=8:48
> DM_PATHS=1

Oh, I have a patch pending for dmsetup to export a bunch of variables in
the environment format with a single call, so we can use it udev
context.
Here is the list, just that we don't clash with names or use the same
names where appropriate:
  DM_NAME=
  DM_UUID=
  DM_STATE=
  DM_TABLE_STATE=
  DM_OPENCOUNT=
  DM_MAJOR=
  DM_MINOR=
  DM_TARGET_COUNT=
  DM_TARGET_TYPES=
  DM_LAST_EVENT_NR=

Let me know if something should be renamed.

Thanks,
Kay
