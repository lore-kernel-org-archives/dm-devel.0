From: Will Drewry <wad@chromium.org>
Subject: Re: [dm-devel] [PATCH v3 3/3] dm: lookup devices by path with
	name_to_dev_t
Date: Mon, 24 May 2010 09:44:07 -0500
Message-ID: <AANLkTik8F43_4SRkH7XpfX5CTQ-xQ_8f3_yJTjDqSulU@mail.gmail.com>
References: <1274294304-30606-1-git-send-email-wad@chromium.org>
	<1274294304-30606-3-git-send-email-wad@chromium.org>
	<20100524115737.GY3991@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100524115737.GY3991@agk-dp.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com
Cc: linux-kernel@vger.kernel.org, snitzer@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, May 24, 2010 at 6:38 AM, Alasdair G Kergon <agk@redhat.com> wro=
te:
> I'll apply this, [snip]

Thanks!

On Mon, May 24, 2010 at 6:57 AM, Alasdair G Kergon <agk@redhat.com> wro=
te:
> On Wed, May 19, 2010 at 01:38:24PM -0500, Will Drewry wrote:
>> + =A0 =A0 char base_path[32]; =A0/* size from name_to_dev_t */
>
>> + =A0 =A0 /* stage the shorter path for name_to_dev_t. */
>> + =A0 =A0 strncpy(base_path, path, sizeof(base_path));
>
> I'm dropping that, and just passing path directly, so the strlen test
> will be used. =A0(There's a "name +=3D 5" in there so 32 would ignore
> any longer standard names anyway.)

Sounds good.  And nice catch on the truncation with 32 - in an
attempt to minimize the extra copying, I went a bit too far!

fwiw, the only reason for the copy was because |path| is a
const in the function but not when passed to name_to_dev_t.
I wasn't sure what the preferred practice was so I just duped
the data needed.

cheers!
will
