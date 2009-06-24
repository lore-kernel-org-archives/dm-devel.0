From: "NeilBrown" <neilb@suse.de>
Subject: Re: Re: Write barriers on MD RAID1
Date: Wed, 24 Jun 2009 17:34:50 +1000 (EST)
Message-ID: <ee1590411620eede90e75c14fde50244.squirrel@neil.brown.name>
References: <4A188CAD.1080009@googlemail.com>
	<0fa4b1e19d3edb12931e0d641ce2c7d7.squirrel@neil.brown.name>
	<4A3E3C49.7010907@googlemail.com>
	<19009.41191.662901.179565@notabene.brown>
	<20090624070917.GB27500@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090624070917.GB27500@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Neil Brown <neilb@suse.de>, device-mapper development <dm-devel@redhat.com>, Ken Milmore <ken.milmore@googlemail.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Wed, June 24, 2009 5:09 pm, Alasdair G Kergon wrote:
> On Wed, Jun 24, 2009 at 01:43:35PM +1000, Neil Brown wrote:
>> Since this test was added, barriers have not worked on md, and (I
>> think) dm and similar devices that don't use __make_request and so
>> don't bother to set next_ordered.
>
> In dm, we added this:
>
> +       blk_queue_ordered(md->queue, QUEUE_ORDERED_DRAIN, NULL);
>

I obviously didn't grep for the right thing.

This will obviously work, but I can't help thinking it is in the wrong
place.  I don't even have a queue in md/raid1, so making a statement
about how it is ordered just doesn't make sense.

Jens?

NeilBrown
