From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 0/4] path latency prio fixes
Date: Fri, 8 Dec 2017 14:49:12 -0600
Message-ID: <20171208204912.GA5638@octiron.msp.redhat.com>
References: <20171118001134.26622-1-mwilck@suse.com>
	<1511169062.25459.37.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1511169062.25459.37.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: Guan Junxiong <guanjunxiong@huawei.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Nov 20, 2017 at 10:11:02AM +0100, Martin Wilck wrote:
> Hi Guan,
> =

> while staring at this code the other day, I realized another possible
> issue with your latency prioritizer. =

> =

> It will cause significant IO to every path of a map during multipath /
> multipathd startup. If any paths really have latencies as long as your
> patch considers (up to 100s), or worse if they don't respond at all,
> startup may be *massively* delayed or may even never complete. So if we
> a storage with two mirrors with a fast and a slow leg (I reckon that's
> the scenario this patch was made for), and if we're out of luck and the
> slow leg is probed first, we may end up in a situation where the fast
> leg, which may be fully up and healthy, is never set up (or with big
> delay) because multipathd keeps waiting for the slow leg to respond.
> =

> Similar delays can occur whenever pathinfo(..., DI_PRIO) is called.
> Unless I'm overlooking something essential here, that's a really
> dangerous thing to do. I believe that before activating this prio
> checker for  everyone, we need find a way to avoid this scenario. =

> =

> By using aio with a reasonable timeout for the latency check rather
> then sync IO, we could at least set an upper limit for the time
> get_prio takes. That would be a first step. But I don't think that
> would be sufficient. =

> =

> What we'd really need is an asynchronous priority checker, similar to
> the asynchronous path checker. The get_prio() call would return
> immediately with some special return code indicating to the caller that
> a priority check is running the background. A preliminary prio would be
> set for the path in pathinfo(), and multipathd would re-check later (or
> get some sort of event) when the priority check has actually been done.
> An open question is what multipathd should do wrt path grouping if it
> only has preliminary prio values, in particular with group_by_prio.

Yeah, you're right. Something like this is necessary. We could have the
prioritizers work like the checkers and have them include a context,
that the checkers can use to save data.  Then could make this work like
the directio checker, with its async calls.

> Putting Hannes and Ben on CC because I'd like to get their opinion,
> too.
> =

> Regards
> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
