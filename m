From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH] dm-mpath: requeue I/O during pg_init
Date: Wed, 6 Nov 2013 01:28:40 +0000
Message-ID: <11AF7C027C4C02408624617A49860784EF1B71@BPXM12GP.gisp.nec.co.jp>
References: <1380620996-110162-1-git-send-email-hare@suse.de>
	<20131105130221.GC27505@agk-dp.fab.redhat.com>
	<5278EE5F.9070208@suse.de>
	<20131105133158.GD27505@agk-dp.fab.redhat.com>
	<5278F67E.2040402@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5278F67E.2040402@suse.de>
Content-Language: ja-JP
Content-ID: <1DE831597160CC4B9B057797C9FA4D26@gisp.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 11/05/13 22:45, Hannes Reinecke wrote:
> On 11/05/2013 02:31 PM, Alasdair G Kergon wrote:
>> On Tue, Nov 05, 2013 at 02:10:55PM +0100, Hannes Reinecke wrote:
>>> If this is just a left-over from the original port to request-based
>>> (for bio-based we _have_ to queue internally as there's no request
>>> queue to be had), fine, we should be removing it.
>>
>> I think that is the case.

Yes. That's the case.
Kiyoshi and I was removing it but couldn't take time to audit the isolation
of pg_init state machine from the process_queued_ios.

>>> But there _might_ be some corner cases which require us to do internal
>>> queueing.
>>  
>> We *only* add I/O to the internal queue in map_io() - which can always
>> be replaced with REQUEUE,  As long as we still 'wake up' the queue
>> immediately when we are ready to receive the I/O, I can't think of any
>> other reason.  And it would let us remove quite a bit of tricky code!
>>
> Precisely what I was thinking.
> 
> I'll be cobbling together a patch.

-- 
Jun'ichi Nomura, NEC Corporation
