From: Geremy Condra <gcondra@google.com>
Subject: Re: [dm-devel] [PATCH] dm: verity: Add support for emitting uevents
 on dm-verity errors.
Date: Thu, 20 Jun 2013 20:00:12 -0700
Message-ID: <CAEQjtam6hHgGKqUwK2Lc=ADm25=E_k9jWWtknaTj9eeXhtUV8g@mail.gmail.com>
References: <1371763260-9933-1-git-send-email-gcondra@google.com>
	<20130621005905.GI23042@agk-dp.fab.redhat.com>
	<CAEQjtanyk2mw2LHMruU+4ujj4KsTtgyfh=3ABk+3g77Bn-6W3g@mail.gmail.com>
	<20130621013045.GJ23042@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130621013045.GJ23042@agk-dp.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Geremy Condra <gcondra@google.com>, dm-devel@redhat.com, wad@chromium.org, linux-kernel@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

On Thu, Jun 20, 2013 at 6:30 PM, Alasdair G Kergon <agk@redhat.com> wrote:
> On Thu, Jun 20, 2013 at 06:12:07PM -0700, Geremy Condra wrote:
>> Assuming nobody currently using DM_UEVENT minds it doesn't cause any
>> problems for me. Any current users object?
>
> DM_UEVENT toggles uevents on or off across the whole of device-mapper.
>
> If there is no particular need for verity *not* to generate uevents
> while other parts of device-mapper *are* generating them, then we can
> make do with just the one Kconfig parameter.  (Userspace is still free
> to ignore particular events.)
>
> So let's drop the second config parameter.

SGTM, next patch coming up- thanks for taking the time to review!

Geremy Condra

>
> Alasdair
>
