From: syrius.ml@no-log.org
Subject: Re: [Evms-devel] Re: dev kernels(bio change),
	evms_activate still produces oops
Date: Thu, 17 Feb 2005 20:58:11 +0100
Message-ID: <87zmy39dem.87y8dn9dem@87wtt79dem.message.id>
References: <87sm48dnh2.87r7jsdnh2@87pszcdnh2.message.id>
	<20050209231044.GA959@osdl.org> <20050211131433.A24845@osdl.org>
	<20050216225601.GA5806@osdl.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20050216225601.GA5806@osdl.org> (Dave Olien's message of "Wed,
	16 Feb 2005 14:56:01 -0800")
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dave Olien <dmo@osdl.org>
Cc: evms-devel@lists.sourceforge.net, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

Dave Olien <dmo@osdl.org> writes:

> I apologize again for being slow about this. Below are the two
> patches I developed. The first one is in 2.6.11-rc4.  The other
> one should appear in the Andrew's mm tree for rc4.
>
> They both apply to linux-2.6.11-rc3-udm2, with some offsets.
>
> The problems both appear because of the way raid5 and raid6 created
> its bio's that it then passed into bio_clone().

>> [...]
> ------------------ patch 1 ----------------------------------------------------
> [...]
> +	struct bio *b = bio_alloc_bioset(gfp_mask, bio->bi_max_vecs, fs_bio_set);

in fact patch 2 is in 2.6.11-rc4, and patch 1 is needed to stop the
oops.
Thanks you very much Dave.
Everything seem to work. I just have dm errors messages, but it
seems related to evms.

For information (since evms-devel is cc'ed):
device-mapper: dm-linear: Device lookup failed
device-mapper: error adding target to table

(happens even if i don't use a dm linear object.)

Cheers

-- 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
