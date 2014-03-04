From: Akira Hayakawa <hayakawa@valinux.co.jp>
Subject: A target to just process bios background?
Date: Tue, 4 Mar 2014 10:30:37 +0900
Message-ID: <20140304103037.a42991f149d749448846caab@valinux.co.jp>
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
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi,

Is it meaningless to submit the split and cloned bios in background
using workqueue?

device-mapper doesn't go to next split before the .map hook returns
(and generic_make_request() returns only in case of DM_MAPIO_REMAPPED).
So, quitting from .map hook and going into next split fast sounds to me
effective at least in terms of CPU usage (in multicore system).

is this discussed before?

A target as tiny as linear or flakey can be thought:
- it has work_struct in per_bio_data
- .map hook queue_work the work into private wq.
- and then return DM_MAPIO_SUBMITTED

is this implemented before?

I think this target will make people happy if they
want to see what if the bio submission is done background
without changing their code but only stacking a dm target.

I am sorry if I am confused.

-- 
Akira
