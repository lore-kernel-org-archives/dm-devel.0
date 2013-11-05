From: Frank Mayhar <fmayhar@google.com>
Subject: Re: [RFC PATCH v2] dm mpath: add a queue_if_no_path
 timeout
Date: Tue, 05 Nov 2013 07:18:28 -0800
Message-ID: <1383664708.4504.4.camel@bobble.lax.corp.google.com>
References: <20130926232241.GC31328@agk-dp.fab.redhat.com>
	<20130926234957.GA3658@redhat.com>
	<1382036590.1980.32.camel@bobble.lax.corp.google.com>
	<20131017191511.GA30452@redhat.com>
	<1382042759.1980.40.camel@bobble.lax.corp.google.com>
	<20131017211338.GB30993@redhat.com>
	<1382129515.1980.46.camel@bobble.lax.corp.google.com>
	<20131018225350.GB7553@redhat.com> <20131030010246.GA3611@redhat.com>
	<1383145687.6677.49.camel@bobble.lax.corp.google.com>
	<20131030154259.GA8206@redhat.com>
	<1383156565.17572.8.camel@bobble.lax.corp.google.com>
	<11AF7C027C4C02408624617A49860784EDC2C1@BPXM12GP.gisp.nec.co.jp>
	<1383229011.17572.12.camel@bobble.lax.corp.google.com>
	<11AF7C027C4C02408624617A49860784EE0B3F@BPXM12GP.gisp.nec.co.jp>
	<11AF7C027C4C02408624617A49860784EE0F5E@BPXM12GP.gisp.nec.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <11AF7C027C4C02408624617A49860784EE0F5E@BPXM12GP.gisp.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Junichi Nomura <j-nomura@ce.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, 2013-11-01 at 04:17 +0000, Junichi Nomura wrote:
> I slightly modified the patch:
>   - fixed the timeout handler to correctly find
>     clone request and "struct multipath"
>   - the timeout handler just disables "queue_if_no_path"
>     instead of killing the request directly
>   - "dmsetup status" to show the parameter
>   - changed an interface between dm core and target
>   - added some debugging printk (you can remove them)
> and checked the timeout occurs, at least.
> 
> I'm not sure if this feature is good or not though.
> (The timer behavior is not intuitive, I think)
> 
> ---
> Jun'ichi Nomura, NEC Corporation
> 
[patch trimmed]

Thanks!  I integrated your new patch and tested it.  Sure enough, it
seems to work.  I've made a few tweaks (added a module tunable and
support for setting the timer in multipath_message(), removed your debug
printks) and will submit the modified patch for discussion shortly.
-- 
Frank Mayhar
310-460-4042
