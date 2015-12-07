From: Milan Broz <mbroz@redhat.com>
Subject: Re: [PATCH v2 0/2] dm verity: add support for error correction
Date: Mon, 7 Dec 2015 19:07:17 +0100
Message-ID: <5665CAD5.9000704@redhat.com>
References: <1446688954-29589-1-git-send-email-samitolvanen@google.com>
 <1449152791-33586-1-git-send-email-samitolvanen@google.com>
 <20151203195401.GA5444@redhat.com> <20151203230538.GB5444@redhat.com>
 <20151204100305.GA37949@google.com> <20151204210935.GA63877@redhat.com>
 <20151207132149.GA7583@google.com> <20151207145814.GB29457@redhat.com>
 <20151207163108.GA21472@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151207163108.GA21472@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sami Tolvanen <samitolvanen@google.com>, Mike Snitzer <snitzer@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mandeep Baines <msb@chromium.org>, Will Drewry <wad@chromium.org>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, Mark Salyzyn <salyzyn@google.com>
List-Id: dm-devel.ids

On 12/07/2015 05:31 PM, Sami Tolvanen wrote:
> On Mon, Dec 07, 2015 at 09:58:14AM -0500, Mike Snitzer wrote:
>> Great.  Moving forward it'd be awesome if you could work to get your
>> verity FEC support regression tests into cryptsetup's tests.
> 
> Sure. These tests would basically involve generating a valid disk
> image, corrupting it up to the theoretical maximum, and verifying that
> dm-verity can correct it.

Does the code handle/report even the same type of data corruption
for RS blocks? Or this is just silently ignored until
data area corruption happens?
Sorry, I did not study the code here, I am just curious :)

(IOW I mean if data are ok but recovery metadata is corrupted.)

Milan
