From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] md: Convert timers to use timer_setup()
Date: Wed, 18 Oct 2017 21:12:00 -0600
Message-ID: <D294B3CB-45BC-49B2-A9DD-AB0A01CCB444@kernel.dk>
References: <20171017000148.GA102867@beast> <390e7ce2-fda1-ad11-6c96-0ea44615c845@lyle.org> <CAGXu5jLQVmS_7wA3z3W8590d-adNHMNY5yp5WsiSx3EiwTsfRQ@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jLQVmS_7wA3z3W8590d-adNHMNY5yp5WsiSx3EiwTsfRQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Michael Lyle <mlyle@lyle.org>, Shaohua Li <shli@fb.com>, Kent Overstreet <kent.overstreet@gmail.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids


> On Oct 18, 2017, at 9:06 PM, Kees Cook <keescook@chromium.org> wrote:
>=20
>> On Mon, Oct 16, 2017 at 8:06 PM, Michael Lyle <mlyle@lyle.org> wrote:
>>> On 10/16/2017 05:01 PM, Kees Cook wrote:
>>> In preparation for unconditionally passing the struct timer_list pointer=
 to
>>> all timer callbacks, switch to using the new timer_setup() and from_time=
r()
>>> to pass the timer pointer explicitly.
>>>=20
>>> Cc: Kent Overstreet <kent.overstreet@gmail.com>
>>> Cc: Shaohua Li <shli@kernel.org>
>>> Cc: Alasdair Kergon <agk@redhat.com>
>>> Cc: Mike Snitzer <snitzer@redhat.com>
>>> Cc: dm-devel@redhat.com
>>> Cc: linux-bcache@vger.kernel.org
>>> Cc: linux-raid@vger.kernel.org
>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>=20
>> This looks good to me-- I'm fine with Jens or someone else picking this
>> up directly, or would take a bcache-specific one to apply to my tree.
>>=20
>> Reviewed-by: Michael Lyle <mlyle@lyle.org>
>=20
> Jens, can you pick this up, or would you prefer I split it up?

I can pick it up, but I don=E2=80=99t think I was ever cc=E2=80=99ed on
the original.
