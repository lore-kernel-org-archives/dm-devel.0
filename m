From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv2 0/2] dm-multipath: push back requests
	instead of queueing
Date: Thu, 30 Jan 2014 07:53:04 +0100
Message-ID: <52E9F6D0.9050703@suse.de>
References: <1389955328-107148-1-git-send-email-hare@suse.de>
	<20140118154154.GA18825@redhat.com>
	<20140130013858.GA22108@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140130013858.GA22108@redhat.com>
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
Cc: Junichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 01/30/2014 02:38 AM, Mike Snitzer wrote:
> On Sat, Jan 18 2014 at 10:41am -0500,
> Mike Snitzer <snitzer@redhat.com> wrote:
> =

>> On Fri, Jan 17 2014 at  5:42am -0500,
>> Hannes Reinecke <hare@suse.de> wrote:
>>
>>> Hi all,
>>>
>>> dm-multipath still carries around it's own queueing framework for
>>> implementing 'queue_if_no_path'.
>>> However, there is no real reason for this; we could as well
>>> push back the requests onto the request_queue.
>>> In doing so we can also reduce the memory pressure during
>>> fail_if_no_path scenarios, as we don't have to allocate a
>>> context for each request when it need to be requeued.
>>>
>>> This patchset is the reworked version from the original, including
>>> the review by Jun'ichi.
>>
>> Much appreciated.  But unfortunately it is too late for 3.14.
>>
>> These will be my immediate priority once I transition to 3.15
>> development (likely by end of next week).
> =

> Hi Hannes,
> =

> Do you have a new patchset for this work based on the review Junichi
> provided?  I'd like to review/stage your latest once you have it.
> =

Hmm, the patchset should include the review.

But I'll check.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
