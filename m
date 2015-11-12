From: Milan Broz <mbroz@redhat.com>
Subject: Re: [PATCH 0/4] dm verity: add support for error correction
Date: Thu, 12 Nov 2015 11:30:00 +0100
Message-ID: <56446A28.1030507@redhat.com>
References: <1446688954-29589-1-git-send-email-samitolvanen@google.com>
 <563B066C.6050202@redhat.com> <20151105173306.GA22302@google.com>
 <20151109163735.GA28884@redhat.com> <20151109191925.GA29185@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151109191925.GA29185@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sami Tolvanen <samitolvanen@google.com>, Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Mandeep Baines <msb@chromium.org>, Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mark Salyzyn <salyzyn@google.com>
List-Id: dm-devel.ids

On 11/09/2015 08:19 PM, Sami Tolvanen wrote:
...
> We don't see actual I/O errors very often. Most corruption we've seen
> is caused by flaky hardware that doesn't return errors. However, I can
> certainly change to code to attempt recovery in this case too.

So if I understand it correctly, there is a simplified flash controller
that can send data with bit flips without detection?

(IOW in "real" SSD this kind of error should be detected internally
by some bad block management?)

This is why I asked about some statistics of real visible types of errors.

For this use case it makes sense to have error correction here but then
we should clearly said that it makes no sense to switch it on for "real" hw
that does internal integrity check or error correction
(but not authenticated integrity check as dm-verity).

...

>> If this error correction feature is going to go upstream we really
>> should see any associated userspace enablement also included in
>> veritysetup.
> 
> I can look into this.

Yes, please, patches do not to be production ready (I can integrate
it to veritysetup upstream myself) but it would be very nice that
released veritysetup can configure all dm-verity features in the same time
the mainline kernel is marked stable.
(The same applies for dm-crypt & cryptsetup.)

Thanks,
Milan
