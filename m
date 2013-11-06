From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC PATCH v3] dm mpath: add a queue_if_no_path
	timeout
Date: Wed, 06 Nov 2013 07:54:20 +0100
Message-ID: <5279E79C.8010509@suse.de>
References: <20130926232241.GC31328@agk-dp.fab.redhat.com>
	<20130926234957.GA3658@redhat.com>
	<1382036590.1980.32.camel@bobble.lax.corp.google.com>
	<20131017191511.GA30452@redhat.com>
	<1382042759.1980.40.camel@bobble.lax.corp.google.com>
	<20131017211338.GB30993@redhat.com>
	<1382129515.1980.46.camel@bobble.lax.corp.google.com>
	<20131018225350.GB7553@redhat.com>
	<20131030010246.GA3611@redhat.com>
	<1383145687.6677.49.camel@bobble.lax.corp.google.com>
	<20131030154259.GA8206@redhat.com>
	<1383156565.17572.8.camel@bobble.lax.corp.google.com>
	<11AF7C027C4C02408624617A49860784EDC2C1@BPXM12GP.gisp.nec.co.jp>
	<1383229011.17572.12.camel@bobble.lax.corp.google.com>
	<11AF7C027C4C02408624617A49860784EE0B3F@BPXM12GP.gisp.nec.co.jp>
	<11AF7C027C4C02408624617A49860784EE0F5E@BPXM12GP.gisp.nec.co.jp>
	<1383664708.4504.4.camel@bobble.lax.corp.google.com>
	<1383667332.4504.8.camel@bobble.lax.corp.google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1383667332.4504.8.camel@bobble.lax.corp.google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Frank Mayhar <fmayhar@google.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 11/05/2013 05:02 PM, Frank Mayhar wrote:
> This is the patch submitted by Jun'ichi Nomura, originally based on
> Mike's patch with some small changes by me.  Jun'ichi's description
> follows, along with my changes:
> =

> On Tue, 2013-11-05 at 07:18 -0800, Frank Mayhar wrote:
>> On Fri, 2013-11-01 at 04:17 +0000, Junichi Nomura wrote:
>>> I slightly modified the patch:
>>>   - fixed the timeout handler to correctly find
>>>     clone request and "struct multipath"
>>>   - the timeout handler just disables "queue_if_no_path"
>>>     instead of killing the request directly
>>>   - "dmsetup status" to show the parameter
>>>   - changed an interface between dm core and target
>>>   - added some debugging printk (you can remove them)
>>> and checked the timeout occurs, at least.
>>>
>>> I'm not sure if this feature is good or not though.
>>> (The timer behavior is not intuitive, I think)
>> Thanks!  I integrated your new patch and tested it.  Sure enough, it
>> seems to work.  I've made a few tweaks (added a module tunable and
>> support for setting the timer in multipath_message(), removed your debug
>> printks) and will submit the modified patch for discussion shortly.
> =

> Comments?
> =

Yeah. Seems to be my eternal fate; initiating fixes and not getting
mentioned at all.
Sigh.

I dimly remember having sent the original patch for the blk timeout
function ... hence a short notice would've been nice.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
