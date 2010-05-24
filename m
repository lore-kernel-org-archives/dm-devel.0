From: Will Drewry <wad@chromium.org>
Subject: Re: [dm-devel] [PATCH v3 3/3] dm: lookup devices by path with
	name_to_dev_t
Date: Mon, 24 May 2010 11:35:57 -0500
Message-ID: <AANLkTinlgQ5Br4vyjgvNKtHD4F3mZKwoz3siYCQyReAl@mail.gmail.com>
References: <1274294304-30606-1-git-send-email-wad@chromium.org>
	<1274294304-30606-3-git-send-email-wad@chromium.org>
	<20100524115737.GY3991@agk-dp.fab.redhat.com>
	<AANLkTik8F43_4SRkH7XpfX5CTQ-xQ_8f3_yJTjDqSulU@mail.gmail.com>
	<20100524150729.GZ3991@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100524150729.GZ3991@agk-dp.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Will Drewry <wad@chromium.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, snitzer@redhat.com
List-Id: dm-devel.ids

On Mon, May 24, 2010 at 10:07 AM, Alasdair G Kergon <agk@redhat.com> wr=
ote:
> On Mon, May 24, 2010 at 09:44:07AM -0500, Will Drewry wrote:
>> fwiw, the only reason for the copy was because |path| is a
>> const in the function but not when passed to name_to_dev_t.
>> I wasn't sure what the preferred practice was so I just duped
>> the data needed.
>
> Well check that it is treated as 'const' and send a separate patch to
> the maintainer to add const, perhaps? =A0If it isn't const (why would
> that be?), then yes we'd need to copy it.

I'll cross-check the code again and send a patch out if it looks like
it is const-safe.

thanks,
will
