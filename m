From: NeilBrown <neilb@suse.com>
Subject: Re: [dm-devel] [PATCH v2 1/1] block: fix blk_queue_split() resource	exhaustion
Date: Tue, 12 Jul 2016 12:55:10 +1000
Message-ID: <87lh17efap.fsf@notabene.neil.brown.name>
References: <1467990243-3531-1-git-send-email-lars.ellenberg@linbit.com> <1467990243-3531-2-git-send-email-lars.ellenberg@linbit.com> <20160711141042.GY13335@soda.linbit>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <20160711141042.GY13335@soda.linbit>
Sender: linux-bcache-owner@vger.kernel.org
To: Lars Ellenberg <lars.ellenberg@linbit.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>, Ming Lei <ming.lei@canonical.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Takashi Iwai <tiwai@suse.de>, linux-bcache@vger.kernel.org, Zheng Liu <gnehzuil.liu@gmail.com>, Kent Overstreet <kent.overstreet@gmail.com>, Keith Busch <keith.busch@intel.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, Ingo Molnar <mingo@redhat.com>, Alasdair Kergon <agk@redhat.com>, Roland Kammerer <roland.kammerer@linbit.com>
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain

On Tue, Jul 12 2016, Lars Ellenberg wrote:
....
>
> Instead, I suggest to distinguish between recursive calls to
> generic_make_request(), and pushing back the remainder part in
> blk_queue_split(), by pointing current->bio_lists to a
> 	struct recursion_to_iteration_bio_lists {
> 		struct bio_list recursion;
> 		struct bio_list queue;
> 	}
>
> By providing each q->make_request_fn() with an empty "recursion"
> bio_list, then merging any recursively submitted bios to the
> head of the "queue" list, we can make the recursion-to-iteration
> logic in generic_make_request() process deepest level bios first,
> and "sibling" bios of the same level in "natural" order.
>
> Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
> Signed-off-by: Roland Kammerer <roland.kammerer@linbit.com>

Reviewed-by: NeilBrown <neilb@suse.com>

Thanks again for doing this - I think this is a very significant
improvement and could allow other simplifications.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXhFwOAAoJEDnsnt1WYoG5m3kQAIeT+C3JZCXXmBrt4taPkTU7
1FAk0kU9rzEAm6O+3VvenmZRYbR0bR0gsMrifYB36+87cNqn5uCPw61xPUjCn9Zj
UDvX2Shz7JBBCCw0cQRYALYcIlqCX+8nSmb8egzqk5mMTVrKxaAc0IOGNsTrkkVz
8ZQzCRD46p/SDngQur9Wz+IorSjWjNHG4O8WpAhXYPnsn3WA1dqtBVFz8FGH/Hw2
jkJ3RbmDv9F63/WBcEDAltxDNZ1Gz5YTHejDtxwjFWcJ7LJmPsbILB/ecNiA0eRP
/L3Ti2XPL3pyd97AnT4ibYpn7LsiMSn0A639lfA6AECZPvVlh+NBLSFds1lKg2ne
Oapm6EOFf1LLIoBDWBk9niht1z+CrhhBKiagsPuqIPJLQuY8ZGD6YDZm737N436I
QOa215dhQGCUE4m+rHgs679wsRIbSbP8gJsA8tCkC+cOn7EXPQc9FmoiQJhr1AJ1
KjIwPb2xkmtKR0ZGN/szk79PEoqwHe0KzAFXKcS+tWt5WezHAfrzKgL8DHT4QHy3
TH0yyz9o6UeBeKEQMFwr6eWryjgmWMi+X4PO9x+3yalxYJ6IsNm6Oa6qT/8OmWuw
/yLvL2TnKF7KTp3tedmMogUwYySdO+MIQsEztFUgrh5I/z7otFOVevMmllM29+pE
fBqs1jgmES+HDl2+Zuit
=s0FL
-----END PGP SIGNATURE-----
--=-=-=--
