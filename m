From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: BFQ + dm-mpath
Date: Fri, 8 Sep 2017 11:13:27 +0200
Message-ID: <756D2B3A-CD5A-4351-BC39-C2BAB771C740@linaro.org>
References: <1503611578.2899.69.camel@wdc.com> <AE77899A-0365-4C7C-91E4-5ACCC396B26B@linaro.org> <ED23C7AC-F202-40E3-8421-E714BF446399@linaro.org> <1504620914.4135.11.camel@wdc.com> <20170907155255.GA22848@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170907155255.GA22848@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, dm-devel@redhat.com, axboe@kernel.dk
List-Id: dm-devel.ids


> Il giorno 07 set 2017, alle ore 17:52, Mike Snitzer =
<snitzer@redhat.com> ha scritto:
>=20
> On Tue, Sep 05 2017 at 10:15am -0400,
> Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
>=20
>> On Tue, 2017-09-05 at 09:56 +0200, Paolo Valente wrote:
>>> Ok, my suspects seem confirmed: the path dm_mq_queue_rq -> =
map_request
>>> -> setup_clone -> blk_rq_prep_clone creates a cloned request without
>>> invoking e->type->ops.mq.prepare_request for the target elevator e.
>>> The cloned request is therefore not initialized for the scheduler, =
but
>>> it is however inserted into the scheduler by
>>> blk_mq_sched_insert_request.  This seems an error for any scheduler
>>> that needs to initialize fields in the incoming request, or in =
general
>>> to take some preliminary action.
>>>=20
>>> Am I missing something here?
>>=20
>> (+Mike Snitzer)
>>=20
>> Mike, do you perhaps have the time to look into this memory leak?
>=20
> It isn't a memory leak, it is missing initialization in the case of
> cloned requests (if I'm understanding Paolo correctly).
>=20

Exactly!

> But cloned requests shouldn't be going through the scheduler.  Only =
the
> original requests should.
>=20
> Commit bd166ef18 ("blk-mq-sched: add framework for MQ capable IO
> schedulers") switched from blk_mq_insert_request() to
> blk_mq_sched_insert_request() and in doing so it opened dm-mpath up to
> this bug.
>=20
> Could be we need to take steps to ensure the block layer still
> supports bypassing the elevator by using direct insertion?
>=20
> Or blk_mq_sched_insert_request() needs updating to check if
> e->type->ops.mq.prepare_request were actually performed and to =
fallback
> to the !elevator case if not..
>=20
> Not sure on the fix, but I can look closer if others (like Jens or
> Paolo) don't have quicker suggestions.
>=20

No quick suggestion from me :(

Thanks for analyzing this bug,
Paolo

> Mike
