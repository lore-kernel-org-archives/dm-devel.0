From: Teng-Feng Yang <shinrairis@gmail.com>
Subject: Allow read IO during share block breaking in dm-thin
Date: Fri, 23 Aug 2013 10:35:30 +0800
Message-ID: <CAKTMprMVgxTDjs+4JEJLgb+1BpLCnY_mXHzvROqKCEiGe5Ekpw@mail.gmail.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi folks,

I have tried to perform some experiments and enhance dm-thin with some
new features for couple of weeks.
I notice that dm-thin uses a dm_deferred_set data structure to record
all the share read IO and inserts new data mappings only when all
share read IO are quiesced.
This method is quite similar to the block tracking mechanism used by
dm-snap, which tries to prevent write IO to the origin device from
overwriting the block when some read IO from snap device has not yet
completed
Although it is reasonable to have something like this in dm-snap, it
looks like an overkill to have the similar mechanism in dm-thin.
Since the "redirect-on-write" nature of dm-thin makes all write IOs to
a share block writes in a new allocated block instead, all preceding
share read IO will still read the correct data even when there are
multiple share write IO on-the-fly.
So here is my question, do we really need to quiesce all share read
IOs before adding a new data mapping, or the share read IO's deferred
set is meant to deal with some other problems?

Any help would be grateful.
Thanks

Dennis
